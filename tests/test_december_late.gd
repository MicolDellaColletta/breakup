extends "res://tests/test_base.gd"

# December from the shortest day to New Year's Eve (docs/december.md): key
# day 21 (a note under the door, the third candle, Olstad's key; the freezer:
# Ruth brought to it, or the lid locked again), night 21's power cut (which
# switch), Christmas Eve four ways (the booth: Daniel's second door; Mrs.
# Hollis's table; the Gleaner; the shop alone), night 22 (the stocking), New
# Year's Eve (the locker key; midnight with Ruth, with Sam, or alone, when
# the phone rings: speak first), night 23 and the bridge into January.

const DEC_21: int = 77 * 24 * 60 + 6 * 60
const DEC_24: int = 80 * 24 * 60 + 6 * 60
const DEC_31: int = 87 * 24 * 60 + 6 * 60

func run() -> void:
	await _shortest_day(true)
	await _shortest_day(false)
	await _power_cut("UPSTAIRS", "power_upstairs")
	await _power_cut("SIGN", "power_sign")
	await _christmas_eve("xmas_booth", "Stay", ["door_daniel_1", "lied_in_church"])
	await _christmas_eve("xmas_hollis", "", ["wore_coat", "place_jacket"])
	await _christmas_eve("xmas_gleaner", "", ["took_envelope"])
	await _christmas_eve("xmas_alone", "", [])
	await _night_twentytwo()
	await _new_year("nye_ruth", "", ["door_ruth_1", "door_ruth_2"], "new_year_ruth")
	await _new_year("nye_sam", "", ["door_sam_1", "door_sam_2"], "new_year_sam")
	await _new_year("nye_alone", "", [], "new_year_alone")
	await _new_year("nye_alone", "Say his name", ["door_daniel_1", "door_daniel_2", "tin_opened"], "new_year_daniel")
	await _night_twentythree()

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
	gs.fray = 2
	for flag in flags:
		gs.flags.append(flag)
	for item in items:
		gs.add_item(item)

func _go(path: String) -> Node:
	root.get_node("Transition").go_to(path, 0.1)
	await wait(2.0)
	return current_scene

# A visit scene, once its story has started.
func _visit(flags: Array, day: int, minutes: int, items: Array = []) -> Node:
	_reset(day, minutes, flags, items)
	var visit: Node = await _go("res://scenes/visit.tscn")
	var column: Node = visit.get_node("%Narrator")
	for i in 50:
		if column._section != "":
			break
		await wait(0.1)
	return visit

func _shortest_day(trusted: bool) -> void:
	section("Key day 21: the shortest day; the freezer (%s)" % ("Olstad's key, Ruth" if trusted else "the bear's seam, locked again"))
	var flags: Array = ["reverend_in_back_room", "door_ruth_1"]
	if trusted:
		flags += ["told_olstad_daniel", "walked_out", "said_on_air", "sat_in_place"]
	_reset(21, DEC_21, flags)
	var counter: Node = await open_scene("res://scenes/counter.tscn")
	var column: Node = counter.get_node("%DialogueColumn")
	check(root.get_node("Hud").get_node("%ClockLabel").text.begins_with("Tue Dec 21"), "Tuesday, December 21")
	_route(column)
	await wait(1.8)
	advance(column)
	await process_frame
	if trusted:
		check(column._section == "note_enters" and _log(column).contains("WE SEE YOUR LIGHT."), "the town's eye is on you: a note under the door")
		advance(column)
	check(column._section == "widow_enters" and _log(column).contains("I gave him Ray's."), "the third candle; Ray's baby teeth for the vestry")
	advance(column)
	check(column._section.begins_with("trooper"), "Olstad: the padlock is hers")
	check(gs.flags.has("olstad_freezer_key") == trusted, "she gives you the key only if you've kept faith with her")
	ring_bell()
	check(column._section == "closing", "closing")
	advance(column)
	check(_log(column).contains("I could hear him, I thought."), "the Reverend, in the back room: he knew")
	check(_log(column).contains("as if he'd sat down to wait") or _log(column).contains("waiting for somebody"), "the freezer opens: Abraham, waiting")
	if trusted:
		await pick(column, "Bring Ruth")
		advance(column)
		check(gs.flags.has("ruth_saw_father") and gs.faith_count("ruth") == 2 and _log(column).contains("I'll never forgive you. Thank you."), "you bring Ruth: kept faith, the cruellest kind")
	else:
		check(_log(column).contains("a key"), "the key in the bear's second seam")
		await pick(column, "Close the lid")
		advance(column)
		check(gs.flags.has("freezer_closed"), "you lock it again")

