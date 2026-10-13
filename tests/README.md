# Tests

Checks that run Godot without a window and play through the game.

| File | What it checks |
|---|---|
| `check_story.gd` | Every story file: speakers, sounds, items, stock, voices, conditions, clock times and where choices lead all exist. **Run it after writing.** |
| `test_prologue.gd` | The drive, the shop (both phone routes, both doors), the first night (dog fed and not fed). |
| `test_day_one.gd` | The morning, Mrs. Hollis three ways, the voices, the colored choice rules, number keys. |
| `test_day_two.gd` | Day two two ways (the morning after night one, Cody or Mrs. Hollis, Ezra, Walt's name, Ruth), the church and Sam's cabin, and the second night's phone three ways. |
| `test_day_three.gd` | Day three three ways (the morning after night two, window day, Olstad's money order and the tin, the gift, Teague / June / a quiet afternoon by what's in the window, the warm jacket), the Friday evening (Ruth's question, Sam, the dark church), and the third night (no call, the window, waving or not). |
| `test_day_four.gd` | Day four three ways (the morning after night three, the jacket coming home to Cody or Mrs. Hollis, Hanna Lund's braid, Sam's first door, the phone in daylight), the Saturday evening (Ruth's napkin, Sam's ten names, the church, the lake), and the fourth night (the phone again, or silence; the dog on its knees). |
| `test_day_five.gd` | Sunday four ways, with no counter (church: bear the hands or walk out, the scale, the doorframe, the book; or stay in the shop while the congregation prays at the window), Mrs. Hollis's kitchen, the Sunday evening (Ruth's house and the shoebox, Sam, the lake), and the fifth night (the phone, with a radio a second behind yours). |
| `test_days_six_seven.gd` | The end of week one. Monday two ways (the snow, Olstad and the rental company's call, Ezra and the tooth, June and the flannel shirt), the town line, Sam's notebook, night six; Tuesday with Walt or the boy, the envelope a day early, the ledger's "One week"; and the John night three ways (the revolver, the background settling, including a tie, and the first flash). |
| `test_week_two.gd` | Week two: the bridges and their title cards (the clock jumping to the key day), key day 8 (Ezra, Mrs. Hollis, Cody and the picks, June's drawings; the Lunds' and the coat; Ruth, Sam and the camera both ways; night eight's call), key day 9 (the coat under the sheet, the tooth asked on the church steps), the evening after a broken faith, and the bridge to week three. |
| `test_week_three.gd` | Week three: the Monday-to-Friday bridge (the swatch, the road closing), key day 10 (Olstad stuck in town, Cody's brass button or Mrs. Hollis, Hanna), leaving the counter for a walked evening, the first-ice party five ways (the shape under the ice: kneel with Sam, show Olstad, skate over it, walk away, or go home without looking), night ten (the train, the button), and the bridge into week four. |
| `test_week_four.gd` | Week four: key day 11 (Olstad's "Who's John?", the tape measure, Sam's trains, Ruth's candy), the evening, the double hour (the clocks falling back, two calls at 1:40, the tin four ways), Halloween two ways, night twelve, and the bridge into November. |
| `test_november.gd` | November to Daniel's arrival: key day 13 (the Wasilla money order, Ruth's cellar and the keys, the minister on the radio), the fitting, the wipers on the line, key day 15 (the sixth bullet three ways, telling Olstad), and the payphone across the street. |
| `test_thanksgiving.gd` | Thanksgiving week: key day 16 three ways (Mrs. Hollis's place for whoever: the duck call, nothing, the picks then Ray's jacket; Ezra's Thursday shells sold or spoken for; Olstad, Sam's note or June's program), the evening (Ruth's mother's bowl, the rehearsal, Sam behind the door), night 16 (no call, the payphone hanging), Thanksgiving (the empty place, the two bachelors, the salt, the pie, the pageant, his voice on the radio in the hall, the vestry door), night 17 (the plate for the Keeper's dog) and the bridge to December. |
| `test_counts.gd` | The counts (`docs/december.md`): kept faith with six people and the romances' doors, worked out from flags (`faith:`, `faithless:`, `doors:`); a betrayal closing a person; the town's eye seeded once on December 1 (`eye>=`); `keep=`, `betray=`, `door=`, `eye=`; saving; two `flag=` on one line. |
| `test_evening.gd` | The town map: which places show, travel time, the pub, the lake, going home. |
| `test_night.gd` | The first night as Keeper: radio, back door with and without the key, the reflection after three, staying in bed. |
| `test_nights.gd` | The nights' drift (`docs/nights.md`): rule tallies (`broken:`), the order of stops (`order:`), stops that only show with something new, something out of place, note one (the bowl at the back door) and note three (LOCK IT NOW). |
| `test_voices.gd` | The voices' own rules: Paranoia talking over the others, fraying and coming back, ??? when frayed, the background. |
| `test_menu.gd` | The title screen, pause menu, saving, loading and settings. Uses its own save folder, never your saves. |
| `test_shop.gd` | The drawn shelves: picking up and putting down, the front window (and saving it), turning to the walls and the back shelf, the bell (nobody comes in until you ring; then "Close up for the day"), the person across the counter, examining a thing in close-up and handing it over. Elsewhere, `advance()` rings the bell whenever the shop is waiting. |
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
