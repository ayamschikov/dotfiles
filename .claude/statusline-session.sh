#!/bin/bash
# Claude Code statusline: line 1 — dir, git, worktree; line 2 — model, context, prompt cache, limits.
# Fields: https://code.claude.com/docs/en/statusline#available-data

# Context thresholds in tokens: "smart zone" heuristic, not a measurement
CTX_WARN=80000
CTX_LIMIT=100000
# The 7-day limit is shown only from this percentage
RL7_SHOW_FROM=50

RESET=$'\033[0m'
DIM=$'\033[2m'
GREEN=$'\033[0;32m'
YELLOW=$'\033[0;33m'
RED=$'\033[0;31m'

input=$(cat)

# Line 1: directory and git branch (unchanged from the previous inline command)
cwd=$(echo "$input" | jq -r '.workspace.current_dir')
dir_name=$(basename "$cwd")
if git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
  branch=$(git -C "$cwd" rev-parse --abbrev-ref HEAD 2>/dev/null)
  if git -c core.useBuiltinFSMonitor=false -C "$cwd" diff-index --quiet HEAD -- 2>/dev/null; then
    git_info=$(printf " \033[1;34mgit:(\033[0;31m%s\033[1;34m)\033[0m" "$branch")
  else
    git_info=$(printf " \033[1;34mgit:(\033[0;31m%s\033[1;34m) \033[0;33m✗\033[0m" "$branch")
  fi
else
  git_info=""
