#!/usr/bin/env python3
"""PreToolUse hook: nothing leaves for GitLab / Jira / Slack unchecked.

1. Text gate. MR descriptions, Jira descriptions/comments and Slack messages
   are denied unless the exact text was approved with `publish-approve`
   (after sepia + a diffx review). Creating an MR additionally requires the
   branch head to be approved (`publish-approve --git`).
2. Explicit confirmation. GitLab comments/threads/approvals, Slack drafts and
   every Slack send (after the text gate) return "ask", so the user confirms
   the actual send. Same for CLI/curl bypasses in Bash.
3. Tamper guard. Writing into the approvals dir other than via
   `publish-approve` is denied.

State: ~/.claude/state/publish/{drafts,approved}. See publish-approve.
"""
import hashlib
import json
import os
import re
import shlex
import subprocess
import sys

STATE = os.path.expanduser("~/.claude/state/publish")
APPROVED = os.path.join(STATE, "approved")
# Reports of text-check (fresh-context reviewer); publish-approve requires one.
CHECKS = os.path.join(STATE, "checks")
DRAFTS = os.path.join(STATE, "drafts")
APPROVE_CMD = "~/.claude/hooks/publish-approve"

# tool -> list of text fields to gate (dotted path; "sections[].content" = list)
TEXT_GATED = {
    "mcp__gitlab__create_merge_request": ["description"],
    "mcp__gitlab__update_merge_request": ["description"],
    "mcp__atlassian__createJiraIssue": ["description"],
    "mcp__atlassian__editJiraIssue": ["fields.description", "fields.environment"],
    "mcp__atlassian__addCommentToJiraIssue": ["commentBody"],
    "mcp__claude_ai_Slack__slack_send_message": ["message"],
    "mcp__claude_ai_Slack__slack_schedule_message": ["message"],
    "mcp__claude_ai_Slack__slack_create_canvas": ["content"],
    "mcp__claude_ai_Slack__slack_update_canvas": ["content", "sections[].content"],
}
# The same Atlassian server (mcp.atlassian.com) is reachable as the per-project `atlassian`
# MCP and as the claude.ai connector; both names must be gated.
for _prefix in ("mcp__atlassian__", "mcp__claude_ai_Atlassian__"):
    TEXT_GATED.update({
        _prefix + "createJiraIssue": ["description"],
        _prefix + "editJiraIssue": ["fields.description", "fields.environment"],
        _prefix + "addCommentToJiraIssue": ["commentBody"],
    })

# tools that always need an explicit "yes" from the user at send time
ASK_ALWAYS = re.compile(
    r"^mcp__claude_ai_Slack__slack_(send_message|send_message_draft|schedule_message"
    r"|create_canvas|update_canvas|add_reaction|create_conversation)$"
    r"|^mcp__gitlab__(create_merge_request_note|create_merge_request_thread"
    r"|create_merge_request_discussion_note|update_merge_request_note"
    r"|update_merge_request_discussion_note|create_note|create_issue_note|update_issue_note"
    r"|publish_draft_note|bulk_publish_draft_notes|approve_merge_request|unapprove_merge_request"
    r"|resolve_merge_request_thread|create_issue|update_issue)$"
)

# diffx/revdiff started directly: Claude picks the diff range itself and drags in
# other people's commits or uncommitted changes. Only the `review` wrapper may run them.
DIRECT_REVIEW = re.compile(r"(^|[;&|(]\s*)(\S*/)?(diffx|revdiff)(\s|$)(?!\s*(-v|--version|-h|--help|--dump-config))")
REVIEW_CMD = "~/.claude/bin/review"

# Fallback when the command cannot be tokenized: anything that may write asks.
BASH_ASK = re.compile(
    r"\bglab\s+(mr\s+(create|note|update|approve|comment)|issue\s+(create|note|comment)|api\b)"
    r"|\bjira\s+issue\s+(create|comment|edit)"
    r"|slack\.com/api"
    r"|gitlab\.taxdome\.dev/api/v4/"
)
# Cheap prefilter: commands that mention none of these never need parsing.
BASH_CANDIDATE = re.compile(r"\b(glab|jira|curl)\b")

