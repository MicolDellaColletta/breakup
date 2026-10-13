# Questions for the morning (Oct 14)

Everything I need from you, in one place, with my lean on each. The easiest
way to answer: "agree with all your leans", plus the numbers you want
different.

---

## 0. What's ready to pull

The branches are stacked. Open PRs and merge them in this order; each one
builds on the one before.

| # | Branch | What | Tests |
|---|---|---|---|
| 1 | `night-walks` | Night walks: exploring the shop, the hidden finds, the gun put somewhere, facing Daniel once. | Full suite passes (24 files) |
| 2 | `february` | February: key days 31–34, Ruth's lie, the duel, the scale and the booth, the February finds. | Full suite passes (25 files) |
| 3 | `full-review` | The full review (`docs/review_full.md`), the story map script, `CLAUDE.md`, and the bug fixes from the review. | See the PR |
| 4 | `red-light` | The red light when Daniel is present (`docs/red_light.md`). Built ahead of your answer to v7 call 11. Drop the PR if you say no. | See the PR |
| 5 | `canon-fixes` | The canon fixes from the review, following my leans on 15–27 (`review_full.md`, last section). Drop it if you disagree with them. | See the PR |
| 6 | `daniel-rewrite` | **A draft** of the Daniel rewrite pass: every soft line from Thanksgiving to February, hard in public, himself alone with MC, never lying, the real name dropping out of the sound, the red light tagged on each scene. Done ahead of your answers to v7 calls 1–3 and 12–14, because "too kind" was your note. | See the PR |
| — | `todo-next` | Docs only: the to-do list, the March plan (`docs/march.md`), this file. Can go in any time. | — |

## A. Daniel v7 (`docs/daniel_v7.md`)

1. **A con man who kills, on the run.** The crew job is his cover, his motive
   is amusement, and he keeps both rules (never lies, always pays). Lean:
   yes.
2. **Revivalist:** the anxious bench (public) and the counsel room (private)
   replace the booth. Lean: yes.
3. **Two Daniels:** hard in public, himself alone with MC, never kind. The
   rewrite pass covers about 70 lines, all listed in the review by file and
   line. Lean: yes.
4. **Letting MC in:** the Reverend, the files, the collection, the plan (the
   doors count). Flinching bores him. Lean: yes.
5. **How far he'll go:** someone who hurt MC disappears in March; the town
   offered to the ice in April. Lean: yes.
6. **The flashback: A, the lake in 1988.** Lean: A.
   - **Who drowns:** a girl from the town, or MC's younger brother? Lean: a
     girl.
7. **Four ways out:**
   - Ruth's and Sam's endings fold into "escape with someone";
   - the Daniel ending gets darker;
   - the fire needs Daniel beaten (Olstad, the town, or the gun).
   Lean: yes.
8. **Fork 6 becomes his offer** ("come with me"), not the books. Lean: yes.
9. **A past that won't hold still** (his true answers don't match, plus the
   five fragments). Lean: yes.
10. **The flashback decays** (three pieces, each worse, the last with MC's
    face). Lean: yes.
11. **The red light.** Lean: yes. It's already built on `red-light`; you can
    try it.

## B. From the review (`docs/review_full.md`)

**The big ones**

12. **He says MC's real name** on day 28, and on the air on night 30. Pillars
    and v7 say he never does, or only at the very end. Lean: **the name drops
    out of the sound** every time he says it (a hiss, like the flashback).
    It's the same trick in both places, and it costs no story.
13. **"He never lies," but four lines are lies** ("the Reverend has gone to
    rest", "Elias is with the Lord", "none of us did", "a hunting accident").
    Lean: reword each to something true but misleading, in the rewrite pass.
14. **Daniel's big scenes have no choices** (the Bible sale, the groceries,
    his first scene as himself, "You sit."). Lean: give each at least one
    real choice in the rewrite pass. The v7 "let in" offers can be those
    choices.

