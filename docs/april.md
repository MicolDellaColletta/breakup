# Breakup: April and the endings (plan)

Oct 14. This replaces the Oct 13 sketch, whose seven calls you agreed. It's
the last month, so it's mostly endings. It follows `season.md` (April: the
light comes back; the night before; breakup), `daniel_v7.md` section 7 (four
ways out), `forks.md` (the endings table, v7) and what March sets
(`march.md`, "As built").

It's planned the way the other months were, with a lean on each call.

---

## What April has to land

- **Four ways out** (decided): go with him; let the town have MC; escape with
  someone; escape alone (the fire, the only true one, and the hardest).
- **Three ways to beat Daniel**, one attempt (decided): Olstad takes him; the
  town turns on him (his files); John's gun.
- **Promises still open** (`review_full.md`, "pays off later"):
  - the gun in the snow ("till May");
  - the bear's "other thing, if it comes to it";
  - Sam's notebooks;
  - the April number in the weigh-in book;
  - Ray Hollis's ring;
  - the photograph of the boy;
  - the town line and the plate;
  - Ruth and the keys;
  - the flashback's last piece (the face).

## Calendar: Holy Week

Breakup is **Saturday, April 22, 2000**, the day Abraham never crossed out.
It's Holy Saturday; Easter is the 23rd. The town won't say so. The player
might notice.

| Key day | Date | What | Kind |
|---|---|---|---|
| 39 | Sun Apr 2 | **The light comes back.** The clocks spring forward. The road opens. Olstad's question. If MC refused him: "It's a race." | Walk-around (the hall, the town line), then the map |
| 40 | Sat Apr 8 | **The race.** The last visitors at the counter. Each of the three ways to beat him is set up here or not at all. The keys, the ring, Sam's minute. | Counter, then the map |
| 41 | Sun Apr 16 | **Palm Sunday: the collection.** The plate goes round: the town buying MC from him. Then the attempt, if MC makes one. | Walk-around (the hall, the counsel room, the steps) |
| 42 | Fri Apr 21 | **Good Friday: the night before breakup.** The procession. The flashback's last piece. Then the last night: run, burn, or wait. | Counter (nobody comes), a walked evening, then the night |
| 43 | Sat Apr 22 | **Breakup.** The ice goes out. The shore. The ending. | The shore (or the road), then the epilogue |

Bridges between them: `bridge_into_april` (already there, without its
"continues" line), `bridge_early_april`, `bridge_holy_week`. The last one
carries the count to zero on the hall door.

## KD39, Sun Apr 2: the light comes back

- **Morning:** the clocks went forward in the night, and the town did it at
  the same minute. Sunset at 20:46. The dark that hid MC is gone: at nine at
  night the town can see him in his window. "The worst news in the game."
- **The hall:** the count on the door says 3. The anxious bench. He doesn't
  call anyone up. He reads the names of the past Keepers, all of them, from
  the ledger, slowly, and the hall says "Amen" after each one. The last name
  he reads is "John".
- **The road opens:** the radio says the pass is clear for the first time
  since December. **Run becomes possible**, from tonight. A new spot on the
  map shows the way out (the town line), and it only shows if MC has a car
  and keys:

  | MC has | Because |
  |---|---|
  | No car | `car_towed` (December), or `gave_reverend_car` |
  | No keys | `ruth_has_keys` (unless `keys_returned`) |
  | A car the line will stop | not `car_forgotten`: Olstad logged the plate in December |

  Driving to the line today is a **look, not an escape**. The cruiser is
  parked across it. Olstad, at the wheel, with the baby asleep in the back.
- **Olstad's question** (at the line):
  - **If she trusts MC** (her faith 2 or more): "When you go, go at night,
    and don't look at me. I won't be looking." That's someone who lets MC go.
  - **Otherwise:** "That car's in my book. You know that."
  - **Lean:** this is where the plate is settled, so Run knows what happens at
    the line.
- **If MC refused him at fork 6:** a note under the door in his hand, true to
  the word: "Friday the 21st, after dark, I'll come to the shop for you. If
  you're gone, I'll know which way. I always do. — D."
  - **If MC said yes:** the note says "Wait for me on the shore."
  - **If MC confessed:** "I know where you'll be."

## KD40, Sat Apr 8: the race

The counter, and the last people who come to it. Each visit sets up one way
out, or one way to beat him. **Lean:** nothing new is unlocked after today.
April 16 is when MC uses what he has.

