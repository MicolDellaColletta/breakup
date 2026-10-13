# The look (plan)

To-do 11. A plan to agree before anything is redrawn. **Leans** are my
recommendations; "Your call" marks the decisions.

## The direction in one line

**A 90s adventure game you found on a shareware disc in a pawn shop:**
low-resolution pixel art, a small palette, hard pixels, and a shop that looks
like Strange Antiquities seen through a CRT. Warm inside, black and blue
outside, and red from the neon.

## References, and what to take from each

- **Strange Antiquities** (the shop): the counter view, first person, the
  customer framed across the counter, shelves crowded right up to the edges,
  objects with weight and texture, tools laid out where your hands are, the
  catalogue as a real book. Warm lamp light.
- **90s VGA adventures** (Sierra, LucasArts, *I Have No Mouth*): painted
  pixel rooms, a dark frame, verbs reduced to clicking things.
- **Signalis, Lone Survivor, Faith**: what pixel art does with dread. Low
  detail lets the player fill in the face, the shape under the ice.
- **Twin Peaks**: red, wood panelling, the diner's warmth, the woods' black.
  Ordinary things lit slightly wrong.
- **Horses**: the stillness. Long holds on one picture.

## 1. Resolution and pixels

- **The world is drawn at 480x270**, and scaled up by whole numbers: x4 on a
  1920x1080 screen, x3 on 1440x810, x2 on 960x540. Every pixel stays
  square and sharp (nearest filtering, no smoothing).
- Lean: 480x270 rather than 320x180. 320 is truer to the period, but the
  shop needs room: 16 shelf spots, the window, a customer, the counter
  objects. 480 still reads as pixel art at x4.
- **The text stays readable.** The dialogue column and labels draw at the
  screen's resolution, not 480x270, in a pixel font at a size that reads
  comfortably (pixel-perfect at x2 or x3). The world is chunky; the words
  are crisp.
- **Your call:** 480x270 (lean) or 320x180.

## 2. Palette

- About **32 colours** for the whole game, chosen once and used everywhere,
  so every scene belongs to the same world. Gradients by dithering, not by
  more colours.
- The families:
  - **Night:** four blues, from black to the snow under moonlight.
  - **Neon:** two reds (the sign, its glow on snow and faces).
  - **Lamp:** three ambers (the shop bulb, the Gleaner, the furnace).
  - **Brass and wood:** four browns and golds (shelves, the register, the
    bell, the coat's buttons).
  - **Snow and paper:** three off-whites (snow, the ledger, the letter).
  - **The church:** cold white and pale green.
  - **Skin, hair, wool:** a handful.
- Each place leans on its family: the shop amber and brass, the nights
  blue, the church white, the Gleaner red and amber, the lake black.
- **When MC is frayed**, the palette slips: one colour swapped for its
  neighbour, the reds a shade off, never explained. (The unreliable narrator,
  in pixels.)
- Lean: start from an existing 32-colour palette made for this (dark,
  muted, warm/cold) and adjust it, rather than inventing from zero.

## 3. The shop, like Strange Antiquities

The counter view gets redrawn first: it's where most of the game is spent.

- **First person, behind the counter**, eye level. The counter top along the
  bottom third, close, worn wood and glass: the register (left), the ledger,
  the loupe on its cord, the bell (right), a cup of coffee going cold.
- **The front window in the middle**, the road beyond: snow, the lot, the
  neon's red on the snowbank, whoever's walking past. Weather and time of day
  change it (the light goes at four in November).
- **The customer stands across the counter**, between you and the window,
  lit from the side by the neon and from above by the bulb. Half-figure,
  big enough to read a face.
- **Shelves crowded to the edges**, left and right of the window: every spot
  holds a real object, drawn as a small sprite with a shadow, so the shelves
  look full and used, not like a grid. Labels, tags and dust.
- **Turning** (left wall, right wall, back shelf) are full pictures in the
  same style. The back shelf is darker, tags facing out.
- **Picking something up** brings it close: the object large, centred, on
  the counter's glass, with the tools beside it (the loupe, your hands; later
  the candle, the magnet). The close-up is where examining happens.
