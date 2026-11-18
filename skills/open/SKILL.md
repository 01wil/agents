---
name: open
description: Put something in front of the user in their OS rather than in the chat - a file, a folder, a URL, an app. Use when the user says "open", "open location", "show me that in the explorer/finder", "reveal it", or asks to look at something themselves. Not for reading a file into the conversation.
---

# open

The user wants to continue by hand. Hand the thing over to the operating system and stop.

This is not the same as reading a file: "open the config and fix the port" means read it, "open
the config" on its own means put it on their screen. When the sentence could be either, ask —
one short question beats opening twelve windows or silently reading instead.

## Steps

1. **Resolve what "it" is.** Usually the thing just discussed: the file you wrote, the folder you
   filed something into, the ticket or page you named. If more than one candidate fits, or the
   user said only "open", ask which one. Never guess between two files.
2. **Decide file or location.** "open X" = open X in its default application. "open location",
   "open the folder", "show me where" = open the containing folder with the item selected.
3. **Open it with the platform command**, looked up in `wiki/knowledge/INDEX.md` (grep it for
   `open`); the entry names the command for this machine and its quirks. Absent that, the usual
   ones: `xdg-open` (Linux), `open` (macOS), `explorer.exe` / `Start-Process` (Windows).
4. **Say what you opened, in one line**, naming the full path or URL. The window may be behind
   another one, and the user needs to know which thing is on screen.

## Rules

- Open one thing. If the user asks for several, open them one at a time and name each.
- A URL opens in the browser. Never paste a long URL and call that opening it.
- Check it exists first. Opening a path that is one typo off produces a confusing empty window or
  an error that looks like a tooling problem.
- Some launchers return a non-zero exit code even when they succeed. Verify by what appeared, not
  by the exit code, and do not retry on a false failure.
- Opening is read-only towards the content. Do not edit, move or create a file to make it
  openable, and do not launch anything that runs or installs something.
- After opening, stop and wait. The user is now working by hand; narrating further steps gets in
  the way.
- If the thing is not on this machine — a server path, a share the agent cannot reach — say so and
  give the exact path to paste, rather than opening something nearby that merely looks right.
