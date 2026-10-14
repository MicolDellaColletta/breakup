# Breakup: Forks and endings

How the player's choices add up to an ending. Every ending but one leaves MC
alone in a new way; the fire leaves him alone, and free. **Many soft forks** (small
choices that move a running total), **six hard forks** (choices that change
what happens next), and **six endings**, read at breakup from both. Decided
October 12. `pillars.md` wins any conflict.

---

## Soft forks: the running totals

Every day, most choices move one of these. None of them changes the story on its
own; together they decide which endings are open at breakup.

| Total | Fed by | Decides | Built? |
|---|---|---|---|
| **The voices** (paranoia, john, appraisal, warmth, animal, ???) | How MC answers, `lean=` | The background (fork 1), colored choices, The ice variant | Yes (`GameState.voices`) |
| **Fray** | Rules broken (+1), unsettling things (+1), small comforts (-1) | Frayed at breakup or not; The ice | Yes (`GameState.fray`) |
| **Rules broken** | The eight rules | Fray; how the town sees MC | Yes (`GameState.rules_broken`) |
| **Kept faith with**, per person | A kindness kept, a promise kept, a truth told: Walt, the Hollises, Ezra, Ruth, Sam, Olstad | Who lets MC go (The fire); who MC trusts with the keys (Run) | Yes: worked out from flags (`faith:`, `keep=`, `betray=`; `december.md`) |
| **Closeness**, per romance (Ruth, Sam, Daniel) | Three doors per person (below) | Which romance can lock at fork 5 | Yes: `door_<who>_<n>` flags (`doors:`, `door=`) |
| **The town's eye** | The town seeing MC break a rule or a custom, through the people who watch (below) | How hard the frenzy turns on MC in February and March | Yes: `GameState.eye` (`eye>=`, `eye=`), seeded December 1 |
| **The blur** | Fray, ???, and how deep MC is in a romance | How unreliable the game itself becomes (below) | No |

Rule of thumb: a soft fork never asks the player to pick "the good option". Each
choice costs something somewhere else (themes.md: "no clean options").

### Thresholds (decided Oct 12)

- **Closeness: three doors.** Each romance has three scenes, and each is a door
  the player chooses to open:
  1. **A true thing told**: MC tells them something real.
  2. **Their secret, shared**: they tell MC theirs (`story.md`, "Romances").
  3. **Their lie, forgiven**: every love interest lies to MC once; MC finds out
     and forgives it.
  Two doors open by New Year's Eve make that person available at fork 5. All
  three, and the fork, lock the ending.
- **Kept faith with: a count.** Six people (Walt, the Hollises, Ezra, Ruth, Sam,
  Olstad), each kept or not, one moment at a time. **The fire needs four of
  six,** including someone who will let MC go.
- **Broken faith closes doors.** An open betrayal (selling someone out, a
  promise broken in front of them) can close a person for good: no more kept
  faith with them, no more doors.

### The romances, door by door (decided Oct 12)

None of them is simply good. Each door is a scene, important and particular to
that person, and each pulls MC further in. **Every route is an attempt to
escape a loneliness that can't be escaped:** each romance gives MC what he
needs, takes something for it, blurs reality further, and leaves him alone in
a new way.

| | **Ruth** | **Sam** | **Daniel** |
|---|---|---|---|
| **The pull** | Being *remembered*: a home, a warm bar, someone who'll keep your photo when you're gone. | Being *believed*: the one person who says "you're not crazy, here's the proof." | Being *known completely*: no more pretending. He knows the name, the night, the lie, and wants you anyway. |
| **The dark thread** | She catalogues Keepers for the church, keeps MC's car keys, would rather he die here than leave. Love as a cage. | Folie à deux: the wall, the list of the dead, the clock's hands. Every door he opens, MC goes down with him. | A killer, and possession. Being broken down and rebuilt as his feels like love. The darkest. |
| **How reality blurs** | Once, drunk, she calls MC by the 1989 Keeper's name and doesn't notice. Does she love MC, or a replacement? MC starts to wonder too. | The conspiracy starts explaining things, and fits too well. Late on, MC finds pins on the wall in his own handwriting he doesn't remember. | ??? speaks in his cadence; with the insanity background he was only ever "a voice from the missing hours." Is he in the room? MC can't tell if he loves a man, ???, or his own destruction. |
| **How MC ends up alone** | A photograph on her wall, loved as a stand-in. | Two people alone together inside a delusion nobody else shares. | The only person who knows MC's real name is the one who would kill him. Being completely known is the deepest isolation. |

