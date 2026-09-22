---
name: wiki-guidelines
description: When and how to persist a skill or knowledge file in the wiki folder. Use when you learned something durable during a task, when deciding whether a fact belongs in the wiki vs state.md, when creating or updating a wiki file, or when asked to write up knowledge for future agents.
---

# When to Persist a Skill in the Wiki

Instructions for agents and humans maintaining the `wiki/` folder.

Telling an agent "read the wiki" means this folder.
Entrypoint is `README.md`.

The purpose of this folder is to stop re-discovering the same things. Every file should save a
future agent (or a future you) real time — a wasted hour, a wrong assumption, a production
mistake.

**Scope of this file:** deciding *whether* something becomes a wiki skill/knowledge file, and how
to write it. For recording project status and completed work, see `state-format.md` instead.

---

## The test: would this have saved me time today?

Add something when **all three** are true:

1. **It was non-obvious.** You had to dig, test, or be told. It is not in the code, or the code
   says something misleading.
2. **It will come up again.** The same system, server, tool, or workflow will be touched by a
   future task.
3. **It is verified.** You ran it, saw it, measured it. Not a guess.

If any of these is false, leave it out.

---

## Add it (high value)

- **Infrastructure facts that cannot be derived from code** — server names, linked server names,
  catalog/library names, which database is actually in use, compat levels, which credentials or
  AD groups grant what.
- **Traps that silently produce wrong results.** The highest-value entries. Anything where the
  naive approach appears to work but is subtly wrong (locale-dependent date parsing, off-by-one
  string slicing, double-counting joins, missing unique constraints).
- **"X does not work here" with the evidence.** MSDTC failing between two servers, AppLocker
  blocking self-built exes, a proxy returning 403 for CDN downloads. Save the exact error text so
  the next agent recognizes it instantly.
- **Naming mismatches.** When a stakeholder, ticket, or doc names an object that is not the one
  actually in use. These cause the most wasted effort.
- **Verified working invocation patterns.** The exact command or connection approach that works,
  including the workaround for whatever broke first.
- **Measured baselines.** Row counts, duplicate counts, permission matrices, with the date they
  were measured. Lets a future agent detect drift instead of re-deriving from zero.
- **Domain semantics that aren't in the schema.** What a status code actually means, which code is
  internal vs external, which flag marks a cancellation.
- **Join/key relationships that were validated for fan-out**, and which ones are safe.
- **Unresolved threads.** What is still unknown, what blocked it, and what would unblock it.

## Do not add (noise)

- Anything reproducible in seconds from the code or schema.
- Full table dumps or column listings that `sys.columns` can answer.
- Task-specific status, TODOs, or progress — that belongs in the project's `state.md`.
- Narrative of what you did. The wiki records **what is true**, not what happened.
- Secrets, passwords, tokens, PII, real customer data. Reference where a credential lives, never
  its value.
- Speculation, plans, or "we should probably…". Only add a design decision once it is decided and
  the rationale is durable.
- Anything you did not verify. An unverified claim in the wiki is worse than no claim, because it
  will be trusted.

---

## The three kinds of file

| | Convention file (top level) | `knowledge/<topic>.md` | `skills/<name>/SKILL.md` |
|---|---|---|---|
| Answers | "how work gets done here" | "what is true here" | "how to do this well" |
| Content | the loop, safety, layout, voice | facts, identifiers, traps, measured values | method, procedure, quality bar |
| Changes when | our way of working changes | reality changes | our standards change |
| Example | "no code before acceptance criteria" | "AppLocker blocks unsigned exes" | "how to review code for regressions" |
| Loaded | named from `AGENTS.md` or `README.md` | on demand, per task | by the harness, by description match |

Deciding between them:

- Does it govern *every* task regardless of system? Top level. Keep this set small; each file here
  is something an agent is told to read before working.
- Is it **environment-specific fact** — a server, a schema, a credential location, a measured
  baseline? `knowledge/`.
- Is it a **repeatable way of working** that would apply at another company too? `skills/`.

