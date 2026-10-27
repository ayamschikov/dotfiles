#!/usr/bin/env python3
"""PreToolUse hook: nothing changes in GitLab CI without the user's "yes".

Returns "ask" for anything that starts, cancels, deletes or edits pipelines,
jobs, schedules, triggers, environments, deployments, CI variables, runners,
tags or releases: GitLab MCP tools other than list/get/download/wait,
`glab ci|schedule|release|variable ...` other than reads, `glab api` / `curl`
writes to the same endpoints, and `git push` of tags (a tag pipeline deploys
to production). Branch pushes pass: they start a branch pipeline, and pushing
branches is allowed without asking. Reading pipelines, logs and artifacts passes.

Shell parsing is shared with publish-gate.py.
"""
import importlib.util
import json
import os
import re
import subprocess
import sys

HERE = os.path.dirname(os.path.realpath(__file__))
_spec = importlib.util.spec_from_file_location("publish_gate", os.path.join(HERE, "publish-gate.py"))
pg = importlib.util.module_from_spec(_spec)
_spec.loader.exec_module(pg)

MCP_GITLAB = re.compile(r"^mcp__.*gitlab.*__(?P<op>.+)$")
CI_NOUN = re.compile(r"pipeline|job|schedule|trigger|deployment|environment|runner|variable"
                     r"|tag|release")
MCP_READ = re.compile(r"^(list|get|download|wait_for|search)_")

# glab groups that act on CI; everything except these read subcommands asks.
GLAB_CI_READS = {
    "ci": {"list", "status", "trace", "lint", "get", "artifact", "config"},
    "pipe": {"list", "status", "trace", "lint", "get", "artifact", "config"},
    "pipeline": {"list", "status", "trace", "lint", "get", "artifact", "config"},
    "job": {"artifact"},
    "schedule": {"list"},
    "release": {"list", "view", "download"},
    "variable": {"list", "get", "export"},
}
# REST resources of CI; any write to them asks.
CI_ENDPOINT = re.compile(
    r"(^|/)(pipelines?|jobs|pipeline_schedules|triggers?|deployments|environments|variables"
    r"|runners|repository/tags|releases)(?=$|[?/])"
)
CI_MUTATION = re.compile(r"mutation.*(pipeline|job|schedule|trigger|deployment|environment"
                         r"|runner|variable|tag|release)", re.I | re.S)
GLAB_LAUNCH_DATA = ("--field", "--raw-field", "--input")
GLAB_API_VALUE_FLAGS = {"-X", "--method", "-H", "--header", "-f", "--field", "-F",
                        "--raw-field", "--input", "--hostname", "-R", "--repo"}
CURL_DATA = (
    "--data", "--data-raw", "--data-binary", "--data-urlencode", "--data-ascii",
    "--json", "--form", "--form-string", "--upload-file",
)
# Fallback when the command cannot be tokenized.
BASH_ASK = re.compile(
    r"\bglab\s+(ci|pipe|pipeline|job|schedule|release|variable|api)\b"
    r"|gitlab\.example\.com/api/v4/"
    r"|\bgit\b.*\bpush\b.*(--tags|--follow-tags|--mirror|refs/tags/)"
)
BASH_CANDIDATE = re.compile(r"\b(glab|curl|git)\b")
TAG_LIKE = re.compile(r"^v?\d+\.\d+")
GIT_PUSH_VALUE_FLAGS = {"-o", "--push-option", "--repo", "--receive-pack", "--exec"}


def api_endpoint(args):
    """Endpoint of `glab api`: the first positional that is not a flag value."""
    skip = False
    for a in args:
        if skip:
            skip = False
        elif a in GLAB_API_VALUE_FLAGS:
            skip = True
        elif not a.startswith("-"):
            return a
    return None


