extends "res://tests/test_base.gd"

# March (docs/march.md): key day 35 (the frenzy: the straw man; the notes by
# the eye; Mrs. Hollis and your page, a kept moment; the search for Sam's
# notebooks, one outcome per hiding place), night 35 (whoever hurt MC goes
# missing: Ezra, or Brekke if MC kept faith with Ezra); key day 36 (the
# anxious bench; his room: the suitcase, the files, the cigar box; leave it
# as it was for Ruth; the lake, the first piece); key day 37 (the sixth
# bullet comes back, six of six) and the counsel room (hard fork 6: yes,
# confess, refuse; his one lie, door three; the lake, the second piece); key
# day 38 and Sam's lie at the tripod, or the hall cellar; the bridge into
# April.

const MAR_11: int = 158 * 24 * 60 + 6 * 60
const MAR_19: int = 166 * 24 * 60 + 6 * 60
const MAR_25: int = 172 * 24 * 60 + 6 * 60
const MAR_31: int = 178 * 24 * 60 + 6 * 60

func run() -> void:
	await _frenzy(["kept_sam", "notebooks_bed", "weighed_hall"], 0, "Take her hand", "notebooks_burned")
	await _frenzy(["kept_sam", "notebooks_room", "refused_scale"], 4, "Go home", "ruth_shielded")
	await _frenzy(["gave_up_sam"], 2, "Go home", "")
	await _gone(["keep_ezra_1"], "gone_brekke")
	await _gone(["betrayed_ezra"], "gone_ezra")
	await _room(["door_ruth_1", "gone_ezra"], true)
	await _room(["door_ruth_1", "gone_brekke"], false)
	await _bullet(["took_bullet", "pointed_gun", "pulled_trigger"])
	await _bullet(["refused_bullet"])
	await _price(["door_daniel_1", "door_daniel_2", "lied_to_daniel"], "\"Yes.\"", "fork6_yes")
	await _price([], "\"Yes.\"", "")
	await _price([], "Tell him about the lake", "fork6_confess")
	await _price([], "\"No.\"", "fork6_refuse")
	await _sam(["kept_sam"], [], "It's all right", "door_sam_1")
	await _sam(["kept_sam", "notebooks_burned"], [], "", "sam_stayed_dark")
	await _sam(["kept_sam", "notebooks_burned"], ["bench_notebook"], "You made it all up", "sam_unforgiven")
	await _sam(["gave_up_sam"], [], "Tell him the time", "told_sam_time")
	await _night_thirtyeight()

func _log(column: Node) -> String:
	var text: String = ""
	for entry in column.get_node("%Log").get_children():
		text += entry.get_parsed_text() + "\n"
	return text

func _route(column: Node, times: int = 80) -> Array:
	ring_bell()
	var route: Array = [column._section]
	for i in times:
		column._on_advance_pressed()
		if route[-1] != column._section:
			route.append(column._section)
	return route

func _reset(day: int, minutes: int, flags: Array, items: Array = []) -> void:
	gs.reset()
	gs.day = day
	gs.minutes = minutes
	gs.voices["appraisal"] = 2
	gs.voices["warmth"] = 1
	gs.fray = 0
	for flag in flags:
		gs.flags.append(flag)
	for item in items:
		gs.add_item(item)

func _go(path: String) -> Node:
	root.get_node("Transition").go_to(path, 0.1)
	await wait(2.0)
	var scene: Node = current_scene
	if scene.has_node("%Narrator"):
		var column: Node = scene.get_node("%Narrator")
		for i in 50:
			if column._section != "":
				break
			await wait(0.1)
	return scene

