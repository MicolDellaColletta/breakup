# To do next

The running list of what's next, in order. The shop redesign has its own
step-by-step list (`shop.md`, "To do"); this is everything around it.

## Pick up here (Oct 15, night)

**Next:** roll the narration pass (`narration.md`) across days 2–42, the
bridges and the endings, in the style of the sample you approved (the
prologue, day one and night one; the comparison is in the "Breakup Narration
Sample" artifact). Four writers by month, then one read-through. Budget across
the season: about 25 each of "as if" / "the way you'd", about 15 slips,
frayed lines, and rare retractions. Then the full suite and the routes.

## Earlier (Oct 14, evening)

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
11. `placeholders`
12. `todo-fixes`
13. `loose-ends`
14. `narration`

**Your notes from playing (Oct 14).** More to come once you finish the
playthrough. Done on branch `todo-fixes` unless it says otherwise.
- [x] **Some dates were still wrong.** Fixed:
      - the March card lands on Wed Mar 1;
      - Holy Week's Monday is "Five days";
      - Mrs. Hollis on Dec 21: "One more, and then it's Christmas";
      - 156 days overdue;
      - "Sixty days" on Nov 1;
      - the mid-November cards have weekdays, so the clock moves (Wed 10, Mon 15,
        Sat 20);
      - the equinox is on Monday;
      - daylight: "six hours and a quarter" on Jan 14, "sunset near eight" on
        Mar 30, "light at half past six" on Apr 3;
      - night 38's morning no longer repeats the April 1 card.
      The town's candles follow its own custom (the fourth on Christmas Eve,
      the fifth at New Year), so they stay as they are. Tell me any other dates
      you saw.
- [x] **The night sink is in the back room, where you can see it.** On night
      three (the frozen pipes), the way down is through the steel door. The
      old sink is drawn by the furnace, between the bench and the back door,
      with a shaving mirror wired to the pipe and turned to the wall. You drink
      there, then go back to the counter and the window. On the night walks
      (night 7 and from night 11) it's a spot of its own.
- [x] **Sam's batteries are in the crates in the back room** (day four). With
      them, under straw, are things Abraham never put out: a Coleman lantern, a
      CB radio, a thermos and a leg-hold trap. They come out onto the counter
      ("New stock on the counter. Put it out on the shelves.") and you shelve
      them by hand. The ledger writes them in. New story effect:
      `unpacked=item,item` (`arrives=true` items).
- [x] **Not enough objects:** 13 more, each with a place (`loose_ends.md`,
      part 4), so there are 44, arriving month by month. Previously: four from the crates
      (above). The right wall and the left wall's bottom row
      still need filling, and the shelves should change by month. More ideas: a
      chainsaw, a fishing reel, binoculars, a Polaroid camera, a VHS player, a
      guitar with five strings, a box of cassettes, a wolf pelt, a .410 shotgun
      (back shelf), a wedding band (back shelf). Your call on which, and when
      they arrive.
- [ ] **The counter view still needs fixing.** Done in part (branch
      `placeholders`): the street in the window by the hour and the season,
      price tags, things on the walls, a mug and a pen cup. New stock now waits
      along the back of the counter. Still to do: what else you meant (tell
      me).

**To make it playable by someone else** (checked Oct 14; nothing in the story
soft-locks):
- [x] **Export presets** (`export_presets.cfg`) for Windows, macOS and Linux.
      The story `.txt`/`.cfg` files are in the non-resource filter, and
      tests, tools and docs are left out. A Linux pack export was checked: the
      story is in it, the tests aren't, and it starts. To build: install the
      4.7.2 export templates (Editor > Manage Export Templates), then Project >
      Export. Builds go in `build/` (ignored by git).
- [ ] **Sound is off** (`settings.gd:21` `SOUND_ON = false`; the volume slider
      is hidden at `menu.gd:28`). There are 24 effects and no music. Your call:
      which effects are timed right enough to switch on.
- [x] **A Menu button on screen,** next to Pockets (the same as Esc).
- [x] **The hidden keys are taught** on the title and the pause menu: "Tab:
      show what you can click · 1–9: pick a choice · Esc: menu".
- [x] **Loading goes back to the start of the part:** the Save screen already
      says so ("A save keeps your progress from the start of this part").
- [x] **After the ending, Continue no longer replays breakup.** When the ending
      plays to the title, the autosave is marked finished, and the title says
      "The end".
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