**Ruth: complicity, desperate attachment.** Being seen is being catalogued;
loving her is loving someone who hands Keepers to the town, and won't let go.

1. **A true thing told** (day three): *"What did they call you, before?"* MC
   gives something real. She doesn't write it down (as built); she keeps it.
   The first time she writes it is for MC alone, on a napkin under a beer
   (`days_four_to_seven.md`). Filed.
2. **Her secret** (November, after hours): drunk (the drinking is the first
   secret), she takes MC to the Gleaner's cellar: a second copy of every
   Keeper's Polaroid since 1989. One for the wall; one for the church, every
   year. *"Somebody has to give them their Keeper. I make sure they know the
   face."*
3. **Her lie, forgiven** (February): she said the 1989 Keeper ran. **She drove
   him to the highway herself,** thirty and in love with him, and her mother
   died that night in the empty shop. Every Keeper she keeps in town is
   penance. **And this winter she has MC's car keys,** taken "for safekeeping"
   on a drunk night in November and never given back. She'd rather MC die here
   than lose another one. Forgiving her is accepting the cage.

**Sam: complete madness, folie à deux.** Being believed by the one rational
man in town, and following him all the way down.

1. **A true thing told** (day four or later): he asks for MC's real name, *"so
   the right one's written down."* MC sees his own line already started
   (*October 5, 1999. "John". ___*): *"I start them in October. It saves time
   in May."* Instead of running, MC starts helping him fill in the others.
2. **His secret** (December): six envelopes addressed to him by name, one every
   September since 1993, all unopened (he said no in 1993, and that winter's
   Keeper died in his place: *"You're sitting in my chair."*). Behind them, the
   wall: string, pins, a decade of clippings, Keepers, hymn numbers, the
   clock's minute, the church's collection totals. MC adds the first pin of his
   own.
3. **His lie, forgiven** (March): MC catches him at the tripod at night, moving
   the clock's hands. He said he never touches it. He's faking the miracle, or
   *"setting it back to the true minute. It drifts. I have to keep it
   honest."* Forgiving him is accepting his reality. The game never says which.

**Daniel: wanting to be broken and rebuilt.** The only person who knows MC
completely is the man paid to end him; being his exception feels like love.
The darkest of the three.

1. **A true thing told** (late November, the sixth bullet): he plays the polite
   stranger (*"What will you give me for this?"*); MC can break the pretence:
   *"It came out of you."* *"There you are."* MC's first true word in Kettle
   Lake, to the man who wants him dead.
2. **His secret** (Christmas Eve, the confession booth, roles reversed): first
   he breaks MC down, calmly laying out every lie MC has told as John until
   nothing of the costume is left. Then he rebuilds: his own confession, the
   count (*"Thirty-one. Thirty-two with John. You'd have been thirty-three."*),
   and his father's kitchen table, the night he stopped believing at twelve.
3. **His one lie, forgiven** (March): the only lie he tells in the whole game.
   *"I said I didn't know why I let you go. I knew."* The reason depends on the
   background (draft: *"Because you didn't beg. You looked at me like you'd been
   waiting."*). His ending, where he says MC's real name, completes the
   rebuilding: he gives MC back to himself, as his.

**About Daniel's silence:** face to face he's a polite stranger from late
November. What he never does until New Year's Eve is call MC, or speak of the
night John died. MC can be the one to break that.

### Keeping faith, person by person (decided Oct 12)

One moment each. Keeping faith always costs MC something.

| Person | The moment | Keeping faith | Breaking it |
|---|---|---|---|
| **Walt** | Day two, the name (built). Later in winter he comes back for the ticket stub, grieving, confused. | Refuse the name kindly; or, if MC took it, give it back when he asks, so the town can say "Ida" again. | Refuse him hard; or keep the name when he comes for it. |
| **The Hollises** | Day three's warm jacket: R. HOLLIS in the collar. | Buy it (rule 2 broken) and give it to Mrs. Hollis for nothing. | Leave it, or sell it on; Cody sees it on someone else in town. |
| **Ezra** | February, after Daniel breaks his hand: he can't load his .22, and Thursday is the only routine he has left. | Load the shells for him and keep his Thursday line in the ledger. A kindness to the man who called MC the goat. | Turn him away. The Thursday line stops. |
| **Ruth** | Her father. MC knows he's in the freezer; she believes he's "away". | Tell her, and take her to the freezer. The cruellest kind thing in the game. | Let her find out from someone else. Daniel would tell her: he never lies. |
| **Sam** | February: the town wants the madman with the lights on the ice, and Daniel asks MC in confession where those lights come from. | Don't give him up; hide his notebooks if they come for the cabin. | Tell Daniel. The congregation goes to the cabin. |
| **Olstad** | February, after Daniel's threat: she asks MC for the truth about the John night, to build a case. | Tell her, at the risk of MC's freedom. It's what makes her look away at the town line, for The fire. | Lie to her. She'll know. |

### The blur (decided Oct 12)

Up to a point, reality stops mattering. The blur rises with fray, with ???, and
with how deep MC is into a romance. As it rises, **the game itself becomes
unreliable:**

- Characters mention conversations MC never had, or forget ones he did.
- The ledger has lines in MC's handwriting he doesn't remember writing.
- A scene from earlier replays slightly differently, and the old version is gone
  from the log.
- In the last weeks, the voices argue about what actually happened.

By breakup, a player deep in any route can't separate reality, lies, paranoia
and delusion. That's the point. (The rule of two explanations still holds:
nothing is confirmed, everything could be MC.)

