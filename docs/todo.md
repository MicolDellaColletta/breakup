# To do next

The running list of what's next, in order. The shop redesign has its own
step-by-step list (`shop.md`, "To do"); this is everything around it.

## Pick up here (Oct 14, evening)

**The season is written end to end** (prologue to breakup and May), and
every ending can be reached by playing (`routes.md`).

**Branches to merge, in order:**
1. `night-walks`
2. `february`
3. `full-review`
4. `red-light`
5. `canon-fixes`
6. `daniel-rewrite`
7. `march`
8. `april`
9. `endings`
10. `routes`

**Your notes from playing (Oct 14), for next week.** More to come once you
finish the playthrough. Not started yet.
- [ ] **Some dates are still wrong.** Every `DAY_DATES` entry and every file
      header's weekday is right. What's wrong is inside the bridges and lines
      (checked Oct 14):
      - `bridges.txt:249` "Saturday. March. … Seven weeks.": the clock lands on
        Sat Feb 26, not March, and that's eight weeks. Make it "Wednesday.
        March." (Mar 1), or move the card.
      - `bridges.txt:302` "Monday. Four days." vs `night_fortyone.txt:93`
        "Monday. Five days." (Mon Apr 17): five is right.
      - `day_twentyfour.txt:31` (Tue Dec 21) "One more Sunday and then it's
        Christmas": Christmas is Sat Dec 25, with no Sunday between. The third
        Advent candle is also late (the fourth Sunday was Dec 19).
      - `bridges.txt:287` "151 days overdue" on Mon Apr 3: paid through
        Oct 30, so 156.
      - `bridges.txt:83` "Sixty-one days" on Mon Nov 1: everywhere else counts
        to Dec 31, so sixty.
      - `bridges.txt:89–96` (mid-November): no card names a weekday, so the
        clock stays on Sat Nov 6 while the text covers Nov 10–20. Give a card
        a weekday or a `time=`.
      - `bridges.txt:264` "Tuesday. The equinox.": it was Mon Mar 20.
      - Daylight: `bridges.txt:276` "sunset after eight" on Mar 30 (about
        7:20; the clocks went forward Apr 2); `night_thirtynine.txt:90` "light
        at half past five" on Apr 3 (sunrise about 7:45); `bridges.txt:209`
        "six hours forty" on Jan 14 (about 6h10).
      - `night_thirtyeight.txt:90` and `bridges.txt:281` both say "Saturday,
        April first, the clocks go forward", back to back.
      Tell me any others you saw.
- [ ] **The night sink goes in the back room, where you can see it.** The
      sink we go to at night should be a spot in `shop_back`, visible on
      screen (art and hotspot), not only a line.
- [ ] **Still not enough objects.** More stock on the shelves and more items
      to find, look at and take. There are 27 things in `stock.cfg`; the floor
      has 16 spots and fewer than half are filled. The right wall and the
      left wall's bottom row are empty all season, and the shelves look the
      same in December as in October. Ideas for the floor (plain things, a
      line and a price each, a few with a prop): a CB radio, a chainsaw, a
      Coleman lantern, a fishing reel, leg-hold traps, a thermos, binoculars,
      a Polaroid camera, a VHS player, a guitar with five strings, a box of
      cassettes, a wolf pelt, a .410 shotgun (back shelf), a wedding band
      (back shelf). Plus new arrivals by month, so the shelves change.
- [ ] **The counter view still needs fixing.** Done in part (Oct 14, branch
      `placeholders`): the window shows the street by the hour and the season
      (dark mornings in December, snow from late October, the streetlight,
      the Gleaner's windows, PAWN backwards on the glass). There are price
      tags on the floor shelves, panelling, antlers and a trap on the left
      wall, the month's calendar and NO REFUNDS by the door, a loans sign
      over the back shelf, and a mug and a pen cup on the counter. Still to
      do: what else you meant (tell me).
- [ ] **Sam's batteries are in the boxes in the back room.** Taking them from
      the crates prompts putting the new objects on the shelves (the
      unpacking leads into stocking).

**To make it playable by someone else** (checked Oct 14; nothing in the story
soft-locks):
- [ ] **Export presets** for Windows and Mac (there's no
      `export_presets.cfg`), with the 4.7.2 templates. **Important:** the
      story is read as raw `.txt`/`.cfg`, which Godot leaves out of exports by
      default. Add `story/*.txt, story/*.cfg, story/documents/*.txt` to the
      non-resource filter, and exclude `tests/*, tools/*, docs/*`. Otherwise
      the built game has no words.
- [ ] **Sound is off** (`settings.gd:21` `SOUND_ON = false`; the volume slider
      is hidden at `menu.gd:28`). There are 24 effects and no music. Turn it
      on for the ones that are timed right.
- [ ] **A menu button on screen,** next to Pockets: Save and Settings are only
      on Esc, and nothing says so.
- [ ] **Teach the hidden keys** once (day one, or the title): Tab shows what
      you can click, 1–9 pick a choice, Esc for the menu.
- [ ] **Loading goes back to the start of the part** (the whole counter day or
      night). Say so on the pause screen, or save between customers.
- [ ] **After the ending, Continue replays breakup** (`title.gd:47`): treat a
      day 43 save as finished.
- [ ] **Skip lines you've seen** (there's no skip or auto-advance), which
      matters more because loading replays a part.
- [ ] Polish: our own icon (it's Godot's), the `.ico`/`.icns`, a credits screen
      with the freesound attributions, Mac signing.
- Length: 43 days, 42 nights, the prologue and 7 walked evenings; about
  45–55k words on one route, roughly **6–9 hours**.

