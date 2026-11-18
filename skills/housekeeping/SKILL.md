---
name: housekeeping
description: Tidy the current work folder and report where the project stands. Use when the user says "housekeeping", asks to clean up the folder or file loose material, or asks for a summary of where the project is. Also use when picking up a folder that has drifted from the standard layout, and before handing work over.
---

# Housekeeping

Two things in one pass: put the folder back into shape, then say where the project stands. Moves
and reports only — nothing is deleted.

Run in the current work folder, in this order.

## 1. Load the project

Read `notes/state.md` (blockers, todos, log) and `notes/requirements.md` (the contract) before
touching anything. If either is missing, the folder was never set up: follow "Starting a new task"
in `wiki/folder-structure.md` and propose the split, rather than tidying around the gap.

## 2. Tidy the folder

Target layout is `wiki/folder-structure.md`: `notes/` is the thinking, `src/` is the code.

- Inside `notes/`: file stray material into origin-grouped subfolders (`mail/`, `tickets/`,
  `data/`). Move and rename only — this is the one restructure that needs no approval.
- Anywhere else — moving a file between `notes/` and `src/`, or reorganizing `src/` — propose the
  full list of moves and wait. A bulk restructure is a destructive operation
  (`wiki/destructive-operations.md`).
- `git mv` for tracked files, so history follows.
- Check the destination before every move (`test -e`). Never overwrite.
- Delete nothing. Propose deletions as a list and wait. The only exception is an artifact you
  created this session (temp script, scratch dir), and you report that you cleaned it up.

## 3. Flag what should not be there

- Secrets: credentials, tokens, connection strings, `.env`, key material. They belong in neither
  repo. Report the path, never the value, and say whether it is already tracked:
  `git log --all --oneline -- <path>`. A committed secret needs rotating, not deleting.
- Tracked files that should be ignored: build output, caches, IDE metadata, large binaries.
- Input files no agent can read yet — see the usability check in `wiki/folder-structure.md`.

## 4. Check the git state

For `notes/` and `src/` separately: branch, uncommitted changes, unpushed commits.

```bash
git status -sb && git log --branches --not --remotes --oneline
```

Uncommitted work is what gets lost. Name it. Do not commit it unasked, and never use
`git checkout --`, `reset`, or `clean` to make a tree look tidy.

## 5. Update state.md

Auto-write, no approval (`wiki/state-format.md`). Real clock: `date '+%Y-%m-%d %H:%M'`.

- One log entry for the pass, listing every file moved or renamed, from and to.
- An `[IN]` entry for each piece of material filed for the first time.
- Refresh the blocker block and todos if they have gone stale against what you just found.

## 6. Report, in this order

1. Project status: where things stand, the next action, open blockers. 5-8 lines.
2. Housekeeping: what moved, what is flagged, what is proposed and waiting — moves outside
   `notes/`, and deletions.
3. Git: uncommitted and unpushed work, per repo.

A proposal stays a proposal until the user answers. If there is nothing to propose, say so in one
line instead of padding the report.
