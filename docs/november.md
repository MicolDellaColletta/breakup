# Breakup: November, to Daniel's arrival

Planned and built in one pass on October 12 (agreed: "arrive at Daniel's
appearance"). Checked against `pillars.md`, `forks.md` (hard fork 3),
`daniel.md` (6a the calls, 7 the caller, 8 the arrival), `underneath.md`.

## The shape

| Date | | Sunset |
|---|---|---|
| Mon 1 – Thu 4 | Bridge (November; the first envelope; "pray for travellers") | 16:52 |
| **Fri 5** | **Key day 13:** the Wasilla money order; the minister calls the radio; Ruth's cellar | 16:41 |
| Sat 6 – Sat 20 | Bridge: the minister calls again; two envelopes; the road shut three days; "forty days" | |
| **Sun 21** | **Key day 14: the fitting** (walk-around) | 16:02 |
| Mon 22 | Bridge: "Make him welcome." | |
| **Tue 23** | **Key day 15: he arrives.** Hard fork 3, the sixth bullet | 15:58 |
| Wed 24 | Bridge: "He's here." The end of what's written. | |

## As built

`story/day_thirteen.txt` … `night_fifteen.txt`, November in `bridges.txt` and
`town.txt`; tested in `tests/test_november.gd`. Engine: dates now run past
October (`GameState.MONTHS`); key days 13–15 and their bridges.

- **Key day 13 (Fri Nov 5):** Olstad brings the mail again: the second money
  order, postmarked Wasilla (*"Your friend's coming up the valley,
  Johnny."*); she touches the door frame once before she stops herself.
  June: the pageant, *"and then the lights go down. That's the end."* Sam
  draws an arrow up the valley on his map (`sam_arrow`).
- **Ruth's second door** (if her first is open and faith holds): after hours,
  drunk, the cellar: every Keeper's Polaroid twice, one sealed for the church.
  *"Somebody has to give them their Keeper."* Ask why (`door_ruth_2`; she
  keeps MC's car keys, `ruth_has_keys`), take your envelope off the wall
  (`took_envelope`), or go back up.
- **Night 13:** the radio takes calls on Fridays now. At eleven, instead of
  the shop phone, a caller on the radio: a travelling minister from a payphone
  on the highway, scripture by heart (*"For I was a stranger, and ye took me
  in"*). The Reverend sounds like a man who heard a step on the stair. The
  shop phone never rings.
- **The bridge:** he calls the radio again and again, nearer each time; on
  the nights he isn't on the radio, the shop phone rings with wipers and
  sleet. The road shut three days. The Reverend loses count: "Forty days."
- **Key day 14 (Sun Nov 21), the fitting:** the coat on a dressmaker's form,
  brass buttons like the one from the ice. Wear it (`wore_coat`: body-warm,
  smelling of all of them and, under it, the lake; Mrs. Hollis kneels to pin
  the hem; *"Now you look like him."*), or refuse (`refused_fitting`: *"We
  have your measurements."*).
- **Night 14:** the Reverend reads the visitor's letter; the call is a car,
  wipers, sleet: the road MC drove in on.
- **Key day 15 (Tue Nov 23), he arrives:** Mrs. Hollis with a pie for the
  minister. At twenty to four, the man in the good coat: he looks at
  everything but the back shelf, holds his left side carefully, and lays a
  flattened, cleaned, warm bullet on the counter. *"What will you give me for
  this?"* Paranoia remembers the sixth shot, per background. **Hard fork 3:**
  write a ticket (`took_bullet`, rule 2 broken, `sixth_bullet` on the back
  shelf), refuse (`refused_bullet`: he buys matches, *"Keep the change. I'd
  hate to owe you."*), or break the pretence: *"It came out of you."*
  (`door_daniel_1`: *"There you are."*). He's taken a room above the Gleaner
  and will speak on Thursday's watch. Then, at closing: tell Olstad
  (`told_olstad_daniel`), tell Sam (`told_sam_daniel`: *"We need to start the
  wall."*), or no one.
- **Evening:** Ruth: *"He asked my name, and then he said it back to me."* The
  church lit on a Tuesday, him at the front, and he looks straight at the
  window MC is standing at.
- **Night 15:** the call from the payphone across the street: the church bell
  on the line, then through the window half a second later; a man in a good
  coat with his back to the shop. The last bridge: *"He's here."*

## Open

- [ ] Thanksgiving week: the Thursday watch with him as guest, the pageant
      (the Keeper in the coat walks across the stage; the lights go down).
- [ ] The wall (Sam), if MC told him.
- [ ] Olstad watching him "real close," if MC told her: her duel starts early
      (`forks.md`, fork 3).
