---
name: continuous-learning
description: Capture a durable lesson when the work teaches something the wiki should have told you. Use at the end of a task, after a mistake or a surprise, when a convention or gotcha was discovered the hard way, when the same correction has come up twice, or when a skill fired at the wrong time and its trigger needs tightening.
---

# Continuous Learning — Fold What You Learned Back In

A lesson learned and left in a finished session is a lesson relearned next time from scratch. This
skill closes the loop: when the work teaches something the wiki should have told you up front,
**write it back into the wiki** so the next agent starts where this one finished.

It is the maintenance half of the end-of-turn checklist in `AGENTS.md`. opencode has no daemon and no
memory between turns — the only persistence is the files. If a lesson does not land in a file, it did
not persist.

---

## When a lesson is worth capturing

Capture when the work surfaced something **durable and reusable** — not a fact about this one task,
but a rule that will hold next time:

- A convention or gotcha discovered the hard way (a build step, an env quirk, an API that lies).
- A correction the user has now made more than once — recurrence means the wiki is missing it.
- A skill that fired at the wrong time, or failed to fire — its `description` trigger needs tightening.
- A pattern that worked well enough to repeat deliberately.

Do **not** capture task-specific trivia, one-off values, or anything already written down. Noise in
the wiki costs every future read; the bar is "will this help a future task", not "is this true".

## Where it goes

First split by destination, because half the wiki is portable and half is machine-local:

- **Portable — the tracked wiki.** A general convention, an engineering rule, or a fact about how the
  user works, writes, or thinks. This is public and travels to every machine. Route it to the file
  that owns the concern (below).
- **Local — the gitignored `knowledge/` folder.** An environment, employer, or machine-specific
  fact: a server quirk, an internal tool's API, a proxy setting, a named person's preference. Never
  goes in the tracked wiki. Add or update a `knowledge/` file and append one line to
  `knowledge/INDEX.md` (`filename — what it covers`) so it stays grep-able. See folder-structure.md.

If a lesson has both a portable rule and a local specific, split it: the rule to the wiki, the
specific to `knowledge/`, each pointing at the other only if needed.

Then, for a portable lesson, route to the file that owns that concern, following `writing-for-agents`
and `wiki-guidelines.md`:

- A trigger misfire → edit the skill's `description`.
- A workflow gap → the relevant format or process file.
- A cross-cutting rule with no home → propose where it should live rather than inventing a new file
  by reflex. A new file is the last rung, not the first (`ponytail` applies to the wiki too).

Keep the edit small and in the existing voice. You are folding a sentence into a document, not
appending a changelog.

## Always ask before writing

Wiki edits are persisted changes to shared instructions, so they follow always-ask: propose the
lesson and the exact file and wording, get confirmation, then write. A learning captured wrong is
worse than one not captured, because every future turn inherits it.

---

## End-of-task check

- Did anything this task teach a durable, reusable lesson?
- Has the user corrected the same thing more than once?
- Did any skill fire at the wrong time?
- If yes to any: which file owns it, what is the smallest edit, and have I proposed it for confirmation?