func _frenzy(flags: Array, eye: int, widow: String, outcome: String) -> void:
	section("Key day 35: the frenzy (%s)" % ", ".join(flags))
	_reset(35, MAR_11, flags)
	var counter: Node = await open_scene("res://scenes/counter.tscn")
	gs.eye = eye
	var column: Node = counter.get_node("%DialogueColumn")
	check(root.get_node("Hud").get_node("%ClockLabel").text.begins_with("Sat Mar 11"), "Saturday, March 11")
	_route(column)
	check(_log(column).contains("a figure. Straw"), "the straw man on the tower, in a coat")
	if flags.has("refused_scale"):
		check(_log(column).contains("Your coat. The spare one"), "you refused the scale: it's your coat")
	await wait(1.8)
	advance(column)
	await process_frame
	check(column._section == "note_enters", "a note under the door")
	if eye >= 4:
		check(_log(column).contains("red crayon"), "the eye high: only a number, six")
	elif eye <= 1:
		check(_log(column).contains("We're praying for you"), "the eye low: we're praying for you")
	else:
		check(_log(column).contains("We know what you are."), "the eye between: we know what you are")
	advance(column)
	check(column._section == "widow_enters" and _log(column).contains("Ray went in light"), "Mrs. Hollis: Ray went in light")
	await pick(column, widow)
	advance(column)
	check((gs.faith_count("hollis") >= 1) == widow.begins_with("Take"), "her hand: %s" % widow)
	advance(column)
	if flags.has("gave_up_sam"):
		check(column._section == "closing", "Sam already taken: nobody comes to search")
		return
	check(column._section.begins_with("search") or column._section == "ezra_enters", "Ezra and four men, for Sam's notebooks")
	check(gs.flags.has(outcome), "the search: %s" % outcome)
	ring_bell()
	check(column._section == "closing", "closing")

func _gone(flags: Array, outcome: String) -> void:
	section("The thirty-fifth night: %s" % outcome)
	_reset(35, MAR_11 + 16 * 60, flags)
	var night: Node = await _go("res://scenes/night.tscn")
	var column: Node = night.get_node("%Narrator")
	advance(column)
	await process_frame
	night.look("odd_candles")
	advance(column)
	check(gs.flags.has("saw_coat_dressed"), "your coat, dressed like the straw man")
	night.look("bed")
	_route(column)
	check(gs.flags.has(outcome) and _log(column).contains("Exact change."), "in the morning, exact change on the table, and %s" % outcome)

func _room(flags: Array, take: bool) -> void:
	section("Key day 36: his room (%s)" % ("take" if take else "leave it as it was"))
	_reset(36, MAR_19, flags)
	var visit: Node = await _go("res://scenes/visit.tscn")
	var column: Node = visit.get_node("%Narrator")
	_route(column)
	check(_log(column).contains("Not yet. He's not ready."), "the anxious bench, Mrs. Lund; to you: not yet")
	if flags.has("gone_ezra"):
		check(_log(column).contains("Ezra hasn't got a sister."), "Ezra's place empty")
	else:
		check(_log(column).contains("His black bag is on the bench"), "Brekke's place empty")
	visit.click("hall_to_gleaner")
	_route(column)
	await wait(0.4)
	check(visit.current_room() == "daniel_room" and _log(column).contains("Don't take anything."), "Ruth lets you up: don't take anything")
	visit.click("room_files")
	_route(column)
	check(_log(column).contains("\"July 1988.\""), "his files: your page, July 1988")
	await pick(column, "Take a notebook" if take else "Put them back")
	_route(column)
	visit.click("room_box")
	_route(column)
	check(_log(column).contains("Kettle Lake."), "the cigar box: the boy on the lake shore; the empty slot, Kettle Lake")
	await pick(column, "Close the box")
	_route(column)
	visit.click("room_leave")
	_route(column)
	check(gs.has_item("daniel_file") == take, "Lund's notebook: %s" % ("taken" if take else "left"))
	check(gs.flags.has("keep_ruth_1") == (not take), "Ruth's trust: kept only if you left it as it was")
	check(gs.flags.has("lake_one") and _log(column).contains("You get to forty."), "at dusk, the lake, 1988: the first piece")
	await wait(2.5)
	check(current_scene.name == "Night", "then the night")