### The town's eye (decided Oct 12)

- **What raises it: strangeness.** The town seeing MC break a rule or a custom:
  lights on after midnight, a window open after dark, skipping church, saying a
  pawned name, something odd in the shop window, being seen with Sam (the town's
  madman) or Olstad (the law). Keeping the customs lowers it, slowly.
- **How it spreads: the watchers.** It only rises when someone who carries it
  sees: Ezra (the church), Olstad (the law), the Gleaner's regulars (the bar),
  the night radio (everyone). Something strange seen by nobody doesn't count.
- **From December, Daniel can multiply it.** From the pulpit and the radio he
  can turn the frenzy toward MC or away from him. It's leverage: he holds the
  town's eye over MC, and the player feels it.
- **What it does, February and March:** notes under the door; the church
  turning MC away; processions stopping outside the shop; customers who stop
  coming; needing Olstad's protection. High enough, and the town comes early.

---

## Hard forks: six turning points

Each one changes what happens next. They're spread across the calendar
(`pillars.md`, "The calendar"), one per act or so.

### 1. The John night (end of week one, October 12)

- **The fork:** the background settles (guilt, witness, debt, insanity), from
  the voices MC listened to all week (`settle=background`, already built).
- **It changes:** the flashes from October 12, who fired the sixth bullet
  (`story.md`, "The sixth bullet"), what MC will have to confess to Olstad or
  to Daniel.

### 2. The tin (the double hour, Saturday October 30; as built)

- **The setup:** the rental's four prepaid weeks run out; Northern Lights
  reports it; Olstad reads the plate. The clocks fall back, and the dark comes
  an hour early.
- **The fork:**
  - **Open the tin** (with what? The ticket says MC can redeem it; the padlock
    needs a key or a hammer) and find the key and the slip: the books are in a
    locker in Anchorage.
  - **Leave it shut.**
  - **Try to run.** Too early: the road, the plate, Olstad at the town line.
    It fails, and costs her trust (and kept faith).
- **It changes:** whether MC knows where the books are before Daniel arrives,
  and what MC has to bargain with at fork 6.

### 3. The sixth bullet (Daniel arrives, late November)

- **The fork:** he puts a flattened bullet on the counter. *"What will you give
  me for this?"* It's warm (rule 2).
  - **Take it** into the ledger, with a ticket.
  - **Refuse.** He buys matches. *"Keep the change."*
  - And, either way: **tell someone who he is** (Olstad, or Sam), or keep it to
    yourself.
- **It changes:** how Daniel reads MC (closeness, Daniel), and whether anyone
  else knows what he is. Telling Olstad starts her duel with him early.

### 4. The Reverend (December)

- **The setup:** Daniel tells Ezra one true thing about the Reverend's radio
  help. The congregation turns.
