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

- **Fixed (part 2): the gun in the dresser** had no way to be taken back on a night walk.
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

## Part 2

Done: see below.


---

# Full review, part 2: the read-through

Oct 13, overnight. Six readers went through every story file, month by month,
reading in full. Their findings are below, by month, with file:line.
Everything was checked against the files before anything was changed.

## What runs through all of it

1. **Daniel is soft everywhere.** About 70 lines from Thanksgiving to February
   read as kind, pastoral or grateful, and the narration softens him too
   ("genuinely grateful", "truly sorry", "his fingers warm"). In public
   he's gentle, never hellfire. The rewrite pass (v7) has its full list
   here, file by file.
2. **He says MC's real name** on day 28, and on the air on night 30. That
   breaks pillars ("knows it, never says it") and v7 (he says it at the end,
   or never). **Decision needed.**
3. **"He never lies," but he does:**
   - "The Reverend has gone to rest" (said while the Reverend is alive);
   - "Elias is with the Lord";
   - "None of us did" (on day 19, a lie under v7);
   - "a hunting accident".
   Each needs rewording to something true but misleading.
4. **Fake choices** in Daniel's big scenes. MC has no choice at all:
   - the Bible sale (day 18);
   - the groceries (day 26);
   - his first scene as himself (day 28);
   - Christmas Eve ("You sit.").
   On day 30, two of the three booth options set nothing.
5. **The clock and the text disagree** in about 15 places. A visit at `+120`
   lands at 14:00 while the text says "twenty to four". Several are fixed;
   the rest are listed.
6. **Lines written for one path** play on every path: night 5 assumes church,
   day 9 assumes the day-5 choices, night 2 assumes night 1, and the bowl is
   described after it's gone.
7. **The shop's lore contradicts itself:**
   - the bear (not in the ledger / 1959 / 1968);
   - the 1998 Keeper (A.K. vs Thomas);
   - Abraham's death (Oct 3 vs Oct 4);
   - rule 9 (two different cards);
   - Ruth's mother (three deaths);
   - the 1989 Keeper (J.W. vs David).
   **Decisions needed** (one canon each).
8. **Prose tics:** "the way you'd…" over 60 times, "as if" about 67 times in
   October alone, "unhurried" for Daniel 8 times. For the narration rewrite
   (`todo.md`, unreliable narration).
9. **Olstad's homophobia,** which pillars requires, never shows in October and
   November.
10. **Finds nothing reacts to:** Abraham's rules, the Keeper photo, the
    burned corner, Abraham's letter to Ruth, the bench notebook (March will
    take this one), the rule-9 card, the light under the locked door, the
    spruce sprig in the ram's horn.

## Fixed in this pass (on `full-review`)

