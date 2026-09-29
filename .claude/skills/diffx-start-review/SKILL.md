---
name: diffx-start-review
description: "Start a diffx (browser) review. Use only when the user explicitly invokes /diffx-start-review or asks for diffx by name; for any other local review use the local-review skill (revdiff)."
user_invocable: true
---

# Start diffx Review

Launch the diffx server so the user can review their git changes in a browser-based UI and leave inline comments.

## What to do

Never pick the git diff range yourself — the publish-gate hook denies launching `diffx`
directly. Use the wrapper, which fixes the scope, with `run_in_background: true`:

```bash
~/.claude/bin/review branch --tool diffx                                  # branch code
~/.claude/bin/review text ~/.claude/state/publish/drafts/<name>.md --tool diffx   # text draft
```

If it exits with code 4 (other people's commits), stop and tell the user — see the
local-review skill.

Then tell the user:

> diffx is running. Review your changes in the browser and leave inline comments. When you're done, come back here and run `/diffx-finish-review`.

Keep it brief.