- **Olstad.**
  - **If MC told her the John night and she has the 1988 file** (from Lund's
    notebook, the deed, or her own digging): "I've got enough. Nearly. I need
    you to sign it, and I need you on the steps of that hall on Sunday when I
    take him." **Sign** → the Olstad way is open (`olstad_case`).
  - **Its cost:** MC's real name goes in a statement. Lean: she keeps it out
    of the town's hearing, but it exists now, on paper, in Anchorage.
- **Ruth.**
  - **If she still has the keys and her doors are at 2 or more:** she puts
    them on the glass. "Take them. I'll set a place anyway."
  - **If her door is at 3:** "Take me with you." That's escape with
    someone, Ruth.
  - **If she's faithless:** she doesn't come. Her bar is shut.
- **Mrs. Hollis.** If MC has Ray's ring from Daniel's room: give it back, or
  don't (`keep=hollis`).
  - **Giving it back:** she puts it on her thumb, too big for every finger now.
    "He'll know I've got it back. Let him."
  - **This is the last kept moment of the season.**
- **Sam.**
  - **If he was forgiven at the tripod (door 3):** "The minute is 5:41 on
    the twenty-second. I'll be at the clock. Come and stand with me, or drive
    me out of here the night before. Either." That's escape with someone,
    Sam.
  - **If he wasn't forgiven:** he doesn't come.
  - **If he's in the cellar:** nobody comes for him unless MC goes on Sunday.
- **Cody.**
  - **If Cody is alive and MC kept faith over the picks:** "My mom says
    there's room in the truck if you want it. On the twenty-first. We're going
    to my aunt's in Fairbanks." That's escape with someone, Cody (Lean: the
    third companion, not a romance).
- **The bear.** If the bear's seam is known (`bear_known`), or MC found
  Abraham's bench notebook: that night's walk opens the seam a third time.
  - **What's inside:** the "other thing, if it comes to it" is a tin of
    paraffin and a box of kitchen matches, sewn in by Abraham in October.
    He'd planned the fire himself.
  - **Lean:** that's the fire's means, and the bear's payoff.

## KD41, Sun Apr 16: Palm Sunday, the collection

- **The hall,** palm fronds of spruce on every bench. Leviticus, the whole
  chapter. Then **the plate goes round.**
- **What goes on it:** money, rings, the deeds to three houses, the
  weigh-in book's pages, and the children's teeth from the jars, one tooth
  per child. The town is **buying MC from him.** They know he wants MC. They
  want the ice to have its Keeper. Will he take it?
  - **If MC said yes at fork 6:** he takes the plate, laughs, and pockets the
    deeds. He already has what he wants.
  - **If MC confessed:** he takes it, and hands the plate to MC to hold.
  - **If MC refused:** he takes it, and says nothing, and that's the
    worst.
