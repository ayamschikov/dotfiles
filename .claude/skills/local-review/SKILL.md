---
name: local-review
description: "Local line-by-line review by the user before anything is published: branch code before an MR, or a text draft (MR description, Jira text, Slack message). Runs ~/.claude/bin/review, which fixes the diff scope itself (only the branch's own commits since merge-base with fresh origin/master, no uncommitted changes, stops on other people's commits) and opens revdiff in a tmux popup. Use before creating an MR, before publishing any text (publish-gate requires it), after a commit the user wants to check, or when the user says «дай проверить», «покажи дифф», «ревью локально», «запусти revdiff», «запусти diffx»."
---

# Local review

Never choose the diff range yourself and never start `diffx`/`revdiff` directly — the
publish-gate hook denies it. The wrapper computes the scope; your job is to run it and act on
the result.

## Code of the current branch

From the repository directory (the branch checked out, work committed):

```bash
~/.claude/bin/review branch [--target master]
```

Run it with `run_in_background: true` and `timeout: 7200000` — the window stays open until
the user acts, which can take longer than a Bash timeout. Tell the user in one line where the
review is open and which key ends the round, then wait for the completion notification.

The branch review opens in a tmux window that outlives a round, so the reviewed marks (Space)
survive:
- `O` — send the annotations and keep the window. The output ends with
  `(окно ревью оставлено открытым; в следующем раунде нажми в нём R)`.
- On the next round of the same branch the wrapper reuses that window and asks for `R`, which
  reloads the diff and keeps the marks on files whose diff did not change.
- `q` with no annotations — approval, the window closes.

Before opening, the wrapper prints the commit list. Exit codes:
- `4` — other people's commits in the branch. Do **not** work around it: show the list, and
  offer to rebase onto `origin/master` or drop them. `--allow-foreign` only when the user
  says a colleague legitimately works in this branch.
- `3` — not in tmux: give the user the printed command.
- `2` — usage error (detached HEAD, on master, no commits).
- `5` — the reused window was closed with `q` but without `R`: the user saw the diff from
  before the new commits. Not an approval — run the round again and remind them to press `R`.

Uncommitted changes never get into the review; if the wrapper warns about them, tell the user
what is left out, or commit first if it belongs to the task.

## Text draft

The final text (after the sepia skill), exactly as it will be sent, goes to
`~/.claude/state/publish/drafts/<short-name>.md`, then:

Next to it write `<short-name>.sources.md`: where every fact of the text comes from — file
paths, repo + branch, commands to run, links, and verbatim excerpts from Jira/Slack/Confluence
(the checker has no access to them; an unexcerpted fact ends up «unconfirmed» and in front of
the user). Then:

```bash
~/.claude/bin/review text ~/.claude/state/publish/drafts/<short-name>.md
```

Run it with `run_in_background: true` and `timeout: 7200000`.

First `text-check` runs a separate `claude -p` (opus, fresh context, read-only tools) over the
draft and the sources; it takes several minutes. Its report is printed for you
(`=== ПРОВЕРКА АГЕНТОМ ===`): items «Автору» with ready edits (one item per kind of problem,
all its places listed), questions «Пользователю», unconfirmed claims.

Exit code `6` — there are items for you and you still have author rounds left (2 since the
user's last review): the user has not seen anything. Apply the edits by your own judgement,
`minor` included; for an unconfirmed claim add the excerpt to the sources (you have Jira,
Slack, GitLab, the checker does not) or drop the claim. Do not argue with the checker by
rewording a fact you cannot back. Then run `review text` again. Rerunning on an unchanged text
means you leave the remaining items as they are: the important ones (`blocker`, `doubt`) then
go to the user, `minor` ones are dropped.

**The user's text.** If the user wrote or edited the text themselves, or asked only to check it
(«проверь на ошибки», «только проверь»), run `review text <draft> --check-only` and do not edit
the text by the checker's items — not even `minor` ones, not even typos. The flag holds until the
approval. With it there is no exit `6`: every item, unconfirmed claims included, goes to the user
in `1-questions.md`, and you apply only the ones they answer «да». Edits made in the review window
set the same mark automatically (exit `7`). If exit `6` arrives on such a text anyway, do not
apply anything: rerun with `--check-only`. Do not run such a text through sepia either.

The user sees only what they have to decide: in revdiff the first file `1-questions.md` holds
the checker's questions (and important edits you did not close), the second is the draft as a
diff against the version the user saw last time (the whole text on the first showing). A
question left without a remark means «leave the text as it is». Once the text is in front of
the user, do not edit it except by the user's remarks — any edit starts a new check.

Never write into `~/.claude/state/publish/checks/` or `stats.jsonl` — publish-gate denies it,
and `publish-approve` refuses a text without a check of exactly that text.
`~/.claude/bin/text-check-stats` summarises how well the checks work.

## After the popup closes

The output ends with `=== ЗАМЕЧАНИЯ ПОЛЬЗОВАТЕЛЯ ===` and the annotations in the form
`## path:LINE (+|-|file-level)` + text. For each: a change request → apply it; a question →
answer it in chat. In a text review, remarks on `1-questions.md` answer the checker's
questions — the file is printed after them (`=== ВОПРОСЫ ===`) with line numbers; remarks on
the draft file use the draft's own line numbers. After applying changes, run the review again so the user sees the result.

revdiff can open the file in `$EDITOR`, and in a text review that file is a temporary copy. After
the window closes the wrapper compares the copy with what was shown and always prints
`Черновик в окне ревью: не изменён.` or the user's diff (`=== ПРАВКА ПОЛЬЗОВАТЕЛЯ В ОКНЕ РЕВЬЮ ===`).
Exit codes of a text review:
- `7` — the user edited the draft in the window; the edits are already in the draft and the text
  is now the user's (see above). Apply the user's remarks, if any, and run `review text` again:
  the edited text needs its own check, and the user sees it before approval.
- `8` — stop and ask the user, do not go on with your version. The printed reason is one of: the
  draft changed during the review, so the user's copy is saved as `<short-name>.user-edit.md`;
  the user wrote answers straight into `1-questions.md` (the diff is printed); a remark says the
  text was edited by hand, yet neither the copy nor the draft changed.

When a round ends with `(замечаний нет)`, approve (the user confirms in a prompt):

```bash
~/.claude/hooks/publish-approve ~/.claude/state/publish/drafts/<short-name>.md   # text
~/.claude/hooks/publish-approve --git <repo-path> <branch>                         # code
```

Then publish the draft content unchanged / create the MR.

## diffx instead of revdiff

Only if the user asks for diffx: add `--tool diffx`. It starts the browser server in the
foreground (run in background), comments are collected with `/diffx-finish-review`.
