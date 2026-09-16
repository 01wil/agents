---
name: folder-structure
description: Standard layout for a work/task folder - two folders at the top, notes/ (local-only, the thinking) and src/ (published, the code) - plus which meta files exist and the machine-local knowledge folder. Use at the START of every new work item, when a task folder is messy or ambiguous, when deciding where to put a file, when setting up git for a project, or when recording durable environment knowledge.
---

# Folder Structure

Read this at the start of every task. It removes the repetitive work of deciding where things go.

Core idea: two folders at the top level, nothing else. `notes/` and `src/`, each its own git repo.

- src/ is the code and everything that ships. Tracked, gets an upstream remote.
- notes/ is the thinking around the code — material you were handed plus the agent's working files
  (requirements, work log). A local-only repo that never gets an upstream, so internal notes never
  leak to a shared remote.

Code in src/, the thinking in notes/. That is the whole rule.

---

## Hard rules

- Never delete anything of value. Not a stray file, a duplicate, or an empty folder — anything you
  were given, or that records work, stays until the user says otherwise. Exception: artifacts you
  created this session (temp scripts, scratch dirs) get cleaned up and reported.
- Ask before restructuring an existing folder. A non-standard layout may be intentional.
  Exception: **inside notes/, the agent files without asking** — see "Filing notes/" below.
- Ask before `git init` or adding a `.gitignore` to a folder that has neither.
- Moving files is fine once approved; use `git mv` when the file is tracked.
- Suggest a better project name when the current one is unclear or misleading — propose, do not
  rename unasked.

---

## Target layout

```text
storage/<Project Name>/          the top level: exactly two folders
├── notes/                       local-only git repo. No upstream. The thinking.
│   ├── requirements.md          the contract + acceptance criteria (requirements-format.md)
│   ├── state.md                 the work log / todos / blockers (state-format.md)
│   └── <received material>      emails, screenshots, data dumps, grouped by origin
└── src/                         published git repo, gets an upstream. The code.
    ├── <code, tests>
    ├── README.md                always (src-docs.md)
    ├── DEPLOYMENT.md            usually (src-docs.md)
    └── ARCHITECTURE.md          when the design is non-obvious (src-docs.md)
```

Not every project needs all of it. A pure-analysis task may legitimately be just notes/ with a
couple of files. Do not scaffold empty folders, and do not create a src/ repo with no code in it.
The agent creates and organizes notes/; the user drops raw input into the project folder and the
agent proposes the split.

This structure is the default and gets enforced: on first contact with a folder that does not
match it, propose the full split (what moves where), reconstruct the timeline in state.md from the
existing files ([IN] entries marked reconstructed — see state-format.md), and create the meta
files. Deviate only when the user says so or an existing layout is clearly deliberate.

---

## Filing notes/: the agent's job, not the user's

The user drops material in; the agent keeps notes/ organized. This is the one restructuring
exception that needs no approval, bounded strictly:

- Move and rename only, inside notes/, into origin-grouped subfolders (e.g. `mail/`, `tickets/`,
  `data/`). **Never delete anything** — not duplicates, not seemingly obsolete files
  (destructive-operations.md).
- Every filing action is logged as part of its [IN] entry in state.md, so the original name and
  location are always recoverable.
- Conversions (xlsx→csv etc., see below) sit next to their original; the original stays.

---

## The meta files: the two-file resume kit

The agent's working files are exactly two. A fresh agent reads these and can continue:

- requirements.md — what is being built, in priority order, and how it is judged done. Confirmed
  before code. See requirements-format.md.
- state.md — blockers, the prioritized todos (with sub-todos and questions-to-people), and the
  append-only log. Auto-maintained. See state-format.md.

No plan.md, questions.md, or analysis.md — state-format.md explains where each of those lives.

---

## The two repositories

- src/ — tracked, gets a remote/upstream. Its `.gitignore` need not mention notes/ because notes/ is
  a sibling, not a child; keep them as two separate folders so the repos never entangle.
- notes/ — its own git repo (`git init` inside it, after asking). Local only, never an upstream. It
  versions the working files and received material so their history survives without leaking.

Commit notes/ as the meta files change; commit src/ per the loop.

### Baseline .gitignore for src/

notes/ is a sibling folder, not a child, so it needs no ignore entry. Give src/ the usual
exclusions for its stack (build output, IDE metadata, test output, local credential configs,
logs); the `csharp-repository-structure` skill carries a ready .NET baseline. Never commit real
secrets — see src-docs.md for credential handling in deployed tools.

---

## What goes where

| Item | Location | Repo |
|---|---|---|
| Emails, requirements docs, meeting notes, screenshots, data dumps handed to you | notes/ | notes (local) |
| Converted/derived data (CSV from an xlsx) | notes/ | notes (local) |
| requirements.md, state.md | notes/ | notes (local) |
| Code, scripts, SQL you wrote | src/ | code (upstream) |
| Tests | src/ | code (upstream) |
| README, DEPLOYMENT, ARCHITECTURE, docs/ | src/ | code (upstream) |
| Credentials, tokens, connection strings with secrets | neither repo | never |

Rule of thumb: is it code, or the thinking around the code? Code goes to src/, thinking and received
material to notes/.

---

## The knowledge folder: machine-local environment truth

Some things you learn are not about one project — they are about this environment: a proxy config, a
shared DB schema, a server's quirks, an internal tool's API. Those live in the wiki's `knowledge/`
folder. It is present on every machine but its contents are local: git-ignored, never pushed, because
they are specific to this employer/machine and often sensitive.

- The folder itself exists everywhere (tracked via a `.gitkeep`); everything inside it is ignored.
- Create a knowledge file when a fact is durable, reusable, and bigger than the current project.
- Keep an `INDEX.md` in the folder: one line per file, `filename — what it covers`. Append to it when
  you add a file. It is the grep-able table of contents, so a specific fact is a lookup, not a
  directory scan. Detailed filenames plus this index are enough; do not build a heavier glossary
  until the folder is large enough to need one.

The split that governs continuous learning (see the continuous-learning skill): general or
about-the-user lessons go to the portable wiki; environment/employer/machine-specific facts go to
knowledge/ and stay local.

---


## Input material: usability check

Input should be in a form an agent can read directly. When it is not:

1. Convert it yourself when you can, and write the result next to the original in notes/ (keep the
   original): xlsx to per-sheet csv (or read `xl/worksheets/*.xml` from the zip); docx/pptx unzip and
   read the XML; images described in a sibling text file so the content survives.
2. Ask the user to convert only when you genuinely cannot — scanned PDFs needing OCR, proprietary or
   password-protected files.
3. Never silently skip an input file because it was inconvenient to read. Say so.

Watch encoding: exported files are often cp1252/Windows-1252, semicolon-delimited with decimal
commas. Reading them as UTF-8 corrupts accented characters.

---

## Starting a new task

1. Look at what is already in the folder. Do not assume it is empty or standard.
2. Read every input file (converting as needed) before planning work.
3. Check for an existing state.md and read it first.
4. If the folder is a flat pile of received files, propose the split — list what moves where — and
   wait for approval for the notes/–src/ split itself. Once notes/ exists, filing inside it needs
   no approval (see "Filing notes/").
5. Only create src/ when there is real code to put in it.

## Finishing a task

1. Code and deliverables are in src/; received material stayed in notes/.
2. Update state.md (auto-write) and commit the notes repo.
3. Offer to record durable environment knowledge in knowledge/ (local) or a general lesson in the
   wiki (continuous-learning skill).
4. Report anything left in an odd place and why, rather than quietly tidying it.