GLAB_WRITE_SUB = {
    "mr": {"create", "note", "update", "approve", "comment"},
    "issue": {"create", "note", "comment"},
}
JIRA_WRITE_SUB = {"issue": {"create", "comment", "edit"}}
READ_METHODS = {"GET", "HEAD"}
CONTROL_OPS = {"|", "||", "&", "&&", ";", ";;", "(", ")", "\n"}
# Slack Web API is POST for reads too, so the method name decides.
SLACK_METHOD = re.compile(r"slack\.com/api/([A-Za-z0-9_.]+)")
SLACK_READ_LAST = {"history", "replies", "info", "list", "members", "test"}


# Heredoc bodies fed to these commands are written out as data, not run.
HEREDOC_DATA_CMDS = {"cat", "tee"}
HEREDOC_OP = re.compile(r"(?<!<)<<(-?)\s*(['\"]?)([A-Za-z_][A-Za-z0-9_]*)\2")
# A data heredoc whose file is then handed to one of these is code after all.
EXEC_CMDS = {
    "bash", "sh", "zsh", "dash", "ksh", "source", ".", "exec", "eval", "env", "xargs",
    "chmod", "python", "python3", "ruby", "node", "perl", "osascript",
}
# Naming publish-approve as an argument of these only reads or tracks the file.
APPROVE_READ_CMDS = {"cat", "head", "tail", "less", "grep", "rg", "ls", "wc", "diff",
                     "file", "stat", "readlink"}
APPROVE_READ_GIT = {"add", "show", "log", "diff", "status", "blame", "ls-files"}
# Redirects that cannot leave the file's text anywhere it could be run from.
HARMLESS_REDIRECT = re.compile(r"\d?>&\d|\d?>\s*/dev/null")


def commit_message_from_stdin(args):
    """True for `git [-C dir] commit ... -F -`: the heredoc is the commit message."""
    i = 0
    while i < len(args) and args[i].startswith("-"):
        i += 2 if args[i] == "-C" else 1
    if i >= len(args) or args[i] != "commit":
        return False
    rest = args[i + 1:]
    return any(
        a in ("-F-", "--file=-") or (a in ("-F", "--file") and j + 1 < len(rest) and rest[j + 1] == "-")
        for j, a in enumerate(rest)
    )


def heredoc_data_target(line, start):
    """For the heredoc operator at `start`, the file it writes to ("" = stdout)
    if its body is plain data; None if the body may be executed."""
    # Pipes and command substitution can hand the body to an interpreter.
    if "|" in line or "$(" in line or "`" in line:
        return None
    prefix = re.split(r"&&|;|&|\(", line[:start])[-1]
    try:
        words = shlex.split(prefix + " " + HEREDOC_OP.sub(" ", line[start:]))
    except ValueError:
        return None
    while words and re.match(r"^[A-Za-z_][A-Za-z0-9_]*=", words[0]):
        words = words[1:]
    if words and os.path.basename(words[0]) == "git" and commit_message_from_stdin(words[1:]):
        return ""
    if not words or os.path.basename(words[0]) not in HEREDOC_DATA_CMDS:
        return None
    if words[0] == "tee":
        files = [w for w in words[1:] if not w.startswith("-")]
        return files[0] if files else ""
    for i, w in enumerate(words):
        if w in (">", ">>") and i + 1 < len(words):
            return words[i + 1]
        if w.startswith(">") and w.strip(">"):
            return w.strip(">")
    return ""


def executes(cmd, target):
    """True if `cmd` runs the file `target` (bash f, chmod +x f, ./f, ...)."""
    name = os.path.basename(target)
    for seg in re.split(r"&&|\|\||[;&|(\n]", cmd):
        words = seg.split()
        if not words:
            continue
        if os.path.basename(words[0]) == name:
            return True
        if os.path.basename(words[0]) in EXEC_CMDS and any(name in w for w in words[1:]):
            return True
    return False


