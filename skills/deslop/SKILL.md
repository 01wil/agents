---
name: deslop
description: Strip AI-generated slop from code before it is committed. Use after generating or heavily editing code, before opening a PR, when reviewing a diff that feels bloated, or when a change contains defensive code, redundant comments, or type escapes that the surrounding codebase does not use. Also use when writing a throwaway script the user will paste into SSMS or a shell by hand, where too many queries and too much commentary are the slop. This skill is about code; for prose a person will read, use the unslop skill instead.
---

# Deslop Code

Read the diff against the base branch and remove what the generation added but the problem did not
need. This is phase 2 of the loop applied to a diff that already exists: the acceptance criteria did
not change, so anything in the diff not serving them comes out.

Run it on your own output before reporting done.

## What to cut

- **Comments that restate the code.** `// increment the counter` above `counter++`. Keep comments
  that explain non-obvious reasoning or a tradeoff.
- **Defensive checks on trusted paths.** Null guards on values that cannot be null, `try`/`catch`
  around code that does not throw, argument validation on a private method whose only caller already
  validated. Guards belong at trust boundaries, not scattered through internal code.
- **Swallowed exceptions.** `catch (Exception) { }` and `catch (Exception ex) { log.Debug(ex); }`
  that let a failure continue silently. Either handle it meaningfully or let it propagate.
- **Type escapes.** `dynamic`, `object`, `as` followed by no null check, casts that exist only to
  silence the compiler. In SQL, an untyped `NVARCHAR(MAX)` where the real domain is a known width.
- **Deep nesting that early returns would flatten.** Three levels of `if` where a guard clause and a
  return do the same job.
- **Speculative flexibility.** An interface with one implementation, a factory producing one type, a
  configuration knob nobody sets, a parameter every caller passes the same value for.
- **Overqualified names.** `ContractDataManagerHelperService` when `ContractRepository` is what it is.
- **Redundant `SELECT` columns.** A query pulling 40 columns where the caller reads 3, especially
  across a linked server where the cost is real.
- **Dead scaffolding.** Commented-out code, an unused `using`, a variable assigned and never read, a
  test that asserts nothing.
- **Patterns the surrounding file does not use.** Consistency with the codebase beats local taste,
  even where the codebase's choice is worse.

## Ad-hoc scripts a human will run by hand

A different standard applies to a script written so the user can paste it into SSMS, show a
colleague something, and throw it away. Nobody reviews it and nobody maintains it. It has to look
like the user typed it in five minutes, because that is what it is.

The failure here is not defensive code, it is **too many queries and too much explanation**. An
agent writes six numbered blocks with a header comment, a `@@servername` check and a full sentence
above every statement. The user then deletes two thirds of it. Write the version that survives.

- **One to three statements.** If a point needs six queries, the point was not understood. Combine:
  one query per idea, not one per column you want to show. Two selects that make an argument beat
  six that narrate it.
- **Fragment comments, not prose.** A short lowercase note that says only what the reader could not
  see at a glance. No full sentences, no capitals where the user writes lowercase, no trailing
  periods.
- **No structural ceremony.** No `-- 1)` numbering, no `=====` separators, no reassurance that
  nothing will be changed, no block explaining how to run it. Two blank lines between statements is
  the whole structure.
- **No belt-and-braces.** A connection check, a row-count guard and a note about which server to
  use are things the user already knows. They read as an agent covering itself.
- **Leave the loose end visible.** An honest note flags what is still unexplained, sometimes with a
  `???`. An agent smooths that into a paragraph or, worse, writes code to handle it. Keep the note,
  drop the handling.
- **Keep the numbers, cut the narration.** Concrete identifiers and measured values earn their
  place. Sentences describing what the reader is about to see do not.

Deleting the script afterwards is normal, so do not build it to last. Fully qualify object names
only where it prevents a real error, and prefer editing the one script over producing a second
variant for a case the user can handle by clicking a different server.

## Guardrails

- **Behavior stays identical** unless you are fixing a clear bug. If a cut changes behavior, it is
  not a cut, it is a change. Stop and say so.
- **Only your own diff.** Do not deslop code the change did not touch. Adjacent slop gets mentioned,
  not fixed.
- **A guard at a real trust boundary stays.** Input from a user, a file, a network call, an external
  API, or a linked server is untrusted. Validate there.
- **Re-run the tests after cutting.** Removing a defensive check that was load-bearing is a real
  risk, and the test suite is how you find out.
- **Keep the summary to a few sentences.** What came out, and why.

## Verify

Read the final diff line by line. Every remaining line should trace to an acceptance criterion. If
you cannot say which criterion a line serves, it is slop you have not cut yet.