fi
worktree=$(echo "$input" | jq -r '.workspace.git_worktree // empty')
[ -n "$worktree" ] && git_info="${git_info} $(printf "\033[0;35mwt:%s\033[0m" "$worktree")"
printf "\033[0;36m%s\033[0m%s\n" "$dir_name" "$git_info"

# Line 2: one jq pass; "-" marks an absent field
IFS=$'\t' read -r model effort fast ctx_tokens ctx_size pc_seen pc_warm pc_ttl pc_expires pc_hit pc_misses pc_miss_cause pc_recache rl5_pct rl5_reset rl7_pct rl7_reset <<EOF
$(echo "$input" | jq -r '[
  (.model.display_name // "-"),
  (.effort.level // "-"),
  (.fast_mode // "-"),
  (.context_window.total_input_tokens // "-"),
  (.context_window.context_window_size // "-"),
  (.prompt_cache.caching_observed // "-"),
  (.prompt_cache.warm // "-"),
  (.prompt_cache.ttl // "-"),
  (.prompt_cache.expires_at // "-"),
  (.prompt_cache.hit_ratio // "-"),
  (.prompt_cache.misses // "-"),
  ((.prompt_cache.last_miss_cause.causes // []) | join(",") | if . == "" then "-" else . end),
  (.prompt_cache.recache_tokens_if_cold // "-"),
  (.rate_limits.five_hour.used_percentage // "-"),
  (.rate_limits.five_hour.resets_at // "-"),
  (.rate_limits.seven_day.used_percentage // "-"),
  (.rate_limits.seven_day.resets_at // "-")
] | map(tostring) | @tsv')
EOF

now=$(date +%s)

fmt_tokens() {
  if [ "$1" -ge 1000000 ]; then
    awk -v n="$1" 'BEGIN { printf "%.1fM", n / 1000000 }'
  else
    printf "%dK" $(( ($1 + 500) / 1000 ))
  fi
}

fmt_duration() {
  local mins=$(( $1 / 60 ))
  if [ "$mins" -ge 1440 ]; then
    printf "%dd%02dh" $(( mins / 1440 )) $(( mins % 1440 / 60 ))
  elif [ "$mins" -ge 60 ]; then
    printf "%dh%02dm" $(( mins / 60 )) $(( mins % 60 ))
  else
    printf "%dm" "$mins"
  fi
}

pct_color() {
  if [ "$1" -ge 80 ]; then
    printf "%s" "$RED"
  elif [ "$1" -ge 50 ]; then
    printf "%s" "$YELLOW"
  else
    printf "%s" "$GREEN"
  fi
}

parts=()

# Model and effort: a model switch or turning on fast mode rebuilds the whole cache
if [ "$model" != "-" ]; then
  m="$model"
  [ "$effort" != "-" ] && m="${m}${DIM}·${effort}${RESET}"
  [ "$fast" = "true" ] && m="${m} ${YELLOW}fast${RESET}"
  parts+=("$m")
fi

# Context: absolute tokens, because the 100K threshold does not depend on window size
if [ "$ctx_tokens" != "-" ] && [ "$ctx_tokens" != "0" ]; then
  if [ "$ctx_tokens" -ge "$CTX_LIMIT" ]; then
    color=$RED
  elif [ "$ctx_tokens" -ge "$CTX_WARN" ]; then
    color=$YELLOW
  else
    color=$GREEN
  fi
  size=""
  [ "$ctx_size" != "-" ] && size="${DIM}/$(fmt_tokens "$ctx_size")${RESET}"
  parts+=("ctx ${color}$(fmt_tokens "$ctx_tokens")${RESET}${size}")
fi

# Prompt cache: warm -> TTL left and hit ratio; cold -> tokens the next request rewrites
if [ "$pc_seen" = "true" ]; then
  if [ "$pc_warm" = "true" ] && [ "$pc_expires" != "-" ]; then
    left=$(( pc_expires - now ))
    [ "$left" -lt 0 ] && left=0
    cache="cache ${pc_ttl} ${GREEN}✓ $(fmt_duration "$left")${RESET}"
  else
    cache="cache ${RED}✗ cold${RESET}"
    [ "$pc_recache" != "-" ] && cache="${cache} ${RED}next +$(fmt_tokens "$pc_recache")${RESET}"
  fi
  if [ "$pc_hit" != "-" ]; then
    cache="${cache} ${DIM}hit $(awk -v r="$pc_hit" 'BEGIN { printf "%d", r * 100 + 0.5 }')%${RESET}"
  fi
  if [ "$pc_misses" != "-" ] && [ "$pc_misses" -gt 0 ]; then
    cause=""
    [ "$pc_miss_cause" != "-" ] && cause=" (${pc_miss_cause})"
    cache="${cache} ${YELLOW}miss ${pc_misses}${cause}${RESET}"
  fi
  parts+=("$cache")
fi

# 5-hour subscription limit; absent for API key sessions and before the first response
if [ "$rl5_pct" != "-" ]; then
  pct=$(awk -v p="$rl5_pct" 'BEGIN { printf "%d", p + 0.5 }')
  reset=""
  if [ "$rl5_reset" != "-" ] && [ "$rl5_reset" -gt "$now" ]; then
    reset=" ${DIM}↻$(fmt_duration $(( rl5_reset - now )))${RESET}"
  fi
  parts+=("5h $(pct_color "$pct")${pct}%${RESET}${reset}")
fi

# 7-day limit: hidden while far from the cap
if [ "$rl7_pct" != "-" ]; then
  pct=$(awk -v p="$rl7_pct" 'BEGIN { printf "%d", p + 0.5 }')
  if [ "$pct" -ge "$RL7_SHOW_FROM" ]; then
    reset=""
    if [ "$rl7_reset" != "-" ] && [ "$rl7_reset" -gt "$now" ]; then
      reset=" ${DIM}↻$(fmt_duration $(( rl7_reset - now )))${RESET}"
    fi
    parts+=("7d $(pct_color "$pct")${pct}%${RESET}${reset}")
  fi
fi

line=""
for p in "${parts[@]}"; do
  [ -n "$line" ] && line="${line} ${DIM}|${RESET} "
  line="${line}${p}"
done
[ -n "$line" ] && printf "%s\n" "$line"
exit 0
