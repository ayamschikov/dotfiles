#!/usr/bin/env bash
# Claude Code notification hook — пингует, когда инстанс ждёт тебя.
# Читает JSON хука со stdin; проигрывает звук + показывает macOS-уведомление
# с ИМЕНЕМ ПРОЕКТА, чтобы было ясно, к какому из параллельных окон вернуться.
#
# Аргумент $1 — событие: Notification (по умолчанию) | Stop.
#   Notification — Claude просит разрешение ИЛИ ввод простаивает ≥60с
#                  (т.е. агент закончил, а тебя нет). Это "вернись ко мне".
#   Stop         — агент завершил ход (срабатывает КАЖДЫЙ ход → шумно,
#                  по умолчанию в settings.json не подключён).

event="${1:-Notification}"
input="$(cat)"

cwd="$(printf '%s' "$input" | jq -r '.cwd // .workspace.current_dir // empty' 2>/dev/null)"
project="$(basename "${cwd:-$PWD}")"
# В tmux все сессии обычно в одном репозитории — показываем окно и тему сессии.
. "$(dirname "$0")/lib-tmux-pane.sh"
if [ -n "$CLAUDE_TMUX_PANE" ]; then
  project="$(tmux display -p -t "$CLAUDE_TMUX_PANE" '#I: #{s/^[^A-Za-zА-Яа-яЁё0-9]+ //:pane_title}' 2>/dev/null || echo "$project")"
fi
message="$(printf '%s' "$input" | jq -r '.message // empty' 2>/dev/null)"

case "$event" in
  Stop)
    sound="/System/Library/Sounds/Glass.aiff"
    title="✅ $project"
    [ -z "$message" ] && message="готово"
    ;;
  *)
    sound="/System/Library/Sounds/Ping.aiff"
    title="🔔 $project"
    [ -z "$message" ] && message="ждёт ввода"
    ;;
esac

# Убираем символы, которые сломали бы строку AppleScript.
title="$(printf '%s' "$title" | tr -d '"\\')"
message="$(printf '%s' "$message" | tr -d '"\\')"

# Оба в фоне, чтобы хук возвращался мгновенно и не тормозил агента.
afplay "$sound" >/dev/null 2>&1 &
osascript -e "display notification \"$message\" with title \"$title\"" >/dev/null 2>&1 &
