# The nights, redesigned (plan)

To-do 4, from `review.md` section 5. A plan to agree before building.
**Leans** are my recommendations; "Your call" marks the decisions.

## What's wrong now

Every night is the same eight stops in any order: radio, bowl, windows,
dresser, painting, locked door, back door, bed (and some nights the phone,
then the dog at three). About eight choices a night are the same four rules
with a line changed. Order doesn't matter. Nothing builds up except fray. The
dresser, painting and locked door are one line of flavour each, every night,
whether there's anything new or not. (Skipping a rule used to be free; that's
fixed: unchecked rules break at bed.)

The routine itself is right: it's the ritual, and repetition is the point.
What's missing is **drift**: the ritual staying the same while what's around
it, and the rules themselves, quietly change.

## The idea in one line

**Same ritual, one thing different every night, and the rules don't stay
the rules.**

## 1. Fewer stops, each one earning its click

- The four rules (radio, bowl, windows, back door) and bed stay every night.
- The dresser, painting and locked door only show when they have something
  new tonight (an `if=` on the hotspot). Most nights, one of them does; some
  nights, none.
- Lean: a typical night goes from about ten clicks to six or seven, and every
  click past the rules is news.

## 2. Something out of place, every night

One thing in the apartment is wrong when you come in, and the narration
doesn't say so. Clicking it plays a short beat (sometimes a choice); walking
past it costs nothing, and you never learn what you missed.

- Examples: the bowl is on the line before you've filled it; the radio's on a
  station you don't remember tuning; one window latch is open and you know
  you closed it; your coat's on the wrong hook; the painting's crooked, and
  when you straighten it, the figure on the ice is a little closer; two cups
  in the sink; the notebook open at a page you haven't written yet.
