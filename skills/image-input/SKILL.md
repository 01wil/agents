---
name: image-input
description: Turn an image into text the agent can actually read. Use when the harness or model cannot see an image, when the user pastes or references a screenshot, when a task folder contains .png/.jpg files, or when you are about to ask the user to describe a picture. Also use for any input file that is not readable as text yet.
---

# Image input

**Never ask the user to describe an image.** Describing a screenshot by hand is slow, lossy, and
it is work the machine can do. If you cannot see it, convert it.

## Steps

1. **Find the file.** The user may reference an image you cannot open. Pasted screenshots are
   normally the newest files in the OS screenshot folder; images belonging to a task are already
   in its `notes/`. Ask for the path only after looking.
2. **Copy it into the work folder** (`notes/`, grouped by origin — `folder-structure.md`). Keep the
   original where it was; copy, never move.
3. **Convert it to text** with whatever vision tool this machine has, and write the result in a
   sibling text file next to the image, one section per image. Look the tool up in
   `wiki/knowledge/INDEX.md` — grep it for `image`. On a machine with none, say so plainly and ask
   the user; that is the only case where asking is right.
4. **Read the text file and use it as the input.** Say that you converted the image, and name the
   file you wrote, so the user can check it.
5. **Spot-check anything that drives a decision.** Generated descriptions are generated text: a
   wrong digit looks exactly like a right one. Verify numbers against a second source (a query, a
   config file) before acting on them.

## Rules

- Keep the image. It is received material (`folder-structure.md`): never delete it, and file the
  description beside it so both survive.
- One description file per folder is enough; append, do not overwrite.
- Transcribe, do not summarize. Tables, labels, highlighted cells and filter states carry the
  meaning in a screenshot of a UI; a prose summary throws them away.
- Mark what could not be read as unreadable rather than guessing. A plausible invented value is
  worse than a gap.
- A filter or a sort shown in a UI changes what the rows mean. Note it, and ask whether the view
  was filtered when it matters.

Same reflex for other unreadable input: convert it yourself (xlsx → csv, docx/pptx → XML, PDF →
text) and keep the original. See "Input material" in `folder-structure.md`.
