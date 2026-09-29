#!/usr/bin/env python3
"""PreToolUse hook: remind about the "Цель / Срезы" declaration before the first
code edit of a task.

Fires once per (session_id x git branch). The branch is the task boundary in this
workflow, so a new task re-arms the reminder while further edits inside the same
task stay quiet. Emits additionalContext only — it never blocks the tool call, and
any internal failure degrades to silence rather than to a stuck edit.
"""

import hashlib
import json
import os
import subprocess
import sys
import time

STATE_DIR = os.path.expanduser("~/.claude/state/declare-cuts")
MAX_AGE_SECONDS = 7 * 24 * 60 * 60

REMINDER = (
    "Первая правка кода в ветке `{branch}` в этой сессии. "
    "Правило «Объём работы» (~/.claude/CLAUDE.md): прежде чем продолжать, должен "
    "быть озвучен блок **Цель / Срезы** — с реальным прогоном обоих тестов, на "
    "введение в заблуждение и на отвергнутую альтернативу. "
    "Если он уже озвучен для этой задачи — просто продолжай, не повторяйся. "
    "Если нет — выдай его сейчас, до правок."
)


def current_branch(cwd):
    try:
        result = subprocess.run(
            ["git", "-C", cwd, "rev-parse", "--abbrev-ref", "HEAD"],
            capture_output=True,
            text=True,
            timeout=5,
        )
    except (OSError, subprocess.SubprocessError):
        return "nogit"
    branch = result.stdout.strip()
    return branch if result.returncode == 0 and branch else "nogit"


def prune(now):
    try:
        for name in os.listdir(STATE_DIR):
            path = os.path.join(STATE_DIR, name)
            if now - os.path.getmtime(path) > MAX_AGE_SECONDS:
                os.remove(path)
    except OSError:
        pass


def main():
    try:
        payload = json.load(sys.stdin)
    except ValueError:
        return

    cwd = payload.get("cwd") or os.getcwd()
    session_id = payload.get("session_id") or "nosession"
    branch = current_branch(cwd)
    key = hashlib.sha256("{}\0{}".format(session_id, branch).encode()).hexdigest()[:32]

    try:
        os.makedirs(STATE_DIR, exist_ok=True)
        # O_EXCL collapses "have I fired already?" and "mark as fired" into one
        # atomic step, so two edits racing in the same turn can't both remind.
        fd = os.open(os.path.join(STATE_DIR, key), os.O_CREAT | os.O_EXCL | os.O_WRONLY, 0o600)
    except OSError:
        return

    try:
        os.write(fd, "{}\n".format(branch).encode())
    finally:
        os.close(fd)

    prune(time.time())

    json.dump(
        {
            "hookSpecificOutput": {
                "hookEventName": "PreToolUse",
                "additionalContext": REMINDER.format(branch=branch),
            }
        },
        sys.stdout,
        ensure_ascii=False,
    )


if __name__ == "__main__":
    main()