- **Light:** one warm bulb, the neon through the window, the lamp-glow on
  the glass. Shadows under every object.
- **The catalogue** opens as a book on the counter: two pages, Abraham's hand
  on the left, your blanks on the right.

## 4. Everything else

- **People:** half-figures at the counter (as above); small full figures in
  rooms and on the ice. Two or three expressions each (neutral, the turn,
  one more). Faces simple; eyes do the work.
- **Rooms** (the apartment, the back room, the church, the Gleaner, the
  cabin): one still picture each, painted in pixels, first person, with
  hotspots that glint faintly on hover. Long holds; nothing animates but
  snow, the neon, a bulb.
- **The nights:** the apartment in blues, the neon red at the window edge,
  the bowl, the painting. The thing out of place is drawn into the picture,
  small.
- **The map:** a hand-drawn pixel map of Kettle Lake, the lake taking up
  half, places as small buildings with lights that go out at closing time.
- **Title cards:** black, a pixel serif in off-white, like a silent film
  (as now, in the new font).
- **The drive:** the windscreen, wipers, the headlights on snow, in four
  colours.
- **Documents** (the letter, the notes, the money orders): paper textures,
  handwriting as a pixel script.

## 5. Text and interface

- **Fonts:** one pixel font for everything (dialogue, labels, buttons),
  one handwriting-style pixel font for documents and the catalogue's notes.
  Free, licensed fonts made for games. Lean: something like *m6x11*,
  *Pixel Operator* or *Silver* for text; to be tried at size before
  choosing.
- **Frames:** thin, dark, period-appropriate (a 1-pixel bevel, no rounded
  corners).
- **The dialogue column** keeps its place and behaviour; it gets the pixel
  font, a darker panel, and colours from the palette for each voice.
- **Your call:** the pixel font for the dialogue too (lean: yes, if it reads
  at length), or a clean font for long text and pixels for the rest.

## 6. A CRT, a little

- An optional screen effect (Settings, on by default): faint scanlines, a
  slight curve at the corners, a little bloom on the neon. Subtle; never in
  the way of reading.
- Lean: on by default, gentle; a setting to turn it off.
- **Your call:** on by default, or off by default.

## 7. Who draws what, and how it gets in

- **You paint the real art** when the story's done. Until then, the
  placeholder art drawn in code follows the same rules (480x270, the
  palette, hard pixels), so the game looks like itself early and the
  paintings slot in without redoing layouts.
- **Asset sizes** (at 480x270): rooms and the shop views 480x270; the
  counter-top strip 480x90; shelf objects 24 to 40 pixels; close-ups
  128x128; half-figures about 120x160; portraits for the column 48x48.
- **Files:** PNG, exact size, imported with no filtering; one folder per
  kind (`art/rooms`, `art/objects`, `art/people`, `art/ui`). A painted file
  replaces its code placeholder by name.

## What gets built, in order

1. **A style frame:** one mock-up of the counter at 480x270 in the palette
   (code-drawn), to agree on before anything else changes.
2. **The engine:** the world drawn at 480x270 and scaled by whole numbers;
   the pixel fonts; the palette as one shared file; the CRT effect.
3. **The shop** in the new style (counter, walls, back shelf, close-up,
   catalogue).
4. **The rooms and the nights**, then **the map, cards, documents, drive**.
5. **People**, last (they need the most care).

## Your calls

1. **480x270** (lean) or 320x180.
2. **A pixel font for the dialogue** too (lean: yes, if it reads at length).
3. **The CRT effect** on by default (lean: yes, gentle).
4. **About 32 colours**, adapted from an existing palette (lean: yes).
5. **A style frame of the counter first**, before anything else changes
   (lean: yes).