def strip_data_heredocs(cmd):
    """Drop bodies of heredocs that `cat`/`tee` only write out, so text inside
    them (links, service names, example commands) is not taken for a send.

    Bodies fed to a shell or another interpreter stay in place and are checked.
    """
    lines = cmd.split("\n")
    out, data_targets, i = [], [], 0
    while i < len(lines):
        line = lines[i]
        out.append(line)
        i += 1
        for m in HEREDOC_OP.finditer(line):
            strip_tabs, delim = m.group(1) == "-", m.group(3)
            end = i
            while end < len(lines):
                body_line = lines[end].lstrip("\t") if strip_tabs else lines[end]
                if body_line == delim:
                    break
                end += 1
            if end == len(lines):
                return cmd  # unterminated heredoc: leave everything to the checks
            body = lines[i:end + 1]
            i = end + 1
            target = heredoc_data_target(line, m.start())
            if target is None:
                out.extend(body)
            else:
                data_targets.append((target, len(out), body))
    stripped = "\n".join(out)
    # A data file run later in the same command is code: put its body back.
    for target, pos, body in reversed(data_targets):
        if target and executes(stripped, target):
            out[pos:pos] = body
    return "\n".join(out)


def split_segments(cmd):
    """Tokenize a shell command and split it into simple commands.

    Raises ValueError on unbalanced quotes; the caller falls back to BASH_ASK.
    """
    lex = shlex.shlex(cmd.replace("\n", " ; "), posix=True, punctuation_chars=True)
    lex.whitespace_split = True
    segments, cur = [], []
    for tok in lex:
        if tok in CONTROL_OPS or (tok and set(tok) <= set("|&;()<>")):
            if cur:
                segments.append(cur)
            cur = []
        else:
            cur.append(tok)
    if cur:
        segments.append(cur)
    return segments


def git_reads(args):
    """True for `git [-C dir] <read-only subcommand>`; any -c may define an alias."""
    i = 0
    while i < len(args) and args[i].startswith("-"):
        if args[i] == "-c":
            return False
        i += 2 if args[i] == "-C" else 1
    return i < len(args) and args[i] in APPROVE_READ_GIT


def approve_invoked(cmd):
    """True unless every mention of publish-approve is an argument of a read-only command.

    A redirect, command substitution or interpreter anywhere in the command counts as a
    call: `cat publish-approve` output can be run from there.
    """
    if "publish-approve" not in cmd:
        return False
    if re.search(r">|\$\(|`", HARMLESS_REDIRECT.sub(" ", cmd)):
        return True
    try:
        segments = split_segments(cmd)
    except ValueError:
        return True
    for seg in segments:
        name = os.path.basename(seg[0])
        if name in EXEC_CMDS:
            return True
        if not any("publish-approve" in tok for tok in seg):
            continue
        if name in APPROVE_READ_CMDS or (name == "git" and git_reads(seg[1:])):
            continue
        return True
    return False


def explicit_method(args, short, longs):
    """Value of -X/--method style flags (curl -XPOST, --request=PUT, ...)."""
    for i, a in enumerate(args):
        if a == short or a in longs:
            return args[i + 1].upper() if i + 1 < len(args) else ""
        if a.startswith(short) and len(a) > len(short) and not a.startswith("--"):
            return a[len(short):].upper()
        for flag in longs:
            if a.startswith(flag + "="):
                return a[len(flag) + 1:].upper()
    return None


def has_flag(args, shorts, longs):
    for a in args:
        if a.startswith("--"):
            if a.split("=", 1)[0] in longs:
                return True
        elif a.startswith("-") and len(a) > 1 and a[1] in shorts:
            return True
    return False


def subcommand(args):
    """First positional argument, skipping flags (and -R/--repo values)."""
    skip = False
    for i, a in enumerate(args):
        if skip:
            skip = False
            continue
        if a in ("-R", "--repo"):
            skip = True
            continue
        if a.startswith("-"):
            continue
        return a, args[i + 1:]
    return None, []


def glab_writes(args):
    group, rest = subcommand(args)
    if group in GLAB_WRITE_SUB:
        sub, _ = subcommand(rest)
        return sub in GLAB_WRITE_SUB[group]
    if group != "api":
        return False
    endpoint, _ = subcommand(rest)
    if endpoint == "graphql":
        return any("mutation" in a for a in rest)
    method = explicit_method(rest, "-X", ("--method",))
    if method is not None:
        return method not in READ_METHODS
    # glab api, like gh api, switches GET -> POST when parameters are passed.
    return has_flag(rest, "fF", ("--field", "--raw-field", "--input"))


