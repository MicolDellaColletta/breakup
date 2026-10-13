# Breakup

A narrative point-and-click game in Godot 4.7.2. Alaska, the winter of
1999–2000. MC, a man running from something, keeps a pawn shop under a dead
man's name ("John") until breakup.

- **Design:** `docs/` (start with `pillars.md`, `story.md`, `forks.md`,
  `season.md`, `daniel_v7.md`).
- **What's next:** `docs/todo.md` ("Pick up here").

## Workflow

- **Plan first.** Each part (a month, a system) is planned in a doc in `docs/`
  with "Your calls" and a lean on each. The user replies, then it's built,
  and the doc gets an "As built" section.
- **Branches and PRs.** One branch per part. Commit and push every change.
  The user opens PRs from the Claude Code UI.
- **Watching a PR:** subscribe to its activity and set a check-in about 50
  minutes out. On merge, delete the check-in and update main.

## Story files (`story/*.txt`)

How sections, lines, choices and jumps are written:

```
=== section_name
speaker | key=value | key=value: The line's text.
> Choice label -> target_section | if=condition | flag=a | lean=warmth
-> target_section | if=condition
```

- **Speakers** are in `story/speakers.cfg`. Use `narration` for the
  narrator, a voice name for a voice, and `daniel_line` for Daniel on the
  phone (in red).
- **Conditions:** `flag:`, `has:`, `held:`, `sold:`, `broken:`, `order:`,
  `knows:`, `faith:who>=n`, `faithless:who`, `doors:who>=n`, `eye>=n`,
  `day==n`, a voice's name `>=n`. Combine with `and`, `or` and `!`.
- **Effects:**
  - Flags: `flag=` (can repeat), `unflag=a,b`.
  - Items: `take=`, `lose=`.
  - Money and the ledger: `cash=`, `write=`.
  - Counts: `eye=+n`, `keep=who`, `betray=who`, `door=who`.
  - Scene and voices: `lean=`, `time=`, `show=room`, `sound=`,
    `end=night|map`.
  - The shop: `pawned=item | loan=n`, `sold=`, `redeemed=`.
- **Gotchas:**
  - **Jumps only run at the end of a section,** after its lines. To branch
    halfway through, split the section in two.
  - `redeemed=` goes on lines, never on choices.
  - **Sections a spot plays with `use_<item>=` or `seen=` must be in
    `story/use.txt`.**
  - **A sound must exist in that scene.** `check_story` reports it if not.
  - **Night walks** (`story/night_walks.txt`) are loaded every night.
- **Spots** (clickable things) are in `story/spots.cfg`, gated with `if=`.
  **Items** are in `story/items.cfg`, documents in `story/documents/`.
- **New days** need entries in `scripts/game_state.gd`: `DAY_STORIES`,
  `DAY_SCENES`, `EVENINGS`, `DAY_DATES`, `BRIDGES` and `NIGHT_STORIES`.
  Customers go in `VISITS` in `scripts/counter.gd`.

## Tests

The tests run headless with Godot 4.7.2 (Linux). In a fresh cloud session,
download it first:

```
curl -L -o godot.zip https://github.com/godotengine/godot/releases/download/4.7.2-stable/Godot_v4.7.2-stable_linux.x86_64.zip
unzip godot.zip
./Godot_v4.7.2-stable_linux.x86_64 --headless --path . --import
./Godot_v4.7.2-stable_linux.x86_64 --headless --path . --script res://tests/check_story.gd
```

- **What runs:** the list of tests is in `tests/run_tests.bat`, and each
  file is described in `tests/README.md`. Run `check_story` after every
  story edit.
- **Don't run scene tests side by side.** They share `user://test_saves`.
  The full run takes about 15 minutes.
- **In tests, `load()` scripts at runtime,** not with `preload`.
- **A new git worktree** needs `--import` once before its tests will run.
- **The story map:** `python3 tools/story_graph.py` lists flags set and never
  read, items never used, and sections nothing points to (see
  `docs/review_full.md`).

## Commits

Never put a model name in commits, PRs or code.
