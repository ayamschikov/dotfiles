#!/usr/bin/env python3
"""Tests for publish-gate.py: run the hook as Claude Code does (JSON on stdin).

    python3 ~/.claude/hooks/tests/test_publish_gate.py
"""
import json
import os
import subprocess
import unittest

HERE = os.path.dirname(os.path.realpath(__file__))
HOOK = os.path.join(HERE, "..", "publish-gate.py")
FIXTURES = os.path.join(HERE, "fixtures")


def decide(tool, tool_input):
    out = subprocess.run(
        ["python3", HOOK], input=json.dumps({"tool_name": tool, "tool_input": tool_input}),
        capture_output=True, text=True, timeout=10, check=True,
    ).stdout
    return json.loads(out)["hookSpecificOutput"]["permissionDecision"] if out else "pass"


def bash(cmd):
    return decide("Bash", {"command": cmd})


def fixture(name):
    with open(os.path.join(FIXTURES, name)) as f:
        return f.read()


SEND_TEXT = (
    "curl -X POST https://slack.com/api/chat.postMessage -d text=hi\n"
    "glab mr note 1 -m hi\n"
    "jira issue comment add TD-1 hi\n"
    "~/.claude/hooks/publish-approve draft.md\n"
)


class LocalOnlyPasses(unittest.TestCase):
    """Text that heredoc writes to a file is data: links, service names, commands."""

    def test_sre_final_report(self):
        # 2026-10-02: cat heredoc mentions publish-approve; python edits todo.md
        self.assertEqual(bash(fixture("sre-final-report.sh")), "pass")

    def test_sre_launch_hookfix(self):
        # 2026-10-02: cat heredoc with the task text, then tmux runs claude on it
        self.assertEqual(bash(fixture("sre-launch-hookfix.sh")), "pass")

    def test_cat_heredoc_with_send_commands(self):
        self.assertEqual(bash(f"cat > /tmp/x.md <<'EOF'\n{SEND_TEXT}EOF"), "pass")

    def test_tee_heredoc_with_send_commands(self):
        self.assertEqual(bash(f"tee -a /tmp/x.md >/dev/null <<EOF\n{SEND_TEXT}EOF"), "pass")

    def test_dash_heredoc_with_tab_delimiter(self):
        self.assertEqual(bash(f"cat > /tmp/x.md <<-EOF\n{SEND_TEXT}\tEOF\necho done"), "pass")

    def test_written_file_only_read_later(self):
        self.assertEqual(bash(f"cat > /tmp/x.md <<'EOF'\n{SEND_TEXT}EOF\nsed -n 1p /tmp/x.md"), "pass")

    def test_commit_message_heredoc(self):
        # 2026-10-19: a commit message naming publish-approve asked to approve a publication
        for flag in ("-F -", "-F-", "--file=-", "-q --file -"):
            with self.subTest(flag=flag):
                self.assertEqual(bash(
                    f"cd ~/dotfiles && git commit {flag} <<'EOF'\nTrack hooks\n\n"
                    f"publish-approve may actually run: ...\n{SEND_TEXT}EOF\n"
                    "git log --oneline -1 && git push 2>&1 | tail -1"), "pass")

    def test_slack_read_api(self):
        self.assertEqual(bash("curl -s https://slack.com/api/conversations.history"), "pass")


class SendsStillAsk(unittest.TestCase):
    def test_curl_slack_post(self):
        self.assertEqual(bash("curl -X POST https://slack.com/api/chat.postMessage -d text=hi"), "ask")

    def test_curl_slack_post_no_method(self):
        self.assertEqual(bash("curl https://slack.com/api/chat.postMessage"), "ask")

    def test_glab_mr_note(self):
        self.assertEqual(bash("glab mr note 123 -m 'hi'"), "ask")

    def test_jira_issue_comment(self):
        self.assertEqual(bash("jira issue comment add TD-1 'hi'"), "ask")

    def test_curl_gitlab_post(self):
        self.assertEqual(bash(
            "curl -X POST https://gitlab.taxdome.dev/api/v4/projects/1/merge_requests/2/notes"), "ask")

    def test_send_after_data_heredoc(self):
        self.assertEqual(bash(f"cat > /tmp/x.md <<'EOF'\nnotes\nEOF\nglab mr note 1 -m hi"), "ask")

    def test_bash_c(self):
        self.assertEqual(bash('bash -c "glab mr note 1 -m hi"'), "ask")


