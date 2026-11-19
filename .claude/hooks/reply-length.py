#!/usr/bin/env python3
"""UserPromptSubmit hook: tells Claude how long its previous reply was.

A Stop hook cannot shorten a reply: the user has already read it by the time
the hook runs, and a block only adds a second message. So the measurement goes
into the next turn's context, where it can still change the next reply.

Counted: prose the user reads in the chat during the previous turn, across all
of its text blocks. Not counted: fenced code blocks and blockquotes, which hold
command output and texts the user copies elsewhere.
"""
import json
import sys

MAX_LINES = 15
MAX_CHARS = 1500


def is_human_prompt(rec):
    if rec.get("type") != "user":
        return False
    origin = rec.get("origin") or {}
    return origin.get("kind") == "human" and isinstance(rec["message"].get("content"), str)


def turn_texts(path):
    turns, current = [], []
    with open(path, encoding="utf-8") as f:
        for line in f:
            try:
                rec = json.loads(line)
            except ValueError:
                continue
            if rec.get("isSidechain"):
                continue
            if is_human_prompt(rec):
                turns.append(current)
                current = []
            elif rec.get("type") == "assistant":
                for block in rec["message"].get("content") or []:
                    if isinstance(block, dict) and block.get("type") == "text":
                        current.append(block["text"])
    turns.append(current)
    return next((t for t in reversed(turns) if t), [])


def prose(texts):
    lines, in_fence = [], False
    for text in texts:
        for line in text.splitlines():
            stripped = line.strip()
            if stripped.startswith("```"):
                in_fence = not in_fence
                continue
            if in_fence or not stripped or stripped.startswith(">"):
                continue
            lines.append(stripped)
    return lines


def main():
    payload = json.load(sys.stdin)
    lines = prose(turn_texts(payload["transcript_path"]))
    chars = sum(len(line) for line in lines)
    if len(lines) <= MAX_LINES and chars <= MAX_CHARS:
        return
    note = (
        f"Твой предыдущий ответ в чате: {len(lines)} строк, {chars} знаков "
        f"(без блоков кода и цитат). Предел стиля brief-report — около {MAX_LINES} строк "
        f"и {MAX_CHARS} знаков. Этот ответ сделай короче: сначала решение или итог, "
        "подробности — одной строкой «о чём можно спросить». Тексты для копирования "
        "клади в блок кода, они не считаются."
    )
    print(json.dumps({"hookSpecificOutput": {"hookEventName": "UserPromptSubmit", "additionalContext": note}}, ensure_ascii=False))


if __name__ == "__main__":
    main()