- Each has a plain reading (you did it and forgot; someone with a key) and a
  folk one. The narrator is unreliable about it ("You're almost sure you
  closed it").
- Lean: drawn as a slight change in the room art plus a hotspot, one per
  night, from night 4 on (the first three nights stay as they are).

## 3. The rules change: three new notes

Over the season, three notes amend the letter. Each is a real choice: obey
the letter, or the note.

| When | The note | Where | The choice |
|---|---|---|---|
| **Week two, night 8** (Oct 14) | *"5. Feed the dog. At the back door. Not upstairs."* | On the kitchen table, in **your own handwriting** | The bowl in the kitchen (as the letter says) or at the back door. At the back door: prints in the snow in the morning, a dog's, then not quite a dog's. In the kitchen: the stairs at three, as now. |
| **Week three, night 10** (Oct 23) | *"9. Don't let the furnace go out."* | Pinned to the steel door, in **the owner's hand** | Go down in the dark and feed it, or don't. Unfed: a cold morning, a crack in something on the shelf (a real item, the hand mirror), and the next night someone has fed it for you. |
| **November, night 13** (Nov 5) | *"1. Leave the back door unlocked. LOCK IT NOW."* | Scratched into the frost on the inside of the back door's window | Rule one against the note. Two weeks before Daniel arrives. Locking it keeps out whatever's coming, maybe, and breaks rule one; leaving it keeps faith with the letter. |

- Two explanations every time: MC writing in his sleep (the first note is
  his own hand); someone with a key (Olstad has one; Ruth knows her father's
  handwriting); or the shop.
- Lean: the notes are **documents** (readable in your pockets, like the
  letter), and the rule they add or change is real from then on: the night's
  rule stop follows the note, and `rules_broken` records which version you
  broke.
- **Your call:** who wrote them. Lean: never said. The first is MC's own
  hand, the second Abraham's (who is dead), the third no one's. The player
  should feel the ground move under the rules.

## 4. Some nights, the order matters

- The night radio sometimes gives an instruction, softly, between hymns:
  *"Tonight, friends, see to your doors before your windows."* Following it
  changes the end of the night (the dog, the call, the morning line).
- Nights 9, 12 and 14 only (once a week). Never explained; easy to miss if
  the radio's off, which is its own cost.
- Lean: a small "order" record per night (the stops in the order you
  clicked them), and one condition, `order:back_door<windows`.

## 5. Consequences that build up

Each rule keeps a **tally** of how many times it's been broken
(`broken:dog>=2` in story files). Things come back days later:

| Rule | Once | Twice or more |
|---|---|---|
| **The radio** off | Silence (as now) | The silence talks: ??? in the quiet, a line that knows where you are (??? +1) |
| **The bowl** left | The stairs don't come (as now) | Scratching at the bedroom door at three. Then a night when the bowl is licked clean anyway, and you didn't fill it |
| **The windows** open | Snow on the sill in the morning | A handprint on the inside of the glass, at your height. Your hand fits it |
| **The back door** locked | A line from Olstad at the counter ("Locked up, Johnny?") | Something left on the back step in the morning: a dish, a scarf, a dog's bowl that isn't yours |
| **The phone** answered | As now | As now (the calls already escalate) |

- And the other way: **a week of rules kept** earns a quiet reward (a warmer
  morning line; Mrs. Hollis noticing; the dog resting its head on the bed).
- Lean: tallies live in `GameState` (saved), so the counter, the map and
  Daniel can read them too.

## 6. Something you do alone in November

Daniel's January line, *"something you did alone in the apartment in
November"*, needs something only the player did.

- Lean: **the notebook** (built: `has:notebook`). From November, the dresser
  stop offers a line to write each night, a choice of two or three (what you
  saw; what you're afraid of; a name). Daniel quotes one back, word for word,
  in January. Two explanations: he's been in the apartment (the back door is
  always unlocked), or ??? told him.
- Without the notebook: what you did instead (sat up in the armchair facing
  the door; left the radio on all night; stood at the window at three).

## 7. Nights that break the ritual

Twice in the season, the ritual can't be done the normal way:

- **The power cut** (week three, ties to the fuse box, shop step 8): the
  radio can't play, so rule seven can't be kept without going down to the
  fuse box in the dark. Which switch? (The neon, the freezer, the upstairs
  room.)
- **The frozen latch** (November): one window frozen open, can't be shut.
  Rule one broken whatever you do, unless you think of the tape from the
  fuse box. (Small object puzzle; ties to shop step 4.)

## Nights 1 to 15: what each gets

| Night | Already unique | Adds |
|---|---|---|
| 1-3 | First night; the broadcast; Friday static | Nothing (they work) |
| 4 | The phone | Out of place: the bowl already on its line |
| 5 | Sunday; the phone | The radio on a station you didn't tune |
| 6 | The light under the locked door | Out of place: two cups in the sink |
| 7 | The John night | Nothing (it's the big night) |
| 8 | The call | **Note one** (the bowl at the back door); out of place: your coat on the wrong hook |
| 9 | Church night | Order: "doors before windows"; tally payoffs start |
| 10 | The train | **Note two** (the furnace) |
| 11 | The double hour, the tin | (Full night already) |
| 12 | Halloween | Order; out of place: the painting closer |
| 13 | The radio caller | **Note three** (lock it now) |
| 14 | The fitting; the wipers | Order; the notebook line |
| 15 | The payphone | The notebook line; tally payoffs on the eve of Daniel |

The power cut and the frozen latch wait for shop step 8 and Thanksgiving
week; they're listed so they're planned for.

## What gets built

1. **Engine:** rule tallies (`broken:rule>=n`), the night's click order
   (`order:a<b`), hotspots that hide when they've nothing new, notes as
   documents that switch a rule's stop to its amended version. Tests.
2. **Content:** nights 4-15 per the table; the three notes; the tally
   payoffs; the notebook lines from November; the morning lines that show
   what happened.
3. **Docs:** `voices.md`/`story.md` updated with the amended rules.

## Your calls

1. **The three notes:** the bowl at the back door (Oct 14), the furnace (Oct
   23), lock it now (Nov 5)? Lean: yes.
2. **Who writes them:** never said; MC's hand, Abraham's, no one's? Lean: yes.
3. **Order on three nights only,** given by the radio? Lean: yes.
4. **The notebook** as the thing Daniel quotes in January? Lean: yes.
5. **Flavour stops hide** when there's nothing new? Lean: yes.
