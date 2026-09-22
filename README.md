# agents

A working system for coding agents, portable across harnesses. One instruction file
(AGENTS.md), a set of convention files (wiki/), and self-loading skills (skills/). Together they
give an agent a repeatable process: spec before code, two files as project memory, and a strict
safety protocol for anything destructive.

## Install

```bash
git clone https://github.com/01wil/agents ~/agents
cd ~/agents
./setup.sh        # Windows: pwsh -File .\setup.ps1
```

The script links `skills/` into `~/.claude/skills` and the instruction file into whichever
harnesses are set up on the machine, backing up anything already there. The repo stays canonical;
the config dirs just point at it. Re-runnable — run it again after adding a harness.

Clone to `~/agents`. `AGENTS.md` resolves every `wiki/...` and `skills/...` reference against that
path, so the documents work from any working directory; setup warns if the clone is elsewhere.

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

Skill frontmatter keeps to `name` and `description`, the two fields every harness reads. Anything
else (`disable-model-invocation`, `allowed-tools`, `model`) is Claude Code-only and must be written
so the skill still behaves correctly where it is ignored — see the `writing-for-agents` skill.

## What's inside

```
AGENTS.md    bootstrap instructions, read every session
wiki/        conventions: the engineering loop, file formats, destructive-op protocol
  knowledge/ machine-specific facts — gitignored, stays local
skills/      capabilities loaded by description match
setup.sh     link into every harness on this machine (setup.ps1 for Windows)
```

## How it works

The agent has no memory between sessions, so the files are the memory. Each project keeps two:
`notes/requirements.md` (what to build, confirmed before code) and `notes/state.md` (todos,
blockers, append-only log). The wiki defines those formats plus the working loop — specify,
implement, verify — and a mandatory protocol before any destructive operation.

Anything machine- or employer-specific lands in gitignored local files (`wiki/knowledge/`,
`skills/acme-*`), so this repo stays portable and publishable.
