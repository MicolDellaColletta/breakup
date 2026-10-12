# Breakup: Forks and endings

How the player's choices add up to an ending. **Many soft forks** (small
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
| **Kept faith with**, per person | A kindness kept, a promise kept, a truth told: Walt, the Hollises, Ezra, Ruth, Sam, Olstad | Who comes to the shore (Thaw); who MC trusts with the keys (Run) | No: flags today (`flag=`), a count later |
| **Closeness**, per romance (Ruth, Sam, Daniel) | Time spent, true things told, choices that let them in | Which romance can lock at fork 5 | No |
| **The town's eye** | Church attendance, the window display, what MC says on air, who MC is seen with, rules seen broken | How hard the frenzy turns on MC in February and March | No |

Rule of thumb: a soft fork never asks the player to pick "the good option". Each
choice costs something somewhere else (themes.md: "no clean options").

---

## Hard forks: six turning points

Each one changes what happens next. They're spread across the calendar
(`pillars.md`, "The calendar"), one per act or so.

### 1. The John night (end of week one, October 12)

- **The fork:** the background settles (guilt, witness, debt, insanity), from
  the voices MC listened to all week (`settle=background`, already built).
- **It changes:** the flashes from October 12, who fired the sixth bullet
  (`story.md`, "The sixth bullet"), what MC will have to confess for Thaw or
  for Daniel.

### 2. The tin (Halloween, October 31)

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

## Six endings

| Ending | What it needs |
|---|---|
| **The season ends** (default) | Nothing else came together. The town gets its Keeper. |
| ↳ *The ice* (variant) | The season ends, with ??? the strongest voice and MC frayed: told from inside MC's head. He walks out and meets what's under the ice, or loses his mind completely. The game never says which. |
| **Run** | A late escape that works (only from April, when the road and the plate allow it). The town walks whoever MC left holding the keys to the shore; MC chooses, from the people he kept faith with. Their spring is the epilogue. |
| **Daniel** | Fork 5 alone (or the Daniel strand), fork 6 confess and don't pay, enough closeness with Daniel. At the shore, he doesn't let go (`daniel.md`, 10b, outcome 3). |
| ↳ *Into the ice together* (variant) | The Daniel ending with ??? the strongest voice: he doesn't stop at the shore (`daniel.md`, 10b, outcome 4). |
| **Break the cycle** (Ruth) | Fork 5 with Ruth, fork 6 pay, enough closeness, and Ruth turns on the town. MC is still there after the ice goes out; it costs her father's legacy. |
| **The truth** (Sam) | Fork 5 with Sam, fork 6 pay, enough closeness, Sam's notebook. The rational answer, shared: it was always the town. |
| **Thaw** | No romance locked, fork 6 pay, enough people kept faith with, not frayed at breakup, and MC confesses his background to someone. They walk him to the shore, watch the ice go out, and walk him back. He gives his own name. |

Order of reading at breakup: Run (if MC is gone) → a locked romance whose
conditions hold → Thaw → The season ends (or The ice).

**Daniel's shore outcomes** (`daniel.md` 10b) sit inside these: he lets go
(The season ends), he isn't there (Ruth, Sam, Thaw), he doesn't let go
(Daniel), into the ice together (its variant).

**Olstad** is on the shore in every ending where MC is.

---

## Settled with this page

- **Management's envelopes are the congregation's.** Ezra, as church
  treasurer, pushes the envelope under the door before dawn every Tuesday. The
  Keeper's wages come out of the collection plate: the town literally pays its
  Keeper. The "something else" is the congregation's: a prayer card, a hymn
  number. Abraham signed the job offers "Management" for the church's money.
  The reveal is a scene: one Tuesday MC wakes early and watches Ezra's boots on
  the step.
- **Abraham walked into the freezer himself,** on October 3, when John didn't
  come, because he believed the unkept shop would take whoever held the keys.
  Belief killed him. **Olstad found him** on October 4, closed the door, told
  nobody, and lets Ruth believe he's "away". Why she kept quiet is open
  (waiting to see the season play out? protecting Ruth?).
- **Keys matter less than rule 1:** the back door is always unlocked, by rule,
  so anyone in Kettle Lake can walk in at night. That's the human answer under
  every footstep, the bowl, the boot prints and the ledger line. The keys
  themselves: front door (MC; Ruth's old one), back door (Olstad, who has two;
  Abraham's, still in his coat in the freezer), Ruth's locked room (Ruth, the
  key on the pink tag).

## Open

- [ ] `breakup_decisions.md` (referenced by `daniel.md`): still not in the
      repo. Paste it, or drop the reference.
- [ ] The thresholds: how much closeness, how many people kept faith with.
- [ ] Which soft forks feed "the town's eye", day by day.
- [ ] Why Olstad kept Abraham's death quiet.
