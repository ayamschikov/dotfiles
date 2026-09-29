#!/usr/bin/env python3
"""PreToolUse(Bash) hook: deny full-filesystem `find` scans.

On macOS, `find /`, `find ~`, or `find /Library|/System|/Applications` walks into
TCC-protected folders and triggers a flood of "Terminal wants access to ..."
permission dialogs. This hook inspects the Bash command, finds every `find`
invocation, checks its search-root arguments, and denies the tool call when a
root resolves to the filesystem root, the bare home directory, or a
TCC-protected system directory. Repo-scoped scans (e.g.
`find /Users/<me>/projects/...`, `find .`) are allowed.
"""
import json
import os
import re
import sys


def is_find_start(tok):
    # `find`, `/usr/bin/find`, `./find`, `$(find`, `` `find `` — but NOT
    # `myfind`, `oldfind`, or a Ruby `arr.find` method call.
    return re.search(r"(^|[^A-Za-z0-9_.])find$", tok) is not None


# find primaries whose *following* token is a path operand, not a search root.
PATH_ARG_OPTS = {
    "-newer", "-anewer", "-cnewer", "-samefile",
    "-fprint", "-fprintf", "-fls", "-fprint0",
}

# Separators that end a single find's argument list.
SEPS = {"|", "||", "&&", ";", "&", "(", ")", "{", "}", "|&"}

DANGER_PREFIXES = ("/System", "/Library", "/Applications",
                   "/private", "/Volumes", "/Network")


def root_is_dangerous(tok, home):
    if tok in ("/",):
        return True
    if tok in ("~", "~/", "$HOME", "${HOME}"):
        return True
    p = tok.replace("${HOME}", home).replace("$HOME", home)
    if p.startswith("~"):
        p = home + p[1:]
    if not (p.startswith("/") or p == home):
        return False
    p = os.path.normpath(p)
    if p == "/" or p == "/Users":
        return True
    if any(p == d or p.startswith(d + "/") for d in DANGER_PREFIXES):
        return True
    if p == home:                       # bare home; subdirs like ~/projects are fine
        return True
    if p.startswith(home + "/Library"):
        return True
    return False


def command_is_dangerous(cmd, home):
    import shlex
    try:
        tokens = shlex.split(cmd, posix=True)
    except ValueError:
        tokens = cmd.split()

    i, n = 0, len(tokens)
    while i < n:
        if is_find_start(tokens[i]):
            j = i + 1
            while j < n:
                a = tokens[j]
                if a in SEPS or a[:1] in (";", "&") or a.startswith("|"):
                    break
                if re.match(r"^\d*[<>]", a):           # redirection like 2>/dev/null
                    j += 1
                    continue
                if a in PATH_ARG_OPTS:                  # skip the option AND its path operand
                    j += 2
                    continue
                if a.startswith("-"):                   # other option / primary
                    j += 1
                    continue
                if root_is_dangerous(a, home):
                    return True
                j += 1
        i += 1
    return False


def main():
    try:
        data = json.load(sys.stdin)
    except Exception:
        sys.exit(0)

    cmd = ((data.get("tool_input") or {}).get("command") or "")
    if "find" not in cmd:
        sys.exit(0)

    if command_is_dangerous(cmd, os.path.expanduser("~")):
        reason = (
            "Blocked a full-filesystem `find` scan (search root is '/', the bare "
            "home '~', or a macOS TCC-protected dir like /System, /Library or "
            "/Applications). Such scans pop repeated 'Terminal wants access to ...' "
            "permission dialogs. Scope the search to your project directory instead "
            "(e.g. `find <repo-path> ...`) or use `rg`. Note: on this machine Ruby "
            "gems live only inside Docker, so do not scan the host disk for gem sources."
        )
        print(json.dumps({
            "hookSpecificOutput": {
                "hookEventName": "PreToolUse",
                "permissionDecision": "deny",
                "permissionDecisionReason": reason,
            }
        }))
    sys.exit(0)


main()
