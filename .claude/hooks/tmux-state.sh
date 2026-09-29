#!/usr/bin/env bash
# Sets the tmux window option @claude_state for the window running this
# Claude session; ~/.tmux/claude.conf renders it as ⏳ / 🔔 / ✅ in the status bar.
#
# $1: running | done | notify | clear
#   notify — reads the Notification hook JSON: permission/input requests → 🔔,
#            idle reminders are ignored (the window already shows ✅).
. "$(dirname "$0")/lib-tmux-pane.sh"
[ -n "$CLAUDE_TMUX_PANE" ] || exit 0
state="$1"

if [ "$state" = notify ]; then
  type="$(jq -r '.notification_type // empty' 2>/dev/null)"
  case "$type" in
    idle_prompt|auth_success|agent_completed) exit 0 ;;
    *) state=waiting ;;
  esac
else
  cat >/dev/null
fi

if [ "$state" = clear ]; then
  tmux set-option -wu -t "$CLAUDE_TMUX_PANE" @claude_state 2>/dev/null
else
  tmux set-option -w -t "$CLAUDE_TMUX_PANE" @claude_state "$state" 2>/dev/null
fi
exit 0
