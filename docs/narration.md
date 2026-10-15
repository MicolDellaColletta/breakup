# The narration rewrite

Oct 15. From the to-do list: **less reliable, more cryptic, fewer tics.** This
is the plan, with your calls. Nothing has been rewritten yet.

## What's there now (counted)

- **4,897 narration lines** across 101 story files. The inner voices
  (paranoia 809 lines, appraisal, warmth, John, animal) are almost clean of the
  tics; the problem is the narration.
- **The tics, in narration lines:**

| Tic | Count | Example |
|---|---|---|
| "as if" | **232** | "She pushes them back toward you, very gently, as if they might go off." |
| "the way you'd …" | **92** | "Her face closes. Not slams. Closes, carefully, the way you'd close a door on someone sleeping." |
| "the way …" (other) | ~200 | "…the way her grandfather does." |
| "like a …" | 132 | "…like a man tasting something." |
| "X. Not Y." fragments | 114 | "Not a fire. Not a shop. Not a town." |
| "for the first time" | 33 | |
| "Nobody …" | 256 | (fine as a voice, but it piles up) |

Many of these lines are good on their own. The trouble is the rate: one simile
every few lines, all built the same way, each one explaining what the thing
means. A reliable narrator explains. An unreliable one reports, and leaves you
the gap.

## What changes

**1. Fewer tics.** Every "as if" and "the way you'd" line gets looked at. Most
lose the simile, or keep a hard, concrete one with no explaining tail.

- Before: *"She pushes them back toward you, very gently, as if they might go
  off."* After: *"She pushes them back toward you with two fingers."*
- Before: *"He stares at you as if you'd slapped him."* After: *"He stares at
  you. One cheek has gone red."*
- Before: *"Her face closes. Not slams. Closes, carefully, the way you'd close
  a door on someone sleeping."* After: *"Her face closes, carefully. Somebody's
  asleep in there."*

**2. More cryptic.** Narration stops telling you what things mean. It reports
what's there, in order, and stops a beat early. The voices still interpret
(paranoia spirals, appraisal reads, warmth hopes); that's their job, and it
keeps the meaning on the page. It now belongs to someone you can doubt.

- Before: *"…a sermon he must have recorded on Sunday."* After: *"…a sermon.
  It's Thursday. He preaches on Sundays."*

**3. Less reliable.** Three layers, all with what the engine already has (no
new code):
- **Slips.** About 15 small facts the narration states and the game later
  contradicts, without saying which is true. Some examples:
  - The bowl's full at night; in the morning you remember filling it, and it's
    dry.
  - The colour of the stranger's coat changes between day 3 and Olstad's day
    13.
  - The door you're sure you locked.
  - Ruth says "you came in on a Tuesday" (it was a Monday).
- **Frayed narration.** When you're frayed (or ??? is strongest), some lines
  change, about two a month: `narration | if=frayed`. The narration sees
  something that isn't there, and the next line, or someone else, doesn't see
  it.
- **Retractions.** Now and then the narration takes something back. *"The
  door was locked. You'd swear to it."* *"Three knocks. Two. You counted
  three."* Rare: a few a month, so they land.

## Your calls

1. **Scope.** A targeted pass (every tic line, the explaining tails, the slips
   and the frayed lines; about 700–900 lines touched, the plain lines left
   alone), or rewrite every narration line?
   **Lean: targeted.** Most plain lines already work, and rewriting all 4,897
   risks flattening the voice you liked.
2. **The tic budget.** How many "as if" / "the way you'd" survive?
   **Lean:** about 25 of each, kept where they're the best line in the scene.
   "X. Not Y." goes down to about 30. "For the first time" goes down to about
   8.
3. **Unreliability: how much, and does the game ever settle it?**
   **Lean:** all three layers (slips, frayed lines, retractions), never
   settled outright. But every slip has one character who saw it differently,
   so a careful player can triangulate. That's the same rule as the loose
   ends: at least one concrete reading exists.
4. **Who interprets.** Should narration stop explaining meaning and leave it
   to the voices?
   **Lean: yes.** Narration reports. Paranoia, appraisal and warmth
   interpret. The voices stay as they are (paranoia's run-ons are character).
5. **Daniel.** His dialogue was rewritten in v7.
   **Lean:** leave his lines alone, and rewrite only the narration around him.
6. **Endings, bridges and cards.**
   **Lean:** included. The cards stay the town's voice (title-card flat), and
   the endings get the lightest touch.
7. **A sample first.**
   **Lean: yes.** I'll do the prologue, day one and night one first, before
   and after side by side, for you to read before the rest goes ahead. Taste
   is the whole job here.
8. **How it's built.**
   **Lean:**
   - The sample, then your notes.
   - Then four writers by month, on a new branch.
   - Then one reader goes through the whole season for consistency: the same
     MC, the same rate of slips.
   - Tests check about 390 exact strings, so the writers keep those lines'
     key words, or the test is updated in the same pass.