- **Bugs:**
  - **The dog-feeding flags** were shared between nights after the
    renumbering (nights 20/21, 22/25, 23/27, 24/28, 25/29, 26/30). Feeding the
    dog one night changed what happened on a later one. Each night now has its
    own flag.
  - **Day 28's map evening** fell through to day two's (Ruth thanking MC "for
    today", the Reverend on the air after his death). It now has its own
    short evening for each place.
  - **The day 34 booth** ended the day before the weigh-in book could be
    seen. Going to the booth now passes the book first.
  - **Taking John's gun back from the dresser** wasn't possible on a night
    walk. Now it is (the bottom drawer, from night 11).
  - **`booth_left`** was never set. Leaving the booth on Christmas Eve and
    walking out on day 30 now set it.
  - **Returning Ruth's keys** didn't clear `ruth_has_keys`, so April's Run
    would still think she had them.
  - **The February weighing** reused October's `weighed` flag. It's
    `weighed_hall` now.
- **Voice:** Olstad's four lines on day 33 were written as narration in
  quotes. They're hers now (`trooper`).
- **Continuity:**
  - **The countdown** said nine weeks on Feb 5, which puts breakup around
    Apr 8. The calendar says Apr 22, so it's eleven, ten, nine and seven now.
  - **The clock against the text:** days 15, 28, 31 and 32 ("twenty to four",
    "three o'clock", "five o'clock"). Day 32's light is fixed too.
  - **Smaller slips:**
    - "a dead man's wall" was Sam's, who is alive;
    - "the church, every window lit" after it burned;
    - "dark at noon" on Dec 31;
    - the coat line on night 31 without the coat;
    - "the drive back" when MC has no car (he walks now).

## Decisions for you

See `docs/questions.md`, "From the review". They're the canon choices
(lore 7), the real name (2), what to do with the dead flags, and the design
holes the readers found:
- the ice party at thirty below in October;
- the town already knowing the lights are Sam's;
- the night-time lock choice that does nothing.

## By month

### October, the first week: days 1–7

Day 1 is Wed Oct 6; the prologue is Oct 5. The story files already use the
right dates.

**Bugs**

- **day_one:57:** the `[John]` choice needs john ≥ 3, but the widow is the
  first customer (john is at most 1 by then), so it never appears.
- **night_two:37:** `broke:dog` means "ever broken", so the line fires even
  if MC fed the dog last night.
- **Lines that assume a path the player may not have taken:**
  - night_two:96, 110, 171.
  - day_two:117 and day_four:144: the duck call assumed bought.
  - day_seven:49: the bread boy assumed.
- **night_one:81 and night_two:86:** the "No key…" lines can never show.
- **night_seven:88:** the jump sits above the choices. It works, but it reads
  like a jump placed mid-section.
- **day_three:69 and night_seven:92/114:** the shells are used after they may
  already be sold.

**Continuity**

- **Day three's clock:**
  - "At three the light starts to go", but sunset is 19:05.
  - The stranger walks out "into the dusk" at 14:45.
  - The boy skips rope at the bus stop at 10:15 on a school day.
- **The shop's lore contradicts itself:**
  - the bear: "not in the ledger" (shop_looks:29) vs 1959 (day_three:278,
    day_six:37) vs 1968 (night_walks:256, the bench notebook);
  - "A.K. 98" on the snowshoes vs Thomas as the 1998 Keeper;
  - the bench calendar circles October 4 vs October 3;
  - Teague's "the ram at the Gleaner": the ram is above the office desk;
  - the compass back on the shelf on day 6 after the Reverend gave it to MC.
- **The bowl** vanishes on day 5 if it wasn't fed on night 4, but day 7 and
  night 7 still describe it.
- **night_five** is written for the church path only (the hands, "this
  morning's hymn"), and says "three nights of silence" when it's two.
- **Smaller ones:**
  - night_six:86: "never rings on Mondays. You know that now", on the first
    Monday.
  - day_six:146: "everyone knocked twice", but Olstad stopped herself.
  - day_six:9: footprints "out the back… to the trees across the road",
    when the road is in front.
- **Cold too early:** fourteen below and the ice holding forty feet in early
  October.
- **Assumed knowledge:**
  - day_five:47, 81, 84: the Polaroid and the scrubbing.
  - day_four:206: Sam named before MC meets him.
  - night_five:77-78: Ruth "at eleven" has no source.
- **Small sums:** day_two:335 "three minutes" is two; night_four:158 church
  bells at 7:30 vs eight.

**Voice**

- **day_three:377:** Paranoia says "Cody. Day two." That's system language.
- **day_two:157:** frayed appraisal gives a confident wrong answer, which is
  ???'s job.
- **day_four:171:** "the same hand wrote them", about spoken words.
- **day_five:177:** knocking "so the bell won't ring". The door rings the
  bell, not the knock.
- **Repeats:**
  - "There. Was that so hard?" ×2;
  - "Tuesday. October twelfth. One week." ×2;
  - the shop_looks "yesterday it was…" lines replay unchanged every day.
- **Tics:** "as if" about 67 times, "the way you'd" 25, "That's all" 14.
- **night_seven:148:** "sweetheart" from Daniel, beyond pillars' limit
  (story.md allows it). Make the two docs agree.

**Choices**

- **day_two:89-90:** "Keep them" ends with the picks pawned anyway.
- **Same result either way:**
  - night_one:120-121: "Don't wave" and "Look away" go to the same place.
  - night_seven:91: `gun_snow` is never read.
- **Missing options:**
  - day_six:95-96: there's no asking Ezra what the tooth is for.
  - day_two:295: no "go up with her" for Ruth.

**Exploration**

- **night_four:26:** "the same words the ledger used" points at a ledger line
  that doesn't exist.
- **day_four:171:** the braid callback needs the jar of teeth examined at the
  right moment.
- **Set-ups with no payoff:**
  - `daylight_call`, `rental_call`;
  - "He's finding where the rules aren't";
  - the light under the locked door;
  - the spruce sprig in the ram's horn;
  - the two different handprints.
- **night_three:138-142:** no window lines for the knife, decoy or duck call,
  though Olstad reacts to them.

**Strongest:**

- the hymn numbers as the rules (night_two:22-28);
- the Ida chain;
- the laying on of hands (day_five:67-70).

**Weakest:**

- day three's clock;
- night five written for one path;
- the shop's contradictory lore.

### October and early November: days 8–14

`DAY_DATES` counts from Oct 5 = 0, so day 8 is Thu Oct 14. Every date,
weekday and sunset matches.

**Bugs**

- **day_thirteen:10:** `if=flag:ruth_has_keys` can never be true here (the flag
  is set that evening).
- **night_eleven:94, 98, 112-113:** redeeming the tin isn't gated on
  `has:pawn_ticket`, and the ticket is optional.
- **night_fourteen:119-121:** a comment sits in the middle of `morning_after`,
  and the pillow hair duplicates `odd_pillow`.
- **spots.cfg:1100-1122:** the `shop_sunday_*` spots include `day==9`, but
  their sections don't exist (harmless for now).

**Continuity**

- **The ice:** two inches on day 8 ("never thick enough"), then the whole town
  skates on day 10, at thirty below in October. It needs a cold-snap line, or
  the party should move.
- **day_eleven:126, 137-138:** Sam assumes the train call; the call was a week
  earlier.
- **night_ten:133:** the railroad doesn't run through Palmer.
- **night_ten:75:** the rule-9 card ("Don't let the furnace go out")
  contradicts `abraham_rules` ("If he comes back, give him what he asks for")
  and the rhyme.
- **night_twelve:57:** gated on `!tin_opened` instead of `lent_shirt`.
- **night_thirteen:11:** "six hours… fifteen more" adds up to 21 hours of
  dark.
- **night_thirteen:111 vs night_twelve:79:** the "first silence" was already
  a silence.
- **night_fourteen:88-89:** the wipers call plays as new, but the bridge
  already described it.
- **day_fourteen:17:** the button isn't gated.
- **day_fourteen:35:** Hanna's braid sewn into a hem while it's still on the
  back shelf (also town:642).
- **day_fourteen:56:** Mrs. Hollis knows about the Thanksgiving minister
  before the radio has announced it.
- **day_nine:** "fewer this time", "again" and "up a pound" assume the day 5
  choices.
- **evening_ten:** "Coat not returned" needs a path; the flashlight appears
  when there's no Sam.
- **day_eight:153, 84:** the radio is quoted before it airs; "three people"
  is two.
- **The countdown:** day_nine:31 counts to Dec 31, bridges:83 to Jan 1.

**Voice**

- **"The way you'd…"** ×17.
- **day_ten:125 = day_thirteen:71:** Hanna and June say the same line.
- **day_ten:33 / day_eleven:49:** Olstad picks up the compass twice, back to
  back.
- **Olstad's four scenes** show none of the homophobia pillars requires, and
  her dialect is down to "Ya."
- **day_twelve:8-36:** too dense, and the header promises things that aren't
  there.

**Choices**

- **day_ten:117-118:** `invited_ice` is never read.
- **day_twelve:** the Halloween choices set nothing.
- **Olstad's options** on days 10, 11 and 13 all go to the same place.
- **The phone on nights 8–10:** "Wait" and "Hang up first" differ only by a
  lean.
- **day_twelve:20-28:** Olstad reports the car stolen and MC has no reply. It's
  the most obvious missing option. There's also no skipping church on day 12.
- **night_eleven:31-32:** the only night without the bowl-to-the-back-door
  option.

**Exploration**

- **day_nine:65-69:** the coat under the sheet hides behind "The doorframe".
- **night_eight:34:** the bowl note appears once, and only at the kitchen.
- **night_ten:75-87:** the rule-9 card is behind an optional spot and dropped
  after one morning.
- **Flags never read:** `obeyed_note_lock`, `kept_letter_lock`, `sam_arrow`,
  `fed_furnace`.
- **night_twelve:21 vs 104:** the radio hint doesn't match the payoff.

**Strongest:**

- the hour that happens twice (night_eleven:90-160);
- the children dressed as the Keeper ("Are you the real one?");
- the shape under the clear ice while the children skate over it.

**Weakest:**

- day twelve (too compressed, no agency over the stolen car);
- night ten's rule 9;
- the continuity knots on day fourteen.

### Daniel arrives, Thanksgiving, early December: days 15–19

The weekdays and the light times all match. No format problems.

**Bugs**

- **day_fifteen:32:** `time=+240` puts the clock at 15:00, but the text says
  "twenty to four" (it needs about +280).
- **day_fifteen:103:** `cash=+1`, but he lays down $1.25.
- **night_seventeen:22,25:** these lines assume MC stood at the vestry glass.
  That spot is optional, so they need an `if=`.
- **night_seventeen:97 vs 102:** the foil ends up in the bowl and on the step
  at the same time.
- **night_nineteen:9:** "a dead man's wall". Sam is alive.
- **Stale headers:** night_fifteen:5 and night_seventeen:4 (the plate is in
  `main`, not downstairs).

**Continuity**

- **day_eighteen:36:** the car was "rented October fourth". The agreement says
  October 2.
- **day_eighteen:20 vs bridges:115:** MC is paid twice in one week.
- **day_nineteen:28:** Ruth's "twenty years". She bought the Gleaner in 1989.
- **day_eighteen:33** (and day_twentysix:10): "Ida's window at the store", a
  second Ida, when Ida is Walt's unsayable pawned name.
- **day_seventeen:178:** "the voice from the phone". He has never spoken on
  the phone.
- **day_seventeen:177 vs 193:** the Reverend is both at the table and in the
  booth.
- **day_eighteen:79 vs night_seventeen:57:** the duck call: "Friday night"
  vs Thursday.
- **He never lies, but here he might:**
  - day_sixteen:152: "a hunting accident… so I'd believe the lie". Fine only
    if it's literally true; make that intentional.
  - day_nineteen:30: "None of us did" is a lie under v7.
- **day_fifteen:151:** "It's time you saw the wall", but the wall needs
  `doors:sam>=1` and telling Sam gives no door.
- **night_nineteen:21:** "Tomorrow the lesson is mine" reads as a first time,
  but he read it Nov 28.
- **night_nineteen:106:** "next Sunday" vs "Tomorrow", and the bridge then
  describes a service MC skipped.
- **day_nineteen:20:** "You left it. Wednesday." MC wasn't at the Gleaner on
  Wednesday.
- **day_sixteen:124:** "two days in town". He arrived yesterday.
- **evening_nineteen:37 vs 40:** the envelopes are unopened, yet Sam knows
  what the 1993 one says.
- **day_sixteen:172:** "Not Tommy's" assumes `lent_shirt`.
- **night_fifteen:67 vs 133:** "glad" about the dog, last night or tonight?
- **day_eighteen:91:** the family Bible in the dresser is never seen in any
  dresser scene.

**Daniel, soft lines (v7 rewrite)**

day_fifteen:39 (narration), 43, 94, 100, 102, 104, 110-111 ("gently, almost
tenderly"; the line can stay, the narration should be predatory), 113, 120;
day_sixteen:110-111, 122; day_seventeen:179, 181 (narration), 185 (public, so
it should be hard); night_seventeen:23; night_eighteen:19; night_nineteen:20-21;
day_nineteen:30.

- **"Booth":** night_sixteen:22 and day_seventeen:192 mean the radio booth.
  Rename it before the rewrite.
- **Voice slips:**
  - night_sixteen:11: "You've never missed one" reads as MC; it means Ezra.
  - day_seventeen:195-196: "He doesn't turn round" reads as the Reverend.
- **Tics:**
  - "the way you'd…" ×14.
  - "unhurried" ×8.
  - "faced, square" ×6.
  - tooth similes ×3.
- **Repeats:**
  - day_nineteen:27-28 = bridges:122.
  - The envelopes are described twice (evening_nineteen:31,37).
- **Too much text:**
  - day_fifteen:32-47 is 15 lines before the first choice.
  - day_seventeen:9-23 is 14 lines of morning.

**Choices**

- **day_eighteen:89-93:** no choice at all. MC hands over his own Bible, with
  no "that one's not for sale".
- **night_nineteen:48:** taping the window costs nothing and breaks no rule,
  so the other two options are traps.
- **day_eighteen:42:** showing the rental letter gets both Olstad's faith and
  the car forgotten, with no cost.
- **day_fifteen:132-134:** there's no telling Ruth, and telling Sam gives no
  door.
- **day_seventeen:174-189:** MC is passive through the key broadcast.
- **night_sixteen:124:** "if you went down and picked it up…", but there's no
  option to.

**Exploration**

- **spots.cfg:1268/1284/1292:** the pie, Olstad and Daniel spots vanish when
  the pageant starts, so Sam's "don't eat the pie", Olstad's "two bachelors"
  (a pillar beat) and the salt are all missable.
- **day_seventeen:143:** Mrs. Hollis writes on the foil, and it's never
  readable.
- **evening_nineteen:22,109:** Daniel walks toward Sam's cabin, and nobody
  picks it up.
- **night_seventeen:70-73:** the back door teases the plate, but the plate
  spot is in another room.
- **evening_nineteen:** "Go home" is there at once, so the wall (Sam's second
  door) can be skipped by accident.
- **day_fifteen:12:** the notebook's "Today." is never paid off.

**Strongest:**

- the payphone, with the bell on the line and then through the window
  (night_fifteen:105-115);
- the pageant blackout with the applause going on in the dark;
- the bare square on Sam's wall.

**Weakest:**

- the Bible sale on day 18 (no choice, polite Daniel);
- nights 16, 18 and 19 run the same loop;
- Ruth on day 19 (repeats the bridge, wrong years, carries the lie).

### December: days 20–25

The weekdays all match `DAY_DATES`, and the light times on day 24 match canon.
No jumps sit in the middle of a section, and there are no typos.

**Bugs**

- **The dog-feeding flags collide after the renumbering, and they persist**
  (none of them is in `TONIGHT_FLAGS`):
  - night 21 reuses `fed_twenty`.
  - night 25 reuses `fed_twentytwo`.
  - nights 23 and 27 share `fed_twentythree`.
  - Feeding the dog on the earlier night brings the stairs later even with
    the bowl left empty.
- **night_twentyfive:11** reads `booth_left`, which is only set in January,
  so it can never fire in December. Leaving the booth (day_twentyfive:141,
  `booth_leave`) sets nothing.
- **day_twentyone:131:** the "Walk home" spot duplicates the "Say nothing. Walk
  home." choice at :86.

**Continuity**

- **The clock and the text disagree.**
  - day_twenty:31,45: the visits at +120 each put the clock at about 2 PM, but
    the text says "twenty to four".
  - day_twentythree:117: Sam comes "at closing" at about 14:00.
- **day_twenty:22 vs :35:** Brekke's hands shook "thirty years", yet he
  stopped delivering babies in 1990 (nine years).
- **night_twenty:67:** the bedside clock ticks after `odd_clock` showed it
  stopped at nine.
- **day_twentyone:67-70:** the car with its hood up repeats
  bridge_second_week almost word for word.
- **day_twentyone:103→137:** the car branch's midnight knock, then
  `walk_home` at 18:00.
- **day_twentyone:123:** "three men go in, two come out" is wrong. It was two
  in and one out.
- **day 22:** Olstad is absent from the fire.
- **night_twentythree:23:** the radio says Ezra carried the transmitter out
  with burned hands. On day 22 nobody moves, and on day 23 Ezra has no burns.
- **day_twentythree:41:** "sleeping in the vestry since the trouble" clashes
  with the manse paths.
- **The threads and the ash disagree.**
  - Threads on "every wrist" Friday vs the bridges (the first thread Thursday,
    half the town by Saturday).
  - The ash: "two days" (day 23) vs "four days" (day 24).
- **day_twentythree:118:** "Sam in the shop for the first time" is wrong. He
  came on days 4, 11, 13 and 16.
- **day_twentythree:120:** "three days later" is about 36 hours.
- **day_twentythree:14 vs night_twentythree:104:** Mrs. Hollis found the gun
  under the pillow, then "she was never in the bedroom".
- **day_twentythree:144:** "your bandaged hand" appears even without
  `tried_church`.
- **day_twentyfour:31:** "one more Sunday and then Christmas" is impossible on
  Tue Dec 21. The Advent candles are off too.
- **day_twentyfour:98:** "the fourth circled". Canon is October 3.
- **day_twentyfive:13:** the envelope comes "from the Gleaner", but it's the
  congregation's (Ezra). And the scarf is both folded by the till and worn by
  Ruth.
- **day_twentyfive:134:** "thirty-two, with John" leaves out the Reverend.
  Also, v7's 1984 grain elevator (31 dead) collides with "thirty-one".
- **He never lies, but here he does:**
  - night_twentyone:25: "The Reverend has gone to rest", while he's alive.
  - night_twentythree:24: "Elias is with the Lord".
- **night_twentytwo:69→79:** MC lies down at six, then the stairs "three
  o'clock".
- **night_twentytwo:99-102:** `odd_ash` says "every window latched" even when
  the window is open.
- **night_twentyfour:** the power cut is muddled:
  - "by feel" plays whether or not the power was restored;
  - town-wide or a fuse?
  - his broadcast is live during the cut.
- **night_twentyfive:69:** "Midnight" comes after a 01:00–02:30 return, and
  the singing is heard after everyone has gone to bed.

**Daniel, soft lines (v7 rewrite)**

day_twenty:77; day_twentyone:29; night_twentyone:25; day_twentytwo:28, 41;
day_twentythree:79, 88, 108; night_twentythree:23-24; day_twentyfour:49, 55,
66; night_twentyfour:34; day_twentyfive:113, 115, 123, 143; night_twentyfive:23.

The narration softens him too: day_twenty:71 "almost grateful"; day_twentytwo:27
"genuinely grateful", :34 "not unkindly", :62 "truly sorry"; day_twentyfour:60
"his fingers warm".

- **No public hellfire:** every pulpit and radio moment is gentle.
- **v7's December "let in"** (how the Reverend died, the vestry key) is
  missing from the booth (day_twentyfive:130-138).
- **"Booth":** the radio booth (night_twentytwo:2,22; day_twentythree:30,41,120)
  and the confession booth (day_twentyfive:7,101,109–147; night_twentyfive:11)
  are muddled together.

**Repetition and length**

- **Repeated lines:**
  - night_twentyone:11 = bridge_storm.
  - "It'll keep" ×3.
  - "got a sum right/wrong" ×2.
  - "Somebody waves. You don't know who." ×2.
  - Daniel's approving nod ×3.
- **Too much text:**
  - day_twentytwo:41-53 is 13 lines with no input.
  - day_twentyone:62-71 tells the walk before the hotspot.
  - day_twentyfive:124 summarises instead of playing it.

**Choices**

- **day_twentytwo:23-24:** yes or no both lose the Reverend. There's no "say
  nothing", and the flags are never read.
- **The day 22 fire:** each of the three spots ends the night, so clicking the
  doors first loses the vestry evidence for good. There's no telling the crowd
  and no going for Olstad.
- **day_twentythree:62-72:** there's no giving Olstad the unbroken spectacles,
  and no waiting for him to leave.
- **day_twentyfive:84-87:** communion has no stakes beyond the eye. The same
  goes for the thread and road_turned_back.
- **day_twentyfive:114:** "You sit." is forced. day_twenty:71 decides "you
  don't ask".
- **day 25:** staying in alone can't lead to the Mass. The Hollis and Gleaner
  routes lead to the same Mass.

**Exploration**

- **Day 21** is a walk-around day with only one hotspot.
- **The day 22 vestry door** (the key evidence) sits behind a small corner
  arrow with no nudge.
- **Stale comments in spots.cfg** after the renumbering.

**Strongest:**

- the fire (day_twentytwo:42-53, 74);
- Abraham in the freezer and Ruth's "Thank you. I'll never forgive you. Thank
  you.";
- Ezra barring the doors.

**Weakest:**

- the booth on Christmas Eve (Daniel therapeutic, asks permission, skips the
  Reverend);
- the logic of the night 24 power cut;
- Daniel's three interchangeable replies at the fork on day 23.

### New Year and January: days 26–30

The weekdays all match. No jumps sit in the middle of a section, and no targets
are missing. `january.md` still numbers these days 24–26.

**Bugs**

- **The dog-feeding flags are reused:**
  - nights 23 and 27 share `fed_twentythree`.
  - nights 26 and 30 share `fed_twentysix`.
  - See December for the rest.
- **day_twentynine:69-71:** `walt_thanks` says "you turned him away", which is
  false if the dollars were pawned.
- **day_twentysix:27/63:** "Give them" doesn't check `held:spectacles`. If
  they were sold, MC offers glasses he doesn't have.
- **day_twentyeight:139-146:** Daniel speaks inside `narration` lines, so the
  red light won't fire.

**Continuity**

- **The real name** (the biggest one):
  - day_twentyeight:93: Daniel says MC's real name, breaking pillars ("never
    says it") and v7 ("not yet").
  - night_thirty:28: he says it on air.
  - night_thirty:29 vs day_thirty:35: "nobody knows it" vs "everyone knows
    it" after `accused_on_air`.
  - day_twentyeight:94: "you haven't heard it since October" is false after
    `accused_on_air`.
- **night_twentyeight:52:** "the church, every window lit". It burned down.
- **day_twentyseven:14:** "in the dark at noon" on Dec 31. Noon is daylight.
- **day_twentyeight:89:** "twenty to four", but the clock is at 14:30.
- **The light maths:**
  - day_twentynine:8: "forty minutes more than the shortest day" is really
    about 78 minutes.
  - day_twentyeight:20: "four minutes earlier": sunrise moves 1–2 minutes a
    day.
- **evening_twentynine:26:** Ezra buried the spectacles "in January". He
  took them Dec 29.
- **evening_twentynine:11:** "my sister in Wasilla" clashes with the bridge
  (the cruiser at her house).
- **day_twentysix:10:** a second Ida.
- **day_twentysix:23:** Ezra's burn bandages two weeks after the fire (he
  carried the box bare-handed). They also blunt the bandage reveal in
  February.
- **day_twentyseven:113:** the town is "talking about April" before the
  breakup sermon airs.
- **day_twentyeight:11:** the calendar line plays without `odd_calendar` seen.
- **night_thirty:23 vs 78:** the goodnights "after midnight", then "Midnight".
- **day_thirty:33:** "the booth tonight", but the booth is daytime.
- **day_thirty:13/32/99:** the booth's place and shape drift (a corner, then
  the end of a passage; a curtain and glass).
- **Stale numbering in comments:** day_twentyseven:4, day_thirty:5,
  bridges:202/210/218, spots.cfg around 1449/1505.

**Daniel, soft lines (v7 rewrite)**

day_twentysix:45 (bringing the groceries); day_twentyseven:96, 101, 103 ("I'll
be right here"); night_twentyseven:12; day_twentyeight:139, 142, 143, 145, 147;
day_thirty:68, 77, 82, 84, 90, 99.

- **His public voice is gentle:** night_twentysix:22, night_twentyseven:24,
  night_twentyeight:20/24, day_thirty:12. v7 wants him naming sinners.
- **"Booth":** day_thirty:13,33,42,46,62,66-72,88,93,98,99; spots.cfg:1516,
  1532; bridges:216; night_thirty:1,12.
- **Repeats:**
  - the breakup sermon (night_twentyseven:24-26 = day_twentyeight:10);
  - "banks and airplanes" (day_twentyseven:12 = bridges:188);
  - "light at a quarter to ten" and "nobody says it's good news" (day vs
    bridge);
  - "in a room" ×2 in one scene.
- **Checklists:** stacked conditional lines read like a list
  (day_twentyeight:139-146, up to 8; evening_twentynine:25-30, up to 5).
  "The way you'd…" appears 9 times.

**Choices**

- **day_twentyseven:84:** the phone is picked up automatically right after
  "Rule four: don't answer". There's no letting it ring.
- **day_twentyseven NYE spots:** without two doors with Ruth or Sam, the only
  option is "Stay at the shop", so the fork is fake for most players.
  `nye_ruth` doesn't check for a betrayal.
- **day_twentyeight:88-150 and day_twentysix:42-53:** MC has no choice in
  either Daniel scene.
- **day_thirty:70-72:** "small true thing" and "nothing" set no flag. The small
  thing ignores state. There's no option to accuse him or ask about the
  Reverend.
- **evening_twentynine:35-36:** no outright "No", and no taking the thread
  off.
- **day_twentynine:57/94:** `walt_dollars_kept` and `widow_picks_kept` set
  nothing.

**Exploration**

- **evening_twentynine:** the ruins have no spots; it's fully linear.
- **day_twentyseven:20:** the locker spot is easy to skip, and then the
  bridge and day 28 say nothing about the locker.
- **day_thirty:** "Your turn: the booth" is clickable at once, so the queue can
  be skipped. Mrs. Lund is hidden inside Ezra's spot, and there's nothing on
  the pews.
- **day_twentynine:** if the picks were sold on day 2, the day is Walt alone.

**Strongest:**

- the Bible with Leviticus 16 cut out;
- midnight, nothing happens, the cheer a beat late; then Sam's "Did you hear
  that.";
- Walt's "Ida. Ida. Ida."

**Weakest:**

- the booth on day 30 (no stakes, soft, rests on canon v7 retires);
- Daniel's first scene as himself on day 28 (a passive list of quotes; breaks
  the real-name rule);
- Olstad's monologue at the ruins on evening 29 (a recap).

### February, plus the shared files (night walks, town, bridges)

Days 31–34 are Sat Feb 5, Fri 11, Sat 19 and Sun 20. Day 35 is Sat Mar 11
(february.md says the 12th).

**Bugs**

- **Day 28 (Jan 3) has no map content.** The map evening falls through to day
  two: Ruth thanks MC "for today", and the Reverend is on the air after his
  death.
- **town:281:** a player who never met Sam gets `cabin_first` in February.
- **night_thirtyone:91:** the "coat back" line plays without the coat.
- **night_thirtyfour:99:** the prints spot can be clicked before bed and
  narrates 3 a.m.
- **day_thirtyfour:15** sets `weighed`, the same flag as October's
  day_five:102.
- **evening_thirtytwo:52:** `keys_returned` doesn't clear `ruth_has_keys`.
- **day_thirtythree:45-48:** Olstad's lines are written as narration, so they
  show in the wrong colour.
- **The clock vs the text:**
  - day_thirtyone:64 "three o'clock" at 13:30;
  - day_thirtytwo:28 "five o'clock" at 16:00.
- **night_thirtytwo:11** checks `doors:ruth>=3`, not a flag set tonight.

**Continuity**

- **The countdown doesn't fit breakup:**
  - "nine weeks" on Feb 5 puts breakup around Apr 8, but the calendar and
    story.md say late April (Apr 22, eleven weeks).
  - bridges:236 "nine crossed out, eight" should be seven.
  - bridges:244 "Tuesday" is a Monday; bridges:246 "six weeks" is off too.
- **The town already knows the lights are Sam's** (night_thirtyone:20,
  town:1057/1061), so Daniel's question in the booth has no tension.
