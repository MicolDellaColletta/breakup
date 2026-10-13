# Breakup: April and the endings (plan)

Oct 13, written overnight. It follows `season.md` (April: the light comes
back; the night before; breakup) and **assumes the leans in `daniel_v7.md`
and `march.md`**. Where a call could go either way, the alternative is noted.
The endings are written last, once March is built, but their shape is needed
now so March points the right way.

---

## Calendar

| Key day | Date | What | Kind |
|---|---|---|---|
| 39 | Sun Apr 2 | **The light comes back.** The clocks spring forward; sunset at 20:46. The road opens. Run becomes possible. | Counter (Sunday, shut), then the map |
| 40 | Sat Apr 15 | **The collection.** The plate passed on Sunday; the town's price paid for MC. The last week begins. | Walk-around (the hall) |
| 41 | Fri Apr 21 | **The night before breakup.** The last night. The fire, if it's open, or the last ordinary night. The flashback's third piece. | The night (a long one) |
| 42 | Sat Apr 22 | **Breakup.** The ice goes out. The shore. The endings. | The shore, then the epilogue |

Breakup is Saturday, April 22, 2000, as on Abraham's calendar (the day not
crossed out), and Holy Saturday.

## KD39, Sun Apr 2: the light comes back

- **The clocks spring forward.** "The worst news in the game": the dark that
  hid MC is gone, and the town can see him at nine at night.
- **The road opens.** The radio says the pass is clear. Run is possible from
  today, but:
  - **The plate:** Olstad's choice in December. If she logged the car, it's
    stopped at the town line.
  - **The keys:** Ruth's. If she kept them, there's no car.
  - **Who MC leaves holding the shop's keys:** the town walks that person to
    the shore in his place.
- **Daniel, if refused at fork 6:** "It's a race." Today he starts it. The
  three ways to beat him open, one per April key day.
- **Map evening:** every place has its last look.

## KD40, Sat Apr 15: the collection

- **The service.** The anxious bench. Then the plate goes round, the town's
  price for MC: money, rings, deeds, the weigh-in book's pages, and the
  children's teeth from the jars.
- **What the plate does** (the v6 open question, "what is the collection
  plate"). Lean: it's **the town buying MC from Daniel.** They know he wants
  MC. They're paying him to let go at the shore.
  - **Will he take it?** That decides his outcome at the shore (see below).
  - **If MC said yes at fork 6,** he takes the plate and laughs, because he
    already has what he wants and now he has their money too.
- **The three ways to beat him** (v7 section 7), each with its own scene:

  | Way | What it needs | What it costs |
  |---|---|---|
  | **Olstad takes him** | Olstad's faith kept (told her the John night), plus the 1988 file (March) or the deed. She arrests him on the hall steps. | MC's own freedom: MC is the witness. She looks away at the town line only if MC also kept faith with her twice. |
  | **The town turns on him** | His files from his room (March), shown to the congregation, in the hall. | The town does to him what it did to the Reverend, and MC watches. The eye goes to its maximum: they turn on MC next. |
  | **The gun** | John's gun, six rounds (March). In the counsel room. | MC becomes a man who did it. The background changes: Guilt, whatever it was before. |

  **Lean:** one attempt only. If it fails, he's on the shore.

## KD41, Fri Apr 21: the night before breakup

- **The shop at night, one last walk:** every find, every room.
- **The fire is open** if all of these hold:
  - no romance locked;
  - Daniel beaten (one of the three ways);
  - four of six people kept faith with;
  - someone who lets MC go (Olstad looking away, or Ruth giving back the
    keys).
  
  If it's open, MC can burn the ledger, the freezer and the bear (the
  choice is MC's: start it, or don't).
- **The flashback's third piece:** the preacher turns. The face fits the
  background and the strongest voice (v7 section 9).
- **Ordinary otherwise:** the rules one last time, the dog, the phone.

## KD42, Sat Apr 22: breakup, and the endings

The ending reader goes through the forks in this order:

1. **Run, alone,** if MC got out before dawn (the road open, the car, the
   plate). Epilogue: the highway south.
2. **Escape with someone** (Run with Ruth, Sam or Cody). Needs their doors at
   three, plus a way out. **Each has a catch:**
   - **With Ruth:** the town walks someone else to the shore in MC's place
     (whoever holds the keys), and Ruth knows who.
   - **With Sam:** in the motel in Anchorage, Sam starts a new wall. MC's
     name is the first pin.
   - **With Cody:** Ray's boy, through the ice in May, found, and Cody stays
     to bury him. MC drives on alone after all.
3. **Go with him** (the Daniel ending). Needs "yes" at fork 6 and his doors
   at two or more, or the confession and the doors.
   - **What happens:** he gives the town to the ice. The congregation walks
     out singing, and the two men drive south.
   - **The epilogue:** a new town, a new tent, a new name, and MC handing out
     hymnals at the door. He says MC's real name, the only time it's ever
     heard; the boy's name, from the lake.
   - **The variant, into the ice together,** if ??? is strongest: he doesn't
     stop at the shore.
4. **The fire** (escape alone, the true one): set the night before. Morning,
   the highway south, the wipers. Was any of it real?
5. **The season ends** (the default): the town walks MC to the shore. Daniel
   is there and lets go, with exact change in MC's palm, "for the ferry". He
   is bored.
   - **The ice** (its variant): ??? strongest and frayed. MC walks out and
     meets what's under it.

**Olstad** is on the shore in every ending where MC is.

## What the counts decide (to check against what's built)

The review (`review_full.md`, part 1) found the counts may be thin. Before
writing the endings, check that each requirement can actually be met:

- **Four of six kept faith:**
  - **what's built:** Walt 2, Hollis 1, Ezra 2, Ruth 2, Sam 2, Olstad 6.
  - **reachable?** Yes, but only on a careful path.
  - **Lean:** lower it to **three of six**, or add one kept moment each for
    Hollis and Ruth in March.
- **Doors:** Ruth 3, Sam 3 and Daniel 3 should each be reachable by
  March's end. Daniel has only 1 `door=` in the story so far; v7's "let in"
  offers in March (the files, the collection) should carry his doors 2 and 3.

## What gets built

1. **The ending reader** (`GameState.ending()`, read in the order above),
   with a test per ending.
2. **Key days 39–42,** the shore scene, and the epilogues (one per ending).
3. **The fire** as a playable night.
4. **The three ways to beat him.**

## Your calls

1. **Breakup is Sat Apr 22** (Abraham's calendar). Lean: yes.
2. **The collection plate is the town buying MC from Daniel.** Lean: yes.
3. **Three ways to beat him,** one attempt only. Lean: yes.
4. **Escape with someone:** a catch for each (Ruth, Sam, Cody). Lean: yes.
5. **The Daniel ending's epilogue:** the new tent, the hymnals, his real name
   said once. Lean: yes.
6. **Lower "four of six kept faith" to three**, or add kept moments in March.
   Lean: add the moments, keep four.
7. **Write the endings last,** after March is built. Lean: yes.
