# Loose ends and new objects

Oct 15. The question: is anything left without a place? Not every player has
to find everything, and the game can be finished without investigating. But
every object, door, call and strange event should have **a real explanation
somewhere**, on at least one route. Where MC's unreliability or the
supernatural is the point, at least one concrete reading has to exist.

This is from a full read (October, November–December, January–May) plus every
object in `stock.cfg`, `items.cfg` and `documents/`. About 90 threads are
already explained and aren't listed here. Examples: ticket 0527, the tin and
the locker, the deed, the 70 names, John's death, Abraham's letter, the bear's
key and paraffin, the lake in 1988, Sam's clock, the rental car and the count
on the hall door.

**How to read it:** part 1 is bugs and contradictions. They need no decision;
I'll just fix them unless you say otherwise. Part 2 is the real gaps, each
with a call and a lean. Part 3 is choices that are never felt later, which
need one line each. Part 4 is the objects: the existing ones still owed a
payoff, then new ones with a place.

---

## Part 1. Bugs and contradictions (I'll just fix these)

1. **Cody is alive under one flag and dead under the other.** On day 40 his
   truck offer runs on `kept_picks`, which means he went through the ice in
   October. The run_cody ending, and the Cody line in daniel_ice, assume he's
   alive. *Fix:* gate it on `gave_picks_back`, and correct `routes.md` and
   test_routes. (My mistake in April.)
2. **The 1989 Keeper got away, but his eyes are in Abraham's jar** (evening 19
   vs Ruth's evening 32), and his suitcase is still in a crate. *Fix:* see
   call 6.
3. **Ida is Walt's dead wife,** yet on day 18 Olstad says "Ida says a man in a
   good coat", and the Kettle money order mentions "Ida's window". *Fix:* make
   it Edie, at the store.
4. **Mrs. Lund is three different people:** Ezra's wife in town.txt, Ole's
   widow with a living son Peter in daniel_file, and on day 29 a woman who
   "can't say her boy's name". *Fix:* she's Ole Lund's widow (Martha), and
   Peter went through the ice. Ezra's wife is someone else, unnamed.
5. **The earlier Keepers' names disagree** across the carbons (Anne, Luis,
   Margaret), the vestry frame (Paul, Annie) and Sam's list (Thomas, Paul,
   Dale, Annie). *Fix:* one list everywhere: 1998 Thomas, 1997 Annie,
   1996 Paul, 1995 Dale, 1994 Luis, 1993 the boy from Fairbanks…
6. **Who mounted the fox:** Teague, the ram and the fox's seam all say it isn't
   Abraham's work, but Olstad and the bench notebook say it is. *Fix:* the
   notebook says "Red fox. Thomas's first. I let him."
7. **The pocket watch's props** (Elgin, 5:27, silent, paper behind the
   movement) contradict examine.txt (Sundqvist & Sons, runs when wound).
   *Fix:* use examine.txt's version; the paper behind the movement becomes
   part of call 10.
8. **The clerical collar** "came in the envelope with the money" in
   stock.cfg, but in Ezra's box on day 23. *Fix:* Ezra's box.
9. **The ledger is in two places:** Daniel takes it on day 39, but it's "on the
   counter" in burn_it. *Fix:* he pushes it back under the door on night 39.
10. **Daniel is in two places on the last night:** on the bottom step and in
    the passenger seat. *Fix:* keep both, and say it: "He's on the step. You
    look at the car. He's in the car. You look back. The step is empty."
11. **Night 22:** you lie down at six in the morning, then the dog comes "at
    three". *Fix:* "at nine".
12. **Small slips:**
    - The bench calendar circles the 3rd; day 24 says the 4th. Make both
      the 3rd.
    - The padlock is a store Master in October but "Department issue" in
      December. Olstad's is a second lock, added.
    - In October Cody lives with his aunt; in April his mother drives. His
      mother takes him to the aunt's.
13. **The Keeper's coat never reaches the ice.** It's built all winter (the
    weigh-ins, letting it out at Christmas) and breakup never mentions it.
    *Fix:* see call 2.

---

## Part 2. Real gaps: your calls

