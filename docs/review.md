# Review, October 13

A full pass over the game as it plays now (the drive to November 23, the shop
through step 3) and the docs. Four parts: bugs, story, systems, writing.
Nothing here is fixed yet; this is the list to work from. "Your call" marks
the ones that need a decision before anyone touches them.

**The short version.** The story holds up: Daniel's arrival, the double hour,
the calls, Olstad's "Who's John?", the cellar, the payphone all work. What
doesn't: a lot of choices are written down and never come back (27 flags,
4 pocket items, 5 shop objects); the totals the docs promise (faith,
closeness, the town's eye) are only a handful of flags; every night is the
same eight clicks; from day four the shop is mostly talk; and the narrator
explains far too much.

---

## 1. Bugs (fix first)

1. **Skipping a nightly rule is free; refusing it is punished.** The bed is
   always clickable, so never clicking the radio or the bowl breaks nothing,
   while "Leave it" breaks a rule. Doing nothing is always best.
   (`spots.cfg` bed, `night.gd:121-129`)
2. **The colored choices never appear.** The only one (`day_one.txt:57`,
   [John]) needs John at 3, which nobody can have on day one. There are no
   ??? choices at all. The whole colored-choice system never fires.
3. **Loading during a fade can jump to the wrong scene.** The transition
   timer keeps running while the menu is open (`transition.gd:30`); loading
   in the last second of a night overwrites the autosave and starts the next
   day. Block the menu during transitions.
4. **Save labels show the wrong date on key days** (the checkpoint is taken
   before `start_day()` moves the clock: "Oct 18" for Oct 23).
5. **A customer without `_given_other` / `_nothing` would freeze the counter**
   (all current ones have both; `check_story` should enforce it).
6. **Examining a detail clears the customer's conversation** from the log
   (`counter.gd`, `start_conversation` on a detail).
7. **The bell's label can lie** on day three (who comes depends on the
   window, decided when it rings; the label is decided earlier).
8. **A customer's picture can vanish** if the next comes in under 0.5s.
9. **New Game overwrites the autosave without asking.**
10. **Pawn loans can take cash below zero**; one line says "out of the
    drawer" with the drawer empty (`day_three.txt:395`).
