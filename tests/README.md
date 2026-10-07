# Tests

Checks that run Godot without a window and play through the game.

| File | What it checks |
|---|---|
| `check_story.gd` | Every story file: speakers, sounds, items, stock, voices, conditions, clock times and where choices lead all exist. **Run it after writing.** |
| `test_prologue.gd` | The drive, the shop (both phone routes, both doors), the first night (dog fed and not fed). |
| `test_day_one.gd` | The morning, Mrs. Hollis three ways, the voices, the colored choice rules, number keys. |
| `test_evening.gd` | The town map: which places show, travel time, the pub, the lake, going home. |
| `test_menu.gd` | The title screen, pause menu, saving, loading and settings. Uses its own save folder, never your saves. |
| `test_base.gd` | Shared helpers the tests use. Not a test itself. |

## Running them

**All of them:** double-click `run_tests.bat`. It ends with ALL TESTS PASSED or
SOME TESTS FAILED, and every failed check is marked `FAIL`.

**Just one,** from a terminal in the project folder:

```
"C:\Users\clari\Downloads\Godot_v4.7.2-stable_win64.exe\Godot_v4.7.2-stable_win64_console.exe" --headless --path . --script res://tests/check_story.gd
```

If Godot moves, update the path at the top of `run_tests.bat`.

## When a test fails

A failed playthrough check usually means a story change moved a choice or a
section the test expects (for example, renaming "Let me look"). Either the
story or the test needs updating; the `FAIL` line says which step.

These scripts are for development only: leave the `tests/` folder out when
exporting the game.