**Placeholder art pass (Oct 14, branch `placeholders`)**, so you can paint
from it. The art reference page has every room, place, person and object as
they look now. Done:
- Every object has its own picture. The rifle was a stub, and the shells,
  Bible, spectacles, brass button, bell clapper, microphone, collar and
  bullet were borrowing other shapes. There's a card of batteries ready for
  Sam.
- The counter views (above).
- The town map: the lake, the roads, the track to Sam's cabin, trees, a roof
  for every place, the shop, the town-line sign, "to Anchorage".
- The night rooms are a little lighter so the shapes read. The bedroom has a
  window, a nightstand and boots; the hall has a runner, the bulb and a
  thermostat.
- `tools/tour_shots.gd` takes the screenshots again (run it under xvfb with
  `SHOTS=dir`).

**Next:**
1. **You play it.** Your notes from playing go here, then get fixed (above).
2. **The narration rewrite:** less reliable, more cryptic, and fewer tics
   ("the way you'd…", "as if").
3. **The art:** 90s pixel art, the checklist in `art_list.md`, and `art.md`.
4. **Sound,** timed to the lines.
5. **Godot in the cloud:** a SessionStart hook.

## Next session (older)

1. **Review: anything still missing.** First thing. A full, honest pass over
   the game as it plays now (the prologue to Daniel's arrival, the shop
   steps built so far) and the docs: what's set up and never paid off, what's
   promised and not built, what's thin. Write the findings down here before
   fixing anything. **Done: `review.md`** (bugs, story contradictions,
   decisions to make, unpaid promises, systems, writing, and an order).

2. **A wider screen.** The game opens in a small window (Godot's default,
   1152 x 648). Make the real resolution bigger and wider: a larger window
   from the start (and fullscreen as a setting), with the layout scaling to
   fill it. Check every scene at the new size: the drive, the apartment, the
   map, the counter (wide and narrow), the nights, the menus.
   **Done (Oct 13):** the window opens 16:9 at 85% of the screen, centred
   (1600x900 if the screen can't be read); turning fullscreen off returns
   to that size. The layout stays 1152x648 and scales (`canvas_items`), so
   it's sharp at any size. Checked every scene at 1920x1080 and 2560x1080:
   fine; on ultrawide the drawn rooms stretch a little sideways (hotspots
   stay aligned). Later, with real art: decide letterbox or wider paintings.

3. **Unreliable narration.** The idea, for every narration line from here on
   (the full rewrite comes later, once everything's written, and the
   writing gets reviewed by hand):
   - Less reliable. The narrator isn't sure, misremembers, contradicts
     itself a little, notices the wrong thing.
   - More subtle. Say less; leave out the explanation; trust the strange
     detail to do the work.
   - Mysterious, cryptic. Twin Peaks: the ordinary told slightly off, the
     uncanny told flat, a sentence that doesn't quite follow.
   - Start with a short style note in `mood.md` with before/after examples,
     agreed first, then a sample pass on one day so the tone can be judged.

4. **Better nightly routine.** Right now every night is the same clicks in
   the same order (radio, bowl, windows, dresser, painting, door, back door,
   bed). Make the routine interesting: rules that change or get added, a
   rule that contradicts another, things out of place, nights where the
   order matters, a cost for skipping, consequences that show up days later.
   Plan it in a doc first, then build. **Plan: `nights.md`.**

5. **The story past November 23.** Thanksgiving week (Daniel on the
   Thursday watch, the pageant), Sam's wall, Olstad's duel. The review (1)
   checks what they need first; plan in a doc, as with every week.

6. **What's left from the last honest review.**
   - Faith, closeness and the town's eye as real counts that change things,
     not just flags.
   - Flags that are set and never paid off.
   - Too much text in places.
   - The romances thin out between the visits at the door.

7. **Your notes from playing.** Anything that felt off, confusing or slow
   while playing goes here, and gets fixed or decided.

8. **A list of the art to make.** Every placeholder drawn in code (rooms,
   people, objects, the back room, the counter top), as a checklist to paint
   from.

9. **Maybe: the shop's wide/narrow jump.** If switching between the wide
   shop and the narrow one (when someone talks) feels jarring in play, keep
   the shop always wide with a fixed column for the text instead.

10. **Maybe: faster tests.** The full run takes over ten minutes because the
    tests share one save folder and can't run side by side. A folder each
    would let them run in parallel (about three minutes).

11. **The look: 90s, pixelated, the shop like Strange Antiquities.** The
    shop window and shelves still feel odd. Direction: a 90s pixel-art
    style for the whole game (low resolution, a limited palette, hard
    pixels), and the shop as a Strange Antiquities-style counter view: warm,
    cluttered, objects with weight, the customer across the counter, tools
    to hand. Start with an art-direction note and a mock-up of the counter,
    agree it, then the shop, then the rest (rooms, map, nights, cards).
    Placeholder art in code until the paintings: the style first, the
    detail later. **Plan: `art.md`.**

12. **Sound, redone carefully.** Turned off for now (`Settings.SOUND_ON`):
    some sounds were out of sync with the text. Later, once things are more
    polished: each sound timed to its line (or to the click), ambient
    loops, and the volume setting back in the menu.

13. **Better interactions with each object.** Once the whole story is
    written: every object in the shop gets interactions that fit it (wind
    the music box, open the watch, shake the tin, read the teeth's papers),
    building on the tools and the catalogue (shop steps 3 and 4).

After those: the shop's step 4 (examine reveals properties; object puzzles),
then on down the list in `shop.md`.