- **The light:**
  - day 32: "Five o'clock. Dark" vs 17:40 "light only just going";
  - day 34: dusk at 16:30 and 17:00, though sunset is near 18:00.
- **bridges:228:** "you weren't asked this time", but Mrs. Hollis asked the
  day before.
- **bridges:223:** Ezra's bandage and "an accident at the hall door" come four
  days before day 31's reveal.
- **bridges:151:** the whole road's open doors already played in December.
- **Ruth's mother's death has three versions:** on the ice in her nightdress /
  putting her coat on / alone in the shop.
- **story.md** says the 1989 Keeper ran in February. The game says the night
  before breakup.
- **Ruth's age:** 30 in 1989, but the diary is a "girl's careful hand" and
  "a schoolgirl's diary", in "the girl's bed".
- **The 1989 Keeper:** "J.W." on the suitcase vs "David" in her letters. And
  why leave the suitcase behind?
- **The bear:** 1968 vs 1959.
- **day_thirtyfour:65:** "Nobody's gone in for ten years", but Ruth went in on
  day 2, and so did MC.
- **night_thirtytwo:98:** "on the bar", but the bowl was on her table.
- **day_thirtytwo:30:** "since the freezer" ignores October's other ways to
  turn Ruth.
- **evening_thirtytwo:42:** forgiving an already-turned Ruth opens no door.
- **town:1082-1084:** "the drive back, one good headlight", even when Ruth has
  the keys or the car was towed.
