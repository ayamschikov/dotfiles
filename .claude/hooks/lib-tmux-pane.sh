# Sourced by hooks. Sets CLAUDE_TMUX_PANE to the tmux pane running this Claude
# session, or leaves it empty outside tmux.
# Claude Code strips TMUX/TMUX_PANE from its own env, so hooks don't see them:
# walk up the process tree until we reach a pane's shell (pane_pid).
CLAUDE_TMUX_PANE="${TMUX_PANE:-}"
if [ -z "$CLAUDE_TMUX_PANE" ] && command -v tmux >/dev/null 2>&1; then
  __panes="$(tmux list-panes -a -F '#{pane_pid} #{pane_id}' 2>/dev/null)"
  if [ -n "$__panes" ]; then
    __pid=$$
    while [ -n "$__pid" ] && [ "$__pid" -gt 1 ] 2>/dev/null; do
      CLAUDE_TMUX_PANE="$(printf '%s\n' "$__panes" | awk -v p="$__pid" '$1 == p { print $2; exit }')"
      [ -n "$CLAUDE_TMUX_PANE" ] && break
      __pid="$(ps -o ppid= -p "$__pid" 2>/dev/null | tr -d ' ')"
    done
  fi
  unset __panes __pid
fi