def jira_writes(args):
    group, rest = subcommand(args)
    if group in JIRA_WRITE_SUB:
        sub, _ = subcommand(rest)
        return sub in JIRA_WRITE_SUB[group]
    return False


def slack_method_writes(name):
    if name.startswith("search.") or name == "auth.test":
        return False
    last = name.rsplit(".", 1)[-1]
    return not (last in SLACK_READ_LAST or last.startswith(("get", "lookup")))


def curl_writes(args):
    joined = " ".join(args)
    slack = SLACK_METHOD.findall(joined)
    if slack:
        return any(slack_method_writes(m) for m in slack)
    if "slack.com/api" in joined:
        return True
    if not re.search(r"gitlab", joined, re.I):
        return False
    method = explicit_method(args, "-X", ("--request",))
    if method is not None:
        return method not in READ_METHODS
    if has_flag(args, "G", ("--get",)):
        return False
    return has_flag(args, "dFT", (
        "--data", "--data-raw", "--data-binary", "--data-urlencode", "--data-ascii",
        "--json", "--form", "--form-string", "--upload-file",
    ))


def bash_writes(cmd, depth=0):
    """True if the command may write to GitLab/Jira/Slack; None if unparsable."""
    if not BASH_CANDIDATE.search(cmd):
        return False
    try:
        segments = split_segments(cmd)
    except ValueError:
        return None
    for seg in segments:
        for i, tok in enumerate(seg):
            # bash -c "...", $(...) and the like: look inside quoted strings.
            if depth < 3 and " " in tok and BASH_CANDIDATE.search(tok):
                inner = bash_writes(tok, depth + 1)
                if inner is None or inner:
                    return inner
            name = os.path.basename(tok)
            args = seg[i + 1:]
            if name == "glab" and glab_writes(args):
                return True
            if name == "jira" and jira_writes(args):
                return True
            if name == "curl" and curl_writes(args):
                return True
    return False


def normalize(text):
    lines = text.replace("\r\n", "\n").split("\n")
    return "\n".join(line.rstrip() for line in lines).strip()


def digest(text):
    return hashlib.sha256(normalize(text).encode("utf-8")).hexdigest()


def extract(obj, path):
    if path.endswith("[]") or "[]." in path:
        head, _, rest = path.partition("[].")
        items = extract(obj, head) or []
        out = []
        for item in items if isinstance(items, list) else []:
            val = extract(item, rest)
            if val is not None:
                out.append(val)
        return out
    cur = obj
    for part in path.split("."):
        if not isinstance(cur, dict):
            return None
        cur = cur.get(part)
    return cur


def emit(decision, reason):
    print(json.dumps({
        "hookSpecificOutput": {
            "hookEventName": "PreToolUse",
            "permissionDecision": decision,
            "permissionDecisionReason": reason,
        }
    }, ensure_ascii=False))
    sys.exit(0)


def deny_text(tool, preview):
    emit("deny", (
        f"publish-gate: текст для {tool} не одобрен пользователем. Порядок:\n"
        "1) прогони текст через скилл sepia (язык и стиль — как требует контекст);\n"
        f"2) запиши итоговый текст ровно в том виде, в каком он уйдёт, в {DRAFTS}/<короткое-имя>.md, "
        f"а рядом — {DRAFTS}/<короткое-имя>.sources.md: откуда каждый факт (пути, команды, ссылки, "
        "выдержки из Jira/Slack — к ним у проверяющего нет доступа);\n"
        f"3) выполни `{REVIEW_CMD} text {DRAFTS}/<короткое-имя>.md` (run_in_background: true) — "
        "сначала текст проверит агент; код 6 — исправь его блокирующие замечания и запусти снова; "
        "затем откроется ревью; учти замечания и повтори ревью, пока замечаний нет;\n"
        f"4) выполни `{APPROVE_CMD} {DRAFTS}/<короткое-имя>.md` (пользователь подтвердит одобрение);\n"
        "5) повтори вызов, передав содержимое файла без изменений.\n"
        f"Начало заблокированного текста: {preview!r}"
    ))


def git_head(cwd, ref):
    try:
        return subprocess.run(
            ["git", "-C", cwd, "rev-parse", "--verify", "--quiet", ref + "^{commit}"],
            capture_output=True, text=True, timeout=5,
        ).stdout.strip()
    except Exception:
        return ""


