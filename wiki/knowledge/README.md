# knowledge/ — machine-local environment truth

This folder holds facts about *this* environment: server quirks, internal tool APIs, proxy
settings, database schemas, named people's preferences. They are durable and reusable, but specific
to one employer or machine — so the contents never leave it.

Everything in here is git-ignored. Only this README and a `.gitkeep` are tracked, so the folder
exists on every machine while its contents stay private. Nothing here is pushed to the public repo.

## What belongs here

A fact belongs in `knowledge/` when it is:
- durable and reusable (it will help a future task, not just this one), and
- specific to the environment, employer, or machine (a server name, a proxy, an internal API).

A general convention or a fact about how the user works does **not** belong here — that goes in the
tracked wiki. See the `continuous-learning` skill for the routing rule.

## INDEX.md

Keep an `INDEX.md` next to these files: one line per file, `filename — what it covers`. It is the
grep-able table of contents, so finding a specific fact is a lookup rather than a directory scan.
Append to it whenever you add a file. `INDEX.md` is itself git-ignored, because its lines name local
files.
