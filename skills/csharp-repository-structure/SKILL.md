---
name: csharp-repository-structure
description: Reorganize or scaffold a C#/.NET repository using Microsoft and .NET Foundation conventions. Use when asked to clean up a .NET solution layout, move projects into src/tests, centralize build configuration, classify repository files, configure test assets or Git LFS, or verify a reorganized solution.
---

# C# Repository Structure

Reorganize or scaffold C# repositories into a professional structure without losing files, Git history, or build correctness.

## Operating Principles

- Inspect the repository before proposing or making changes.
- Prefer the smallest structure appropriate for the repository. Do not create empty optional directories unless scaffolding was explicitly requested.
- Never delete files.
- Never rename C# source files or declared types. Move files only.
- Do not alter application behavior or source code. Limit content changes to paths, project and solution references, build configuration, ignores, attributes, and documentation required by the move.
- Preserve Git history with `git mv` when the repository is under Git and the source is tracked.
- Do not overwrite existing configuration blindly. Merge required settings while preserving project-specific rules.
- Put uncertain items in `misc/` and report why. Never guess destructively.
- Respect user changes and unrelated worktree modifications.

## Target Layout

```text
<RepoRoot>/
|-- .github/
|   `-- workflows/
|-- .config/
|-- src/
|   |-- <Project>.Api/
|   |-- <Project>.Core/
|   |-- <Project>.Domain/
|   `-- <Project>.Infrastructure/
|-- tests/
|   |-- <Project>.UnitTests/
|   |-- <Project>.IntegrationTests/
|   |-- <Project>.EndToEndTests/
|   |-- TestData/
|   `-- Shared/
|-- docs/
|   |-- architecture/
|   |-- adr/
|   `-- api/
|-- samples/
|-- build/
|-- tools/
|-- assets/
|-- notes/
|-- agent/
|   |-- context/
|   |-- prompts/
|   `-- README.md
|-- .editorconfig
|-- .gitignore
|-- .gitattributes
|-- Directory.Build.props
|-- Directory.Packages.props
|-- global.json
|-- nuget.config
|-- <Project>.sln
|-- README.md
|-- LICENSE
|-- CHANGELOG.md
`-- CONTRIBUTING.md
```

Treat `samples/`, `tools/`, `assets/`, `notes/`, `agent/`, and specialized project layers as optional. Create them when content or the user's scaffolding request justifies them.

## Classification Rules

| Item | Destination |
|---|---|
| Runtime-project `.cs` files and their project | `src/<ProjectName>/` |
| Test-project `.cs` files and their project | `tests/<ProjectName>/` |
| Test fixtures and JSON, XML, CSV, ZIP, or sample inputs used by tests | `tests/TestData/` |
| Shared test helpers and builders | `tests/Shared/` or a dedicated shared test project |
| Test binaries larger than 10 MB | `tests/TestData/`, with Git LFS when Git is available |
| Architecture documentation, ADRs, and diagram sources | `docs/` |
| Personal notes, TODOs, and scratchpads | `notes/`, ignored by Git |
| AI instructions, prompts, and context | `agent/` |
| Dockerfiles, CI scripts, and build helpers | `build/` unless a tool requires a conventional location |
| Images used by repository documentation | `assets/` |
| Demo and example projects | `samples/` |
| Unknown or ambiguous items | `misc/`, followed by explicit review notes |

Do not move files required at a tool-defined path merely to satisfy aesthetics. Examples include `.github/workflows`, root-level Docker discovery explicitly used by CI, and configuration whose consumer requires its current location. Report justified exceptions.

## Root Whitelist

The root should contain only:

- The solution file or solution filter files.
- The top-level directories in the target layout.
- `.editorconfig`, `.gitignore`, `.gitattributes`, `global.json`, `nuget.config`, `Directory.Build.props`, and `Directory.Packages.props`.
- `README.md`, `LICENSE`, `CHANGELOG.md`, and `CONTRIBUTING.md`.

Move other root items according to the classification rules. If a required tool convention conflicts with the whitelist, preserve correctness and document the exception.

## Workflow

### 1. Establish Safety

1. Determine the repository root.
2. Check whether it is a Git repository.
3. Inspect Git status and identify pre-existing changes. Do not revert or overwrite them.
4. Discover installed .NET SDKs and locate all `.sln`, `.slnx`, `.csproj`, `.fsproj`, shared props/targets, lock files, and tool manifests.
5. Record the initial solution/project relationships and, when feasible, run a baseline restore/build before moving anything.

### 2. Inventory and Classify

Inventory every file and directory, including hidden items, while excluding generated internals such as `.git/`, `bin/`, and `obj/` from move planning. For each item, record:

