#!/usr/bin/env python3
"""Tests for ci-gate.py: run the hook as Claude Code does (JSON on stdin).

    python3 ~/.claude/hooks/tests/test_ci_gate.py
"""
import json
import os
import subprocess
import tempfile
import unittest

HERE = os.path.dirname(os.path.realpath(__file__))
HOOK = os.path.join(HERE, "..", "ci-gate.py")


def decide(tool, tool_input, cwd=None):
    payload = {"tool_name": tool, "tool_input": tool_input}
    if cwd:
        payload["cwd"] = cwd
    out = subprocess.run(
        ["python3", HOOK], input=json.dumps(payload),
        capture_output=True, text=True, timeout=10, check=True,
    ).stdout
    return json.loads(out)["hookSpecificOutput"]["permissionDecision"] if out else "pass"


def bash(cmd, cwd=None):
    return decide("Bash", {"command": cmd}, cwd)


API = "https://gitlab.example.com/api/v4/projects/1"


class McpTools(unittest.TestCase):
    def test_launches_ask(self):
        for tool in ("play_pipeline_job", "retry_pipeline", "retry_pipeline_job", "create_pipeline",
                     "play_pipeline_jobs", "play_pipeline_schedule", "trigger_pipeline",
                     "approve_deployment", "create_pipeline_schedule", "create_tag",
                     "cancel_pipeline", "cancel_pipeline_job", "delete_pipeline",
                     "erase_pipeline_job", "update_pipeline_metadata", "delete_pipeline_schedule",
                     "take_ownership_pipeline_schedule", "create_pipeline_trigger",
                     "delete_pipeline_trigger", "stop_environment", "delete_environment",
                     "stop_stale_environments", "delete_review_app_environments",
                     "update_deployment", "create_deployment", "create_variable"):
            with self.subTest(tool=tool):
                self.assertEqual(decide(f"mcp__gitlab__{tool}", {"project_id": "1"}), "ask")

    def test_reads_pass(self):
        for tool in ("list_pipelines", "get_pipeline", "list_pipeline_jobs",
                     "get_pipeline_job_output", "list_job_artifacts", "download_job_artifacts",
                     "wait_for_pipeline", "list_environments", "get_runner", "get_merge_request"):
            with self.subTest(tool=tool):
                self.assertEqual(decide(f"mcp__gitlab__{tool}", {"project_id": "1"}), "pass")

    def test_other_gitlab_server_name(self):
        self.assertEqual(decide("mcp__selfhosted-gitlab__cancel_pipeline", {}), "ask")


class Glab(unittest.TestCase):
    def test_launches_ask(self):
        for cmd in ("glab ci run -b master", "glab ci retry 123", "glab ci trigger 123",
                    "glab pipeline run", "glab -R a/b ci run", "glab schedule run 5",
                    "glab release create v1", f"glab api -X POST projects/1/jobs/2/play",
                    "glab api projects/1/pipeline -f ref=master",
                    "glab api graphql -f query='mutation { jobPlay(input: {}) { job { id } } }'",
                    "glab ci cancel pipeline 5", "glab ci delete 5", "glab schedule delete 3",
                    "glab variable set FOO bar", "glab variable delete FOO",
                    "glab api -X DELETE projects/1/pipelines/5", "glab api -X POST projects/1/jobs/2/erase",
                    "glab api -X PUT projects/1/pipelines/5/metadata -f name=x"):
            with self.subTest(cmd=cmd):
                self.assertEqual(bash(cmd), "ask")

    def test_reads_pass(self):
        for cmd in ("glab ci list", "glab ci status", "glab ci trace 5", "glab ci lint",
                    "glab ci artifact master job", "glab api projects/1/pipelines",
                    "glab api projects/1/jobs/2/trace", "glab mr list", "glab variable list",
                    "glab release view v1"):
            with self.subTest(cmd=cmd):
                self.assertEqual(bash(cmd), "pass")


class Curl(unittest.TestCase):
    def test_launches_ask(self):
        for cmd in (f"curl -X POST '{API}/pipeline?ref=master'",
                    f"curl --request POST {API}/jobs/5/retry",
                    f"curl -d token=x -d ref=v1 {API}/trigger/pipeline",
                    f"curl -XPOST {API}/pipeline_schedules/3/play",
                    f"curl -X POST {API}/pipelines/5/cancel", f"curl -X DELETE {API}/pipelines/5",
                    f"curl --request PUT {API}/variables/FOO -d value=1",
                    "curl -X POST https://gitlab.example.com/api/graphql "
                    "-d '{\"query\":\"mutation { pipelineCancel(input: {}) { errors } }\"}'"):
            with self.subTest(cmd=cmd):
                self.assertEqual(bash(cmd), "ask")

    def test_reads_pass(self):
        for cmd in (f"curl {API}/pipelines", f"curl -s {API}/jobs/5/artifacts/feature_flags.csv",
                    f"curl -X POST {API}/merge_requests/1/notes -d body=x"):
            with self.subTest(cmd=cmd):
                self.assertEqual(bash(cmd), "pass")


class GitPush(unittest.TestCase):
    def test_tags_ask(self):
        for cmd in ("git push --tags", "git push origin --follow-tags", "git push origin v8.10.13",
                    "git push origin refs/tags/x", "git -C /tmp push origin 8.1.0",
                    "git push --mirror origin"):
            with self.subTest(cmd=cmd):
                self.assertEqual(bash(cmd), "ask")

    def test_local_tag_by_name_asks(self):
        with tempfile.TemporaryDirectory() as d:
            subprocess.run(["git", "init", "-q", d], check=True)
            subprocess.run(["git", "-C", d, "-c", "user.email=a@b", "-c", "user.name=a",
                            "commit", "-q", "--allow-empty", "-m", "x"], check=True)
            subprocess.run(["git", "-C", d, "tag", "release-x"], check=True)
            self.assertEqual(bash("git push origin release-x", cwd=d), "ask")
            self.assertEqual(bash("git push origin feature/x", cwd=d), "pass")

    def test_branches_and_deletes_pass(self):
        for cmd in ("git push", "git push -u origin feature/PROJ-1-x", "git push --force-with-lease",
                    "git push origin HEAD:feature/x", "git push --delete origin v1.2",
                    "git push origin :v1.2", "git fetch origin --tags", "git tag -l"):
            with self.subTest(cmd=cmd):
                self.assertEqual(bash(cmd), "pass")


class Shell(unittest.TestCase):
    def test_nested_shell_asks(self):
        self.assertEqual(bash("bash -c 'glab ci run -b master'"), "ask")

    def test_heredoc_data_passes(self):
        self.assertEqual(bash("cat > /tmp/x.md <<'EOF'\nglab ci run\ngit push --tags\nEOF"), "pass")

    def test_unparsable_falls_back(self):
        self.assertEqual(bash("glab ci run -b 'master"), "ask")
        self.assertEqual(bash("echo 'unbalanced"), "pass")

    def test_unrelated_passes(self):
        self.assertEqual(bash("ls -la && git status"), "pass")
        self.assertEqual(decide("Read", {"file_path": "/tmp/x"}), "pass")


if __name__ == "__main__":
    unittest.main()