func _power_cut(switch: String, flag: String) -> void:
	section("The twenty-first night: the power cut (%s)" % switch)
	_reset(21, DEC_21 + 16 * 60, [])
	var night: Node = await _go("res://scenes/night.tscn")
	var column: Node = night.get_node("%Narrator")
	advance(column)
	await process_frame
	night.look("radio")
	advance(column)
	check(_log(column).contains("Nothing. Not static. Nothing."), "the radio dead, the neon dead, the freezer stopped")
	await pick(column, "fuse box")
	advance(column)
	await pick(column, switch)
	advance(column)
	check(gs.flags.has(flag) and gs.rules_broken.has("radio") == (switch != "UPSTAIRS"), "%s: rule seven %s" % [switch, "kept" if switch == "UPSTAIRS" else "broken"])
	if switch == "SIGN":
		check(_log(column).contains("the only light on the road"), "the Keeper's light, the only light on the road")

func _christmas_eve(spot: String, choice: String, flags: Array) -> void:
	section("Key day 22: Christmas Eve (%s)" % spot)
	var visit: Node = await _visit(flags, 22, DEC_24)
	var column: Node = visit.get_node("%Narrator")
	_route(column)
	await wait(0.7)
	check(visit.current_room() == "shop", "the shop, shut, cards under the door")
	check(_log(column).contains("The booth is open tonight.") == flags.has("door_daniel_1"), "a note from him, only with his first door")
	visit.click(spot)
	_route(column)
	match spot:
		"xmas_booth":
			check(_log(column).contains("You said \"No\" in church"), "he takes the costume off you, lie by lie")
			await pick(column, choice)
			_route(column)
			check(gs.doors("daniel") == 2 and _log(column).contains("You'd have been thirty-three."), "you stay: his count, his father's table: Daniel's second door")
		"xmas_hollis":
			check(_log(column).contains("You saw it fit.") and _log(column).contains("R. HOLLIS"), "Mrs. Hollis's table: Ray's chair, and the coat behind the door, ready")
		"xmas_gleaner":
			check(_log(column).contains("I always make another one."), "the Gleaner: your empty envelope, given back")
		"xmas_alone":
			check(_log(column).contains("Because there was no room for them in the inn."), "alone: his voice, the Christmas story")
	await wait(2.5)
	check(current_scene.name == "Night", "then the night")

func _night_twentytwo() -> void:
	section("The twenty-second night: the stocking")
	await wait(2.0)
	var night: Node = current_scene
	var column: Node = night.get_node("%Narrator")
	advance(column)
	await process_frame
	night.look("odd_stocking")
	advance(column)
	check(gs.flags.has("saw_stocking") and _log(column).contains("1958"), "out of place: a stocking, and a milk tooth from 1958")

func _new_year(spot: String, choice: String, flags: Array, outcome: String) -> void:
	section("Key day 23: New Year's Eve (%s)" % outcome)
	var items: Array = ["locker_key"] if flags.has("tin_opened") else []
	var visit: Node = await _visit(flags + ["car_forgotten"], 23, DEC_31, items)
	var column: Node = visit.get_node("%Narrator")
	_route(column)
	await wait(0.7)
	check(visit.current_room() == "shop", "the last day: the shop, five candles")
	if items.has("locker_key"):
		visit.click("nye_locker")
		_route(column)
		await pick(column, "drive to Anchorage")
		_route(column)
		check(gs.flags.has("anchorage_tomorrow"), "the locker's paid through tonight: Anchorage tomorrow")
		await wait(0.3)
	visit.click(spot)
	_route(column)
	if choice != "":
		await pick(column, choice)
		_route(column)
	check(gs.flags.has(outcome), "hard fork 5: %s" % outcome)
	check(_log(column).contains("Nothing happens."), "midnight, and nothing happens")
	if outcome == "new_year_alone" or outcome == "new_year_daniel":
		check(_log(column).contains("Happy New Year, sweetheart."), "the phone at midnight: \"Happy New Year, sweetheart.\"")
	if outcome == "new_year_daniel":
		check(gs.rules_broken.has("phone"), "you speak first: rule four broken on purpose; the Daniel strand locks")
	await wait(2.5)
	check(current_scene.name == "Night", "then the night")

func _night_twentythree() -> void:
	section("The twenty-third night; the bridge into January")
	await wait(2.0)
	var night: Node = current_scene
	var column: Node = night.get_node("%Narrator")
	advance(column)
	await process_frame
	night.look("radio")
	advance(column)
	await pick(column, "Turn it on")
	advance(column)
	check(_log(column).contains("Breakup, friends. That's the day."), "the radio: the new date, breakup")
	night.look("odd_calendar")
	advance(column)
	check(gs.flags.has("saw_calendar"), "out of place: the calendar, every Saturday crossed out but one in April")
	night.look("bed")
	_route(column)
	await wait(5.2)
	check(current_scene.name == "Bridge" and gs.day == 24, "the bridge into January")
	await wait(2.0)
	_route(current_scene.get_node("%Narrator"))
	check(gs.flags.has("has_books"), "Anchorage, on New Year's Day: John's books")
	await wait(4.0)
	check(current_scene.name == "Title", "the end of what's written")
