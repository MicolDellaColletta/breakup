extends "res://tests/test_base.gd"

# The endings (docs/april.md, "KD43"): breakup reads what happened in order:
# the fire; a run with Ruth, Sam or Cody; a run alone (he finds you, or he
# can't); go with him (and into the ice together); the ice; the season ends
# (he lets go, bored; or Olstad, alone, can't stop it). Each from a
# hand-set state; each ends on May and the title. GameState.ending() names
# the same one.

const APR_22: int = 200 * 24 * 60 + 5 * 60

func run() -> void:
	await _ending(["set_fire", "olstad_looks_away", "gun_snow", "left_kettle_lake"], {}, "fire", "There's nothing left to pay.")
	await _ending(["ran_with_ruth", "left_kettle_lake"], {}, "run_ruth", "she sets the table for three")
	await _ending(["ran_with_sam", "left_kettle_lake"], {}, "run_sam", "Just to keep it")
	await _ending(["ran_with_cody", "left_kettle_lake"], {}, "run_cody", "a pair of ice picks on the seat")
	await _ending(["ran_alone", "daniel_in_car", "left_kettle_lake"], {}, "run_alone_him", "taps twice on the roof")
	await _ending(["ran_alone", "daniel_taken", "left_kettle_lake"], {}, "run_alone", "It says somebody else's.")
	await _ending(["fork6_yes", "door_daniel_1", "door_daniel_2"], {}, "daniel", "It's the boy's name, from the lake.")
	await _ending(["fork6_confess", "door_daniel_1", "door_daniel_2"], {"unknown": 6}, "daniel_ice", "still holding on")
	await _ending([], {"unknown": 6}, "the_ice", "it isn't your face")
	await _ending(["fork6_yes"], {}, "season_ends", "\"For the ferry,\" he says.")
	await _ending(["daniel_given"], {}, "season_ends", "\"That's enough,\" she says.")

func _log(column: Node) -> String:
	var text: String = ""
	for entry in column.get_node("%Log").get_children():
		text += entry.get_parsed_text() + "\n"
	return text

func _route(column: Node, times: int = 120) -> void:
	for i in times:
		column._on_advance_pressed()

func _ending(flags: Array, voices: Dictionary, expected: String, line: String) -> void:
	section("Breakup: %s (%s)" % [expected, ", ".join(flags)])
	gs.reset()
	gs.day = 43
	gs.minutes = APR_22
	gs.voices["appraisal"] = 2
	gs.voices["warmth"] = 1
	for flag in flags:
		gs.flags.append(flag)
	for name in voices:
		gs.voices[name] = voices[name]
	if voices.get("unknown", 0) > 0 and not flags.has("fork6_confess"):
		gs.fray = gs.FRAYED_AT
	check(gs.ending() == expected, "the reader says %s (got %s)" % [expected, gs.ending()])
	root.get_node("Transition").go_to("res://scenes/visit.tscn", 0.1)
	await wait(2.0)
	var column: Node = current_scene.get_node("%Narrator")
	for i in 50:
		if column._section != "":
			break
		await wait(0.1)
	_route(column)
	check(_log(column).contains(line), "the ending plays: \"%s\"" % line)
	if flags.has("gun_snow"):
		check(_log(column).contains("John's gun. Five in the cylinder."), "May: the gun in the snowbank, where you pushed it in October")
	await wait(4.0)
	check(current_scene.name == "Title", "then the title")
