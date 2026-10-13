# Breakup: December, revised (plan)

A review of December as built (`december.md`), and the rework. **Decided
Oct 13: all eight leans. Built** (see "As built" at the end).

## What's missing now

- **Daniel is absent for long stretches.** Dec 4 and Dec 21 barely have him;
  Dec 1 he's a face at the window. He's the month's engine and he's offstage.
- **The town stays too normal.** Candles, cards, a nativity. Everyone's kind.
  Nothing is *wrong* with them yet, so January has nothing to grow from.
- **The Reverend gets off lightly.** Warned, he escapes; hidden, he's moved
  in January. The first death the town commits should land.
- **Few objects.** A money order and a collar. The shop is the game; December
  should fill its shelves with what's happening in town.
- **No curve.** Each day is its own vignette. December should get steadily
  worse, week by week, until New Year's.

## The idea in one line

**He arrives as a guest and ends the month as the town's prophet, and the
town covers a killing for him.** *Midnight Mass*: the stranger who brings
miracles, the faithful who close ranks, the fire.

---

## The shape, revised

Four new key days (marked **new**), so ten in December. The road closes on
the night of the 12th and stays closed until the 2nd of January: no
coroner, no fire marshal, no state troopers but Olstad, no way out.

| Date | Key day | What happens | Daniel |
|---|---|---|---|
| Wed Dec 1 | 18 (counter) | The envelope at dawn (Ezra); the car (built) | He comes **in** now, and buys the shop's oldest Bible |
| Sat Dec 4 | 19 (counter + evening) | Sam's wall (built) | On the shore path, walking toward the cabin as MC leaves |
| **Mon Dec 6** | **new** (counter) | **The first miracle.** The town doctor's hands stop shaking | Pawns his father's pocket watch, stopped at nine |
| Sun Dec 12 | 20 (walk-around) | The Reverend exposed; the doors barred; the storm closes the road | Reads the lesson; tells the truth that kills him |
| **Wed Dec 15** | **new** (walked night) | **The church burns**, with the Reverend inside | In the crowd, with soot on his cuffs, singing |
| **Fri Dec 17** | **new** (counter) | **The ruling.** The doctor says the fire. Olstad doesn't believe it. **Hard fork 4** | Sits in the customer chair while Olstad asks you |
| Tue Dec 21 | 21 (counter) | The shortest day; the freezer (built) | At the counter with the red thread for your wrist |
| Fri Dec 24 | 22 (walk-around) | **Midnight Mass in the ruins** | Preaches from the burned altar; his door 2 in the ash |
| **Wed Dec 29** | **new** (counter) | **The road still shut; the store empty**; his flock brings food | Brings yours himself |
| Fri Dec 31 | 23 (walk-around) | New Year's Eve, hard fork 5 (built) | The phone at midnight (red) |

## How the town gets weirder: the ladder

One step a week, never explained, two explanations each.

1. **Week one (Dec 1-6): devotion.** The back table at the Gleaner. People
   start leaving their doors open at night, all of them, not just the
   Keeper (rule one, for everyone). The doctor's hands. The Gleaner's clocks
   all stop at nine, and Ruth doesn't wind them.
2. **Week two (Dec 7-12): the turn.** The hymn numbers stop. The
   children's rhyme grows a tenth line (*"ten, the old man, in he goes"*). The
   Reverend's car won't start. The doors barred.
