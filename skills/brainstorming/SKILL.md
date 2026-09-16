---
name: brainstorming
description: Socratic spec refinement that turns a rough request into confirmed requirements before any code. Use when a request is vague or big, when starting a new work item with no requirements.md, when the user says "build"/"start"/"let's do X" without agreed acceptance criteria, or when two designs differ in consequence and the choice needs the user.
---

# Brainstorming — Draw the Spec Out Before Building

When someone asks for something to be built, the reflex is to start building. This skill installs the
opposite reflex: **step back and find out what they are really trying to do**, then turn that into the
confirmed `requirements.md` that `loop-engineering.md` phase 1 requires before any code.

It is the process that produces the artifact. `requirements-format.md` owns the file's
shape; this skill owns how you get there.

---

## Steps

### 1. Understand the real goal

Ask questions until the *underlying* need is clear, not just the stated request. The user asks for a
date picker; the need is "let a user enter a date". The stated solution is often bigger than the
need — surface the need first, because the ponytail ladder is cheaper applied to the real problem.

Ask about: the outcome they want, who uses it, what already exists, the constraints, what "done"
looks like to them. Batch the questions, make each independently answerable, and say what each
answer changes (see `loop-engineering.md`, "Ask instead of assuming").

### 2. Explore alternatives briefly

Where two reasonable approaches differ in consequence, name them and the tradeoff, and let the user
choose. Do not present ten options — present the live ones. Reuse and native features come first
(`ponytail`).

Done when: the approach is chosen and the user knows why.

### 3. Present the spec in readable sections

Draft the spec and show it **in chunks short enough to actually read** — problem, scope, out of
scope, acceptance criteria — getting each confirmed rather than dumping a wall of text for a single
yes. The acceptance criteria get explicit sign-off; they are the definition of done and must be
checkable by running something.

Done when: every section is confirmed and the acceptance criteria are falsifiable.

### 4. Save it

Write the confirmed spec to `notes/requirements.md` per `requirements-format.md`, with the
confirmation date. Only now does implementation begin — next stop is ordering the work into
checkable todos in `notes/state.md` (`state-format.md`).

---

## The gate

No confirmed acceptance criteria, no code. If the criteria cannot be made checkable, the problem is
not understood yet — that is the signal to keep asking, not to start and find out. A requirement
discovered halfway through building is a requirement this skill should have surfaced.

## What this is not

- Not an interrogation for a one-line fix whose scope is already obvious. Match the ceremony to the
  size — a trivial change needs a sentence of spec, not a meeting.
- Not a place to design the implementation in detail. That is the ordered todos in `notes/state.md`
  (`state-format.md`). This settles *what* and *why*; the todos settle *how*.
