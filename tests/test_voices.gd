extends "res://tests/test_base.gd"

# The voices' own rules (docs/voices.md): Paranoia talking over the others,
# being frayed, and the background.

func run() -> void:
	await _talking_over()
	_fraying()
	await _frayed_choices()
	_backgrounds()

# A small story file, played in a bare dialogue column.
func _column(story: String) -> Node:
	var column: Node = load("res://scenes/dialogue_column.tscn").instantiate()
	root.add_child(column)
	var file: FileAccess = FileAccess.open("user://test_voices.txt", FileAccess.WRITE)
	file.store_string(story)
	file.close()
	column.load_story("user://test_voices.txt")
	await process_frame
	return column

func _shown(column: Node) -> Array:
	var out: Array = []
	for entry in column.get_node("%Log").get_children():
		out.append(entry.get_parsed_text())
	return out

func _talking_over() -> void:
	section("Paranoia talks over the others when it's loud")
	var story: String = "=== t\nnarration: The ledger.\nappraisal: The stamp on the bottom.\nwarmth: She's still waiting.\nnarration: The end.\n"
	gs.reset()
	gs.day = 1
	gs.voices["appraisal"] = 1
	gs.voices["warmth"] = 1
	gs.voices["paranoia"] = 5
	var column: Node = await _column(story)
	column.play("t")
	advance(column)
	var shown: Array = _shown(column)
	check(shown.size() == 4 and shown[1].begins_with("APPRAISAL"), "at 5, Paranoia isn't loud enough yet: every voice speaks")
	column.queue_free()
	gs.voices["paranoia"] = 6
	column = await _column(story)
	column.play("t")
	advance(column)
	shown = _shown(column)
	check(shown.size() == 3 and shown[1].begins_with("PARANOIA"), "at 6, Paranoia cuts in once, and the other drowned line goes")
	check(not shown[1].contains("stamp"), "what Appraisal would have said is gone")
	column.queue_free()
	gs.voices["appraisal"] = 4
	column = await _column(story)
	column.play("t")
	advance(column)
	shown = _shown(column)
	check(shown[1].begins_with("APPRAISAL") and shown[2].begins_with("PARANOIA"), "a voice within three points still gets through")
	column.queue_free()

func _fraying() -> void:
	section("Fraying, and coming back")
	gs.reset()
	gs.break_rule("window")
	check(gs.fray == 0, "the prologue doesn't fray")
	gs.day = 1
	gs.break_rule("radio")
	gs.break_rule("radio")
	gs.lean("unknown")
	check(gs.fray == 3 and gs.frayed, "every broken rule and every ??? choice frays: three, and MC is frayed")
	gs.end_night()
	check(gs.fray == 3, "a night with a broken rule doesn't bring MC back")
	gs.end_night()
	check(gs.fray == 2 and not gs.frayed, "a whole day and night with every rule kept takes one away")
	gs.add_fray(-5)
	check(gs.fray == 0, "never below zero")

func _frayed_choices() -> void:
	section("Frayed: ??? gets louder")
	var story: String = "=== t\nnarration: The phone.\nunknown | if=frayed: Say hello.\n> Wait -> t\n> [???] Say hello. -> t | needs=unknown\n"
	gs.reset()
	gs.day = 1
	gs.voices["unknown"] = 1
	var column: Node = await _column(story)
	column.play("t")
	advance(column)
	check(choices(column) == ["Wait"], "not frayed: no ??? choice at 1 point, and ??? stays quiet")
	column.queue_free()
	gs.fray = 3
	column = await _column(story)
	column.play("t")
	advance(column)
	check(_shown(column).size() == 2 and _shown(column)[1].contains("Say hello"), "frayed: ??? speaks up")
	check(choices(column).size() == 2, "frayed: the ??? choice shows from 1 point")
	check(column.get_node("%Log").get_child(1).text.contains("[shake"), "frayed: ??? won't hold still")
	column.queue_free()

func _backgrounds() -> void:
	section("The background, from the voices")
	gs.reset()
	check(gs.background() == "", "nothing leads at the start")
	gs.voices["warmth"] = 3
	gs.voices["john"] = 3
	check(gs.background() == "", "a tie leads nowhere")
	gs.voices["warmth"] = 4
	check(gs.background() == "guilt", "Warmth ahead: guilt")
	gs.voices["unknown"] = 3
	gs.fray = 3
	check(gs.background() == "insanity", "??? plus being frayed: insanity")
	gs.settle_background()
	gs.fray = 0
	gs.voices["appraisal"] = 9
	check(gs.background() == "insanity", "once settled, it stays")
	var column: Node = load("res://scenes/dialogue_column.tscn").instantiate()
	root.add_child(column)
	check(column._condition_met("background:insanity") and not column._condition_met("background:witness"), "story files can ask: if=background:insanity")
	column.queue_free()