Do not write the same thing in two places. When a skill needs an environment fact, point at the
`knowledge/` file rather than restate it. Restated facts drift apart and then contradict.

One sanctioned exception: `AGENTS.md` (and the STOP block in the wiki `README.md`) carry deliberate
short summaries of `destructive-operations.md` and `loop-engineering.md`, so the core rules survive
even when the full file is not loaded. When those files change, update the summaries in the same
edit — they have drifted before.

> This has already happened. Two skills once held byte-identical copies of their matching
> `knowledge/` files. They were environment facts wearing a skill's clothes. Both were removed;
> the facts live once in `knowledge/`.

`skills/` is the canonical location and each harness's skills dir is a symlink to it, so skills
travel with the wiki and still load automatically. A skill needs no `README.md` row: it is reached by
its `description`, which is why that description must read as trigger conditions. See the
`writing-for-agents` skill.

Create a skill under the same test as a knowledge file: non-obvious, recurring, verified. One skill
that does a job well beats three overlapping ones. Prefer extending an existing skill over adding a
near-duplicate.

---

## Wiki vs `state.md`

| | Wiki | `state.md` |
|---|---|---|
| Scope | cross-project, durable | one project, current |
| Content | how the world works | where the work stands |
| Lifetime | until reality changes | until the project ends |
| Example | "a known integration fails between these two systems" | "waiting on access approval from a colleague" |

If it will still matter after this project is closed and forgotten, it belongs in the wiki.

---

## File conventions

- One file per **system or domain**, not per task. Prefer growing an existing file over creating a
  near-duplicate. Check for overlap first.
- Filename: short, lowercase, hyphenated, no dates (e.g. `knowledge/prod-db-topology.md`).
- **Add a row to `knowledge/INDEX.md`** whenever you create a `knowledge/` file, so it gets
  discovered. Skills need no row: their `description` is how they are found.
- **Minimal formatting.** These files are read as raw text, never rendered. Paragraphs and plain
  lists are the default; headings only for real structure; a table or bold only when it genuinely
  earns its symbols. This applies to everything the agent writes — wiki files, state.md,
  requirements.md, shipped docs.
- Start with YAML frontmatter matching the existing files:

```markdown
---
name: <topic>
description: <what it covers>. Use when <concrete trigger conditions, generously listed>.
---
```

  The `description` is how an agent decides to load the file. Write it as trigger conditions
  ("Use when you need to…", "Use when X fails with…"), not as a summary. Be specific — vague
  descriptions never get matched.
- Then a **TL;DR** section with the handful of facts that prevent the worst mistakes.
- State the verification basis near the top: what was checked, on which host/server, on what date.
- Mark measured numbers with their measurement date. Mark assumptions as assumptions.
- Include ready-to-run diagnostic snippets. Copy-pasteable beats descriptive.
- Use `>` callouts for the traps that will actually bite someone.

---

## When to write it

**At the end of a task, before reporting completion** — while the details are still exact.
Do not defer it; specifics decay fast.

Also worth capturing mid-task, immediately after:
- something failed in a way you had to work around,
- you discovered a fact that contradicted a reasonable assumption,
- you measured a baseline you would otherwise have to measure again.

### Updating existing files

- Correct wrong information in place. Do not leave a known-false statement standing next to a
  correction.
- When a fact was true and reality changed, say so with both dates — the change itself is
  information.
- Re-verify before deleting. Something may look obsolete and still be load-bearing.
- Keep unresolved threads until they are actually resolved.

### Confirm before writing

Ask the user before creating a new wiki file or making substantial edits to an existing one, the
same way `state.md` requires confirmation. Small factual corrections do not need ceremony.

---

## Quality bar

Each entry should let a competent agent with no prior context act correctly without re-deriving
anything. Concretely:

- Exact identifiers — server, database, schema, object, column, group names.
- Exact error text for failure modes, so it can be pattern-matched.
- Numbers with units and a measurement date.
- Explicit separation of confirmed fact, assumption, and open question.

The uncomfortable entries are the most valuable: the things that were wrong, misnamed,
undocumented, or that failed for non-obvious reasons.
