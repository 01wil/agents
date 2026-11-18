---
name: using-git-worktrees
description: Use a separate git worktree for work that should not disturb the current checkout — a parallel task, a long-running branch, a risky change you want isolated, or running an agent on one branch while you work on another. Use when asked for an isolated workspace or a worktree, or before starting feature work alongside uncommitted changes you don't want to stash.
---

# Using git worktrees

A worktree is a second working directory for the same repository, checked out to its own branch. It
lets two branches exist on disk at once, so a parallel task, a risky change, or an agent working
unattended does not collide with what is in your main checkout. No stashing, no switching branches
out from under uncommitted work.

Reach for one when isolation is the point. For ordinary sequential work on one branch, a plain
checkout is simpler; do not add a worktree for its own sake.

## Create

From inside the repo:

```bash
git worktree add ../<repo>-<branch> -b <branch>      # new branch
git worktree add ../<repo>-<branch> <existing-branch> # existing branch
```

Put it beside the repo, not inside it, so it never lands in the repo's own file scans or git status.
One branch can be checked out in only one worktree at a time; git refuses a second.

## Work in it

It is a normal checkout: commit, push, run tests there as usual. It shares the same `.git`, so all
branches and history are visible from either. Local-only, untracked files (a `notes/` folder,
`.env`) do **not** travel to a new worktree — recreate or copy what the task needs.

The destructive-operations rules apply in a worktree exactly as anywhere (`wiki/destructive-operations.md`).
A worktree isolates the working tree, not the shared history: a force-push or a branch delete from
one still affects everyone.

## Clean up

When the work is merged or abandoned:

```bash
git worktree remove ../<repo>-<branch>
```

Remove the worktree before deleting its branch. If a directory was deleted by hand, `git worktree
prune` clears the dangling reference. Leaving stale worktrees around is how you end up unable to
check a branch out because git thinks it is still open elsewhere; `git worktree list` shows what
exists.

## For unattended or parallel agent work

Give each agent its own worktree on its own branch, so their edits, builds, and test runs cannot
touch each other or your main checkout. Tell each one the exact directory it owns and that it stays
inside it. This pairs with delegating to subagents (`AGENTS.md`): isolate the workspace, then isolate
the context.