- **letter_1989:** "eleven letters, one for every year since 1988 but two"
  doesn't add up.

**Daniel, soft lines (v7 rewrite)**

day_thirtyone:45-46; day_thirtyfour:37, 45-46, 77-78; night_thirtytwo:21 (the
radio, gentle); night_walks:221, 230.

- **"Booth":** day_thirtyfour:2-5, 36, 76; spots.cfg `hall_booth_sam`;
  bridges:216; night_walks:166.
- **day_thirtythree:54:** the John night is the same text for every
  background.
- **Repeats:**
  - bridges:237 = town:1068;
  - bridges:238 = town:1069;
  - night_thirtythree:42 = town:1064.

**Choices**

- **day_thirtythree:57:** the deed is given automatically, with no keeping it;
  a liar can never give it. There's no "refuse to answer".
- **evening_thirtytwo:16:** the 1989 letter is laid down automatically, and
  there's no giving Ruth Abraham's "Ruthie" letter.
- **evening_thirtytwo:43:** refusing Ruth sets no flag.
- **night_thirtyfour:65:** locking the back door changes nothing.
- **The deed and room-key gates are fine:** there are always at least two
  options.

**Finds**

| Find | Days | Gate | Paid off later? |
|---|---|---|---|
| False-bottom drawer (rules) | 18+ | none | **no** |
| Desk key | 20+ | none | opens the desk |
| 1989 letter | after the key | desk key | yes, evening 32 |
| Deed | any night | the bulletin or two Sam doors | yes, day 33 and day 34 |
| Photo in the crate | 23+ | none | **no** |
| Burned corner | 24+ | none | **no** |
| Locked room | 28+ | room key | yes, evening 32 |
| Ruth's diary | 31+ | a second visit to the room | only if found **on night 31** |
| Abraham's letter to Ruth | 31+ | none | **no** |
| Bench notebook | 31+ | none | **no** (March) |
| Facing Daniel | 23–29 | once | yes, day 33 |