3. **Week three (Dec 13-21): the fire.** Ash falls with the snow for two
   days; the snow on the road goes grey. **The red thread:** his flock ties
   a strand of red wool round the wrist (Leviticus: the scarlet thread on the
   scapegoat's horns). By the 21st most of the town wears one.
4. **Week four (Dec 22-31): the closing of ranks.** The road shut, the store
   empty, and his people bringing food door to door, to the ones with the
   thread first. People sleep in the church hall to be near him. Midnight
   Mass in the ruins. Nobody mentions the Reverend at all.

## The Reverend's death

- **The fork on the 12th stays** (warn him, hide him, stay out), **but it
  can't save him.** That night the storm closes the road.
  - **Warned:** he tries; the plow's stopped at the town line; he walks back
    in the dark. On the 15th he's at the church, praying.
  - **Hidden** (the back room, Sam's): on the 14th Daniel asks MC, at the
    counter, plainly: *"Is he in your back room?"* He never lies; he asks
    because he'll know if you do. **Tell him** (he thanks you; that night the
    Reverend's gone from the bench), or **lie** (Daniel smiles; the next
    morning the bench is empty anyway, and your back door, which is never
    locked, is open). Either way, the church on the 15th.
  - **Stayed out:** the manse, then the church.
- **The fire (Dec 15, a walked night).** MC wakes to the bell ringing on its
  own, and light on the ceiling. The church burning on the hill. The whole
  town in the snow in their nightclothes, watching, not helping, singing. The
  Reverend inside.
  - **What MC can do:** go round the back, to the vestry side door
    (`saw_vestry_door`: it's bolted from the outside, and the bolt is hot;
    on the path, a man's prints going away, and on the snow, a red thread),
    try the front doors (`tried_church`: burned hands, the crowd pulling MC
    back, kindly), or stand with the town and sing (`sang_at_fire`, the eye
    down).
  - Daniel, in the crowd, his cuffs black with soot, singing louder than
    anyone. He catches MC's eye across the fire and looks sorry, truly.
- **The ruling (Dec 17).** With the road shut there's no coroner. **The town
  doctor, Dr. Brekke**, whose hands stopped shaking on the 6th, writes it
  out: an old man asleep in the vestry; the stove; smoke, then fire. Olstad,
  eight months pregnant, alone, doesn't believe a word of it.
- **Hard fork 4 becomes complicity.** At the counter, with Daniel in the
  customer chair, Olstad asks MC what he saw.
  - **Tell her the truth** (the bolt, the prints, the thread, if MC saw them;
    or just "I don't believe it"): `keep=olstad`, her case begins; the eye
    +2; the flock stops bringing food to the shop.
  - **Say nothing:** Olstad looks at you the way she'll look at the town.
  - **Back the doctor** ("It was the stove"): Daniel nods. That evening, a
    red thread on your doorstep. **Wear it or don't**: wearing it, the eye
    goes to nothing and the town is warm to you again, and you are one of
    them (`wears_thread`).

## Daniel, every key day

He's in every key day from now on, even if only for a line.

| Day | Where |
|---|---|
| Dec 1 | Comes in, buys the shop's oldest Bible ("one with Leviticus in it"), asks about the bear |
| Dec 4 | On the shore path, walking toward Sam's as MC leaves; nods |
| Dec 6 | Pawns his father's watch, stopped at nine: *"What will you give me for this?"* again |
| Dec 12 | The lesson; the truth that kills |
| Dec 14 | (hidden) *"Is he in your back room?"* |
| Dec 15 | At the fire, singing, soot on his cuffs |
| Dec 17 | The customer chair, during Olstad's questions |
| Dec 21 | Brings the red thread to the counter; ties it on himself, or offers yours |
| Dec 24 | Midnight Mass in the ruins; door 2 in the ash |
| Dec 29 | Brings your groceries himself, when the store's empty |
| Dec 31 | The phone at midnight (red) |

## New objects

All on the shelves, all with properties (`props.gd`), most of them evidence:

- **The oldest Bible** (Dec 1, sold to him; it comes back on the 29th with
  Leviticus 16 cut out, clean, with a razor).
- **His father's watch** (Dec 6, pawned): stopped at nine. Wind it: it
  runs for a minute and stops at nine again.
- **The Reverend's spectacles** (Dec 17, brought in by Ezra with the other
  "church things" to be held "till we build again"): the lenses whole. Glass
  cracks in a fire that hot. Olstad wants them (Dec 29); so does Ezra.
- **The church bell's clapper**, black, and the **melted microphone** from
  the booth, in the same box.
- **The red thread** (Dec 17/21): a hank of red wool. Wear it or keep it.
- (The collar, as built, now comes in the Reverend's box.)

## New people

- **Dr. Brekke**, the town doctor for forty years. Delivered half of Kettle
  Lake. His hands have shaken since 1990. On the 6th, at the Gleaner, Daniel
  holds them for a minute, and they stop. He signs whatever he's asked to
  after that, and weeps when he does.

## The days in more detail (new ones)

**Mon Dec 6, the first miracle** (counter):
- Mrs. Hollis, breathless: the doctor's hands, at the Gleaner, last night.
  *"Still as a table."*
- Dr. Brekke himself, for nothing: to hold his hands out over the counter
  and show MC. A steady old man crying.
- Daniel, at closing: the watch, stopped at nine. Take it (rule two, it's
  warm), refuse (he winds it; it stops at nine), or ask him what it's worth
  to him (*"Everything I had at twelve."*).
- Night: the radio, his voice, a list of the sick in town, by name. Out of
  place: the alarm clock by the bed, stopped at nine.

**Wed Dec 15, the fire** (a walked night; rooms: the road, the church
burning, the vestry side door). See above.

**Fri Dec 17, the ruling** (counter):
- Ezra with the box of church things (the spectacles, the clapper, the
  microphone, the collar) to hold.
- Dr. Brekke, to say it to MC himself, because "the Keeper should hear it
  right."
- Olstad and Daniel: fork 4. Then the thread on the step, if MC backed the
  doctor.
- Sam, at closing, if his doors are open: *"Petrol. Under the vestry. I
  can smell it from the shore. Nobody else can, apparently."*

**Wed Dec 29, the road still shut** (counter):
- The store empty since the 26th. His flock going door to door with boxes.
  Who gets food first: the threaded.
- Daniel brings MC's box himself, and the Bible with Leviticus 16 cut out.
- Olstad, for the spectacles: give them (evidence; `keep=olstad`), or keep
  them. Ezra came for them yesterday too; if MC gave them to him, they're
  gone, and Olstad's case loses its best piece (`spectacles_to_church`).
- Night: his voice on the radio reading the names of the households that
  have been fed. MC's, or not.

## What changes in what's built

- **Dec 12:** the storm and the road closing; the three fork outcomes stay as
  choices but lead to the fire (no `reverend_warned` escape, no car south).
- **Dec 21:** the Reverend lines go (he's dead); the red thread added;
  Daniel at the counter.
- **Dec 24:** the booth burned; Christmas Eve becomes Midnight Mass in the
  ruins (candles in the snow, communion: Sam's note again, *"don't eat"*,
  if he warned you), with Daniel's door 2 in the ash after, on two chairs
  that survived the fire. Hollis table, the Gleaner, alone: still there,
  before midnight.
- **Dec 31:** the Anchorage trip waits for the road (Jan 2), and the locker's
  contents go to lost property for thirty days, so it's still possible.
- **January (not yet merged):** KD25's evening (the Reverend moved or taken)
  becomes **Olstad at the ruins**, a week after the baby, showing MC what
  she's found (the vestry bolt, kept in an evidence bag); the confession is
  now held in the Gleaner's back room (the booth burned). Small edits
  elsewhere.
- **Sam:** a hydrologist, not a doctor (fix the "I had a practice" line on
  his wall).

## Engine

- **The days renumber.** December grows by four, so January becomes key days
  28-30 (files and tables renamed; `day==N` in spots and the map updated).
  Mechanical, but it touches a lot; one pass, tested.
- **Rooms:** the church burning (night), the vestry side door, the ruins
  (by day, and at Midnight Mass), the Gleaner's back room.
- **Speaker:** Dr. Brekke.
- **Stock:** the Bible, the watch, the spectacles, the clapper, the
  microphone, the thread; and props for each.

## Your calls

1. **Four new key days** (Dec 6, 15, 17, 29), so December has ten, and
   January renumbers. Lean: yes.
2. **The Reverend always dies in the fire**; the fork on the 12th colours how
   he gets there, and **hard fork 4 moves to the 17th** as complicity: tell
   Olstad the truth, say nothing, or back the doctor (and the thread). Lean:
   yes.
3. **The road closed** Dec 12 to Jan 2 (no coroner; Olstad alone; Anchorage
   waits). Lean: yes.
4. **Dr. Brekke**, a new character: the town doctor, healed by Daniel on the
   6th, signs the ruling. Lean: yes (rather than making Sam a medical
   doctor; Sam stays the hydrologist who smells petrol).
5. **The red thread** as the flock's mark, worn by most of the town by the
   21st, offered to MC. Lean: yes.
6. **Midnight Mass in the ruins** replaces the booth on Christmas Eve, with
   Daniel's door 2 in the ash afterwards. Lean: yes.
7. **Daniel in every key day**, per the table. Lean: yes.
8. **Hold the January PR** and build this on top of it, so January's
   follow-ups are fixed in the same pass. Lean: yes.

## As built (Oct 13)

- **Renumbered:** December is key days 18-27, January 28-30 (files renamed
  to match); the bridge into February is before day 31.
- **New key days:** 20 (`day_twenty.txt`, Dec 6: the doctor's hands, the
  watch), 22 (`day_twentytwo.txt`, Dec 15: his question if the Reverend's
  hidden, then the fire, a walked night: `church_fire` and `vestry_door`),
  23 (`day_twentythree.txt`, Dec 17: Ezra's box, Brekke's ruling, Olstad
  with him in the chair: `told_olstad_fire` / `silent_on_fire` /
  `backed_doctor`, the thread on the step), 26 (`day_twentysix.txt`, Dec 29:
  the spectacles to Ezra or Olstad, the cut Bible, food for the threaded).
  Nights 20, 22, 23, 26 (the clock at nine, ash, the thread on the handle,
  the peaches).
- **Changed:** Dec 1 he comes in for the Bible; Dec 4 he passes on the shore
  path; Dec 12 the storm closes the road and turns every escape back
  (`road_turned_back`); Dec 21 the red thread (`wears_thread`,
  `refused_thread`); Dec 24 Midnight Mass in the ruins (communion:
  `took_communion` / `refused_communion`), Daniel's door 2 on the two chairs
  in the ash; Dec 31 Anchorage waits for the road. Bridges rewritten (the
  rhyme's tenth line, doors open, ash, the thread spreading, the hall
  sleepers, the store empty).
- **January:** the evening of day 29 is Olstad at the ruins with the bolt
  (`will_testify` / `wont_promise`); day 30's confession is in the church
  hall, in a booth of two doors and the two scorched chairs.
- **New:** Dr. Brekke (`brekke`); stock: `father_watch`, `bible_cut`,
  `spectacles`, `bell_clapper`, `microphone`; item `red_thread`; rooms
  `church_fire`, `vestry_door`, `ruins`; map evenings for days 20, 23, 26.
- **Tests:** `test_december.gd` (to the ruling), `test_december_late.gd`
  (the shortest day to New Year's), `test_january.gd`.
