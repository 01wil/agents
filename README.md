# agents

A working system for coding agents, portable across harnesses. One instruction file
(AGENTS.md), a set of convention files (wiki/), and self-loading skills (skills/). Together they
give an agent a repeatable process: spec before code, two files as project memory, and a strict
safety protocol for anything destructive.

## Set up a new machine

Clone to `~/agents` (every path in these files resolves against it):

```bash
git clone https://github.com/01wil/agents ~/agents
```

Then tell your agent: "set up ~/agents on this machine". The agent does the rest, following these
steps. All are re-runnable; never overwrite a real file, rename it to `<name>.bak-<date>` first.

1. Create `~/agents/wiki/knowledge/` content only if this machine has local facts. It is ignored by
   git; nothing in it is ever published.
2. Instruction file: link `~/agents/AGENTS.md` to `~/.claude/CLAUDE.md`, and to the per-harness file
   (table below) for each harness whose config dir already exists. Where symlinks are not possible,
   or the harness ignores them (see "Known limit"), write a one-line real file instead: "Read
   `~/agents/AGENTS.md` and follow it."
3. Skills: make `~/.claude/skills` a real directory and put one link in it per skill folder from
   `~/agents/skills/` and `~/agents/wiki/knowledge/skills/`. Remove links in it that no longer
   resolve. On Windows use directory junctions (`New-Item -ItemType Junction`), which need no admin
   rights.
4. Check: no other copy of the wiki exists on the machine (`~/agents` is the only one); if one
   does, merge what is new into `~/agents` and tell the user before removing it.

Re-run steps 2 and 3 after adding a harness or a skill.

### Cowork (desktop, web, mobile)

These sessions cannot reach `~/agents` on disk, so the symlink route above does not apply. Instead
the workflow is installed as a Cowork plugin — a copy of the content, registered with Cowork. Tell
your agent to build it (the `cowork-plugin` skill handles the mechanics); the shape is:

- A plugin named `agents-workflow` holding `skills/` and the `wiki/*.md` convention files. Exclude
  `wiki/knowledge/` entirely — it is machine-local and must never ship in a plugin.
- `AGENTS.md` becomes a skill named `engineering-workflow` (its bootstrap instructions, minus the
  `~/agents` path resolution, since there is no clone here).
- Every skill that cites a convention file gets a one-line footer resolving `wiki/<file>.md` to the
  plugin's own `wiki/` location, because `~/agents/...` paths do not exist in a Cowork session.

It is a copy, so rebuild and reinstall it after changing a skill or a wiki file. The filesystem
harnesses (CLI, opencode, Codex, Gemini) read the repo live and never need this step; this is only
for Cowork.

## Harness support

| | instruction file | skills |
|---|---|---|
| Claude Code | `~/.claude/CLAUDE.md` | `~/.claude/skills` (native) |
| opencode | `~/.config/opencode/AGENTS.md` | `~/.claude/skills` (Claude-compatible path) |
| Codex CLI | `~/.codex/AGENTS.md` | reads `skills/` as plain docs, via AGENTS.md |
| Gemini CLI | `~/.gemini/GEMINI.md` | reads `skills/` as plain docs, via AGENTS.md |

One skills directory serves both skill-aware harnesses, so a skill is never registered twice. A
harness with no skill support still reaches them: `AGENTS.md` tells it to list
`~/agents/skills/*/SKILL.md` and read what matches the task.

Known limit: Claude Code skips a `~/.claude/CLAUDE.md` that is a symlink when it runs inside a
Cowork desktop session, and skips user-scope imports resolving outside the session's working
directory. The link works normally in the Claude Code CLI. To carry these rules into a desktop
session, make `~/.claude/CLAUDE.md` a real file whose text tells the agent to read
`~/agents/AGENTS.md` and follow it — an instruction is read at runtime, where a symlink or an
`@import` is not.

Skill frontmatter keeps to `name` and `description`, the two fields every harness reads. Anything
else (`disable-model-invocation`, `allowed-tools`, `model`) is Claude Code-only and must be written
so the skill still behaves correctly where it is ignored — see the `writing-for-agents` skill.

## What's inside

```
AGENTS.md    bootstrap instructions, read every session
wiki/        conventions: the engineering loop, file formats, destructive-op protocol
  knowledge/ machine-specific facts — gitignored, stays local
skills/      capabilities loaded by description match
```

## How it works

The agent has no memory between sessions, so the files are the memory. Each project keeps two:
`notes/requirements.md` (what to build, confirmed before code) and `notes/state.md` (todos,
blockers, append-only log). The wiki defines those formats plus the working loop — specify,
implement, verify — and a mandatory protocol before any destructive operation.

Anything that must not be public lands in `wiki/knowledge/`, which git ignores in full, so this
repo stays portable and publishable.