**Call 1. The dog on the stairs and the steel bowl.** All the clues point to
Mrs. Hollis: the grey hair, the hairpins, the worn knees, the bowl on her rack.
Two beats that would confirm it were planned and never written.
- **Lean:** write them.
  - December, at Christmas: she rinses the bowl at your sink. "You line it up
    so neatly. Abraham never did."
  - February, the night after the lanterns: you see it on the stairs, long
    grey hair, going up on its hands and knees. In the morning she says
    "Somebody has to."
  - Ruth, on her evening: the bowl started the winter after her mother died,
    which is why she can't look at it.
  - On the last night, if Daniel is on the step, he moves his feet to let her
    by.

**Call 2. The coat at breakup.**
- **Lean:**
  - In season_ends, Mrs. Hollis buttons you into it: "We let it out at
    Christmas."
  - In daniel_ice, he takes it off you and lets it go on the water.
  - In the fire, it burns on its hook if it's in the shop (`coat_in_shop`).
  - In every run ending, the hook is empty in May.

**Call 3. Who takes your place when you run** (run_ruth: "you know who was
holding the keys"; run_alone: "somebody else's").
- **Lean:** Mrs. Hollis. She has a key from Christmas, and she goes to sit in
  the empty shop the way Ruth's mother did. One May line names her. It closes
  call 1 too: "Somebody has to."

**Call 4. The front bell at night, the two cups, the wet toothbrush, the warm
chair, the taped clapper.**
- **Lean:** Ruth. She has the keys, and she still comes to sit at her father's
  table at night, the way her mother "went and sat in the shop". She tapes the
  bell so it won't wake you. One line on her evening: "I still come and sit.
  I tape the bell." Not her: the toothbrush. That one stays MC's (he used it
  and forgot).

**Call 5. Who feeds the furnace, and who writes in Abraham's hand after he
died** (the "Don't let the furnace go out" card on Oct 23, the "Oct 12. One
week." ledger line, JOHN crossed out on the envelope).
- **Lean:** Olstad and Ruth, split.
  - Olstad has fed the furnace on her rounds since the 4th, to keep the
    freezer cold. She'll say so in the freezer scene on day 24.
  - The handwriting is Ruth's, copying her father's, to keep the shop "his"
    for one more season. On her evening, she sees the ledger line: "I did
    that. I've done his hand since I was nine."

**Call 6. The 1989 Keeper (J.W.).** He got away (Ruth drove him), so the brown
eyes in the jar can't be his.
- **Lean:** he got away. The eyes are the 1993 boy from Fairbanks. Sam is
  wrong about whose they are, and Abraham's notebook corrects it if you find
  it. The suitcase in the crate is what J.W. left behind when Ruth drove him
  off in the night: he took nothing. One line in Ruth's evening: "He didn't
  even take his case."

**Call 7. The pie, the cloves and communion.** Sam says "don't eat the pie",
the wine tastes of cloves, and Mrs. Hollis writes on the foil. Nobody ever
says what it is.
- **Lean:** Dr. Brekke's clove oil, a numbing agent: "so the Keeper doesn't
  feel the cold." The foil says "For the walk". At breakup the cup before the
  walk tastes of cloves, and MC knows the taste if he took communion. If he
  refused it, he feels the cold all the way out.

**Call 8. The stranger with Ray's jacket** (day 3, and the man who waves from
the shore on day 4).
- **Lean:** Thomas's friend from Seattle, the one Olstad mentions on day 1. He
  came up to look for Thomas and bought Ray's jacket off Mrs. Hollis's line.
  On day 13 Olstad says she put a frostbitten Seattle man on the Palmer bus.
  This also gives Thomas a life (call 9).

**Call 9. Thomas's real name.** Sam has it ("so it's written down") and never
says it, the burned scrap is in his hand, and the hand mirror engraved J.M. has
no owner.
- **Lean:**
  - His real name is Jonah Marsh. Sam says it on evening 19, if you told Sam
    yours.
  - The mirror is his; the shop drops the "last winter's" note.
  - The burned scrap ("not the ice. They walk you out onto it") goes to Sam's
    wall if you hold it on a later cabin visit.

**Call 10. Daniel's father's watch, and the clocks stopped at nine.**
- **Lean:**
  - Nine is when the Thursday watch began on the radio, nine o'clock, the hour
    the town watches the lake. Daniel's father kept the same watch in
    Minnesota, at the same hour, the night the boy drowned.
  - When Daniel redeems the bullet on day 37, he takes the watch back too, and
    gives one fragment: "He stopped it when they found the boy. He made me
    wear it."
  - In the paper behind the movement, there's a newspaper clipping from 1988
    (the boy at the lake), if you open it with the loupe.

