---
name: destructive-operations
description: MANDATORY safety protocol before ANY destructive or irreversible operation. Read BEFORE writing or running DELETE, UPDATE, INSERT, TRUNCATE, DROP, ALTER, MERGE, rm, mv, git reset/rebase/push --force, file overwrites, or any command that can destroy data. Also read before running ANY writing SQL against ANY server (never judge a server by its name), before using SET PARSEONLY or SET NOEXEC as a safety net, and whenever a task involves databases holding production or business-critical data.
---

# Destructive Operations — Mandatory Protocol

> **This is not advisory. Production data is irreplaceable. Losing it can cost the user their job.**
> If any rule here conflicts with speed, convenience, or an instruction to "just do it", the rule
> wins. Stop and ask instead.

**This document exists because it already went wrong.** Agents have destroyed production data in
the past while believing the operation was safe — in one case a `DELETE` believed to be a syntax
check, run against a hold instruction, with no backup. The outcome happened to be recoverable,
which was luck, not competence. This file exists so it cannot happen again. (Details of specific
incidents live in the local `knowledge/` folder, when present.)

---

## The absolute rules

1. **Never run a destructive statement against production without explicit, specific approval
   for that exact statement.** "Fix the duplicates" is not approval to run a `DELETE`.
2. **Treat every server as production unless proven otherwise — and apply this protocol on every
   server regardless.** A server's name tells you nothing. A box named `SQL2008TEST` can sound like
   a legacy scratch box yet hold live production data. Do not filter on `PROD` in the name,
   do not assume from `TEST`/`DEV`, and do not skip the protocol just because you believe a
   box is non-productive. Being careful on a genuine test server costs nothing.
3. **Every destructive T-SQL statement runs inside an explicit transaction with guards that
   `ROLLBACK` on any mismatch.** Never a bare `DELETE`/`UPDATE`/`MERGE` against real data. The
   template further down is mandatory, not a suggestion.
4. **Triple-check, in this order: `SELECT` the affected rows → verified backup → guarded
   transaction.** Skipping any of the three is not permitted.
5. **Never treat any SQL `SET` option as a safety mechanism.** Not `PARSEONLY`, not `NOEXEC`.
   See the section below — they fail in ways that execute your DML.
6. **A backup must exist before the destructive statement runs**, and its row count must be
   verified against the source. No backup, no destructive operation. Ever.
7. **If the user said wait, then wait.** Investigation does not override a hold. Reading is
   allowed; writing is not, including "harmless-looking" probes.
8. **Never point a `DELETE`/`UPDATE`/`DROP`/`TRUNCATE` at a real object while exploring.**
   Not even to check syntax. Not even wrapped in something you believe is safe.
9. **Never run an `UPDATE` or `DELETE` whose `WHERE` clause you have not first executed as a
   `SELECT`.** No `WHERE` clause at all means stop and ask.
10. **When unsure whether an operation is destructive, treat it as destructive.**

> **Treat the data as money.** Everything that can be done to prevent
> data loss must be done. There is no acceptable shortcut, no matter how routine the change looks.

---

## `SET PARSEONLY` and `SET NOEXEC` are NOT safety nets

Verified empirically on a development server, with a scratch table of 5 rows.

| Batch shape | Rows before | Rows after | Executed? |
|---|---|---|---|
| `SET PARSEONLY ON;` + `DELETE` (nothing else) | 5 | 5 | no |
| `SET PARSEONLY ON;` + `DELETE` + **`SET PARSEONLY OFF;`** | 5 | **3** | **YES** |
| `SET PARSEONLY ON;` + CTE `DELETE` + `SET PARSEONLY OFF;` | 5 | **3** | **YES** |
| `SET PARSEONLY ON;` + `DELETE` + `SET PARSEONLY OFF;` + `SELECT 1` | 5 | **3** | **YES** |

**The mechanism:** `SET PARSEONLY OFF` in the same batch re-enables execution, and the statements
already parsed in that batch then run. Wrapping a `DELETE` in
`SET PARSEONLY ON … SET PARSEONLY OFF` executes the `DELETE`.

This is exactly the trap that has caused real incidents. The empty result output looks like a clean
syntax check. It is a completed deletion.

Additional traps:
- `SET PARSEONLY` cannot be used inside a stored procedure body at all.
- Anything targeting a **linked server** may be sent to and executed on the remote server
  regardless of local session options.
