# Wiki — Start Here

Entrypoint for agents. If you were told **"read the wiki"**, this is the index. The rules
themselves live in `AGENTS.md` (session start, the loop, end-of-turn duties, hard rules) — if you
have not read it, read it first. This file only maps where knowledge lives.

---

> # STOP — read this before touching data
>
> **If your task involves `DELETE`, `UPDATE`, `INSERT`, `TRUNCATE`, `DROP`, `ALTER`, `MERGE`,
> `rm`, `mv`, overwriting a file, or `git reset`/`clean`/`rebase`/`push --force` — read
> [`destructive-operations.md`](destructive-operations.md) FIRST, in full, before writing a
> single statement.** The same applies to any SQL that writes, on any server — never judge a
> server by its name. Agents have destroyed production data believing the operation was a
> harmless syntax check. No backup, no destructive operation. If the user said wait, wait.

---

## Structure

```
<repo>/
├── AGENTS.md      the bootstrap instruction set — the rules live here
├── wiki/
│   ├── *.md       how work gets done      — you are told to read these
│   └── knowledge/ what is true about THIS machine/employer — local-only, load per task
└── skills/        how to do things well   — opencode loads these by description
```

`setup.sh`/`setup.ps1` symlink `~/.config/opencode/{AGENTS.md,wiki,skills}` to this repo, so the
repo is canonical. Never edit the copies under `~/.config` — they are the same files.

## Convention files

| File | What it governs |
|---|---|
| [`destructive-operations.md`](destructive-operations.md) | **MANDATORY** before anything that writes or deletes. The protocol, the templates |
| [`loop-engineering.md`](loop-engineering.md) | **MANDATORY** before writing code. The four phases, acceptance criteria, the production guardrail |
| [`folder-structure.md`](folder-structure.md) | the two-folder work layout (`notes/` local-only, `src/` published), where each file goes |
| [`requirements-format.md`](requirements-format.md) | `notes/requirements.md` — the confirmed spec and acceptance criteria that gate all code |
| [`state-format.md`](state-format.md) | `notes/state.md` — blockers, todos, [IN]/[OUT] correspondence, the append-only log |
| [`src-docs.md`](src-docs.md) | the docs that ship in `src/` — README, DEPLOYMENT, ARCHITECTURE |
| [`writing-style.md`](writing-style.md) | the user's voice for mail, chat, and status updates |
| [`wiki-guidelines.md`](wiki-guidelines.md) | what belongs where in this folder, and when to write it |

## Knowledge — load per task

`knowledge/` holds what is true about this specific machine and employer: server topology, internal
tools, environment gotchas, credentials' locations. Local-only (gitignored). Read
[`knowledge/INDEX.md`](knowledge/INDEX.md) for what exists; on a fresh checkout the folder is
empty except its README — that is expected. Unsure which file applies? Grep rather than guess:

```bash
grep -ril "<server-or-table-or-tool>" wiki/knowledge/
```

Skills need no index here — opencode loads them by their `description`.

## Maintaining this folder

- What belongs where, and when to write it → [`wiki-guidelines.md`](wiki-guidelines.md).
- How to write it so an agent actually reaches it → the `writing-for-agents` skill.
- A new environment fact = a new `knowledge/` file + a row in `knowledge/INDEX.md`. A new
  convention file = a new row in the table above.
