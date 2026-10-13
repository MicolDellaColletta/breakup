# Full review, part 1: the map

Oct 13. This is the first pass of the full review (`todo.md`, item 2), over
everything built up to the end of February (the `february` branch).

It was made with `tools/story_graph.py`. That script reads every story file,
`spots.cfg`, `items.cfg` and the scripts, and lists how the flags, items,
sections, choices and counts connect. Run `python3 tools/story_graph.py` to
get the raw list again.

Each hit was checked by hand and sorted below as one of: **fixed**,
**bug**, **pays off later** (fine, but March or April must read it),
**dead** (cut it, or give it a payoff), or **not a problem** (the script
can't see it).

**Size:** 81 story files, 1,880 sections, 225 spots, 30 items.

## Fixed in this pass

- **`booth_left`** was read on night 30 ("the empty chair in the booth") but
  never set, so the line could never play. Walking out of the confession queue
  on day 30 (`walk_out`) now sets it.

## Bugs and questions to check

- **The gun in the dresser** has no way to be taken back on a night walk.
  The pillow keeps it in hand. The bear, furnace, freezer and floorboard each
  have a `take_gun_*` section, but the dresser doesn't. Only the face-off at
  the Gleaner can fetch it from there. Add `take_gun_dresser`?
- **The gun in the snow** (night 7, "till May") can never come back, and
  nothing ever reads `gun_snow`. That's fine if May pays it off (the endings,
  the thaw). Write it into the April plan, or the hidden gun is wasted.
- **The counts are thin.**
  - Doors: Daniel has 1 door in the story files, against Sam's 3 and Ruth's 1
    from `door=` (the rest come from `door_<who>_N` flags in `FAITH`).
  - Kept faith from `keep=`: Hollis only 1, Ezra 1, Ruth 1, Sam 1, against
    Olstad's 6.
  - Check that every ending's requirement (`forks.md`) can actually be met
    with what's built. "Four of six kept faith" may only be reachable with
    Olstad, Walt and one other.
- **The voices' leans are lopsided.** Over 666 choices: none on 303, paranoia
  119, animal 87, warmth 63, appraisal 44, John 30, ??? 20. If leans decide
  the background and the ending variants, John and ??? are starved. Is that
  intended?
- **February, three choices gated on the deed and the room key:** check that a
  player who missed those finds still gets at least two options.

## Pays off later: flags March and April must read

These are set on purpose and wait for a payoff. Each is a promise to keep.

| Flag | Set in | Should pay off in |
|---|---|---|
| `gave_deed`, `told_olstad_john` | day 33 | Olstad's case (March), the fire (her looking away) |
| `notebooks_safe` / `_bear` / `_room` / `_bed` | day 34 | March: the town looking for them. One of the four should be found. |
| `refused_scale` / `weighed` | day 34 | The weigh-in book in April; the eye |
| `pulled_trigger` | night walk face-off | Daniel, in March ("you pulled it. It was empty. I counted.") |
| `wont_promise` | the ruins, day 29 | Olstad at the town line |
| `ruth_lied_freezer`, `ruth_told_late` | day 28 | Ruth's ending, Run (who holds the keys) |
| `lied_to_daniel`, `told_daniel_hidden` | day 22 | His one lie (March), fork 6 |
| `took_communion` / `refused_communion` | Christmas Eve | The congregation's eye; the shore |
| `refused_thread` | day 24 | The procession (March) |
| `silent_on_fire`, `showed_olstad_letter` | Dec | Olstad's case |
| `road_turned_back`, `road_closed` | Dec | Run (the road in April) |
| `refused_watch`, `refused_coat_hang` | Dec, Jan | Small; one line each in March would do |
| `gun_snow` | night 7 | May, the thaw (see above) |

## Dead: cut, or give a line

Set once and never mentioned again. Each needs one line of payoff somewhere,
or should be removed:

- **Early weeks:** `daylight_call` (day 4), `rental_call` (day 6),
  `kept_picks` (day 8), `prayed_again` (day 9), `invited_ice` (day 10),
  `sam_arrow` (day 13).
- **Smaller ones:** `fed_furnace` (night 10), `ruth_refused` (day 2),
  `sam_never_touches` (evening 19), `saw_coat_close` (the town map).
- **Possibly stale:** `daniel_in_town` (day 15) and `power_left` /
  `power_upstairs` (night 24).

## Items

- **Taken and never used:** the documents (`abraham_letter`, `abraham_rules`,
  `bench_notebook`, `carbon_copies`) and the money orders are read from the
  pockets, so they're fine. These need a use:
  - **`keeper_photo` and `burned_corner`:** nobody reacts to them. Show Ruth
    the photo? Show Olstad the corner?
  - **`note_furnace`:** nobody reacts to it.
  - **`red_thread`:** it's only read as the flag `wears_thread`, never as the
    item.
- **Used and never taken:** `silver_dollars` and `spectacles` are shop stock
  (`pawned=`/`sold=`), so they're fine.

## Sections nothing points to

**Not a problem:**

- The counter's `<customer>_given_<item>` sections are built by name in
  `counter.gd`.
- `shop.txt:enter_counter` is named in the scripts.

**To check:** `town.txt` has `ruth_house`, `town_line` and `lunds`. Are they
reachable from the map, or left over from an older map?

## Not done yet (part 2: reading)

The script can't judge writing. Still to do, month by month, reading the
files:

- **Dialogue:** each character's voice, Daniel against v7, repeated lines,
  contradictions between months, too much text.
- **Choices:** fake choices (two labels, one result), and whether each choice
  gives the player something real.
- **Exploration:** for each night walk and spot, when it appears, and whether
  it's findable without luck. A table of finds by date.
- **Continuity:** dates and weekdays, sunrise and sunset, who knows what when,
  dead people staying dead.
- **The forks:** a table of the six hard forks, what each one changes later,
  and whether every ending can still be reached.