**Call 11. The church's box** (the clapper, the microphone, the collar, the
cut Bible: "held till we build again"). Nobody ever asks for it back.
- **Lean:**
  - On Palm Sunday, Ezra collects the clapper, the collar and the microphone
    for the plate: the town gives its church to the Keeper.
  - The Bible stays with you. In May, if there's still a shop, the clapper
    hangs from the pine post as a bell.

**Call 12. The bodies, and what Olstad's case costs.** Unless you burn the
shop, Abraham (and Daniel, if you shot him) stay in the freezer forever, and
the price of signing as a witness, your real name in Anchorage, is never
collected.
- **Lean:** May lines.
  - If there's no fire: "Olstad opens the freezer in June. She does it alone.
    She writes it down."
  - If Daniel was taken: "A subpoena comes to the shop, in your real name.
    Nobody's there to sign for it." (On the run routes, it finds you.)

**Call 13. What the town did with Daniel** (`daniel_given`).
- **Lean:** in May, the straw man goes back up on his post wearing the good
  coat. "Nobody asks whose."

**Call 14. Ezra or Brekke goes missing in March** (`gone_ezra`/`gone_brekke`).
Daniel "always tells you what he's done" and never says.
- **Lean:**
  - Daniel says one line on evening 37: "He went out to count the holes. I
    counted with him."
  - In May the lake gives him back, next to Ray if Ray is there.

**Call 15. The money orders stop in December without comment.**
- **Lean:**
  - Daniel on day 28: "I stopped paying for you. You're mine now; I don't
    need to rent you."
  - Holding all three (Anchorage, Wasilla, Kettle Lake) adds a notebook line:
    the trail, and the "31. 32. 33."
  - At breakup, Mrs. Hollis says "thirty-three" aloud as they paint it, so the
    number lands.

**Call 16. The Polaroid in the coat, and the daytime phone call.**
- **Lean:** both are Daniel. In the counsel room he says: "I stood in those
  trees the week before you came. I took a picture of John's car. I rang once
  on a Saturday, to see if you'd jump." The pink slip is from the Gleaner's
  pad, so Ruth took the message.

**Call 17. The painting over the armchair.** It's unsigned, "a spring in the
eighties", and grows figures.
- **Lean:** Ruth's mother painted it, spring 1989, the spring J.W. got away. Her
  paints are in the locked room. Ruth says on her evening: "Mum painted that.
  There was nobody on the ice when she did."

**Call 18. The bear's first seam, 1959.**
- **Lean:** the bench notebook's bear entry adds "and what the lake gave back,
  May '59": the Keeper before Abraham's time, inside it. One line; it opens
  nothing new.

**Call 19. "LOCK IT NOW", scratched in the frost on the back door.**
- **Lean:** the Reverend. On day 21 he says: "I wrote on your glass once.
  Hymns weren't enough."

