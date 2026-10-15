# Routes: every ending, reached by playing

Oct 14. Each ending is checked by `tests/test_routes.gd`. Every route starts
on the morning of February 5 (key day 31) with what October to January would
have set on that route. Then it lets the game run, scene after scene, the way
a player goes through them:
- every counter day, map evening, walk-around, walked evening, night and
  bridge, in order;
- the route's choices, and the first choice otherwise;
- the rules kept every night.

It runs until breakup plays the ending and the title comes back.

**Result:** all eight routes reach their ending (24 checks). `ROUTE=fire`
runs one route on its own. The whole test takes about 40 minutes, so it isn't
in the everyday suite.

`tools/setters.py <flag> …` lists where any flag or item is set, and what that
place requires. It's how the starting states below were checked.

## The routes

| Ending | October to January sets (where) | February to April, the route's choices |
|---|---|---|
| **The fire** | `walt_kind` (day 2, turning down Walt's dollars); `faith_hollis` (days 3–4, the jacket or the duck call); `ezra_satisfied` (day 2, his shells); `showed_olstad_ticket` (day 3); `told_olstad_daniel` (day 15, the cruiser); `door_sam_1` (day 4, your real name) | load Ezra's shells; tell Olstad the truth; keep Sam and hide his notebooks in the bear; take Mrs. Hollis's hand; take Lund's notebook from his room; refuse him at fork 6; forgive Sam; sign Olstad's statement; read Lund's page from the anxious bench; the bear's paraffin (night 40); burn it |
| **Escape with Ruth** | `door_ruth_1` (day 3, the pub), `door_ruth_2` (day 13, the cellar), `ruth_has_keys` (day 13), `car_forgotten` (day 18, the rental letter) | forgive Ruth (door 3, the keys back); take Lund's notebook; "be at the car"; the anxious bench; she's at the car |
| **Escape with Sam** | `door_sam_1`, `door_sam_2` (evening 19, the wall), `car_forgotten`, John's gun under the pillow (night 7) | keep Sam; refuse him; forgive Sam at the tripod; "be at the car"; John's gun on Palm Sunday (he never loaded it, so it fires); Sam at the car |
| **Escape with Cody** | `gave_picks_back` (day 8: Cody lives), `car_towed` (day 18) | "I'll be there"; the truck at the end of the road |
| **Run alone (he finds you)** | `car_forgotten` | refuse him; do nothing on Palm Sunday; leave; he's in the passenger seat; drive |
| **Run alone (he can't)** | `showed_olstad_ticket`, `told_olstad_daniel`, `car_forgotten` | tell Olstad the truth; sign; the steps; leave alone |
| **Go with him** | `door_daniel_1` (day 15, "It came out of you."), `door_daniel_2` (Christmas Eve, staying in the chair) | "Yes." at fork 6; do nothing on Palm Sunday; stay |
| **The season ends** | nothing | the first choice every time |

*Into the ice together* and *the ice* turn on ??? being the strongest voice,
which a route can't steer choice by choice. `test_endings.gd` covers them
from a set state.

## What the routes showed about the design

- **Escaping with Ruth or Sam by car needs Daniel beaten first.** If he
  isn't, he's sitting in the passenger seat (night 42), and the only way out
  by car is with him. Cody's truck doesn't need the car, so it's the one
  escape with someone that works while he's free. That's as planned. It also
  makes beating him matter for three endings, not one.
- **The paraffin is always findable:** Abraham's bench notebook (a night find
  from February) opens the bear on its own, even if the town never searched
  it.
- **The fire's five conditions** can all be met on one route without any of
  them closing another: kept faith with four, Olstad looking away, Daniel
  beaten, no romance locked, the paraffin.