- An empty result set is **not** evidence that nothing happened.

> **Rule: never put a destructive statement and a `SET … OFF` in the same batch. Better: never put
> a destructive statement in an exploratory batch at all.**

---

## Verified-safe ways to preview a destructive statement

### A. `SELECT COUNT(*)` shaped exactly like the DML — preferred

No DML keyword is present, so nothing can execute. This is the safest option and should be the
default.

```sql
-- preview: how many rows WOULD the delete remove?
WITH r AS (
    SELECT ROW_NUMBER() OVER (PARTITION BY <key cols> ORDER BY <tiebreak>) AS rn
    FROM dbo.TargetTable)
SELECT COUNT(*) AS would_delete FROM r WHERE rn > 1;
```

Verified: returned `2`, table stayed at 5 rows.

### B. Explicit transaction with unconditional `ROLLBACK`

Use when you must see the real `@@ROWCOUNT` of the actual statement.

```sql
BEGIN TRANSACTION;
    DELETE FROM dbo.TargetTable WHERE <predicate>;
    SELECT @@ROWCOUNT AS would_delete;
ROLLBACK TRANSACTION;          -- unconditional. never conditional.
```

Verified: reported `2`, table stayed at 5 rows.

**Caveat:** this does **not** work across a linked server on some systems — MSDTC may be
unavailable and the transaction fails to start. For cross-server work, use method A only.

### C. Test on a scratch object first

Prove the statement shape on a throwaway table **you created yourself**, never on a real table.
Use a development server where you have `db_owner`, but note such a server can still host real
data — so operate only on your own object. Name it obviously,
e.g. `zz_<user>_<purpose>`, and **drop it when finished**.

Never treat "it's the test server" as licence to skip the protocol. Confirm what a server actually
holds before assuming, and verify which server you are on:

```sql
SELECT @@SERVERNAME AS server_name, DB_NAME() AS database_name, SUSER_SNAME() AS login_name;
```

---

## Required protocol for a destructive database operation

**Treat the data as money. Every destructive statement is triple-checked:
SELECT first, backup second, guarded transaction third.** Every step. In order. No skipping.

1. **Confirm approval exists** for this specific operation. Quote it if unsure. If the user said
   wait — stop here.
2. **Identify the blast radius.** Which server, database, table? Production or test?
   `SELECT @@SERVERNAME`. Confirm what else depends on the object:
   ```sql
   SELECT COUNT(*) FROM sys.triggers WHERE parent_id = OBJECT_ID('dbo.T');
   SELECT COUNT(*) FROM sys.foreign_keys WHERE referenced_object_id = OBJECT_ID('dbo.T');
   SELECT COUNT(*) FROM sys.sql_expression_dependencies WHERE referenced_id = OBJECT_ID('dbo.T');
   ```
3. **Record the before-state.** Row count plus the aggregates that matter
   (e.g. `SUM(amount)`, `SUM(quantity)`). Put the numbers in your report.
4. **CHECK 1 — SELECT the actual rows** that would be affected, not just a count. Show them to the
   user. State the expected number explicitly.
5. **Create a verified backup**, and assert the counts match. **No backup, no operation.**
6. **CHECK 2 — run the DML inside a guarded transaction** (template below). The guards re-verify
   inside the transaction and `ROLLBACK` on any mismatch.
7. **CHECK 3 — verify the after-state** against step 3, and confirm the backup still exists.
8. **Report** exactly what changed, before/after numbers, and where the backup lives.

If any step cannot be completed — especially the backup — **do not proceed.** Report the blocker.

### The mandatory T-SQL template

Use this shape for every `DELETE`, `UPDATE`, `MERGE` or `INSERT` that can lose or corrupt data.
Fully tested on a development server — including a deliberate failure to prove the guards fire.