11. **Map buttons don't move** when fullscreen is toggled (`map.gd:77-79`).
12. **Unreachable section:** `day_seven.txt` `opening` (the 09:00 "You turn
    the sign. OPEN.") never plays; `morning` has no `-> opening`.
13. **The end of what's written loops.** After the last bridge the title
    comes back, and Continue replays "to be continued" forever. Needs an end
    screen and an autosave that doesn't loop.

## 2. Story: contradictions in the text (must fix)

1. **Cody alive after he drowned.** `day_ten.txt:86-90` plays for anyone who
   didn't give the picks back, including players whose Cody drowned on day
   two: "Cody's not been home two nights. He does that." Needs its own
   grieving line on `!sold:ice_picks`.
2. **Cody gives advice he never gave.** `evening_ten.txt:89` "Cody said not
   to", ungated; only true on `flag:gave_picks_back`.
3. **MC knows where Abraham is too early.** `town.txt:142` (Warmth): "You know
   exactly where he is." Nothing has told MC. Make it a suspicion.
4. **The plain explanation removed.** `day_fifteen.txt:47`: "Not warm from
   his pocket." That rules out the human reading the rule of two needs.
5. **Sam's wall set up three ways.** Day 15 has Sam "start the wall" and MC
   never having heard of it; Ruth already described it (`town.txt:652`); the
   docs make it ten years old. Make it "It's time you saw the wall."
6. **The impossible train.** `day_eleven.txt:120`: Sam says MC told him about
   the train before MC has heard it (`night_ten.txt:109`). Fix, or make it the
   blur on purpose (gate on fray).
7. **Ruth's facts drift:** Daniel takes "Dad's old room" over the Gleaner
   (Abraham lived over the shop) four lines after "the room nobody rents";
   "two weeks in advance" vs "for the week"; Abraham leaving "every September
   since I can remember" vs only after 1989; the shoebox lid 1989-1998 with a
   letter from last month.
8. **Smaller ones:** the millennium countdown ends Dec 31 one day and Jan 1
   the next (`bridges.txt:82`: make it sixty); "no train for a hundred miles"
   with Wasilla an hour away; who locked the shop on Ezra's two September
   Thursdays while Abraham was in town; Thomas went under in April, so by the
   town's own rule he'd have come back in May (say not all of them do).

## 3. Docs that disagree (decided Oct 13, see `decisions.md`)

All seven decided and done: 1, 2 and 5 as proposed (the docs now say "a
polite stranger face to face; calls, never speaks on one; the payphone is the
last call"); 3, the six extra "sweetheart"s cut; 4, the docs moved to the
double hour; 6 and 7 settled by a bigger decision: **MC is a man**, and it
can be said, so the Keeper's "he" is about him and "sir" stays.

(The original list, for the record:)

1. **Does Daniel talk to MC before New Year's Eve?** The pillars say never;
   `forks.md`, `november.md` and day 15 have him speak as a polite stranger.
   Proposed: "never on the phone, never about the John night".
2. **Does Daniel call?** Docs say he never calls until New Year's Eve; the
   silent calls are his whole presence. Proposed: "never speaks on a call".
3. **"Sweetheart."** The bible keeps ??? to the prologue's four uses (plus
   night three, approved). The text has six more (nights 4, 5, 7, 8, 13, day
   15). Each one spends the New Year's Eve payoff. Cut back, or approve.
4. **Hard fork 2** is on Halloween in one doc, Sunday in another, and built
   as Saturday's double hour. Update the docs.
5. **No call in Thanksgiving week** (`daniel.md`) vs the payphone call on
   Nov 23. Proposed: "no call after the payphone".
6. **The Keeper is "he"** in the rhyme ("in he goes") and on the radio
   ("whoever he is"). MC's gender is never stated. Intended (the town assumes)
   or not?
7. **"Sir"** from the rental clerk (`day_six.txt:45,61`). Allowed by the
   bible's letter, not by the strict reading.

## 4. Promises not kept (choices that never come back)

**The ten that matter most:**

1. **The rental deadline.** The company calls with Olstad standing there
   (day 6), the letter's in your pocket, "the rental's due" (day 11), and
   nothing happens.
2. **The money orders for 0527**, from Anchorage then Wasilla. In your
   pocket, changing nothing; the Wasilla one can't even be read.
3. **Locker 114**: John's books, "PAID THRU 12/31/99". One line of flavour.
4. **Telling Olstad or Sam about Daniel**, "There you are", refusing the
   bullet: the climactic choices of day 15, read by nothing yet (fine for a
   cliffhanger, but they must be read in Thanksgiving week).
5. **Taking your envelope off Ruth's wall.** Ruth and the church never
   notice.
6. **Breaking faith with Mrs. Hollis.** Ruth's version changes who comes;
   Hollis's does nothing.
7. **Keeping Cody's picks.** Only giving them back has consequences.
8. **Crossing out "John" for Sam.** Never acknowledged.
9. **The human eyes in the jar; listening at the freezer.** No follow-up.
10. **Walt's wife's silver dollars.** Pawned the first morning; Walt comes
    back and never mentions them. Same tier: speaking on air at church,
    skating over (or reporting) the thing under the ice.

**The full lists.** Flags set and never read (27): `road_closed`,
`ezra_doubts`, `ruth_refused`, `broke_faith_hollis`, `sam_crossed`,
`daylight_call`, `rental_call`, `kept_picks`, `prayed_again`,
`walked_out_again`, `invited_ice`, `skated_over`, `showed_olstad_ice`,
`pageant_yes`, `sam_arrow`, `refused_fitting`, `refused_bullet`,
`there_you_are`, `daniel_in_town`, `told_olstad_daniel`, `told_sam_daniel`,
`listened_freezer`, `seen_human_eyes`, `said_on_air`, `saw_coat_close`,
`door_ruth_2`, `took_envelope`. Pocket items never used: `rental_letter`,
`money_order`, `money_order_wasilla`, `carbon_copies` (and `locker_key`,
`polaroid` barely). Shop objects that arrive and are never mentioned again:
`silver_dollars`, `braid`, `brass_button` (`sixth_bullet` is too new);
starting stock no story touches: `rifle`, `hand_mirror`, `pocket_watch`,
`tooth_jar`.

## 5. Systems: what's real, what's veneer

- **Real:** what you hand over on days 1-3 (it decides who comes until day
  10); Appraisal and Warmth lines; the background settling on night 7; fray.
- **Half-built:** properties and the catalogue (87 properties, nothing reads
  them yet: no `learn=`, no `knows:` in any story); close-ups only open while
  someone's waiting, so five moments, all days 1-3; **no handing over at all
  on days 4-15**; the window matters on day 3 only; the back room is
  look-only.
- **Veneer:** cash (one $40 round to spend it on); the till (`till_short`
  never read: stealing has no consequence); map time (nothing checks the
  hour); pockets (uses change nothing); Animal (56 leans, read once, no
  background); `rules_broken` read twice.
- **Counts that are only flags:** faith (`faith_hollis`, `broke_faith_*`;
  nothing for Walt, Ezra, Olstad), closeness (`door_*`), the town's eye and
  places with hours (nothing).
- **The nights:** all fifteen are arrival, radio, bowl, windows, three lines
  of flavour, back door, bed, sometimes the phone, the 3 a.m. dog. About
  eight of each night's choices are the same four rules. What they affect:
  fray, a rule entry, that night's dog scene. Order doesn't matter; nothing
  builds up except fray. (To-do 4.)

## 6. Characters

- **Vanish:** Walt after Oct 12; the Reverend not at the counter since day 9
  (and fork 4 needs a relationship with him); Teague after day 3 (he's
  supposed to point at the bear's second seam in week three); Hanna and Ezra
  down to bridge lines.
- **Thin:** Ruth and Sam only on optional evenings; **Nov 6-20 is one bridge
  with no romance scene at all.**
- **Too pointed:** the dog points at Mrs. Hollis four times (her dog bowl,
  her hairpins, kneeling, the humming); the sleepwalking reading gets
  nothing. Hold one or two back until December.
- **Too fast:** the coat, Thomas in his coat, every child as the Keeper, the
  fitting, the pageant: the folk strand is readable in three weeks, and "none
  saw May" is said out loud on day two. The bible wants the player to realise
  slowly.

## 7. Groundwork missing for after November 23

- **Ruth's February lie:** she's never said the 1989 Keeper "ran"; her
  mother's death in 1989 and the bowl being her mother's are never
  mentioned; she hasn't asked about her father since day two.
- **Sam's March lie:** he's never said he doesn't touch the clock; the clock
  stopping at the same minute every spring never appears.
- **Olstad's duel:** no line yet about Sam; nothing has her watching Daniel
  and MC together.
- **Daniel's January line** ("something you did alone in November"): every
  November night is the same, so there's nothing to call back. The new
  nights (to-do 4) should give him one.
- **Thanksgiving:** the extra place set facing the lake isn't planted.

## 8. Writing

- **Density.** About 69k words. The first week is overwritten (day three
  4.5k; days 1, 2, 5 around 3k); later days are leaner and better. Longest
  runs with no choice: `day_twelve.txt:9-36` (490 words), `day_fifteen:32-48`,
  Sam in `town.txt:282-297`, `bridges.txt:38-53`, the Gleaner
  `town.txt:40-55`, `night_thirteen:22-34`, `day_five:59-72`, `drive:35-52`.
- **Over-explaining.** Paranoia decodes what the player just saw, again and
  again: the children dressed as the Keeper (`day_twelve:35`), the rules read
  on air (`night_two:28-29`), "the point of the rule" (`night_three:87`), "you
  realize", "which means", "that's the point". The narrator sets up a scare
  and explains it away (the coat on the hook, `apartment.txt`).
- **Repetition.** "Rule one." x26, "Rule five." x16, "Facing the door" x27,
  "You roll the sack shut." x11, "A soft click" x11; "as if" x111, "the way
  ..." x120; recycled images ("like a glass on a table so it won't make a
  sound" x3; "He doesn't sound grateful. He sounds like a man..." x2).
- **Voice balance.** Narration 2319 lines, Paranoia 539, Appraisal 69, ???
  42, Warmth 36, John and Animal 8 between them. Paranoia carries all the
  interpretation; John and Animal barely exist.
- **Already unreliable, and good** (the model for to-do 3): `day_eight:16-31`
  (Paranoia correcting a memory as it forms), `night_seven:128-171` (four
  flashbacks, "Or that's what you've decided happened"), `night_one:116-125`
  (the reflection), `night_nine:52` (the line in your own hand you don't
  remember writing), `bridges.txt:95` ("Forty-one days." He's lost his
  place).
- **A style note for the unreliable pass**, to agree before rewriting:
  1. The narrator reports; it never interprets. No "you realize", "which
     means", "that's the point". One "as if" a scene, at most.
  2. The uncanny gets the flattest sentence in the scene; the ordinary gets
     the over-attentive, slightly wrong detail.
  3. Paranoia never restates. It disagrees, misremembers, fixes on the wrong
     thing.
  4. The narrator can be wrong: small details drift between days (a count,
     a time, a shelf) and it never says so.
  5. End a line early. Don't explain a scare away; don't confirm it.
  6. Sentences that don't quite follow: the second clause slightly beside
     the first.
  7. Repeat with drift: the ritual stays terse, one detail changes.
  8. The town is polite, cheerful and beside the point. The dread is in the
     manners.
  9. Never name a feeling. Give the body, or an object.
  10. About 120 words between choices; no more than six narration lines in a
      row.
- **Before and after:**
  - `day_twelve:34-35`. Before: "Every one of them is dressed as the
    Keeper." / Paranoia: "Every one. Every child in Kettle Lake. They made
    the costumes from scraps." After: "Every one of them is dressed as the
    Keeper. Someone has taken real trouble over the hems." / Paranoia:
    "Count them."
  - `night_three:87`. Before: "You leave it. Anyone can come in. That's the
    rule. You're starting to understand that's the point of the rule." After:
    "You leave it. In the morning the mat by the door is straighter than you
    left it. Or you didn't leave it crooked. It's a good mat."

## 9. The screen

Easiest: keep the 1152x648 base and open the window at 1600x900 or
1920x1080, letting `canvas_items` scale everything. Raising the base itself
would mean redoing fixed sizes (fonts 16-30, map and title margins, menu and
HUD panels, the shelf view's pixel tabs and tags). On wider-than-16:9
screens the drawn art stretches, and the dialogue column needs a maximum
width. (To-do 2.)

---

## Proposed order

1. **Bugs** (section 1), with tests: a morning's work.
2. **Story contradictions** (section 2) and **your calls** (section 3).
3. **The wider screen** (to-do 2).
4. **Nights** (to-do 4), planned in a doc: rules that change, a cost for
   skipping, something distinctive for Daniel's January line.
5. **Real counts** (faith, closeness, the town's eye) and paying off the ten
   promises (section 4), as part of the shop steps and Thanksgiving week.
6. **The unreliable narration** style note (section 8), agreed, then a
   sample day.
7. Then the shop steps 4 onward, and the story past November 23.
