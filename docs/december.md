# Breakup: December (plan)

Key days 18 to 23, from `season.md`. A plan to agree before building.
**Leans** are my recommendations; "Your call" marks the decisions.

December is the month the town stops being kind. It opens with a face at the
door at dawn and ends with midnight, when the world doesn't end. In between:
the town turns on the Reverend, the freezer opens, and somebody says MC's
real name. Two hard forks (4, the Reverend; 5, New Year's Eve), and the first
month where the counts (kept faith, the doors, the town's eye) decide what
happens instead of only being written down.

## The shape

| Date | | Sunset |
|---|---|---|
| **Wed Dec 1** | **Key day 18** (counter): the envelope at dawn; the car | 15:47 |
| Thu 2 – Fri 3 | Bridge | |
| **Sat Dec 4** | **Key day 19** (counter, then a walked evening): Sam's wall | 15:43 |
| Mon 6 – Sat 11 | Bridge: the Reverend's car; Daniel and Ezra at the Gleaner | |
| **Sun Dec 12** | **Key day 20** (walk-around): the Reverend. **Hard fork 4** | 15:36 |
| Mon 13 – Mon 20 | Bridge: an empty pulpit, or not; the cold | |
| **Tue Dec 21** | **Key day 21** (counter, then the shop at night): the shortest day. The freezer | 15:33 |
| Wed 22 – Thu 23 | Bridge | |
| **Fri Dec 24** | **Key day 22** (walk-around): Christmas Eve | 15:34 |
| Sat 25 – Thu 30 | Bridge: Christmas Day; the year running out | |
| **Fri Dec 31** | **Key day 23** (walk-around): New Year's Eve. **Hard fork 5** | 15:41 |
| Sat Jan 1 | The bridge into January (Anchorage, if the locker's still paid) | |

Light from about a quarter past ten to half past three. Every day is a crack
under a door, and December is when the door closes.

---

## Before anything else: the counts

`season.md` says the real counts come at the start of December, because fork
4 needs them. Three of them, all saved, all readable as conditions.

### 1. Kept faith, per person (six)

- **Walt, the Hollises, Ezra, Ruth, Sam, Olstad.** Each person is
  **kept** (some kept moments, none broken), **broken** (an open
  betrayal: closed for good, `forks.md`), or **neither** yet.
- **Conditions:** `faith:ruth` (kept), `faith:ruth>=2` (kept, and
  how many times), `faithless:ruth` (broken). **Effects:** `keep=ruth`,
  `betray=ruth`.
- **Lean: worked out from flags, not a new store.** The flags already
  written (`faith_hollis`, `broke_faith_hollis`, `broke_faith_ruth`,
  `broke_faith_sam`, `lied_to_ruth`...) are the record; `GameState` reads
  them through one table (person → the flags that keep, the flags that break).
  Old saves work with no migration, and nothing can disagree with the flags.
- **What already counts** (the table, seeded from what's built):

| Person | Kept by (so far) | Broken by (so far) |
|---|---|---|
| Walt | Refusing the name kindly (day two) | Taking the name and refusing it back (January) |
| The Hollises | `faith_hollis` (the jacket to Mrs. Hollis, or to Cody) | `broke_faith_hollis` |
| Ezra | `ezra_satisfied` (the shells, week one); `kept_ezra_shells` (Thanksgiving) | — (his real moment is February) |
| Ruth | `door_ruth_1` and `door_ruth_2` count as kept too | `broke_faith_ruth`, `lied_to_ruth` |
| Sam | `door_sam_1`; `told_sam_daniel` | `broke_faith_sam` |
| Olstad | `showed_olstad_ticket`; `told_olstad_daniel` | `tried_to_run` (costs her trust; not closed) |

  `tried_to_run` is the one in-between: it doesn't close Olstad, it takes
  one kept moment away.

### 2. Closeness: the doors, per romance (Ruth, Sam, Daniel)

- **Conditions:** `doors:sam>=2`. **Effect:** `door=sam` (the next door).
  Counted from the `door_<who>_<n>` flags already in use; a broken faith
  closes the doors too.
- **Where everyone stands on December 1:** Ruth can have two (her name; the
  cellar). Sam one (his name), Daniel one ("There you are"). December holds
  **Sam's door 2** (the wall, KD19) and **Daniel's door 2** (the booth,
  KD22), so by New Year's Eve each of the three can reach two.

### 3. The town's eye

- One number, saved, never shown. **Effect:** `eye=+1` / `eye=-1`.
  **Condition:** `eye>=3`.
- It only moves in front of a watcher (`forks.md`): Ezra, Olstad, the
  Gleaner, the night radio. So `eye=` is only ever written on a line where one
  of them is in the room. `check_story` can't enforce that; the docs can.
- **Lean: seeded once, on December 1,** from what the town has already seen:
  walking out of church, speaking on the air (`said_on_air`), being seen
  with Sam at the potluck (Olstad's "two bachelors"), sitting in the empty
  place (`sat_in_place`), refusing the pie, trying to run, the window left
  open on nights the radio was on. Each +1, capped at 4, so nobody starts
  December already lost.
- **What it does in December:** small, so the player feels it before it
  bites. Who says good morning. Whether Mrs. Hollis brings a dish. At 3+, a
  note under the door on KD21 (*"We see your light."*). From January it
  starts to cost things (`season.md`).

---

## Key day 18, Wednesday December 1: the envelope at dawn

A counter day, with a dawn before it.

**Dawn.** MC wakes at six in the dark (the furnace ticking, or the cold).
Downstairs, through the glass of the front door: boots on the step, and the
envelope coming under the door. MC goes to the door. Through the glass,
bending, straightening: **Ezra.** He sees MC see him. Neither moves. Then he
touches his hat and goes down the step into the dark.
- Management is the congregation (`forks.md`, settled). Nobody says it.
- In the envelope: a hundred and fifty, faced. And for the first time, the
  money order isn't for the shop, it's for **0527**, postmarked **Kettle
  Lake** (Anchorage in October, Wasilla in November, here now). Whoever
  it's for has come closer. **Paid here:** the money orders.

**1. Olstad: the car.** Northern Lights has written to her; the rental's
reported stolen. She stands at the counter with the letter.
*"I could tow it. Or I could forget."*
- What decides it: whether you tried to run (`tried_to_run`), what you did
  with the rental letter (`rental_letter`, `rental_call`), and kept faith
  with her.
- **The choice:** ask her to forget (she does if faith with her is kept:
  `car_forgotten`; otherwise she can't), let her tow it (`car_towed`: no
  car until April), or **show her the letter, signed "John"** (the truth, a
  kept moment: she forgets, and she knows something now).
- **Paid here:** the rental deadline (`review.md` 4.1).

**2. Mrs. Hollis**, with the first Advent candle for the window. *"One a
week, dear. Till he comes."* She doesn't say who. Reads the Thanksgiving
place: the duck call (*"I heard it, Friday night. On the lake."*), the
jacket (*"It's back on the hook. It's warmer in the house."*), or the bare
place.

**3. The man in the good coat, passing.** He doesn't come in. He stands at
the window, reading the shelves through the glass, the way you'd read a menu.
Then he writes something in a small book, and goes on to the Gleaner. If
MC sold him Ezra's shells: Ezra is with him, carrying the box.

**Night 18.** The radio: him, hosting the morning repeat now, the Reverend's
voice only reading the notices. **Out of place:** the front-door mat moved
an inch, square to the door, as if someone had stood on it a long time.

## Key day 19, Saturday December 4: Sam's wall (his door 2)

A counter day, then a **walked evening** (`visit.tscn`: the cabin inside).

**The counter.** Ruth, at the counter in daylight: she brings back
MC's glass from the Gleaner (*"You left it. You never leave it."*). If she
has the keys (`ruth_has_keys`), they're on her ring; you see them. Then June,
with Christmas: the school wants the shop's window for the nativity (the
window as a custom; leaving it MC's own costs the eye).

**The evening, with Sam's doors open** (`doors:sam>=1`, not broken): the
cabin, the curtains drawn. The six envelopes on the table, all unopened, one
every September since 1993: *"You're sitting in my chair."* Then the wall:
string, pins, the clock's minute, the collection totals, the hymn numbers, a
decade of Keepers.
- **Door 2, his secret:** MC adds a pin. Which pin is the choice: the
  money order's postmark, the face at the door at dawn (Ezra), or Daniel's
  bullet (`door=sam`).
- **Groundwork for his lie** (March): *"I never touch the clock. Nobody
  does. That's the point of it."*
- **Paid here:** crossing out "John" for him (`sam_crossed`: MC's line on the
  wall has the real name, or "John" in quotes); the human eyes in the jar
  (`seen_human_eyes`: the 1989 Keeper's were brown; it's on the wall, with a
  question mark).
- **Without his doors:** the cabin from the road. A light behind the
  curtain, and a figure at the wall, pinning something, very carefully.

**Night 19: the frozen latch** (`nights.md` 7). One window frozen open; it
won't shut. Rule one broken whatever you do, unless you remember the tape in
the fuse box (the shop's hall, downstairs, in the dark).

## Key day 20, Sunday December 12: the Reverend (hard fork 4)

A walk-around day: the church, the vestry, the shop at night.

**The setup** (the bridge before: Daniel and Ezra at the Gleaner's back
table every night; a hymn number missing from the board). **Daniel has told
Ezra one true thing:** the Reverend helped the Keepers. On the night radio,
between the hymns, a hint, every year. *He never lies; that's what makes it
work.* If Ezra had doubts (`ezra_doubts`), he has them in the pew, and
then he doesn't.

**The service.** Daniel reads the lesson: Leviticus 16 again, the second
goat. After the blessing, nobody leaves. Ezra shuts the doors. The Reverend
(Elias) stands in the pulpit with his hands on the rail and understands.
- **Paid here:** speaking on the air (`said_on_air`): *"You were on the
  radio, the Keeper. Was he helping you too?"* Every face turns. MC can say
  no (a lie, in church) or nothing.
- The teeth jar: Ezra asks for it today, for the vestry. They're counting
  their children.

**The Reverend's car won't start** (the bridge has Daniel looking under the
hood of it on Wednesday, "helping").

**The fork,** at dusk, when MC finds Elias in the vestry, packing a single
bag, or the bag finds MC (left at the shop's back door: rule one):
- **Warn him** (`reverend_warned`): tell him tonight, now; walk him to the
  town line in the dark, or give him the car if it's still MC's
  (`!car_towed`, `!ruth_has_keys`). He gets out. In January, once, on the
  night radio, a hint between hymns in a voice from far away.
- **Hide him** (`reverend_hidden`): the back room (behind the steel door,
  by the freezer: grim), or Sam's cabin (`faith:sam`). The town's eye +2;
  Ezra knows by Christmas. In January he has to be moved, and somebody sees.
- **Stay out of it** (`reverend_gone`): Monday, the manse empty, the car
  still in the drive. Nobody says where he went. In the next envelope, with
  the money: **his collar**, folded, with a ticket stub. For the shop.
- **Daniel knows, whichever.** He says nothing. He never lies; he just
  doesn't speak.

**Night 20.** No Reverend on the radio. Him, alone, at the microphone, for
the first time at night: *"The Reverend has gone to rest. I'll sit with you
now."* If hidden: through the floor, from the back room, a man praying, very
quietly, the same words.

## Key day 21, Tuesday December 21: the shortest day

A counter day, short (light 10:15 to 15:33), then the shop after closing.

**The counter.** Few come. Mrs. Hollis with the third candle. A note under
the door if the eye is high (*"We see your light."*). Olstad, eight months
on, sitting down in the customer chair because she has to: *"Abraham kept
the freezer padlocked. Mine. I've got the only key."* (`season.md`: the
padlock is hers.)

**After closing: the freezer.** The furnace has run hot all month (or been
fed for you; `nights.md` note two).
- **The key** (a stand-in until shop step 8): the bear's second seam, its
  stitching new, and inside, a key on a red tag. Or Olstad's, if she gave
  it (kept faith).
- **Paid here:** listening at the freezer (`listened_freezer`: it's
  quieter than it was in October); the calendar circled October 4.
- **The freezer opens.** Abraham on a crate, coat buttoned, frost on his
  eyebrows, as if he'd sat down to wait for someone. Two explanations: an
  old man who believed it; the shop that took him.
- **Kept faith, Ruth** (`forks.md`):
  - **Tell her, and take her to the freezer** (`keep=ruth`): the cruellest
    kind thing in the game. She stands a long time. She takes his scarf.
  - **Tell Olstad** (she already knows; she says so: *"I closed that door on
    October fourth. I've been closing it every day since."*).
  - **Close it, and lock it again.** Ruth will find out; Daniel never lies.

**Night 21: the power cut** (`nights.md` 7). The longest night; at eleven the
radio dies, the neon dies, the freezer's hum stops. The fuse box, in the
dark: which switch (the neon, the freezer, the upstairs room). Whatever MC
picks, the other two stay dark till morning.

## Key day 22, Friday December 24: Christmas Eve

A walk-around day. Where MC spends it depends on who's open to him.

- **With Daniel's first door** (`doors:daniel>=1`): a note under the door
  in a careful hand: *"The booth is open tonight. Nobody else is coming."*
  **Door 2, his secret:** the confession booth, roles reversed. He takes MC
  apart, gently, every lie as John until nothing of the costume's left; then
  his own count (*"Thirty-one. Thirty-two with John. You'd have been
  thirty-three."*) and his father's kitchen table. (`door=daniel`; or walk
  out of the booth, and he lets you.)
- **Mrs. Hollis's table:** three places and Ray's chair, and on Ray's chair,
  whatever went on the empty place at Thanksgiving. **Paid here:** the coat
  (`wore_coat`: it's hanging behind the kitchen door, finished, the hem done;
  `refused_fitting`: the same, and she says "it'll keep").
- **The Gleaner:** Ruth, the regulars, the wall of faces with tinsel on it.
  **Paid here:** your envelope (`took_envelope`): Ruth gives it back, empty,
  or the church does, with your face drawn in by hand.
- **The shop, alone,** and the radio: him, reading the Christmas story to the
  town. The shepherds; the census; *"because there was no room."*

**Night 22.** Midnight Mass on the radio. **Out of place:** a stocking on the
bedroom door handle. Inside: a tangerine, a candy cane, and a milk tooth
twisted in paper with a name on it. Not yours. Not anyone's you know.

## Key day 23, Friday December 31: New Year's Eve (hard fork 5)

A walk-around day: the shop, then wherever MC is at midnight.

**The day.** The town waiting, every radio on. The night radio counting
hours, not days, for the first time. Y2K on the Anchorage station: the banks,
the planes. In Kettle Lake nobody's talking about computers.

**The party** at the Gleaner from nine. Everyone, the Advent candles all
lit in the windows, the paper hats. Daniel isn't there.

**The fork: where MC is at midnight** (`forks.md`):
- **The Gleaner, with Ruth** (`doors:ruth>=2`, not broken).
- **The ice, with Sam,** at the tripod, the clock's minute (`doors:sam>=2`,
  not broken).
- **Alone at the shop** (always). The phone at midnight: *"Happy New Year,
  sweetheart."* With Daniel's two doors (`doors:daniel>=2`), MC can **speak
  first** (rule four, broken on purpose): the Daniel strand locks.
- **Locks the romance, or none** (`new_year_ruth`, `new_year_sam`,
  `new_year_daniel`, `new_year_alone`). The call comes in every branch: only
  alone hears it live; the others find it on the machine in the morning, or
  hear the phone ringing through the floor of the Gleaner, under the
  countdown.
- **Midnight, and nothing happens.** The lights don't go out. The ice doesn't
  move. The town, disappointed, cheering anyway, a beat late.
- **Paid here:** Locker 114, paid through tonight (`tin_opened`): MC has the
  key, and the car if it's still his. That's January 1's choice.

**Night 23**, after midnight. **Out of place:** the calendar on the wall
already turned to January, and every Saturday crossed out except one in
April.

## The bridges

- **Before KD19 (Thu–Fri):** the plow doesn't come. The Gleaner's back table:
  Daniel and Ezra, every night, heads together.
- **Before KD20 (Mon–Sat):** a hymn number missing from the board; the
  Reverend's car with its hood up and Daniel's sleeves rolled, "helping";
  the second Advent candle.
- **Before KD21 (Mon 13 – Mon 20):** per the fork: an empty pulpit and
  Daniel in it (gone); a pulpit with Ezra reading (warned); the back room's
  door, and a plate taken in twice a day (hidden). Forty below.
- **Before KD22 (Wed–Thu):** Christmas cards under the door, one from every
  house, unsigned; or none, if the eye is high.
- **Before KD23 (Sat 25 – Thu 30):** Christmas Day in a line or two (the
  shop shut, the radio carols); the money order for 0527 again, postmarked
  **"Kettle Lake"** and hand-delivered.
- **Into January (Sat 1):** the locker (drive to Anchorage, if the car and
  the key allow: `has_books`; or let it lapse), then "to be continued".

## What gets built

1. **Engine, first:** the counts (`faith:`, `faithless:`, `doors:`,
   `eye`; `keep=`, `betray=`, `door=`, `eye=`), the faith table from
   existing flags, the eye seeded once on December 1; `check_story` knows
   them. Tests (`test_counts.gd`).
2. **Engine, December:** `DAY_DATES` 18–23; KD19's walked evening; KD20,
   22, 23 as walk-arounds; visit rooms (the cabin inside, the vestry at
   dusk, the manse, the booth, the Gleaner by night, the ice at midnight);
   the freezer stand-in key; the power cut and the frozen latch.
3. **Story:** six key days, six nights, five bridges, the map's December
   evenings.
4. **Tests:** `test_december.gd`, a route per fork-4 branch and per fork-5
   branch.
5. Built in **three passes** (one PR each): the counts; KD18–20 (to fork 4);
   KD21–23 (to fork 5).

## Your calls

1. **The counts worked out from flags** (kept faith and doors), with only
   the eye stored, seeded on December 1 and capped at 4. Lean: yes.
2. **Fork 4's three outcomes:** warned (he gets out, a voice once in
   January); hidden (the back room or Sam's, eye +2, moved in January);
   gone (his collar comes to the shop in the envelope). Lean: yes.
3. **The freezer key as a stand-in** on December 21 (the bear's seam, or
   Olstad's key), with shop step 8 later. Lean: yes.
4. **Christmas Eve's booth needs Daniel's first door** ("There you are");
   the booth is his second. Lean: yes (`season.md` said two, but the booth
   is door two).
5. **New Year's Eve:** Ruth or Sam need two doors and no betrayal; Daniel
   locks only if MC speaks first on the midnight call. Lean: yes.
6. **The night disruptions:** the frozen latch on night 19, the power cut
   on night 21. Lean: yes.
7. **Three passes, three PRs** (counts; to fork 4; to fork 5). Lean: yes.
