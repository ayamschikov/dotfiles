# Sourced by hooks. Sets CLAUDE_TMUX_PANE to the tmux pane running this Claude
# session, or leaves it empty outside tmux.
# Claude Code strips TMUX/TMUX_PANE from its own env, so hooks don't see them:
# walk up the process tree until we reach a pane's shell (pane_pid).
# One `ps -A` snapshot instead of `ps` per level: each ps call costs ~0.25s on
# macOS, and SessionEnd hooks are killed after 1.5s by default.
CLAUDE_TMUX_PANE="${TMUX_PANE:-}"
if [ -z "$CLAUDE_TMUX_PANE" ] && command -v tmux >/dev/null 2>&1; then
  __panes="$(tmux list-panes -a -F '#{pane_pid} #{pane_id}' 2>/dev/null)"
  if [ -n "$__panes" ]; then
    CLAUDE_TMUX_PANE="$(
      { printf '%s\n' "$__panes" | sed 's/^/P /'; ps -A -o pid=,ppid= 2>/dev/null | sed 's/^/T /'; } |
        awk -v start=$$ '
          $1 == "P" { pane[$2] = $3; next }
          $1 == "T" { parent[$2] = $3; next }
          END {
            for (p = start; p > 1; p = parent[p]) {
              if (p in pane) { print pane[p]; exit }
              if (!(p in parent)) exit
            }
          }'
    )"
  fi
  unset __panes
fi