def glab_changes(args):
    group, rest = pg.subcommand(args)
    if group in GLAB_CI_READS:
        sub, _ = pg.subcommand(rest)
        return sub is not None and sub not in GLAB_CI_READS[group]
    if group != "api":
        return False
    endpoint = api_endpoint(rest)
    if endpoint == "graphql":
        return any(CI_MUTATION.search(a) for a in rest)
    if not endpoint or not CI_ENDPOINT.search(endpoint.split("?", 1)[0]):
        return False
    method = pg.explicit_method(rest, "-X", ("--method",))
    if method is not None:
        return method not in pg.READ_METHODS
    return pg.has_flag(rest, "fF", GLAB_LAUNCH_DATA)


def curl_changes(args):
    urls = [a for a in args if "gitlab" in a.lower()]
    if any("graphql" in u for u in urls):
        return any(CI_MUTATION.search(a) for a in args)
    if not any(CI_ENDPOINT.search(u.split("?", 1)[0]) for u in urls):
        return False
    method = pg.explicit_method(args, "-X", ("--request",))
    if method is not None:
        return method not in pg.READ_METHODS
    if pg.has_flag(args, "G", ("--get",)):
        return False
    return pg.has_flag(args, "dFT", CURL_DATA)


def is_local_tag(name, repo_dir):
    try:
        return subprocess.run(
            ["git", "-C", repo_dir, "show-ref", "--verify", "--quiet", f"refs/tags/{name}"],
            capture_output=True, timeout=5,
        ).returncode == 0
    except Exception:
        return False


def git_push_tags(args, cwd):
    """True if `git [...] push ...` sends a tag."""
    repo_dir, i = cwd, 0
    while i < len(args) and args[i].startswith("-"):
        if args[i] == "-C" and i + 1 < len(args):
            repo_dir = os.path.join(repo_dir, os.path.expanduser(args[i + 1]))
            i += 2
        elif args[i] in ("-c", "--git-dir", "--work-tree"):
            i += 2
        else:
            i += 1
    if i >= len(args) or args[i] != "push":
        return False
    rest = args[i + 1:]
    if any(a in ("-d", "--delete") for a in rest):
        return False
    if any(a in ("--tags", "--follow-tags", "--mirror") for a in rest):
        return True
    positional, skip = [], False
    for a in rest:
        if skip:
            skip = False
        elif a in GIT_PUSH_VALUE_FLAGS:
            skip = True
        elif not a.startswith("-"):
            positional.append(a)
    for spec in positional[1:]:
        src = spec.lstrip("+").split(":", 1)[0]
        if not src:
            continue  # ":ref" deletes
        if "refs/tags/" in spec or TAG_LIKE.match(src) or is_local_tag(src, repo_dir):
            return True
    return False


def bash_changes(cmd, cwd, depth=0):
    """True if the command may change something in CI; None if unparsable."""
    if not BASH_CANDIDATE.search(cmd):
        return False
    try:
        segments = pg.split_segments(cmd)
    except ValueError:
        return None
    for seg in segments:
        for i, tok in enumerate(seg):
            # bash -c "...", $(...) and the like: look inside quoted strings.
            if depth < 3 and " " in tok and BASH_CANDIDATE.search(tok):
                inner = bash_changes(tok, cwd, depth + 1)
                if inner is None or inner:
                    return inner
            name = os.path.basename(tok)
            args = seg[i + 1:]
            if name == "glab" and glab_changes(args):
                return True
            if name == "curl" and curl_changes(args):
                return True
            if name == "git" and git_push_tags(args, cwd):
                return True
    return False


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
        cmd = pg.strip_data_heredocs(raw)
        changes = bash_changes(cmd, cwd)
        if changes or (changes is None and BASH_ASK.search(cmd)):
            pg.emit("ask", f"ci-gate: команда может изменить CI (запуск, отмена, удаление, "
                    f"правка, деплой). Выполнять? {raw[:300]}")
        sys.exit(0)

    m = MCP_GITLAB.match(tool)
    if m and CI_NOUN.search(m["op"]) and not MCP_READ.match(m["op"]):
        target = {k: v for k, v in tool_input.items() if not isinstance(v, (dict, list))}
        pg.emit("ask", f"ci-gate: {tool} меняет CI. Выполнять? "
                f"{json.dumps(target, ensure_ascii=False)[:300]}")
    sys.exit(0)


if __name__ == "__main__":
    main()