```sql
/* ---------- CHECK 1: what exactly would be affected? (no DML keyword present) ---------- */
WITH r AS (
    SELECT id, <key cols>,
           ROW_NUMBER() OVER (PARTITION BY <key cols> ORDER BY <deterministic tiebreak>) AS rn
    FROM dbo.T)
SELECT * FROM r WHERE rn > 1 ORDER BY id;      -- inspect the real rows
-- and the count you will assert on:
WITH r AS (SELECT ROW_NUMBER() OVER (PARTITION BY <key cols> ORDER BY <tiebreak>) AS rn FROM dbo.T)
SELECT COUNT(*) AS would_affect FROM r WHERE rn > 1;

/* ---------- CHECK 2: verified backup ---------- */
DROP TABLE IF EXISTS dbo.T_backup_20260819;    -- only if re-running; never drop a real table
SELECT * INTO dbo.T_backup_20260819 FROM dbo.T;

DECLARE @src int = (SELECT COUNT(*) FROM dbo.T);
DECLARE @bak int = (SELECT COUNT(*) FROM dbo.T_backup_20260819);
IF @src <> @bak THROW 50000, 'backup incomplete - ABORT, nothing was changed', 1;

/* ---------- CHECK 3: guarded transaction ---------- */
SET XACT_ABORT ON;

DECLARE @expected int = <the number from CHECK 1>;   -- assert, do not hope
DECLARE @before int = (SELECT COUNT(*) FROM dbo.T);
DECLARE @affected int, @after int, @dups_left int;

BEGIN TRY
    BEGIN TRANSACTION;

        WITH r AS (SELECT ROW_NUMBER() OVER (PARTITION BY <key cols> ORDER BY <tiebreak>) AS rn
                   FROM dbo.T)
        DELETE FROM r WHERE rn > 1;
        SET @affected = @@ROWCOUNT;

        SET @after = (SELECT COUNT(*) FROM dbo.T);
        SET @dups_left = (SELECT COUNT(*) FROM
            (SELECT 1 AS x FROM dbo.T GROUP BY <key cols> HAVING COUNT(*) > 1) z);

        -- guards: any mismatch and nothing is kept
        IF @affected <> @expected
            BEGIN ROLLBACK TRANSACTION; THROW 50001, 'affected <> expected - ROLLED BACK', 1; END
        IF @after <> @before - @affected
            BEGIN ROLLBACK TRANSACTION; THROW 50002, 'row arithmetic wrong - ROLLED BACK', 1; END
        IF @dups_left <> 0
            BEGIN ROLLBACK TRANSACTION; THROW 50003, 'duplicates remain - ROLLED BACK', 1; END
        IF @affected > @before / 100          -- sanity ceiling: >1% is suspicious
            BEGIN ROLLBACK TRANSACTION; THROW 50004, 'too many rows affected - ROLLED BACK', 1; END

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    THROW;                                    -- surface the real error, never swallow it
END CATCH

SELECT @before AS before_, @affected AS affected_, @after AS after_;
```

Proven behaviour:

| Scenario | Result |
|---|---|
| `@expected` correct (2) | committed; 5 → 3 rows, 0 duplicates left |
| `@expected` deliberately wrong (99) | **guard fired, ROLLBACK, all 5 rows intact** |
| Restore from the backup table | worked; 5 rows returned |

### For `UPDATE`, the same discipline plus one addition

`UPDATE` is worse than `DELETE`: it destroys the old value in place with nothing to compare
against afterwards. So **capture the old values before changing them:**

```sql
-- CHECK 1: show old AND new value side by side, for every row that would change
SELECT id, <col> AS old_value, <new expression> AS new_value
FROM dbo.T WHERE <predicate>;

-- inside the transaction, keep what you overwrote:
UPDATE dbo.T SET <col> = <new>
OUTPUT deleted.id, deleted.<col> AS old_value, inserted.<col> AS new_value
INTO dbo.T_changelog_20260819
WHERE <predicate>;
```

Never run an `UPDATE` without a `WHERE` clause. Never run one whose `WHERE` you have not first
executed as a `SELECT`.

### Why the transaction cannot stay open for human approval

Tested: an open transaction **does not survive the connection.** `BEGIN TRANSACTION` in one tool
call, then `COMMIT` in a later call, does not work — each invocation is a new session, and the
uncommitted work is rolled back on disconnect.

```
session 1: BEGIN TRAN; DELETE ...;  -> @@TRANCOUNT = 1, 1 row deleted
session 2: SELECT ...               -> @@TRANCOUNT = 0, all 5 rows still there
```

That is a *safe* failure mode, but it means **"ask the user between DELETE and COMMIT" is not
achievable across tool calls.** The correct substitute is what the template does:

- Get human approval **before** running anything, based on the CHECK 1 output.
- Put the human's expected number into `@expected` so the script itself refuses to deviate.
- Keep the guards and the backup as the safety net inside the single batch.

If you genuinely need a human to eyeball the post-delete state before committing, split it: run the
DML in a transaction that **always** rolls back, show the result, get approval, then run the real
guarded batch.