- Current path.
- Owning project or consumer.
- Proposed destination.
- Classification reason.
- Whether references must change.
- Whether it is ambiguous, generated, large, or binary.

Inspect project files and scripts before classifying assets. File extensions alone are not enough to determine ownership.

### 3. Plan Moves

Create a complete source-to-destination move plan before moving files. Check for:

- Destination collisions and case-only path changes.
- Relative `ProjectReference`, `Compile`, `Content`, `None`, `EmbeddedResource`, import, signing-key, analyzer, and generated-code paths.
- Solution references and solution-folder organization.
- Paths in scripts, workflows, Dockerfiles, documentation, launch settings, run settings, coverage configuration, and package sources.
- `InternalsVisibleTo`, namespaces, and assembly names that might depend on project identity. Do not change them unless necessary for path correctness and allowed by the user.

### 4. Move Safely

Use `git mv` for tracked files in a Git repository. Use non-destructive filesystem moves for untracked files or non-Git repositories. Never emulate a move by deleting content.

Keep each project directory intact unless there is clear evidence that individual files are misplaced. Move project files together with project-owned configuration and assets.

### 5. Repair References

Update only references made invalid by the moves:

- Solution project paths.
- `.csproj` and shared props/targets relative paths.
- Project references and file-based MSBuild items.
- Build, CI, test, Docker, and documentation paths.

Prefer `dotnet sln <solution> remove/add` when it preserves solution metadata correctly; otherwise edit the solution carefully. Normalize paths according to the existing file's conventions.

### 6. Handle Test Data

Move test fixtures and archives to `tests/TestData/`. For `testdata.zip` and similar archives:

1. Search tests, projects, and scripts for direct archive consumption.
2. Keep the archive zipped if runtime behavior depends on it.
3. Otherwise extract it without deleting the original unless the user explicitly permits deletion. Because deletion is prohibited by default, retain the archive and report the duplicate representation.
4. Preserve relative paths expected by tests or update path configuration without changing test behavior.

### 7. Configure Git LFS

Only configure LFS in a Git repository and only if Git LFS is installed or can be safely initialized.

- Track `tests/TestData/**/*.zip` when such archives exist.
- Detect binary files larger than 10 MB and add precise patterns where practical.
- Merge generated LFS entries into `.gitattributes` without removing existing attributes.
- Do not rewrite Git history or migrate existing objects unless explicitly requested.
- If Git or Git LFS is unavailable, skip this step and report it.

### 8. Add Supporting Files

- Add a concise `README.md` to each existing or newly created top-level content folder among `src`, `tests`, `docs`, `notes`, `agent`, `build`, and `samples`.
- Update `.gitignore` using the repository's existing style. Ensure it covers `notes/`, `bin/`, `obj/`, `.vs/`, `*.user`, and `TestResults/` without discarding useful existing rules. Baseline for a fresh repo:

```gitignore
# Build output
[Bb]in/
[Oo]bj/

# IDE
.vs/
.idea/
*.user
*.suo

# Test output
[Tt]est[Rr]esults/
*.trx
coverage*.xml

# Local credentials — NEVER commit real secrets
config.json
appsettings.Local.json

# Runtime logs
logs/
```
- Add or update central build files only when requested or clearly applicable. Do not centralize package versions speculatively if doing so risks semantic changes.

### 9. Verify

Run verification from the repository root:

1. Confirm all planned items exist at their destinations and no source items were lost.
2. Confirm the root whitelist, documenting justified exceptions.
3. Run `dotnet restore <solution>`.
4. Run `dotnet build <solution> --no-restore`.
5. Run relevant tests when feasible, especially if paths for test data changed.
6. Inspect Git status and diff for accidental source changes, deletions, or unrelated modifications.

If baseline build errors existed before the reorganization, distinguish them from regressions introduced by the move. Never claim success if a command failed.

## Required Report

Return:

1. **New folder tree**: A readable representation of the resulting repository.
2. **Move log**: A table containing every `from` to `to` operation.
3. **Ambiguous items**: Each item placed in `misc/`, its reason, and the decision needed.
4. **Build verification**: Commands run, exit status, and relevant output. Include restore/test results when run.
5. **LFS configuration**: Exact tracked patterns and files, or why LFS was skipped.
6. **Follow-up recommendations**: Evidence-based suggestions such as project boundaries, inconsistent naming, missing tests, or configuration cleanup.

Also call out:

- Git/history preservation status.
- Any root whitelist exceptions.
- Any optional target folders intentionally not created.
- Any verification that could not be completed.
