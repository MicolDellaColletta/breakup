# Breakup: The shop, redesigned

A draft for discussion. Nothing here is built yet. Change anything. Written
October 12 after an honest review of what the shop is now; checked against
`pillars.md` (the rule of two explanations), `underneath.md`, `forks.md`.

---

## Why

Right now the shop is scenery around a visual novel:

- **21 objects in the game, 7 for sale.** The rest arrive when the plot says.
- **8 "find something on the shelves" moments in 15 days,** most in days one to
  three. After week one the counter is people talking while you click
  Continue.
- **Money does nothing.** $150 a week in, almost nothing out.
- **You never choose what the shop holds.** No buying, no choosing between two
  things, no shelf you can't fit everything on.
- **Close-ups rarely decide anything.** The one exception, June's music box
  (three candidates, two clues, the right one sings and has her name), is the
  best scene the shop has. **That scene is the model for all of this.**

## The new shop in one breath

A small occult-adjacent antiques game in the *Strange Antiquities* mould:
**objects have stories and properties you uncover; people come with problems,
not item names; you work out which object answers them; you fill the shop by
going out into the town and choosing what to bring back.** Every object has a
folk answer and a plain one. The game never says which is true.

---

## 1. The screen

### The main view: the shop from behind the counter

- **The front window in the middle**, its three display spots on the ledge,
  the road beyond it (who's walking past, the weather, the dark).
- **Shelves on either side of the window**, objects drawn on their spots, the
  same placeholder art as now.
- **The counter along the bottom**: the ledger, the bell, the register, the
  counter drawer.
- Everything clickable: pick up, put down, examine, move.

### Off screen

- **Turn left / turn right:** the side shelves along the walls (more stock than
  fits in the main view). Arrows at the edges, like the apartment.
- **Turn around:** the back shelf, held things, tags facing out. The tin lives
  here.
- **The hallway, the office, the back room** (below), through the door behind
  the counter.

### Hidden places

- **The counter drawer** (built: the shells). Gets a **false bottom**, found by
  noticing the drawer is shallower inside than out.
- **Abraham's desk in the office:** a locked drawer; the key's on a nail
  behind the calendar upstairs.
- **Under the floor of the window display:** a loose board, Abraham's real
  takings book (the money the church paid, year by year).
- **Inside the bear** (below).
- Hidden places hold objects, documents, and clues to the main plot.

### "Next customer"

- **Customers don't walk in on their own any more.** Between visits, the shop is
  yours: look round, examine, rearrange, read the catalogue, go to the back.
- A button at the counter: **"Next customer"** (or the bell going, if you'd
  rather it came to you). Press it when you're ready. Someone's always waiting
  outside, stamping their boots.
- Some days a customer comes in *while* you're in the back room: the bell, and
  you have to go and see who it is.
- Time passes per customer (as now), not per click: exploring is free, so
  nobody's rushed into a wrong answer.

## 2. Objects

### What an object knows about itself

Each object in `stock.cfg` gets **properties**, hidden until found:

| Property | Found by | Example |
|---|---|---|
| Tag and ledger line | Reading the tag, the ledger | 0311, "M. Sundqvist. Held." |
| Marks | The loupe | Initials, a maker's stamp, a church mark (four lines crossed) |
| Material, age | Handling, the loupe | Bone, not ivory; prewar brass |
| Warmth | Touch | Rule 2: still warm |
| Sound | Winding, shaking, knocking | It sings; it rattles; it's hollow |
| Smell | Close up | Lake water, lanolin, gun oil |
| Mechanism | Working it | A hidden compartment, a key, a stopped hand |
| Story | Puzzles, people, the ledger | Whose it was and what happened |
| **Folk use** | People, the catalogue | "It points to the drowned." |
| **Plain use** | Examining, Sam, Appraisal | "Two iron nails behind the painting." |

### The catalogue

**Abraham's book**: the ledger's back half, his own notes on objects in a
small careful hand, half folk belief and half appraisal. MC fills in the
blanks as properties are found. It's the reference you check a customer's
problem against, and a document of the town (what Abraham believed, what he
knew).

### Tools, unlocked over time

- **Loupe** (day one, in the counter drawer): marks, stamps, initials.
- **Candle** (the church, week two): watermarks in paper, wax seals.
- **Magnet** (Sam): iron, what the compass is reacting to.
- **Radio dial** (Ezra's, or the church's): objects that make the radio hum.
  Plain answer: metal, interference. Folk answer: they're listening.
- **Seam ripper** (the Lunds', week two, from the coat): what's been sewn
  into things.

### Objects with puzzles inside them

Not every object, but the good ones, each a short close-up puzzle:

- **The music box** (built): open the lid, wind the key, read the name.
- **A pocket watch stopped at 5:27.** Open the back: a photograph, folded,
  of a man on the ice. The date on the back is the 1989 Keeper's.
- **A cigar box with a combination lock**: the combination is a hymn number
  sequence from the Thursday broadcasts.
- **A family Bible with every page of one verse cut out**: put the cuttings
  (found elsewhere) back in order. Leviticus 16.
- **A child's slate**: chalk rubbings under the paint, the rhyme, a different
  name at "nine".
- **A camera with film still in it** (Ruth's old one): develop it at the
  pharmacy, two days later: the Gleaner's cellar in 1989.

## 3. People bring problems, not names

- *"Something to keep my boy off the ice."* *"Something my mother sang to."*
  *"Something that'll make him stop calling."* *"Something Ray would have
  wanted buried with him."*
- You check the problem against the catalogue and the shelves, examine,
  decide, and hand it over (or say there's nothing).
- **The right object:** money, faith with that person, a line in the ledger,
  sometimes a clue.
- **The wrong object:** they notice, or worse, they don't; the town's eye, fray,
  faith lost, a story going wrong (a boy on the ice with the wrong charm).
- **Two answers for every need:** the folk answer (the object they believe in)
  and the plain answer (the object that would actually help). Sometimes
  they're the same object. Often not. **Choosing between belief and use is
  the shop's moral core**, and the town's spine (`pillars.md`: belief, and the
  abuse of belief).

## 4. Getting stock

### People give

- Gifts (the hotdish, the fry bread, the birch: now some of them are objects).
- Pawns (as now, with appraisal, below).
- **Legacies:** when someone in town dies, their things come to the Keeper.
  The town expects it.
- Daniel, from November: he brings things. Always paid for, exactly.

### Found around town

- **Walk-around days** (Sundays, the lake) get findable objects: in the
  church's lost property, on the shore, in the snow by the poles.
- **After thaw** things wash up (late game).

### Buying trips (the evening map)

- New sources on the map, each offering **two or three objects, take one**:
  - **The church basement**: last year's Keeper's things, boxed. (Thomas's.)
  - **Walt's attic**: Ida's things, which he can't keep and can't throw away.
  - **The dump** at the end of the lake road.
  - **Teague's trapline**: furs, skulls, things from the ice.
  - **The jumble sale** before Thanksgiving.
  - **The Gleaner's cellar** (if Ruth's door is open).
- Cost: money (now the $150 a week matters), a favor, an hour of the evening,
  or a rule (it's still warm).
- **Shelf space is limited.** Choosing what to keep is part of it.

## 5. Pawns become appraisals

- Someone brings something in. You examine it: **real or fake, what it's worth,
  whose it was.** Appraisal speaks up (strong Appraisal sees more).
- Then the loan, and **rule 3: every item gets a price** (a real decision when
  the item is a braid, or a name).
- Wrong appraisals cost money, or worse: a stolen thing in the shop, Olstad's
  book.

## 6. The window

- Three spots, seen from the road (built).
- What's in it **draws certain people** (built, day three) and **tells the town
  something about the Keeper** (new: the town's eye, a real count). A knife in
  the window, the coat-button in the window, June's drawing: each says
  something.
- Changes any time you're behind the counter, not only Fridays.

---

## 7. The shop explorable

Rooms, all point and click (the shop scene by day, the night scene by
night):

| Room | What's there |
|---|---|
| **Behind the counter** (main view) | Window, shelves, counter, drawer (false bottom), register, ledger, the phone |
| **Side shelves** (left, right) | More stock; the bear in the corner; the fox |
| **Back shelf** (turn around) | Held things; the tin; the jar of teeth |
| **Hallway** | The fuse box; the stairs up; the steel door |
| **Office** | Abraham's desk (locked drawer), the calendar, the carbons, the safe |
| **Back room** (new, explorable) | Crates, Abraham's taxidermy bench (tools, glass eyes in jars, wire), the furnace, the back door, **the freezer** |

### The back room

- Behind the steel door. Cold. The hum, loud now.
- **Abraham's workbench:** the tools he mounted the fox and the ram with (and the
  bear, twice). Glass eyes in a baby-food jar, sorted by size. A half-finished
  mount of something small. Things to examine; tools to take (the seam ripper
  is here, not at the Lunds', if that's simpler).
- **Crates:** unsorted stock. Opening one is a small buying trip that costs
  nothing but time; what's inside is a surprise.
- **The furnace:** feed it, or the shop gets cold (and some objects crack).
- **The back door:** rule one, as now.
- **The freezer** (below).

### The freezer

- **Padlocked.** A heavy padlock, new, not Abraham's. (Olstad's: she locked it
  on October 4, `forks.md`. The town would say the shop locked it.)
- MC can't open it. MC can listen at it, put a hand on it (cold, colder than
  it should be), notice frost on the outside of the seal, see boot prints that
  go in and don't come out (night one).
- **The key:** a spare, sewn into **the bear's second seam** (Teague, week three:
  *"You don't do that for a bear. You do it to get at something."*). Found
  with the seam ripper and the loupe, once MC knows to look.
- **Gated to December** (`story.md`: the freezer is a set piece, not before
  December): the seam can be found earlier, but it's stitched too tight to open
  until the seam ripper; or the key's there but the padlock's frozen shut
  until the furnace has run hot for a week. Either way, December.
- **Inside:** Abraham, sitting on a crate, his coat buttoned, frost on his
  eyebrows, as if he'd sat down to wait. (`forks.md`: he walked in himself.)
  Two explanations, as always: a frightened old man who believed it, or the
  shop that took him.
- What MC does then is a fork: tell Ruth (kept faith with Ruth, the cruellest
  kind thing), tell Olstad (she already knows), close the door and lock it
  again.

### The fuse box

Three switches, taped down. Label: **SHOP LIGHTS. DON'T.** (built). They need
to do something:

| Switch | What it actually runs | Turning it off |
|---|---|---|
| 1 | **The neon sign** | The shop goes dark from the road. To the town, an unkept shop. Someone comes to check within the hour (the town's eye; at night, rule territory). |
| 2 | **The freezer** | The hum stops. The silence is enormous. In a day, water under the steel door. Olstad comes, fast, and turns it back on herself without a word. (She knows what's in there.) |
| 3 | **The upstairs room** (Ruth's old room, the locked door) | The light under the locked door (night six) goes out and stays out. Plain answer: a lamp on a timer, on this circuit, Abraham's doing. Folk answer: something in there switches it on. |

- **Finding which is which** is a small puzzle: flip one, see what goes dark;
  the label on the inside of the fuse-box door, in Abraham's hand, faded.
- **It explains a mystery** (the light under the door) and **opens a cost**
  (the freezer).

---

## 8. Objects: a first list

About thirty-five, mixing what's built with new. Folk use / plain use; *story*
where it touches the plot.

| Object | From | To discover | Folk | Plain | Story |
|---|---|---|---|---|---|
| Duck call (built) | Shelf | R.H. carved; it sounds like a mallard | Calls the drowned back | A good duck call | Ray Hollis |
| Decoy (built) | Shelf | Club stamp underneath | Brings luck to a blind | Club property | |
| Skinning knife (built) | Shelf | A.K. '98, KEEPER scratched | The last Keeper's | A good knife | Last winter's Keeper |
| Snowshoes (built) | Shelf | Frame stamp | Walk where ice won't hold | Spread weight | |
| Ice picks (built) | Shelf | Cord, bent spike | Save you from the lake | Save you from the lake | Cody |
| Compass (built) | Shelf | Swings to iron | Points to the drowned | Iron nails, freezers | The painting |
| Fox (built) | Shelf | Bad work, eyes too deep | Watches the road | Amateur taxidermy | Who mounted it |
| Rifle (built) | Back | 0431, Ray's | | | Ray pawned it the week he went |
| Tin (built) | Back | 0527, padlock | | | The books (hard fork 2) |
| Music box (built) | Back | Sings, "Marta" | Calms the restless | A music box | June's mother, 1993 |
| Hand mirror (built) | Back | J.M. | Shows you late | Old silvering | |
| Pocket watch (built) | Back | Maker's name | | | |
| Jar of milk teeth (built) | Back | Initials, years | For the church | For the coat | The underneath |
| Braid (built) | Back | Red wool | | | Hanna; the coat's hem |
| Brass button (built) | Back | Brown wool in the shank | | | Thomas, under the ice |
| Flattened bullet (built) | Back | Warm | | | The sixth bullet |
| **Thomas's scarf** | Church basement | Hand-knit, a name tag: Thomas + another name | Keep it, he'll keep you warm | A scarf | Thomas and his friend (Olstad burned the photos) |
| **Ida's sewing tin** | Walt's attic | Bronze hairpins, a church card | | | The coat; Ida sewed coats |
| **A child's slate** | School jumble sale | Chalk rubbings: the rhyme, a different nine | Teaches the rules | A slate | The rhyme changes each year |
| **Stopped pocket watch** | The dump | 5:27; a photo inside | Stops when someone drowns | Broken spring | The 1989 Keeper, "David" |
| **Hymnal with notes** | Church lost property | Numbers circled in the margins | | | The Reverend's code (rules as hymns) |
| **Wolf skull** | Teague | Drilled for a cord | Keeps the dead from following | Decoration | |
| **Lantern** | The shore | Burned, lake weed in the frame | Lights the way out on the ice | A lantern | The first-ice party |
| **Cigar box, combination** | Back-room crate | The combination is hymn numbers | | | Abraham's takings |
| **Rosary of bone** | A pawn | Bone, not ivory; a child's | Prays for a Keeper | A rosary | Someone's child, 1958 |
| **Family Bible, cut** | Legacy | One verse cut from every page | | | Leviticus 16 |
| **Snow globe** | The jumble sale | The church inside; a tiny figure on the lake | A good-luck charm | A souvenir | Made in 1989 |
| **Ruth's old camera** | Gleaner cellar | Film still inside | | | The cellar, 1989 |
| **Glass eyes, jar** | Back room bench | Sorted by size, one pair human | | | Abraham's work; the bear |
| **Seam ripper** | Back room bench | | | A tool | Opens the bear's seam |
| **Freezer key** | Inside the bear | Brass, new | | | December |
| **Daniel's matches** | Daniel | A matchbook from a Wasilla motel | | | Where he stayed |
| **Hollis jacket** (built) | Stranger | Warm | | | Ray |
| **Wreath ribbon** | The poles | Red wool, Hanna's | Marks the place | A ribbon | The poles |
| **Olstad's spare key** (built) | Olstad | Red tag | | | The back door |

## 9. What happens to days 1 to 15

- **The story beats stay.** Every visit that's a conversation keeps its
  conversation; most get a problem to solve around it.
- Day one: the widow's duck call is already the right shape (a need, the
  shelves, the initials). Cody's ice picks become a folk/plain choice. Olstad's
  tin, Walt's silver (an appraisal).
- Day three's June stays as the model. Week two's Ezra becomes the
  "usual" as a learned habit (you've found the false bottom). The fitting week
  adds the seam ripper.
- Each week gets **one buying trip** on the map, and **one object puzzle** in
  the shop or the back room.

## 10. Build order

1. **The screen:** the main view (window in the middle, shelves around it),
   turn left / right / around, "Next customer". The back room as a room.
2. **Objects:** properties in `stock.cfg`, the catalogue, the loupe; examine
   reveals properties; the catalogue fills in.
3. **Requests as matching:** customers ask for needs; story files map a need to
   right/wrong answers (folk, plain, wrong).
4. **Getting stock:** buying trips on the map; finds on walk-around days;
   legacies; shelf space; money matters.
5. **Appraisal** for pawns.
6. **The fuse box, the freezer, the bear, hidden drawers.**
7. **Rework days 1 to 15** around the new shop.
8. The second pass from the review: the nightly rules varied, flags paid off,
   faith and the town's eye as real counts.

## Open questions

- [ ] **"Next customer": a button, or the bell?** (Lean: a button that says what
      it does, *Open the door*, and the bell when it's pressed.)
- [ ] **Does exploring cost time?** (Lean: no. Only customers, trips and puzzles
      that say so.)
- [ ] **The freezer key: in the bear, or with Olstad?** (Lean: a spare in the
      bear; Olstad has the other. Getting hers is a kept-faith moment.)
- [ ] **The fuse box: can the freezer switch be turned off before December?**
      (Lean: yes, and Olstad turns it back on within a day, saying nothing. The
      first time the player sees her know.)
- [ ] **How many objects by the end?** (Lean: 35 to 40 across the game, about 15
      in the shop at any one time.)
- [ ] **Folk vs plain answers:** does the game ever reward the folk answer more
      than the plain one? (Lean: sometimes. The town rewards belief. That's the
      trap.)