def check_text(tool, tool_input):
    for path in TEXT_GATED[tool]:
        val = extract(tool_input, path)
        vals = val if isinstance(val, list) else [val]
        for text in vals:
            if text is None:
                continue
            if not isinstance(text, str):
                emit("deny", "publish-gate: передай текст строкой в markdown "
                     "(contentFormat: \"markdown\"), ADF-объект проверить нельзя.")
            if not normalize(text):
                continue
            if not os.path.exists(os.path.join(APPROVED, digest(text))):
                deny_text(tool, normalize(text)[:120])


def check_mr_code(tool_input, cwd):
    branch = tool_input.get("source_branch") or ""
    sha = git_head(cwd, branch) if branch else ""
    if not sha:
        emit("deny", (
            f"publish-gate: не нашёл локальную ветку {branch!r} в {cwd}, "
            "поэтому не могу проверить, что код просмотрен в diffx. "
            "Запусти из каталога репозитория, где есть эта ветка."
        ))
    if not os.path.exists(os.path.join(APPROVED, "git-" + sha)):
        target = tool_input.get("target_branch") or "master"
        emit("deny", (
            f"publish-gate: код ветки {branch} (HEAD {sha[:10]}) не проверен пользователем в diffx. "
            f"Выполни в репозитории `{REVIEW_CMD} branch --target {target}` (run_in_background: true), "
            f"учти замечания пользователя, затем выполни "
            f"`{APPROVE_CMD} --git {cwd} {branch}` и повтори создание MR."
        ))


def main():
    try:
        data = json.load(sys.stdin)
    except Exception:
        sys.exit(0)
    tool = data.get("tool_name", "")
    tool_input = data.get("tool_input") or {}
    cwd = data.get("cwd") or os.getcwd()

    if tool == "Bash":
        raw = tool_input.get("command", "")
        cmd = strip_data_heredocs(raw)
        if approve_invoked(cmd):
            emit("ask", "Одобрить к публикации то, что ты проверил в diffx? "
                 f"Команда: {raw}")
        if "state/publish/approved" in cmd:
            emit("deny", "publish-gate: одобрения ставит только publish-approve.")
        if "state/publish/checks" in cmd or "state/publish/stats" in cmd:
            emit("deny", "publish-gate: отчёты проверки и статистику пишет только text-check; "
                 "отчёт для автора он печатает сам.")
        if DIRECT_REVIEW.search(cmd) and "bin/review" not in cmd:
            emit("deny", (
                "publish-gate: не запускай diffx/revdiff напрямую — диапазон считает обёртка. "
                f"Код ветки: `{REVIEW_CMD} branch` (из каталога репозитория); "
                f"текст: `{REVIEW_CMD} text <черновик>`; `--tool diffx` — если пользователь просит diffx. "
                "Запускай с run_in_background: true и жди, пока пользователь закроет ревью."
            ))
        writes = bash_writes(cmd)
        if writes or (writes is None and BASH_ASK.search(cmd)):
            emit("ask", f"Команда пишет во внешнюю систему (GitLab/Jira/Slack): {raw[:300]}")
        sys.exit(0)

    if tool in ("Write", "Edit", "MultiEdit", "NotebookEdit"):
        path = os.path.realpath(os.path.expanduser(
            tool_input.get("file_path") or tool_input.get("notebook_path") or ""))
        if path.startswith(os.path.realpath(APPROVED) + os.sep):
            emit("deny", "publish-gate: одобрения ставит только publish-approve.")
        if (path.startswith(os.path.realpath(CHECKS) + os.sep)
                or path == os.path.realpath(os.path.join(STATE, "stats.jsonl"))):
            emit("deny", "publish-gate: отчёты проверки и статистику пишет только text-check.")
        sys.exit(0)

    if tool in TEXT_GATED:
        check_text(tool, tool_input)
    if tool == "mcp__gitlab__create_merge_request":
        check_mr_code(tool_input, cwd)
    if ASK_ALWAYS.match(tool):
        target = tool_input.get("channel_id") or tool_input.get("merge_request_iid") or ""
        emit("ask", f"Отправить во внешнюю систему ({tool} {target})? Проверь текст в запросе.")
    sys.exit(0)


if __name__ == "__main__":
    main()
