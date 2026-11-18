# Wiki — INDEX

Entrypoint for agents, and the index of what exists. If you were told **"read the wiki"**, start
here. The rules
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
└── skills/        how to do things well   — loaded by description match
```

Each harness gets links into this repo: `AGENTS.md` into its config dir, and one link per skill
from `skills/` and `wiki/knowledge/skills/` into its skills dir (`README.md`, "Set up a new
machine"). So the repo stays canonical and nothing local has to sit in a published folder. Never
edit the linked copies — they are the same files. Paths in these documents resolve against
`~/agents/`, not against the config dir (`AGENTS.md`).

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
tools, environment gotchas, credentials' locations. Local-only (gitignored).

**Read [`knowledge/INDEX.md`](knowledge/INDEX.md) at the start of a task** — it is one line per
file, so it is cheap — and load only the entries whose server, tool, table or topic the task names.
This index and that one are the pair: general conventions here, environment truth there; on a fresh checkout the folder is
empty except its README and `INDEX.md` does not exist yet — that is expected. Create it with the
first knowledge file. Unsure which file applies? Grep rather than guess:

```bash
grep -ril "<server-or-table-or-tool>" wiki/knowledge/
```

Skills need no index here — a harness that supports them loads them by their `description`. On one
that does not, list `~/agents/skills/*/SKILL.md` and read what matches.

## Extending and maintaining this repo

The repo is the agent's own instruction set: every agent that learns something durable is expected
to extend it, and to leave it clean enough for the next one. Three decisions, in order.

**1. Does it belong here at all?** `wiki-guidelines.md` owns that test — durable and reusable, or
it stays in the project's `state.md`. Task status never comes here.

**2. Where does it go?**

| What you learned | Where it goes | Published? |
|---|---|---|
| A convention for how work is done | a `wiki/*.md` file + a row in the table above | yes |
| A repeatable procedure worth loading by itself | `skills/<name>/SKILL.md` | yes |
| A fact about this machine, employer, server, or internal tool | `wiki/knowledge/<topic>.md` + a row in `knowledge/INDEX.md` | **never** |
| A procedure that only makes sense at this employer | `wiki/knowledge/skills/<name>/SKILL.md` | **never** |

The split is the whole discipline: anything naming a real server, system, person, ticket, or
internal hostname goes under `wiki/knowledge/`, which is ignored in full. Write the general lesson
in the published file and keep the specifics local — a published file that needs a server name is
two files, not one.

**3. Write it so it gets reached.** The `writing-for-agents` skill owns the wording: a description
is a trigger condition, not a summary. A file nobody's pointer names is a file nobody reads.

### After changing the repo

1. Add the index row in the same edit. An unindexed file is invisible to the next agent; the two
   `INDEX.md` files are how discovery works.
2. When you add or rename a skill, add or fix its link in the harness skills dir (`README.md`,
   "Set up a new machine").
3. Commit with a message saying what behaviour changed and why. Never commit anything from
   `wiki/knowledge/`; check with `git status` before committing, and treat a hit there as a bug in
   the ignore rules, not something to force through.
4. Getting commits to the remote can be machine-specific — grep `knowledge/INDEX.md` for `push`
   before assuming a plain `git push` works here.

### Keeping it clean

- Prune in the same pass as you add. Stale instructions cost more than missing ones, because they
  are obeyed.
- One meaning in one place. Two files saying the same thing drift, and the drift is silent.
- Fix the pointer before adding prose: a skill that fired at the wrong moment needs a sharper
  description, not a longer body (`continuous-learning` skill).
- Never a second copy of this repo. `~/agents` is the only authoritative clone; edit it in place,
  and treat any other copy as stale.
