# agents

A working system for coding agents, built for [opencode](https://opencode.ai). One instruction file
(AGENTS.md), a set of convention files (wiki/), and self-loading skills (skills/). Together they
give an agent a repeatable process: spec before code, two files as project memory, and a strict
safety protocol for anything destructive.

## Install

```bash
git clone https://github.com/01wil/agents ~/agents
cd ~/agents
./setup.sh        # Windows: pwsh -File .\setup.ps1
```

The script symlinks AGENTS.md, wiki/ and skills/ into `~/.config/opencode/`, backing up anything
already there. The repo stays canonical; the config dir just points at it. Done — opencode picks it
up on next start.

## What's inside

```
AGENTS.md    bootstrap instructions, read every session
wiki/        conventions: the engineering loop, file formats, destructive-op protocol
  knowledge/ machine-specific facts — gitignored, stays local
skills/      capabilities opencode loads by description match
setup.sh     symlink into ~/.config/opencode (setup.ps1 for Windows)
```

## How it works

The agent has no memory between sessions, so the files are the memory. Each project keeps two:
`notes/requirements.md` (what to build, confirmed before code) and `notes/state.md` (todos,
blockers, append-only log). The wiki defines those formats plus the working loop — specify,
implement, verify — and a mandatory protocol before any destructive operation.

Anything machine- or employer-specific lands in gitignored local files (`wiki/knowledge/`,
`skills/acme-*`), so this repo stays portable and publishable.