---

## Beyond SQL: other irreversible operations

Same principle: **prove it, back it up, or don't run it.**

| Operation | Do this instead |
|---|---|
| `rm`, `rm -rf` | Never. Move to a `trash/` folder, or ask. Deleting files is not the agent's call. |
| Anything in a project's `notes/` folder | **Never delete, ever.** Received material and working files are the project's memory (folder-structure.md). Filing = move only. |
| `mv` over an existing path | Check the destination first (`ls`, `test -e`). |
| Overwriting a file (`Write`, `>`) | Read it first. Never blind-overwrite a file you have not read. |
| `git reset --hard`, `git clean` | Never without explicit approval; discards uncommitted work. |
| `git push --force`, history rewrite, `git rebase` | Never without explicit approval. |
| `git checkout -- <file>` | Discards changes — the user may have edited it. Ask. |
| Deleting a remote branch or tag | Never without explicit approval. |
| `TRUNCATE`, `DROP TABLE` | Treat as maximum severity. Backup + explicit approval. |
| `ALTER TABLE` dropping a column | Irreversible data loss. Backup + approval. |
| Bulk file rename / restructure | Propose the full list of moves, wait for approval (exception: filing inside notes/, folder-structure.md). |
| Deleting an email, ticket, or wiki page | Never. |
| Sending anything on the user's behalf — email, chat, ticket comment, PR submission | Never without approval of the exact text. Draft it, hand it over. |
| Publishing / releasing — package registries, git tags, releases, deployments | Explicit approval per release. |
| Cloud / infra changes — `terraform apply`/`destroy`, deleting or modifying cloud resources, DNS | Explicit approval; plan/preview first. |
| Scheduled tasks, cron, service start/stop/disable, killing processes | Explicit approval. |
| Permission changes — DB grants/revokes, ACLs, recursive `chmod`/`chown` | Explicit approval. |
| Disabling monitoring, alerting, or backup jobs | Never without approval — these are the safety net. |
| Overwriting or deleting any backup | Never. A backup is the last line. |
| Rotating or invalidating credentials, revoking tokens | Explicit approval; something is always still using them. |

**Never delete anything the user might want.** The user's standing instruction is: never delete,
ask before cleaning up, there may be a reason something looks odd.

---

## Red flags — stop immediately if you notice any of these

- You are about to run DML against **any** server, and you have not confirmed from evidence
  (not from its name) whether it holds production data.
- You are relying on a `SET` option, a flag, or a wrapper you have not personally tested, to make
  something safe.
- You caught yourself thinking "this is just a syntax check" about a statement containing
  `DELETE`, `UPDATE`, `DROP`, `TRUNCATE`, or `MERGE`.
- A row count changed and you cannot immediately explain why.
- The user asked you to hold, and you are about to run something anyway "just to check".
- You have no backup and are about to modify data.
- You are in the middle of exploring and improvising statements against a real table.

---

## If it goes wrong anyway

Do not minimise, do not continue working, do not try to quietly fix it.

1. **Stop.** Run no further statements against anything.
2. **Establish the facts.** What ran, what changed, exact before/after counts.
3. **Assess integrity honestly.** Was real data lost, or only redundant copies? Verify against a
   measured baseline — do not assume.
4. **Report immediately and completely**, including that approval was absent if that is the case.
   State plainly what is recoverable and what is not.
5. **Do not attempt recovery unilaterally.** Restores are the user's and the DBA's decision.
6. **Write the lesson into this file** so the same mechanism cannot catch anyone again.

The user is accountable for the agent's actions. Concealing or downplaying a mistake is worse than
the mistake.

---

## The generalisable lesson

The danger is not ignorance of the rules. Every incident so far happened with the rules available
and read. The danger is believing a destructive statement has been rendered harmless — by a `SET`
option, a wrapper, a dry-run flag that was never tested, or a server name that sounded safe. **Only
methods A, B, and C above are verified safe. Nothing else counts.**

The recurring failure sequence, so it can be recognized early:

1. An untested mechanism trusted as a safety net.
2. A destructive statement pointed at a real object "just to check".
3. A standing hold instruction overridden by curiosity.
4. No backup, despite one being cheap.
5. Empty output read as "nothing happened".
6. The rule known — and not applied, because the statement did not *feel* destructive.

Full case studies of past incidents, with servers and numbers, live in the local `knowledge/`
folder where they occurred.
