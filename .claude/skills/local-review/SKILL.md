---
name: local-review
description: "Local line-by-line review by the user before anything is published: branch code before an MR, or a text draft (MR description, Jira text, Slack message). Runs ~/.claude/bin/review, which fixes the diff scope itself (only the branch's own commits since merge-base with fresh origin/master, no uncommitted changes, stops on other people's commits) and opens revdiff in a tmux popup. Use before creating an MR, as soon as any text for publication is drafted, without showing the draft in chat first (publish-gate requires the review), after a commit the user wants to check, or when the user says «дай проверить», «покажи дифф», «ревью локально», «запусти revdiff», «запусти diffx»."
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

Before the window opens, two fresh-context `claude -p` read the branch. `code-check` looks for
slop by `~/.claude/rules/code-slop.md` (guards against the impossible, one-use abstractions,
code for the future, duplicates of existing helpers, edits outside the task, tests that check
nothing) and compares the commit messages with the diff. Then `comment-check` reads the code
comments by `~/.claude/rules/code-comments.md`. Exit `6` from either: items for you. Apply them
by your own judgement in a new commit and run `review branch` again. Rerunning on unchanged code
means you leave the remaining items: the important ones go to the user in the revdiff
description.

## Text draft

When to start the review and when to send: `~/.claude/CLAUDE.md`, the sepia section.

**Before writing the text**, start `<short-name>.sources.md` with the brief:

```markdown
## Кому и зачем
- Читатель: who reads it and what they already know (team, system, earlier discussion).
- Главная мысль: one sentence the reader must take away.
- Действие: what the reader should do after reading, or «ничего, для сведения».
```

Write the text from the brief: the main point and the action come first, then only what supports
them. Below the brief the same file lists where every fact of the text comes from — file paths,
repo + branch, commands to run, links, and verbatim excerpts from Jira/Slack/Confluence (the fact
checker has no access to them; an unexcerpted fact ends up «unconfirmed» and in front of the
user).

The final text (after the sepia skill), exactly as it will be sent, goes to
`~/.claude/state/publish/drafts/<short-name>.md`, then:

```bash
~/.claude/bin/review text ~/.claude/state/publish/drafts/<short-name>.md
```

Run it with `run_in_background: true` and `timeout: 7200000`.

`text-check` runs two separate `claude -p` (opus, fresh context) one after the other; its report
is printed for you (`=== ПРОВЕРКА АГЕНТОМ ===`):
1. **The reader** sees only the text and the brief — no sources, no tools, like the real reader.
   It retells what it understood, outlines the text and reports structure, flow, density and
   AI slop. About a minute; it runs on every new version of the text.
2. **The fact checker** sees the sources and has read-only tools; it lists every claim as
   confirmed / unconfirmed / contradicted. Several minutes; it runs only once the reader has
   nothing important left for you, so facts are not checked in a text about to be rewritten.

Exit code `6` — there are items for you and that stage still has rounds left (2 per stage since
the user's last review): the user has not seen anything. The printed instruction says what to
do:
- the reader understood the text wrongly or lost the thread in its order: rebuild the text from
  the brief, do not patch sentences; run it through sepia; add no new facts;
- the reader stumbles in places: apply its edits;
- the fact checker: apply the edits by your own judgement, `minor` included; for an unconfirmed
  claim add the excerpt to the sources (you have Jira, Slack, GitLab, the checker does not) or
  drop the claim. Never put the origin of a fact or a caveat for the checker into the text. Do
  not argue with the checker by rewording a fact you cannot back.

Then run `review text` again; the reader reads the new version too. Rerunning on an unchanged
text means you leave the remaining items as they are: the important ones (`blocker`, `doubt`)
then go to the user, `minor` ones are dropped. The user's view starts with the reader's
retelling, so the user can check the main point without reading the text.

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
the user, do not edit it except by the user's remarks.

**After the user's first review the checker no longer runs.** The user chose this: an edit made
by their remarks comes back as a bare diff in seconds, and nothing changes in places they did not
touch. `review text` prints `=== ПРОВЕРКА АГЕНТОМ: пропущена ===` and goes straight to revdiff.
So apply exactly what the remarks ask, nothing more: no rewording of neighbouring sentences, and
a fact you add on a remark is on you, nobody checks it. Run `review text --recheck` only when the
user asks for a check; its items then go to the user as questions, you do not apply them.

Never write into `~/.claude/state/publish/checks/` or `stats.jsonl` — publish-gate denies it,
and `publish-approve` refuses a text without a check of exactly that text.
`~/.claude/bin/text-check-stats` summarises how well the checks work.

## After the popup closes

The output ends with `=== ЗАМЕЧАНИЯ ПОЛЬЗОВАТЕЛЯ ===` and the annotations in the form
`## path:LINE (+|-|file-level)` + text. For each: a change request → apply it; a question →
answer it in chat; «не понял», «объясни» → explain in chat by the `explain` skill. In a text review, remarks on `1-questions.md` answer the checker's
questions — the file is printed after them (`=== ВОПРОСЫ ===`) with line numbers; remarks on
the draft file use the draft's own line numbers. After applying changes, run the review again so the user sees the result.

revdiff can open the file in `$EDITOR`, and in a text review that file is a temporary copy. After
the window closes the wrapper compares the copy with what was shown and always prints
`Черновик в окне ревью: не изменён.` or the user's diff (`=== ПРАВКА ПОЛЬЗОВАТЕЛЯ В ОКНЕ РЕВЬЮ ===`).
Exit codes of a text review:
- `7` — the user edited the draft in the window; the edits are already in the draft and the text
  is now the user's (see above). Apply the user's remarks, if any, and run `review text` again:
  the user sees the result before approval (the checker skips it, see above).
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
