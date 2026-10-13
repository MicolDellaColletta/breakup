# The red light

Built Oct 13, ahead of the Daniel calls, from `daniel_v7.md` section 10 (call
11, lean yes). It's on its own branch so it can be dropped if the call goes
the other way.

## How it behaves

- **When Daniel is present,** the whole picture goes faintly red. The red is
  multiplied in over about two seconds, so the lamps and lights take it most.
  It comes on by itself on any `daniel` line. It doesn't come on for
  `daniel_line`: on the phone he isn't in the room.
- **Alone with MC** (`| red=alone`), it's deeper and breathes slowly. It's
  set on:
  - the confession booth (day 30),
  - Sam's booth (day 34),
  - the face-off at the Gleaner's back window (night walks).
- **Present but silent:** `| red=on`.
- **Gone** (`| red=off`), it fades out over a second and a half. It also goes
  off by itself:
  - **at the counter,** when the next customer comes in;
  - **at night,** at the end of the section he was in;
  - **in any scene,** at once, when the scene changes.
- **The phantom:** on a frayed night (fray at 3 or more), on odd days from day
  15, a faint red comes **with nobody there**. If he really speaks, it turns
  into the real thing.

## Where it lives

- **The light itself:** `scripts/presence.gd`, an autoload (`Presence`),
  drawn above the scenes and the HUD and under the pause menu and the fades.
- **Its hooks:**
  - **The narrator:** `red=` lines, and his voice.
  - **Scene changes:** `transition.gd`.
  - **The counter:** the next customer.
  - **The night scene:** the end of a section, and the phantom red.
- **Checks:** `check_story` checks every `red=` value.
- **Tests:** `test_presence.gd`, plus two checks in `test_february` (on with
  him at the counter, off when he leaves with Ezra).

## Not yet

- **The rewrite pass:** it will add `red=alone` to the counsel room and
  `red=on` to scenes where he's there but silent (the end of the bar on the
  evening of day 32, the chair on day 33).
- **Saves:** a save made mid-scene comes back without the red until he
  next speaks.