- **The fork:**
  - **Warn him.** He has a night to leave.
  - **Hide him** (the locked room? Sam's cabin?). Dangerous: the town's eye.
  - **Stay out of it.**
- **It changes:** whether Elias escapes or vanishes; whether the helper's voice
  still comes through once or twice later (a recording, or a man in hiding); how
  the town sees MC.

### 5. New Year's Eve (December 31)

- **The fork:** where MC is at midnight, when nothing happens:
  - **At the Gleaner, with Ruth.**
  - **On the ice, with Sam,** at the tripod.
  - **Alone at the shop,** when the phone rings: *"Happy New Year, sweetheart."*
- Who's available depends on closeness. Alone is always possible.
- **It changes:** it locks the romance strand (Ruth, Sam, Daniel), or none. The
  call comes in every branch; only "alone" hears it live.

### 6. Daniel's price (March)

- **The setup:** he names it out loud, because he never lies: the books.
- **The fork:**
  - **Pay him.** Give him the tin, or the locker (fork 2 helps: MC knows
    where). He leaves Kettle Lake that night.
  - **Confess to him,** in his own booth: the John night, the truth he can't
    price. Don't pay.
  - **Refuse** both.
- **It changes:** whether he's on the shore at breakup, which decides most of
  the endings.

Breakup itself is not a seventh fork. It's where the totals and the six forks
are read.

---

## The endings: four ways out (v7, decided Oct 14)

Replaces the six endings above this line in earlier versions. The user's frame: **go with
him, let the town have MC, escape with someone, or escape alone.** The only true
escape is alone, and it's the hardest. Details: `daniel_v7.md` section 7,
`april.md`.

| Way out | Ending | What it needs |
|---|---|---|
| **Go with him** | **Daniel** (and *into the ice together*, ??? strongest) | "Yes" at fork 6 (his offer, "come with me") and his doors, or the confession of the 1988 lake. He gives the town to the ice; they walk out singing. A new town, a new tent, MC handing out hymnals. He says MC's real name, the only time it's heard. |
| **Let the town have MC** | **The season ends** (and *The ice*, ??? strongest and frayed) | The default. Daniel on the shore lets go, exact change in MC's palm, "for the ferry". Bored. |
| **Escape with someone** | **Run**, with Ruth, Sam or Cody (Break the cycle and The truth fold in here) | Their doors at three, and a way out (the road, the car, the plate). Each has a catch: someone else walked to the shore; Sam's new wall with MC's name first; Cody staying to bury Ray. |
| **Escape alone** | **The fire** (the true one) | No romance locked; four of six kept faith with, including someone who lets MC go; and **Daniel beaten**, one attempt, one of three ways: Olstad takes him, the town turns on him (his files), or John's gun. Then the shop burns. |

Order of reading at breakup: Run alone → escape with someone → Daniel → The fire
→ The season ends (or The ice).

**Olstad** is on the shore in every ending where MC is.

---

## Settled with this page

- **Management's envelopes are the congregation's.** Ezra, as church
  treasurer, pushes the envelope under the door before dawn every Wednesday. The
  Keeper's wages come out of the collection plate: the town literally pays its
  Keeper. The "something else" is the congregation's: a prayer card, a hymn
  number. Abraham signed the job offers "Management" for the church's money.
  The reveal is a scene: one Wednesday MC wakes early and watches Ezra's boots on
  the step.
- **Abraham walked into the freezer himself,** on October 3, when John didn't
  come, because he believed the unkept shop would take whoever held the keys.
  Belief killed him. **Olstad found him** on October 4, closed the door, told
  nobody, and lets Ruth believe he's "away".
- **Why Olstad kept quiet (decided Oct 12): a trap, and fear.**
  - **On the surface, a trap.** The carbon on Abraham's desk said "John". If
    nobody knows the old man is dead, the new Keeper doesn't know she knows
    anything, and she can watch who shows up as John. That's why she watches
    MC so closely from day one, and calls him "John" to time the answer.
  - **Underneath, fear more than belief.** She doesn't believe in the ice. She
    believes in what the congregation does to people who get in the way of the
    season. She's watched it for years, and let Keepers go to the shore rather
    than be the one who stopped it. Closing the freezer door was her keeping
    her head down one more time. December proves her right: the Reverend.
  - **The payoff:** the player can catch the trap (thriller strand); on the
    shore, she says out loud what she was afraid of (folk strand). Standing
    there at all is her fear, faced.
- **Keys matter less than rule 1:** the back door is always unlocked, by rule,
  so anyone in Kettle Lake can walk in at night. That's the human answer under
  every footstep, the bowl, the boot prints and the ledger line. The keys
  themselves: front door (MC; Ruth's old one), back door (Olstad, who has two;
  Abraham's, still in his coat in the freezer), Ruth's locked room (Ruth, the
  key on the pink tag).

## Open

- [x] `breakup_decisions.md`: replaced by `decisions.md`, a dated log of every
      decision.
- [x] The thresholds: three doors per romance (two by New Year's Eve); the fire
      needs four of six kept faith with.
- [x] What feeds the town's eye: strangeness, through the watchers; Daniel
      multiplies it from December.
- [x] Why Olstad kept quiet: a trap, and fear.
- [x] Each love interest's three doors (above).
- [x] The kept-faith moment for each of the six (above).
- [ ] Daniel's reason for letting MC go, per background.
- [ ] Ruth's ending: does "Break the cycle" still fit the cage, or does it need a
      new name?
