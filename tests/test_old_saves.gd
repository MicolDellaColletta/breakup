extends "res://tests/test_base.gd"

# Saves from before a change still load (todo.md, "Old saves"): a save
# file stores only what it knew about, and GameState.from_dict fills the
# rest with defaults. These are hand-made saves the way each month's build
# wrote them.

func run() -> void:
	_november()
	_december_before_the_eye()
	_february_before_the_hall()
	_round_trip()

func _november() -> void:
	section("A November save, before the counts")
	gs.from_dict({"day": 15.0, "cash": 212.0, "flags": ["met_sam", "door_ruth_1"], "voices": {"warmth": 2.0}})
	check(gs.day == 15 and gs.cash == 212, "the day and the money come back, as whole numbers")
	check(gs.eye == 0 and gs.faith_count("ruth") == 1, "what it didn't know starts empty: no eye; Ruth's door still counts as kept faith")
	check(gs.voices.get("warmth", 0) == 2 and gs.voices.get("paranoia", -1) == 3 and gs.voices.get("unknown", -1) == 0, "the voices it had; the others where a new game starts them")

func _december_before_the_eye() -> void:
	section("A December save from before the eye was stored")
	gs.from_dict({"day": 20.0, "flags": ["walked_out", "said_on_air", "tried_to_run"]})
	gs.start_day()
	check(gs.eye == 3, "the eye is seeded on its first morning, from what the town already saw")
	gs.start_day()
	check(gs.eye == 3, "and only once")

func _february_before_the_hall() -> void:
	section("A February save from before the hall's own weighing flag")
	gs.from_dict({"day": 34.0, "flags": ["weighed", "fed_twentysix"]})
	check(gs.flags.has("weighed") and not gs.flags.has("weighed_hall"), "October's weighing doesn't count as the hall's")
	check(gs.flags.has("fed_twentysix") and not gs.flags.has("fed_thirty"), "an old night's dog flag stays its own night's")

func _round_trip() -> void:
	section("Saved and loaded again: nothing lost")
	gs.reset()
	gs.day = 33
	gs.eye = 2
	gs.set_flag("keys_returned")
	gs.add_item("church_deed")
	var data: Dictionary = JSON.parse_string(JSON.stringify(gs.to_dict()))
	gs.reset()
	gs.from_dict(data)
	check(gs.day == 33 and gs.eye == 2 and gs.flags.has("keys_returned") and gs.has_item("church_deed"), "through JSON and back: the day, the eye, the flags, the pockets")
