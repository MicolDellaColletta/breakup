# Breakup: The voices

MC isn't alone in their head. Like the skills in Disco Elysium, parts of MC's
personality speak up, notice things and give advice. Some of that advice is good.

## The five voices

| Voice | What it is | Sounds like |
|---|---|---|
| **Body** | Cold, hunger, pain, instinct, what the hands remember | "Your arms remember carrying it. They won't tell you from where." |
| **Mind** | Reasoning, noticing details, connecting clues | "Before dawn, hidden, talking to them. Not with a gun." |
| **Feeling** | Empathy, guilt, reading people | "She hasn't said he's dead. She won't be the first to say it." |
| **Tongue** | Lying, persuading, being John | "Next time, sign it fast. Like it's nothing. Like it's yours." |
| **Paranoia** | Fear, staying hidden, survival | "She'll remember that. They always remember the lie, not the face." |

**??? is not a voice.** It sits outside the system. It isn't one of MC's aspects,
or at least the player should never be sure.

Colors and names live in `story/speakers.cfg`.

## How strong they are

Each voice has a strength, kept in `GameState.voices`. Everyone starts at 1,
Paranoia at 2 (MC has been running for a while).

**The player never sees the numbers.** They see what the numbers do:

1. **Strong voices speak up.** A line can need a voice to be strong enough:
   `mind | if=mind>=2: ...`. A weak Mind just stays quiet, and the player never
   knows what they missed.
2. **Strong voices open choices.** `> "I knew Ray." -> widow_lie | voice=tongue | if=tongue>=2`
   shows up as **[TONGUE] "I knew Ray."** in Tongue's color, only for a Tongue
   that's strong enough.
3. *(Idea, not built)* A page in the pockets that describes MC in words:
   "Your tongue is quick these days. Your body feels like someone else's."

## How they grow

Following a voice makes it stronger: `| grow=tongue` on a choice or a line.

Examples in the game so far (placeholders, change freely):

- **Drive:** taking the job offer out of the coat → Mind. Leaving it → Paranoia.
- **Mrs. Hollis:** answering to "John" → Tongue. Saying nothing → Paranoia.
- **Mrs. Hollis:** taking Tongue's lie → Tongue again.

So a player who reads the job offer has a Mind strong enough to get the duck call
hint from Mind. A player who answered to John gets Tongue's lie as an option.

## What the voices shape

### The background
Instead of tagging choices as guilt / witness / debt / insanity, the background
grows out of **which voices MC listens to**. One possible mapping:

| Strongest voices | Reads as |
|---|---|
| Feeling | **Guilt**: escaping something they did |
| Mind (+ Paranoia) | **Witness**: they saw, or noticed, too much |
| Tongue (+ Body) | **Debt**: they owe, and talked their way out until they couldn't |
| Paranoia + being frayed | **Insanity**: lost time; they don't know why they ran |

To decide: the real mapping, and at what point in the game the background
"settles".

### Being frayed (not built yet)
When MC is frayed, the voices start giving **bad advice**, and ??? gets louder.
You stop being able to trust your own head. This is the insanity background felt,
not told.

## Open questions

- [ ] Final names: keep Body / Mind / Feeling / Tongue, or evocative names
      (Disco style: "Half Light", "Electrochemistry")?
- [ ] The background mapping above.
- [ ] Do items grow voices too (a knife for Body, a ledger for Mind)?
- [ ] The "describe MC in words" page: yes or no?
- [ ] How bad advice works when frayed: a different line, or the same voice lying?
