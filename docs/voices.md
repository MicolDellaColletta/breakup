# Breakup: Voices

The voices in MC's head. They replace the separate `lean=` idea for
backgrounds: one system instead of two.

Inspiration: Disco Elysium's skills, without the numbers and dice.

---

## Who lives in MC's head

| Voice | What it is | Choices that feed it | Color |
|---|---|---|---|
| **Paranoia** | Fear, hiding, survival. The main voice. | fearful, careful, hiding | gold (existing) |
| **John** | Lying, playing the part, being John. | smooth, lying, in character | to pick |
| **Appraisal** | Noticing, weighing things and people. | observant, cold, precise | purple |
| **Warmth** | Kindness, guilt, reading people. | kind, soft, guilty | to pick |
| **Animal** | Body, instinct, the thing inside the skin. | loud, impulsive, physical | to pick |
| **???** | Not one of MC's voices. Or the player shouldn't be sure. | weird, obeying ??? | red (existing) |

**John** is the voice of the identity MC is wearing. The more MC lies well, the
louder it gets. At its strongest it could start saying things MC never knew,
which feeds the question of what ??? is.

## When they speak

- **The prologue is Paranoia only.** MC is running, alone and scared; fear
  drowns everything else out. No rewrites needed.
- **The others wake up on day one,** when MC stops running and has to live
  somewhere. When you hold still, the rest of your head comes back.
- A voice speaks up when it's strong enough. A strong Appraisal points out the
  stamp on the decoy; a weak one stays quiet.

## How choices shape them

Most choices look equal. There's no "right" one, and they lead to the same
place. What differs is **how they sound,** and each one quietly feeds the
voice it sounds like.

- **No numbers on screen, ever.** The player learns who MC is from which voices
  speak up and which colored choices appear.
- **The prologue doesn't feed any voice** except Paranoia, which starts high
  anyway.

### Colored choices

When a voice is strong enough, a special choice can appear, in that voice's
color and marked with its name:

> **[John]** "Ray mentioned you. Said you'd come in."

- **Unlocks at 3 points.** One point per choice that feeds it. A player who
  leans into one voice sees its first colored choice during day one; a player
  who spreads their choices out sees it later, or not at all. Tune once we know
  how many choices a day has.
- **It stays unlocked,** as long as that voice is still the strongest of the
  ones eligible in that moment (see the next point).
- **At most one colored choice per moment.** If two voices both have a special
  option in the same scene, only the stronger one shows. On a tie, the scene
  decides which one it offers.
- **It's the same color the voice speaks in,** so the player links the purple
  choice to the purple voice without being told.
- **Static until hovered.** Normally it's just colored text. On hover, the
  letters move gently (a slow wave). Subtle, never flashing.

### Paranoia is different

Paranoia **never gets a colored choice.** It's the baseline, always there. When
it's high, it **talks over** the other voices instead: more Paranoia lines,
fewer from the rest.

### ??? is its own track

Following ??? doesn't strengthen a voice; it's MC slipping.

- Choices that obey ??? (or are just *wrong* in a way only ??? would want) feed
  the ??? track.
- When it's high enough, a **??? choice** can appear: dark red, typed slowly,
  maybe a little broken. It follows the same one-per-moment rule, and wins
  over the others.

## Frayed

A state, not a voice. Unsettling items and broken rules fray MC (see
`day_one.md`).

- **When frayed, the voices give bad advice.** You can no longer trust your own
  head.
- **??? gets louder** and starts drowning the others out.
- Rest, keeping the rules, or small comforts bring MC back. (To design.)

## Backgrounds

MC's past isn't picked from a menu; it comes from which voices MC listens to.

| Background | Comes from |
|---|---|
| **Guilt**: escaping something they did. | Warmth |
| **Debt**: they owe someone. | John (talking your way out of what you owe) |
| **Witness**: they saw something. | Appraisal (you noticed too much) |
| **Insanity**: lost time, gaps in memory. | the ??? track, plus being frayed |

**Animal** doesn't map to a background. It's about *how* MC acts, not what
they're running from. (Open question below.)

## In the story files (later)

A choice that feeds a voice:

```
> Tell her you were sorry to hear. -> widow_kind | lean=warmth
> Ask what it's worth to her. -> widow_price | lean=appraisal
```

A colored choice, only shown when John is unlocked:

```
> [John] "Ray mentioned you. Said you'd come in." -> widow_lie | needs=john
```

A voice line that only appears when the voice is strong:

```
appraisal | if=appraisal>=2: The stamp on the bottom. It isn't his.
```

That last one needs conditions on lines, not just on choices. Small to build.

---

## Open questions

- [ ] Colors for John, Warmth and Animal.
- [ ] Does Animal feed a background, or stay outside them?
- [ ] What brings MC back from frayed?
- [ ] Is "frayed" shown to the player, or only felt? (Also in `day_one.md`.)
- [ ] First test: rewrite the widow scene in `story/day_one.txt` with the voices,
      on paper, and see how it reads.