- **The attempt** (lean: one only, and only one of these is offered; the
  first that's available, in the order below):

  | Way | Needs | What happens | Flag |
  |---|---|---|---|
  | **Olstad** | `olstad_case` (signed on KD40) and her faith 2 or more | On the hall steps, after the service. She says his name, three names, all of them. He holds his wrists out before she asks. "See you in court, Keeper. You'll be there." He goes quietly, smiling, in the back of the cruiser beside the baby seat. | `daniel_taken` |
  | **The town** | `took_files` (Lund's notebook) | MC walks up to the anxious bench uninvited and reads Martha Lund's page aloud, his handwriting and her flour bin. The hall goes quiet. Then Martha stands up. That night the lanterns go up the outside stairs of the Gleaner, the way they went down to Sam's cabin. He doesn't run. He never runs. | `daniel_given` |
  | **The gun** | `gun_six`, or `has_sixth_round` plus a hidden gun MC fetched back | The counsel room, after the queue. He sees it and smiles. "I wondered if you would." Five live rounds and the flattened one. | `daniel_shot` |

  - **If MC has more than one way:** the choice is MC's, at the start of the
    day ("Today you could…"). **Lean:** yes, MC chooses.
  - **If the gun's way fails:** the flattened sixth round comes round first.
    It can't fire. He laughs, takes the gun, and it's over: he's on the shore
    on the 22nd, and he knows MC tried.
  - **Lean:** the gun works only if MC loaded it himself (`has_sixth_round`,
    and MC chose where the flattened round went: a choice on KD40's night,
    "put it in the empty chamber" or "throw it in the lake"). If Daniel
    loaded it (`gun_six`), he put the flattened round where it would come
    round first. **He never lies, but he never said it would fire.**
  - **What the gun costs:** he dies in the counsel room. MC puts him in the
    shop's freezer, beside Abraham. The town never asks where the preacher
    went; the ice has its own ideas. The background becomes Guilt, whatever
    it was before. Lean: yes, it's this dark.
- **The hall cellar:** if Sam was given up, after the service MC can lift the
  hatch. The padlock key hangs on a nail beside it; nobody locks anything
  now. Letting him out → `freed_sam` (he goes back to his clock).

## KD42, Fri Apr 21: Good Friday, the night before breakup

- **The counter:** open, and nobody comes. At noon, the whole road walks
  past to the hall with the straw man on a pole, singing. The radio plays the
  clock ticking all day.
- **The walked evening:** the procession at dusk goes down to the shore,
  candles on the ice, along the path of holes, and back. MC walks with it,
  or watches from the shop step.
- **The flashback, the last piece:** the preacher in the water turns round,
  and the face is…
  - **Guilt** (or MC shot him): MC's own face, at seventeen, in a white
    shirt.
  - **Witness:** Daniel's, at thirty, laughing.
  - **Debt:** Daniel's, holding out the roll of bills again.
  - **Insanity** (or ??? strongest): nobody's. The shirt is empty, standing
    in the water on its own.
- **The last night:** the night scene, every room, one last time. What's
  possible:

  | Choice | Needs | Leads to |
  |---|---|---|
  | **Leave now** (the car, the back door) | a car, keys, the line clear (`car_forgotten` or Olstad looking away) | Run: alone, or with whoever's waiting at the car (Ruth, Sam or Cody, if their offer was taken) |
  | **Burn it** (the ledger, the freezer, the bear) | the fire is open (below), and the paraffin from the bear | The fire |
  | **Wait** | nothing | The shore in the morning |

  **The fire is open** when all of these hold:
  - no romance locked (not `new_year_ruth` or `new_year_sam` with their
    third doors);
  - Daniel beaten (`daniel_taken`, `daniel_given` or `daniel_shot`);
  - four of six kept faith with;
  - someone who lets MC go (Olstad looking away, or Ruth giving back the
    keys);
  - the paraffin.

- **If Daniel isn't beaten,** he comes, as his note said. At the back door,
  the door MC always leaves open. He doesn't come up. He sits at the bottom
  of the stairs all night, in the dark, and talks up to MC, quietly, about
  the lake, until it's light. If MC tries to leave, he's sitting in the car.

## KD43, Sat Apr 22: breakup

**The shore at dawn.** The whole town in a line along the shore, candles, the
straw man on his pole. Sam's clock on its tripod far out on grey ice. Olstad
at the end of the line, in uniform, the baby with her sister. The ice talks.

The ending reader goes in this order (lean):

1. **Run, alone** (MC drove off the night before, alone, and the fire wasn't
   set).
   - **If Daniel wasn't beaten:** the epilogue is a motel in Whitehorse, a
     knock, and exact change pushed under the door. He always knows.
   - **If he was:** whoever MC left holding the shop's keys is walked to the
     shore in his place. MC hears about it on a truck-stop radio in June.
2. **Escape with someone** (Run with a companion). Each has a catch:
   - **Ruth:** someone else is walked to the shore in MC's place, and Ruth
     knows who, and sets a place for them every night in the new kitchen.
   - **Sam:** in a motel in Anchorage, Sam starts a new wall. The first pin
     is MC's name, the real one, which Sam has worked out.
   - **Cody:** in May, Ray comes up through the ice off the point, and Cody
     goes back to bury him. MC drives on to Fairbanks alone after all.
3. **Go with him** (the Daniel ending). Needs:
   - "yes" at fork 6 that held (his doors at 2 or more), or the confession
     with his doors at 2 or more;
   - MC didn't run;
   - he wasn't beaten.

   What happens:
   - **At the shore** he takes MC's arm. Then he raises the other hand, and
     the town walks out onto the breaking ice along the path of holes,
     singing, because he told them to. He watches MC watch.
   - **The epilogue:** a new town in Montana in June, a white tent, and MC at
     the door handing out hymnals. He says MC's real name, the only time
     the game lets it be heard. It's the boy's name, from the lake.
   - ↳ ***Into the ice together*** (??? strongest): he doesn't stop at the
     shore. In May, Cody on the shore sees two men come back, still holding
     on.
4. **The fire** (escape alone, the true one): set the night before, with
   Abraham's paraffin. Morning, the highway south, John's car, the wipers.
   - **Olstad:** if she's the one who let MC go, the last thing MC sees is her
     cruiser at the town line, lights off.
   - **The radio** says nothing about Kettle Lake.
   - **His coat** smells of smoke, or doesn't.
5. **The season ends** (the default): the town walks MC to the shore.
   - **If Daniel wasn't beaten:** he's there. He lets go, with exact change in
     MC's palm, "for the ferry". He's bored.
   - **If he was:** Olstad tries to stop it and can't. One woman against a
     town.
   - ↳ ***The ice*** (??? strongest and frayed): MC walks out on his own, and
     meets what's under it.

**In every ending where MC is gone or dead, May:**
- the gun in the snowbank by the back door appears as the snow melts, if MC
  put it there in October (`gun_snow`);
- the bear's seam, open;
- Sam's clock still running on its tripod, sunk to the case.

## What the counts decide (checked against what's built)

**Kept faith** (keep moments in the story, plus the `FAITH` table):

| Person | What there is to keep |
|---|---|
| Walt | 2 |
| Hollis | the jacket, her hand (March), the ring (April) |
| Ezra | 2 |
| Ruth | the doors, the room (March), the keys |
| Sam | 2 |
| Olstad | 6 or more |

Four of six is reachable on a careful path. Lean: keep four of six.

**Doors:**
- **Daniel:** booth (Christmas), his one lie (March), and one more. Lean: "Come
  back, then" on day 28 becomes his door 1 (it's a lean-in), so three are
  reachable.
- **Ruth and Sam:** three each reachable by March's end.

## What gets built

1. **Engine:**
   - `DAY_DATES` 39–43.
   - **The ending reader:** `GameState.ending()`, returning `run_alone`,
     `run_with_ruth` / `_sam` / `_cody`, `daniel`, `daniel_ice`, `fire`,
     `season_ends` or `the_ice`, in the order above. A test for each.
   - **An ending scene:** the visit scene, plus an epilogue card, then the
     title. Run endings start on the road (the drive scene's car, at dawn,
     the wipers in reverse).
   - **The way out:** a map spot from KD39 (`way_out`); the night-42 "leave
     now" spot.
   - **The fire** as a playable night: three things to burn, in the order MC
     chooses.
2. **Story:** five key days, the nights of 39–42, the walked evening of 42,
   the shore, eight endings with their epilogues, and three bridges.
3. **Places:** the town line (`town_line_night`), the shore at breakup
   (`shore_breakup`), the shop burning (`shop_fire`), the highway at dawn
   (`highway`), the white tent in Montana (`tent`).
4. **Tests:** `test_april.gd` (each key day) and `test_endings.gd` (each
   ending, from a hand-set state).
5. **Docs:** `april.md` As built; `forks.md` and `pillars.md` endings brought up
   to date.

## Your calls

1. **Holy Week:** five key days (Apr 2, 8, 16, 21, 22). Breakup on Holy
   Saturday, never named. Lean: yes.
2. **Run opens on April 2,** but only as a look until the last night. The
   line settles the plate (Olstad's trust). Lean: yes.
3. **KD40 sets everything up:** Olstad's statement, Ruth's keys or her offer,
   the ring, Sam's minute, Cody's truck, the bear's paraffin. Nothing new
   after that. Lean: yes.
4. **The bear's "other thing"** is Abraham's paraffin and matches, the fire's
   means. Lean: yes.
5. **The collection** on Palm Sunday, and how he takes the plate depends on
   fork 6. Lean: yes.
6. **One attempt to beat him,** MC's choice when more than one way is open.
   Lean: yes.
7. **The gun's twist:**
   - if Daniel loaded it, the flattened round comes round first and won't
     fire ("he never said it would fire");
   - if MC loaded it, it works.
   - The night of KD40 asks where MC puts the round.

   Lean: yes.
8. **If the gun works, he dies,** and goes in the freezer beside Abraham;
   MC's background becomes Guilt. Lean: yes. Tell me if that's too far.
9. **Cody as the third companion** (not a romance; needs him alive and the
   picks kept). Lean: yes.
10. **The last face in the flashback** depends on the background (Insanity:
    an empty shirt standing in the water). Lean: yes.
11. **If he isn't beaten, he comes on Good Friday night:** he sits at the
    bottom of the stairs, talking up to MC till light, or he's sitting in the
    car. Lean: yes.
12. **The order the ending reader checks things:** run alone → with someone
    → Daniel → the fire → the season ends. **May lines** in every ending
    where MC is gone (the gun in the snow, the bear, the clock). Lean: yes.
13. **Daniel's door 1** is "Come back, then" (day 28), so three of his doors
    are reachable. Lean: yes.
14. **Build in two parts:** April's days first, then the endings and the
    ending reader, each its own PR. Lean: yes.