class HeredocAsCodeStillAsks(unittest.TestCase):
    """Bodies that a shell or interpreter runs are code."""

    def test_bash_heredoc(self):
        self.assertEqual(bash("bash <<'EOF'\nglab mr note 1 -m hi\nEOF"), "ask")

    def test_cat_heredoc_piped_to_shell(self):
        self.assertEqual(bash("cat <<'EOF' | sh\nglab mr note 1 -m hi\nEOF"), "ask")

    def test_cat_heredoc_in_command_substitution(self):
        self.assertEqual(bash('bash -c "$(cat <<\'EOF\'\nglab mr note 1 -m hi\nEOF\n)"'), "ask")

    def test_cat_heredoc_then_executed(self):
        self.assertEqual(bash("cat > /tmp/s.sh <<'EOF'\nglab mr note 1 -m hi\nEOF\nbash /tmp/s.sh"), "ask")

    def test_cat_heredoc_then_chmod_and_run(self):
        self.assertEqual(bash(
            "cat > s.sh <<'EOF'\nglab mr note 1 -m hi\nEOF\nchmod +x s.sh && ./s.sh"), "ask")

    def test_heredoc_to_git_not_as_message(self):
        # without -F - the body is not the message; keep checking it
        self.assertEqual(bash("git commit -m x <<'EOF'\nglab mr note 1 -m hi\nEOF"), "ask")
        self.assertEqual(bash("git commit -F - <<'EOF' | sh\nglab mr note 1 -m hi\nEOF"), "ask")

    def test_unterminated_heredoc(self):
        self.assertEqual(bash("cat > /tmp/x <<'EOF'\nglab mr note 1 -m hi"), "ask")


class GateBypassesBlocked(unittest.TestCase):
    def test_publish_approve_asks(self):
        self.assertEqual(bash("~/.claude/hooks/publish-approve ~/.claude/state/publish/drafts/x.md"), "ask")

    def test_publish_approve_in_bash_heredoc_asks(self):
        self.assertEqual(bash("bash <<'EOF'\n~/.claude/hooks/publish-approve x.md\nEOF"), "ask")

    def test_publish_approve_mentioned_in_argument_still_asks(self):
        # only read-only commands are exempt; echo can feed a shell
        self.assertEqual(bash('echo "then run publish-approve"'), "ask")

    def test_reading_publish_approve_passes(self):
        # 2026-10-19: `cat publish-approve` asked to approve a publication
        self.assertEqual(bash("cd ~/.claude/hooks && cat publish-approve; echo '-----'"), "pass")
        self.assertEqual(bash("grep -n gate ~/.claude/hooks/publish-approve 2>/dev/null"), "pass")
        self.assertEqual(bash("git -C ~/dotfiles add .claude/hooks/publish-approve"), "pass")

    def test_publish_approve_run_through_read_still_asks(self):
        for cmd in (
            "cat ~/.claude/hooks/publish-approve | sh",
            "cat ~/.claude/hooks/publish-approve > /tmp/a && /tmp/a x.md",
            'python3 -c "import os; os.system(\'publish-approve x.md\')"',
            "cat $(~/.claude/hooks/publish-approve x.md)",
            "git -c alias.x='!publish-approve x.md' x",
            "cp ~/.claude/hooks/publish-approve /tmp/a",
        ):
            with self.subTest(cmd=cmd):
                self.assertEqual(bash(cmd), "ask")

    def test_write_into_approved_via_heredoc_denied(self):
        self.assertEqual(bash("cat > ~/.claude/state/publish/approved/abc <<'EOF'\nx\nEOF"), "deny")

    def test_write_tool_into_approved_denied(self):
        path = os.path.expanduser("~/.claude/state/publish/approved/abc")
        self.assertEqual(decide("Write", {"file_path": path, "content": "x"}), "deny")

    def test_write_into_checks_denied(self):
        self.assertEqual(bash("echo '{}' > ~/.claude/state/publish/checks/abc.json"), "deny")
        path = os.path.expanduser("~/.claude/state/publish/checks/abc.json")
        self.assertEqual(decide("Write", {"file_path": path, "content": "{}"}), "deny")

    def test_write_into_stats_denied(self):
        path = os.path.expanduser("~/.claude/state/publish/stats.jsonl")
        self.assertEqual(decide("Edit", {"file_path": path, "old_string": "a", "new_string": "b"}),
                         "deny")

    def test_jira_comment_via_claude_ai_connector_denied(self):
        for prefix in ("mcp__atlassian__", "mcp__claude_ai_Atlassian__"):
            self.assertEqual(decide(prefix + "addCommentToJiraIssue",
                                    {"issueIdOrKey": "TD-1", "commentBody": "unapproved 7f3a"}), "deny")
            self.assertEqual(decide(prefix + "editJiraIssue",
                                    {"fields": {"description": "unapproved 7f3a"}}), "deny")

    def test_review_text_passes(self):
        self.assertEqual(bash("~/.claude/bin/review text ~/.claude/state/publish/drafts/x.md"), "pass")

    def test_direct_diffx_denied(self):
        self.assertEqual(bash("diffx master..HEAD"), "deny")


class McpSendsBlocked(unittest.TestCase):
    def test_slack_send_unapproved_text_denied(self):
        self.assertEqual(decide("mcp__claude_ai_Slack__slack_send_message",
                                {"channel_id": "C1", "message": "unapproved text 7f3a"}), "deny")

    def test_gitlab_note_asks(self):
        self.assertEqual(decide("mcp__gitlab__create_merge_request_note",
                                {"merge_request_iid": "1", "body": "x"}), "ask")

    def test_jira_comment_unapproved_denied(self):
        self.assertEqual(decide("mcp__atlassian__addCommentToJiraIssue",
                                {"issueIdOrKey": "TD-1", "commentBody": "unapproved text 7f3a"}), "deny")


if __name__ == "__main__":
    unittest.main(verbosity=2)