- **The diary's window** is very narrow.
- **Day 34:** the booth ends the day, so clicking it first loses the scale
  book for good.
- **The night 33 drawing** says "give it to Olstad", but there's no way to.
- **The night 34 prints** don't connect to notebooks hidden under the bed.
- **town.txt `ruth_house`, `town_line` and `lunds` are reachable** through
  places.cfg. They aren't leftovers.

**Strongest:**

- the April column already filled in;
- Ruth's lie with the creaking chair at the end of the bar;
- the yellow house with the swing.

**Weakest:**

- the day 34 booth;
- night 34 (repeats December, the lock does nothing, the prints out of
  order);
- day 32.

---

## Canon fixes (branch `canon-fixes`, ready if you agree with questions 15–27)

Done ahead of your answers, following the leans in `questions.md`. Drop the PR
to undo any of them.

- **15, the bear:** 1959 everywhere. The ledger gives it a year but no price.
- **16, the snowshoes:** "T. 98", Thomas.
- **17, Abraham's death:** the bench calendar circles October 3.
- **18, the furnace card:** unnumbered ("No number."), so Abraham's rules keep
  their nine.
- **19, Ruth's mother:** three versions, kept on purpose. `story.md` says so.
- **20, the 1989 Keeper:** not a contradiction. "David" (in quotes) was his
  Keeper name, J.W. his own. `story.md` now says he ran the night before
  breakup (April), not in February.
- **21, Ruth's diary and room:** a grown woman's hand, not a schoolgirl's.
- **22, the storekeeper:** Edie, not Ida.
- **23, "sweetheart":** pillars now allows the Witness flash, as `story.md`
  does.
- **24, the cold snap:** a line in the bridge before day 10. Thirty below, the
  lake booming as it sets, "clear as a window".
- **26, night 34:** locking the back door changes the night now. The knob
  turns until light, and in the morning there's a frosted handprint, instead
  of the prints coming up to the bedroom door.
- **27, Olstad:** one line each on days 10 and 13. Thomas "didn't have one
  either"; "a man paying a man's bills… there was a word for that, and it
  wasn't 'friend.'"
