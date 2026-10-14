# The Daniel rewrite pass (draft)

Oct 13, overnight. This is a draft of `daniel_v7.md` calls 3 and 12–14, done
ahead of your answers because your note was "he's too kind". It's on its own
branch, `daniel-rewrite`, which stacks on `canon-fixes`. Drop the PR, or
change any line, if the direction is wrong.

## The rules it follows

- **Never kind.** Courtesy stays, as a tool, never as warmth.
- **In public he's a hard preacher:** Leviticus, Jeremiah, Revelation. He
  shames people by name with what's in his files.
- **Alone with MC, he's himself:** quiet, amused, too close. He watches MC's
  face and enjoys the fear ("There. That. Do that again.").
- **He never lies.** The lies he used to tell are rewritten into true but
  misleading lines:
  - "The Reverend won't be at this microphone again" (said the night before
    the fire);
  - "Elias won't be cold again";
  - "You'd have had to be at the lake";
  - "I shut the door on his hand, and then I opened it and shut it again, to
    be sure".
- **MC's real name is never heard.** When he says it (day 28, and on the air
  on night 30), the sound drops out: a hiss, a word the room won't hold.
- **"It'll keep"** is said once in the whole game (day 30).
- **The red light:**
  - `red=alone` on his counter visits, the booths and the face-off;
  - `red=on` where he's there and silent (Thanksgiving, the fire, the end of
    the bar, the chair on day 33);
  - `red=off` where he leaves a scene that goes on;
  - his voice on the radio is tagged `on=radio`, so it doesn't bring the
    red.

## The big changes, by month

- **Thanksgiving:**
  - **The sixth bullet:** "I carried it six hundred miles, and you don't want
    it back."
  - **His first time on the radio** is a hard sermon: "You are not clean…
    The child at one of these tables with another man's eyes… You need
    someone to carry it for you. And you have one. You've had one since
    October."
- **December:**
  - **The doctor's hands:** "That's the going rate up here."
  - **On the air:** Jeremiah against the Reverend.
  - **At the Mass:** "not one of you carried water", and the man who sold
    him the petrol is made to stand (left unnamed; see below).
  - **Christmas Eve:** in the booth he tells MC plainly how the Reverend died:
    the vestry, the collar folded for Ezra, the bolt, eleven minutes on the
    bell. "Every word of that is true. Tell Olstad, if you like. True is the
    one thing she can't use." This is v7's first "let in".
- **New Year's Eve:** on the phone (in red text) he's predatory, not soothing:
  "You broke a rule for me, and you knew you were doing it."
- **January:**
  - **Day 28,** his first scene as himself: his lines come out of the
    narration as real speech. The name drops out. "There. That. Do that
    again."
  - **Day 30:** he shames Dr. Brekke from the pulpit. In the booth: "I like
    watching you carry it."
- **February:**
  - **Ezra's hand:** "I shut it on his hand… I always pay for what I break."
  - **Olstad:** her niece on the swing in a red hat, called in at twenty past
    four.
  - **Day 34, the booth:** he isn't asking *who* (the town knows it's Sam).
    He wants MC to say it: "They need someone who's been inside to say it."
  - **The face-off:** he enjoys every second, takes the gun "one finger at a
    time", and says "In March you'll come and ask me for it. Nicely."

## Decisions this draft made (change them if you like)

1. **Dr. Brekke is shamed by name** from the pulpit on day 30 (the shaking
   hand, the drinking since Advent).
2. **The man who sold him the petrol** stands at the Mass, unnamed. The draft
   first named Walt Pruitt; I took that out because Walt is one of the
   kept-faith people.
3. **His three replies at the fork on day 23** are now different from each
   other.
4. **Ruth's "None of us did"** (day 19) is now "You'd have had to be at the
   lake", which she hears as Kettle Lake.

## The choices added (Oct 14, after the leans were agreed)

- **The counsel room and the anxious bench** (call 2):
  - the booth on days 30 and 34 is now the counsel room, the old props room
    behind the stage, with one bulb and two chairs;
  - on day 30 Dr. Brekke is called up to the anxious bench, the front pew,
    where the hall prays over him out loud;
  - Christmas Eve's two chairs stand in the ash.
- **Day 18, the Bible:** "Go up and get it" or "There isn't one"
  (`refused_bible`). If MC lied, on day 26 the Bible comes back anyway,
  taken from MC's dresser through the open back door.
- **Day 25, Christmas Eve:** "Sit." or "Stay on your feet." (`stood_in_ash`).
- **Day 26, the groceries:** take the box, or push it back
  (`refused_groceries`; he leaves it on the step).
- **Day 28, his first scene:** "Get out of my shop." (`ordered_daniel_out`),
  "Come back, then." (`invited_daniel`), or say nothing.
- **Day 30, the counsel room:** the options set flags now
  (`confessed_small`, `confessed_nothing`). There's a fourth: ask him about
  the Reverend (`asked_about_reverend`). He answers, delighted: "Do you
  know how many have asked? You. Only ever you."

## Tests changed

These now expect the new text:
- `test_thanksgiving.gd` (the broadcast);
- `test_december.gd` (the night 21 radio);
- `test_presence.gd` (radio adds no red).
- `test_december.gd`, `test_december_late.gd`, `test_january.gd` (the new
  choices).