**Call 20. "Four not fed"** (radio, night 26).
- **Lean:** name them in the lines, depending on state: you (if no thread),
  Olstad, Sam, and Ruth (if she isn't threaded).

**Call 21. Olstad's "the truth about something else"** (day 16).
- **Lean:** on evening 29 she says what it was: "He told me your real name. He
  wanted me to know he had it."

**Call 22. Daniel at Sam's cabin on December 4.**
- **Lean:** Sam, on the next cabin visit: "He stood at my window an hour
  Saturday. He didn't knock. I didn't move."

**Call 23. Abraham's things.**
- His letter is never given to Ruth. **Lean:** on day 40, if you hold it, you
  can give it to her: "It wasn't your fault." It echoes in run_ruth.
- Rule 9 ("If he comes back, give him what he asks for. I didn't") names
  nobody. **Lean:** if you hold the rules, a paranoia line at fork 6 says it's
  the preacher. He came once before, in 1988.
- The hooked tool and the half-stitched stoat. **Lean:** the tool is in his
  coat pocket in the freezer, and the letter mentions the stoat he left on
  Oct 3.
- Ruth's "Dad goes away every fall": to Anchorage, for the paper, to find
  the next Keeper (this fits the carbons).

**Call 24. The finds nobody reacts to** (the Keeper photo, the carbons, the
first two money orders).
- **Lean:**
  - The photo: Ruth sees it on her evening ("David").
  - The carbons: Olstad on evening 29 ("There's no carbon for this year. Who
    wrote to you?").
  - The money orders: call 15.

---

## Part 3. Choices that are never felt later (one line each, no calls)

| Choice | Where the line goes |
|---|---|
| `invited_daniel` / `ordered_daniel_out` (day 28) | Night 42: "You said come back." Day 37: "Your shop. Say it again." |
| `refused_watch` (day 20) | The watch goes back with the bullet on day 37 (call 10): "You wouldn't hold it. I remember." |
| `refused_groceries` (day 26) | Night 26, the peaches: the box is in from the step anyway. |
| `stood_in_ash` (day 25) | Daniel on day 28: "You stood in it. I saw." |
| `power_left` (night 24) | The next morning, the freezer's hum is back, and the frost has a line of melt. |
| `silent_on_fire` / `backed_doctor` (day 23) | Evening 29, Olstad: "You said the stove." |
| `sang_at_fire`, `tried_church` (Dec) | Day 25, booth: the burned hands, the hymn. |
| `gun_pillow` (day 23) | Daniel: "Mrs. Hollis says you sleep on it." |
| `safe_marked` (day 35) | Mid-March bridge: the safe opened in the night, the notebooks still inside. |
| `sam_stayed_dark` (evening 38) | Day 40, Sam: "You didn't come out. I saw." |
| `round_loaded` / `round_thrown` (night 40) | Palm Sunday, with the gun: "You put it at the back. Good." In May: the round on the shore. |
| `signed` with Olstad's trust below 2 (day 41) | "The steps are empty." |
| Sam's wall pins (evening 19), `window_nativity` (day 19) | Day 33, the wall in public: the pins you gave him. |
| `has_books` (January) | Evening 37, Daniel: "The rest of them." |
| `daylight_call`, `rental_call`, `invited_ice`, `road_closed`, `prayed_again`, `fed_furnace` | Most are paid off by calls 5 and 16; the rest are texture, so drop the flag. |

---

## Part 4. Objects

### Existing objects still owed a payoff

| Object | What's owed | Lean |
|---|---|---|
| **Rifle 0431** (pawned every autumn, redeemed at breakup, church mark) | Never redeemed | Ezra redeems it on day 42, for the walk. In May it's back on the shelf with a new tag. |
| **Decoy no. 14** ("they took in nineteen"; something rolls inside) | Never opened | Ray's granddad's. Inside is a wedding ring: the twentieth decoy's owner. Mrs. Hollis knows it. |
| **Snowshoes** "K. 97–98" | Whose? | Annie's (1997; Kathleen Anne). Fixed with the names list. |
| **Skinning knife**, eleven tally lines | Never explained | One per Keeper since 1988. The eleventh was cut in August, before you came. |
| **Tooth jar** ("in the vestry, by Christmas") | Never handed over | Ezra takes it on day 23, with the box of church things. |
| **Hand mirror J.M.** | No owner | Thomas's (call 9). |
| **Father's watch** | Never comes back | Call 10. |
| **Clapper, microphone, collar** | Never collected | Call 11. |
| **Lantern** (white gas, never lit, 1987 paper) | New on day 4 | Lights night 24's power cut. If you sold it, you sit in the dark (and `power_left` means something). |
| **CB radio** (KETTLE BASE; someone counting on 19) | New | Sam asks to buy it, or Daniel's count is on it in December, reaching 33 when the road closes. |
| **Thermos** (warm) | New | Ray's. Mrs. Hollis knows it, and doesn't buy it. In May, it's empty. |
| **Leg-hold trap** (NOT FOR FOX) | New | Teague's, lent to Abraham "for the stairs". He takes it back in January (with the wolf skull below). |

### New objects, each with a place (by month)

So the shelves change through the season, and the empty right wall fills up.

| Month | Object | Shelf | How it comes in | What it pays off |
|---|---|---|---|---|
| Nov | **Wasilla matchbook** (room 11, "Nov 1–3") | drawer | Daniel leaves it on day 15 | The Wasilla money order: "the same town, the same night" |
| Nov | **Thomas's scarf** (name tape: "Thomas" crossed out, the real name under it) | back, no loan | Ruth brings it, day 13 | Call 9 |
| Nov | **Snow globe** ("Kettle Lake 1989"; a figure on the lake in red flannel) | floor, $4 | June leaves it after the pageant, day 17 | The Keeper photo, and the figure in the painting |
| Dec | **Marked hymnal** (one page torn out; numbers circled) | back | In Ezra's day-23 box | The Reverend's radio code; the hymn numbers on Sam's wall |
| Dec | **Cody's mitten** ("C.H. '86") | back | Mrs. Hollis brings it with Ray's teeth, day 24 | The child's tooth in the jar; plays differently on day 29, Cody alive or not |
| Dec | **Ruth's camera** (film still in it; the last frame: a highway sign, April '89) | back | Ruth, after her cellar door, day 19 | Her third door: she drove J.W. out |
| Jan | **Ida's sewing tin** (1958 hairpins; brown wool under the tray) | floor, $8 | Walt, day 29 | The coat; who the dog was before Mrs. Hollis |
| Jan | **Ray's tackle box** (his house keys; "If I go through") | floor, $20 | Mrs. Hollis, day 30 | The ice picks; Ray in May |
| Jan | **Wolf skull** (drilled for a cord: "keeps the dead from following") | floor, $25 | Teague, a new January visit | The trap; what Teague knows |
| Feb | **Ezra's .22** (a notch for every Thursday) | back | Ezra, after his hand is broken | The shells: he shoots at the ice at nine. His kept-faith moment. |
| Feb | **Sam's envelopes** (the seventh unopened: September 1999, "Dear John") | back, no loan | Sam, day 33 | The missing carbon: Abraham offered Sam the job first |
| Mar | **The Polaroid "JOHN. 1999."** (a height mark; "April 22" on the back) | drawer | Under the door during the frenzy, day 35 | The wall of faces; the date |
| Apr | **The collection plate** (rings, three deeds, Ray's ring if kept) | back | Ezra, Palm Sunday | The deed of 1931: the town pawns itself to its Keeper |

That's 13 new objects, plus the 4 from the crates. Four of the new ones go on
the floor (the right wall from November), and nine go on the back shelf or in
the drawer.

---

## Your calls, in short

1. **Part 1** (bugs and contradictions): just fix them? **Lean: yes.**
2. **Calls 1–24:** the leans above. The biggest are 1 (the dog is Mrs.
   Hollis), 3 (she takes your place), 4 (Ruth sits in the shop at night),
   5 (Olstad feeds the furnace; Ruth writes her father's hand), 7 (clove oil),
   10 (nine o'clock and the watch) and 12 (the freezer opened in June).
3. **Part 3** (the never-felt choices): one line each? **Lean: yes.**
4. **Part 4:** the existing objects' payoffs and all 13 new objects? **Lean:
   yes,** built in three passes: October–December, January–February,
   March–May.
5. **Order:** **Lean:** Part 1 first, since the Cody bug affects an ending;
   then calls 1–5 (the core of the town's horror); then the rest.

---

## As built (Oct 15, branch `loose-ends`)

Every lean was approved and built. Where something landed differently from
the plan, it's because shop effects (`pawned=`, `unpacked=`, `redeemed=`) only
work at the counter.

**Part 1.**
- **Cody:** the day-40 truck now needs `gave_picks_back` (he's alive).
  daniel_ice reads Cody or Mrs. Hollis accordingly.
- **Names:** one Keeper list everywhere: Thomas (Jonah Marsh) 1998, Annie
  1997, Paul 1996, Dale 1995, Luis 1994, the Fairbanks boy 1993, David (J.W.)
  1989.
- **Edie:** replaces Ida in December.
- **The Lunds:** Ezra is Hanna's grandfather. Martha is his son Ole's widow
  (Ole died in 1988); Peter and Hanna are her children. Only town.txt said
  "Ezra's wife"; it now says "daughter-in-law".
- **The fox:** Annie's, January '98, in the ledger, the catalogue and the
  bench notebook. Olstad still thinks it's Abraham's work, and she's wrong.
- **The eyes in the jar:** the Fairbanks boy's. The bench notebook says so,
  and David got away.
- **Pocket watch 0402:** Sundqvist & Sons. It counts when wound. Behind the
  movement is an unused one-way bus ticket from Anchorage, April 1989.
- **The collar:** came in Ezra's box.
- **The ledger:** back under the door on night 39.
- **The last night:** on the step and in the car, said outright.
- **Night 22:** "Nine o'clock".
- **Abraham:** died on the 3rd; found on the 4th. The Master padlock is
  Olstad's from the 4th, plus a second Department lock in December.
- **Ray:** went through in September, not '93.

**Part 2.**
- **The dog:** confirmed in three beats. Christmas morning, she rinses the
  bowl at your sink. Night 34, the grey hair on the stairs. Day 35, the knees
  of her stockings, then "Somebody has to". On the last night he moves his
  feet to let her by.
- **Ruth's evening (32):** now one confession. It covers the bowl, the case,
  the painting, Anchorage every fall, and "David" (if you hold the photo). If
  her doors are 2 or more, it adds sitting at his table at night and taping
  the bell, and "I've done his hand since I was nine".
- **Olstad:** feeds the furnace (day 24). On evening 29 she says what Daniel
  told her: your real name. She also asks about the missing carbon.
- **The cloves:**
  - The pie foil says FOR THE WALK (day 17, if you refused the pie).
  - The Christmas wine is clove oil.
  - At breakup, the cup at the shore, numb or not, depending on whether you
    took communion.
- **The Seattle man:** on the Palmer bus (day 13).
- **Jonah Marsh:** said by Sam on evening 19 (door 1). It's on the scarf's
  name tape, and the J.M. mirror is his.
- **Daniel's watch:** redeemed on day 37, with nine o'clock and the boy. Rule
  9 is a paranoia line at his offer (evening 37).
- **The church box:** Ezra collects the clapper, microphone and collar on day
  40, and redeems rifle 0431 "for the walk".
- **May:**
  - The freezer opened in June.
  - The subpoena.
  - The straw man in the good coat.
  - Ezra or Brekke given back by the lake.
  - The bullet on the shingle.
  - Mrs. Hollis goes out in the coat in your place if you ran.
- **"33":** said aloud as it's painted.
- **Daniel's lines:**
  - Day 28: "I stopped paying for you."
  - Day 30, the booth: the trees, the Polaroid, the Saturday call.
  - Evening 37: what happened to Ezra or Brekke.
- **The Reverend:** wrote on the glass (day 21).
- **The four not fed:** named by doors (night 26).
- **Sam:** Daniel at his window (December). The burned scrap goes on his
  wall (January cabin).
- **The safe:** found open in mid-March.
- **The bench notebook:** the bear's first seam, "what the lake gave back,
  May '59".
- **Abraham's letter:** the stoat and the hook. The hook is in his pocket in
  the freezer.

**Part 3:** all the one-line echoes, as listed.

**Part 4.**
- **Existing objects:**
  - **Decoy no. 14:** Arne Sveen's ring, 1931 (Mrs. Hollis, day 15).
  - **Thermos:** Ray's (day 18).
  - **Knife:** its eleven lines (Sam, day 13).
  - **Tooth jar:** Ezra takes it on day 23, unless the town's eye is on you.
  - **CB radio:** counts to 33 on night 21.
  - **Lantern:** lights the power cut on night 24.
  - **Trap:** Teague takes it back, day 29.
- **New objects:**
  - Thomas's scarf, Ruth's camera and the snow globe (day 19; moved from
    days 13 and 17).
  - The hymnal (day 23).
  - Cody's mitten (day 24; she'd already given the teeth to Ezra).
  - The matchbook (day 15).
  - Ray's tackle box (day 28; moved from 30).
  - Ida's sewing tin and the wolf skull (day 29; Teague's visit moved from
    30).
  - Sam's envelopes (day 33; a new Sam visit).
  - The Polaroid (day 35).
  - Ezra's .22 (day 35, the day before he may vanish; moved from February).
  - The collection plate (day 42).
- **New pictures:** scarf, globe, book, mitten, camera, tackle, skull,
  envelopes, plate.

**Left as texture** (set, never read; no line needed): the `saw_*` odd-thing
flags, `confessed_*`, `asked_about_reverend`, `wont_promise`, `lake_two`,
`lake_three`, `daylight_call`, `rental_call`, `invited_ice`, `road_closed`,
`prayed_again`, `fed_furnace`, `ruth_refused`, `showed_olstad_letter`.