func _bullet(flags: Array) -> void:
	section("Key day 37: the sixth bullet (%s)" % ", ".join(flags))
	_reset(37, MAR_25, flags)
	if flags.has("took_bullet"):
		gs.acquired.append("sixth_bullet")
	var counter: Node = await open_scene("res://scenes/counter.tscn")
	var column: Node = counter.get_node("%DialogueColumn")
	_route(column)
	await wait(1.8)
	advance(column)
	advance(column)
	check(column._section.begins_with("daniel"), "him, for the sixth bullet")
	if flags.has("pointed_gun"):
		check(gs.has_item("revolver") and gs.flags.has("gun_six") and _log(column).contains("Six. Now it's a whole thing."), "he loads John's gun on the glass, six of six, and gives it back")
		check(_log(column).contains("I laughed for an hour."), "you pulled the trigger: he counted")
	else:
		check(gs.has_item("sixth_round") and _log(column).contains("I kept it."), "you refused it in November: he kept it; the round, standing on the glass")
	check(_log(column).contains("I'll leave the door open for you."), "after closing, the little room behind the stage")

func _price(flags: Array, choice: String, outcome: String) -> void:
	section("The counsel room: his price (%s)" % choice)
	_reset(37, MAR_25 + 13 * 60, flags)
	var visit: Node = await _go("res://scenes/visit.tscn")
	var column: Node = visit.get_node("%Narrator")
	_route(column)
	check(_log(column).contains("You. After breakup."), "his price: you, not the books")
	if flags.has("lied_to_daniel"):
		check(_log(column).contains("I'd like you anyway."), "your December lie, and he'd like you anyway")
	var doors_before: int = gs.doors("daniel")
	await pick(column, choice)
	_route(column)
	if outcome == "":
		check(not gs.flags.has("fork6_yes") and _log(column).contains("You don't mean it yet."), "yes, without his doors: he laughs, you don't mean it yet")
	else:
		check(gs.flags.has(outcome), "fork 6: %s" % outcome)
	check(_log(column).contains("I knew.") and gs.doors("daniel") == doors_before + 1, "his one lie, at the door: door three")
	check(gs.flags.has("lake_two") and _log(column).contains("Count with me."), "on the road home, the lake again: your hands on her")
	await wait(2.5)
	check(current_scene.name == "Night", "then the night")

func _sam(flags: Array, items: Array, choice: String, outcome: String) -> void:
	section("The evening of key day 38: %s" % outcome)
	_reset(38, MAR_31 + 14 * 60, flags, items)
	var visit: Node = await _go("res://scenes/visit.tscn")
	var column: Node = visit.get_node("%Narrator")
	_route(column)
	if choice != "":
		await pick(column, choice)
		_route(column)
	if outcome == "door_sam_1":
		check(gs.doors("sam") >= 1 and _log(column).contains("Setting it back to the true minute."), "his hand in the clock; you forgive him: his third door")
	elif outcome == "told_sam_time":
		check(gs.flags.has(outcome) and _log(column).contains("What time is it, John?"), "the hall cellar: you tell him the time")
	else:
		check(gs.flags.has(outcome), outcome)
	await wait(2.5)
	check(current_scene.name == "Night", "then the night")

func _night_thirtyeight() -> void:
	section("The thirty-eighth night, and into April")
	var night: Node = current_scene
	var column: Node = night.get_node("%Narrator")
	for i in 50:
		if column._section != "":
			break
		await wait(0.1)
	advance(column)
	await process_frame
	night.look("odd_holes")
	advance(column)
	check(gs.flags.has("saw_lamps"), "a lamp in every hole in the ice, a path to the middle")
	night.look("bed")
	_route(column)
	await wait(5.2)
	check(current_scene.name == "Bridge" and gs.day == 39, "the bridge into April")
	await wait(2.0)
	_route(current_scene.get_node("%Narrator"))
	await wait(4.0)
	check(current_scene.name == "Visit" and gs.day == 39, "into April: Sunday the second, the hall")
