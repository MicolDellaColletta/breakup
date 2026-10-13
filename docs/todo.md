# To do next

The running list of what's next, in order. The shop redesign has its own
step-by-step list (`shop.md`, "To do"); this is everything around it.

## Next session

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