**One canon each** (the shop's lore contradicts itself)

15. **The bear's year:** "not in the ledger" / 1959 / 1968. Lean: **1959**
    everywhere; the ledger lists it.
16. **The 1998 Keeper:** "A.K. 98" on the snowshoes vs Thomas. Lean:
    **Thomas**; the snowshoes say "T.H. 98".
17. **Abraham's death:** Oct 3 vs Oct 4 on the bench calendar. Lean: **Oct
    3**.
18. **Rule 9:** "Don't let the furnace go out" (night 10's card) vs "If he
    comes back, give him what he asks for" (Abraham's rules). Lean: the
    furnace card is Abraham's **list of chores**, not a rule. Reword it so it
    reads like a chore list.
19. **Ruth's mother:**
    - the versions: found on the ice in her nightdress (what Ruth says) /
      putting her coat on (Abraham's letter) / dying alone in the shop
      (pillars).
    - Lean: **keep all three on purpose**, one per teller, never resolved.
    - Update `story.md` to say so.
20. **The 1989 Keeper's name:** "J.W." on the suitcase vs "David" in Ruth's
    letters. **Not a contradiction:** "David" is in quotes, his Keeper name,
    the way MC's is "John". `story.md` now says so (on `canon-fixes`).
21. **Ruth's age in 1989** was 30, but the diary is written as a schoolgirl's.
    Lean: reword it to a grown woman's hand.
22. **A second Ida** (the storekeeper) while Ida is Walt's unsayable pawned
    name. Lean: rename the storekeeper **Edie**.
23. **"Sweetheart"** from Daniel in the October flash: pillars forbids it,
    story.md allows it. Lean: story.md wins (only the witness flash).

**Design holes the readers found**

24. **The first-ice party at thirty below, in October,** two days after the ice
    was "two inches". Lean: a cold-snap line in the bridge before day 10.
25. **The town already knows the lights are Sam's,** so Daniel's booth
    question on day 34 has no tension. Lean: he isn't asking *who*. He wants
    MC to **say it out loud**, as the man who's been inside the cabin. It's
    the word they need, not the name.
26. **Night 34's lock choice does nothing.** Lean: locked, the prints stop at
    the back door and the knob turns all night. Unlocked, they come up to the
    bedroom door.
27. **Olstad's homophobia** (a pillar) never shows in October or November.
    Lean: one subtle line each on days 10 and 13.
28. **Dead flags** (set and never read). Lean:
    - give the ones listed in the March plan a payoff;
    - read `invited_ice` at the party (Hanna waves);
    - cut `daylight_call`, `rental_call` and `prayed_again`;
    - the rest get one line each in the narration rewrite.
29. **Fake choices in nights 8–10** (wait vs hang up differ only by a lean).
    Lean: leave them. The lean *is* the effect there, and it feeds the
    background.

## C. March (`docs/march.md`)

30. **Four key days** (Mar 11, 19, 25, 31). Lean: yes.
31. **The town searches for Sam's notebooks,** one outcome per hiding place.
    Lean: yes.
32. **Someone disappears:** Ezra, or Dr. Brekke if MC kept faith with Ezra.
    Never shown. Lean: yes.
33. **His room on Sunday** (the suitcase, the files, the cigar box). Lean:
    yes.
34. **The sixth bullet comes back:** he redeems it and loads John's gun in
    front of MC. Lean: yes.
35. **Fork 6 as his offer** (yes / confess / refuse). Lean: yes.
36. **Sam's lie at the tripod,** or the hall's cellar if he was given up.
    Lean: yes.
37. **The first two flashback pieces,** on the nights of key days 36 and 37.
    Lean: yes.
38. **A beat in the three-week gap before March** (Olstad away for the
    christening, the count on the hall, holes in the ice). Lean: yes.

## C2. April and the endings (`docs/april.md`)

39. **Breakup is Sat Apr 22** (Abraham's calendar). Lean: yes.
40. **The collection plate** is the town buying MC from Daniel. Lean: yes.
41. **Three ways to beat him** (Olstad, the town, the gun), one attempt only.
    Lean: yes.
42. **Escape with someone:** a catch for each companion. Lean: yes.
43. **The Daniel ending's epilogue:** the new tent, the hymnals, his real name
    said once. Lean: yes.
44. **"Four of six kept faith":** keep it, and add kept moments for Hollis and
    Ruth in March. Lean: yes.

## D. Order of work, once you've answered

1. **Merge** 0's branches.
2. **The canon fixes** (15–23) and the design holes (24–27): one small PR.
3. **The Daniel rewrite pass** (3, 12–14), with the red light on every scene.
4. **March.**
5. **April and the endings.**
