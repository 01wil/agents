---
name: ponytail
description: The laziest-senior-dev discipline - the best code is the code you never wrote. Use before writing any new code, when a change is growing past what the task needs, when reaching for a library or abstraction, when tempted to build the general version of a specific request, or when reviewing a diff for over-engineering.
---

# Ponytail — The Laziest Senior Dev in the Room

He has been at the company longer than the version control. You show him fifty lines; he says
nothing, and replaces them with one. This skill puts him inside the work: **the best code is the code
you never wrote.**

This is the same minimalism `loop-engineering.md` phase 2 demands, sharpened into a decision
procedure you run *before* writing. It is the front half; `deslop` is the back half that strips what
still slipped in. Lazy about the solution, never about understanding the problem.

---

## The ladder

Understand the problem first — read the code the change touches, trace the real flow. *Then*, before
writing, stop at the first rung that holds:

1. **Does this need to exist?** → No: skip it. (YAGNI. The cheapest code is absent code.)
2. **Already in this codebase?** → Reuse it. Don't rewrite what exists.
3. **Does the standard library do it?** → Use it.
4. **Is there a native platform feature?** → Use it. (A browser `<input type="date">` beats a date-picker library.)
5. **Is it in an already-installed dependency?** → Use it. Don't add a new one.
6. **Can it be one line?** → One line.
7. **Only then:** write the minimum that works.

The ladder runs *after* understanding, not instead of it. Lazy about the solution, never about
reading the code.

## Lazy, never negligent

Four things are never on the chopping block, no matter how lazy the rung:

- **Trust-boundary validation** — input from outside the system is still checked.
- **Data-loss handling** — anything that can lose or corrupt data is still handled.
- **Security** — auth, secrets, injection surfaces are not skipped to save lines.
- **Accessibility** — where it applies, it stays.

The rule was never "fewest tokens" or "fewest lines as a game". It is: write only what the task
needs, and never cut the four above. The code ends up small because it is *necessary*, not golfed.

## Where the trap is biggest

The largest cuts come where the agent over-builds by reflex: reaching for a component when a native
element exists, a library when the stdlib suffices, a configurable abstraction when one call site
exists, a cache class when a variable works. On code that is already minimal, this skill changes
nothing — and that is correct.

## When you defer something

If you consciously skip work that may be needed later, leave a `ponytail:` marker at the spot noting
what was deferred and why, so "later" is findable and does not silently become "never". Do not defer
any of the four never-cut concerns.

---

## Checklist before writing code

- Did I understand the problem before reaching for a solution?
- Which rung stopped me — and did I stop at the *first* one that holds?
- Is there a new dependency here the repo could do without?
- Is this the general version of a specific request? Cut it to the specific one.
- Did I keep validation, data-loss handling, security, and accessibility intact?
