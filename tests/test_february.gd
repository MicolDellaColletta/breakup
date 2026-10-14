extends "res://tests/test_base.gd"

# February (docs/february.md): key day 31 (Ezra's hand, brought in by him:
# load the shells or turn him away; Mrs. Hollis fasting; the goat at the
# door), night 31; key day 32 (the goat; Ruth's note) and Ruth's lie at the
# shut Gleaner (her third door, the keys; read with the 1989 letter), night
# 32; key day 33 (the duel: the sister's address; the John night for
# Olstad's case; the deed), night 33; key day 34 (the scale; the booth and
# Sam: keep faith and hide his notebooks, or give him up), night 34 (the open
# back door); the February finds; the bridge to the end of what's written.

const FEB_5: int = 123 * 24 * 60 + 6 * 60
const FEB_11: int = 129 * 24 * 60 + 6 * 60
const FEB_19: int = 137 * 24 * 60 + 6 * 60
const FEB_20: int = 138 * 24 * 60 + 6 * 60

func run() -> void:
	await _scapegoat("Load the shells for him", "Go out to it")
	await _scapegoat("I can't", "Stay behind the counter")
	await _night_thirtyone()
	await _ruth(["ruth_has_keys", "door_ruth_1", "door_ruth_2", "saw_locked_room"], ["letter_1989"], "It wasn't your fault")
	await _ruth(["ruth_has_keys", "door_ruth_1"], [], "You'd keep me here")
	await _duel(["will_testify", "pointed_gun", "found_deed"], ["church_deed"], "Tell her the truth")
	await _duel([], [], "Lie.")
	await _night_thirtythree()
	await _lights("Step onto the scale", "I don't know whose lights", "Hide them in the bear")
	await _lights("No.", "Sam Wakeman.", "")
	await _night_thirtyfour()
	await _finds()

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
	var scene: Node = current_scene
	if scene.has_node("%Narrator"):
		var column: Node = scene.get_node("%Narrator")
		for i in 50:
			if column._section != "":
				break
			await wait(0.1)
	return scene

func _scapegoat(ezra: String, goat: String) -> void:
	section("Key day 31: the scapegoat (%s)" % ezra)
	_reset(31, FEB_5, ["coat_in_shop"])
	var counter: Node = await open_scene("res://scenes/counter.tscn")
	var column: Node = counter.get_node("%DialogueColumn")
	check(root.get_node("Hud").get_node("%ClockLabel").text.begins_with("Sat Feb 5"), "Saturday, February 5")
	_route(column)
	check(_log(column).contains("An iron ring, bolted through."), "on the burned tower: a post, a crosspiece, an iron ring")
	await wait(1.8)
	advance(column)
	await process_frame
	check(column._section == "ezra_enters" and _log(column).contains("I missed Thursday."), "him, bringing Ezra in, his hand broken: he missed Thursday")
	check(root.get_node("Presence").state == "present", "he spoke at the counter: the red light is on")
	await pick(column, ezra)
	advance(column)
	if ezra.begins_with("Load"):
		check(gs.faith_count("ezra") >= 1 and gs.ledger_lines[-1].contains("Loaded for him."), "you load it for him: kept faith with Ezra; his line in the ledger")
	else:
		check(gs.is_faithless("ezra") and _log(column).contains("I'll load it for you."), "you turn him away; he loads it for Ezra on the step")
	advance(column)
	check(column._section == "widow_enters" and _log(column).contains("Everybody's being weighed again."), "Mrs. Hollis, fasting: the scale again")
	check(root.get_node("Presence").state == "", "he's gone with Ezra: the light goes with him")
	advance(column)
	check(column._section == "goat_enters", "the goat at the door")
	await pick(column, goat)
	advance(column)
	check(gs.flags.has("let_goat_in") == goat.begins_with("Go out"), "the goat: %s" % goat)
	ring_bell()
	check(column._section == "closing", "closing")

func _night_thirtyone() -> void:
	section("The thirty-first night: the coat with its collar up")
	_reset(31, FEB_5 + 16 * 60, ["coat_in_shop"])
	var night: Node = await _go("res://scenes/night.tscn")
	var column: Node = night.get_node("%Narrator")
	advance(column)
	await process_frame
	night.look("odd_coat_up")
	advance(column)
	check(gs.flags.has("saw_coat_up") and _log(column).contains("keeping warm"), "out of place: the coat, buttoned, collar up, as if someone were in it")
	night.look("bed")
	_route(column)
	await wait(5.2)
	check(current_scene.name == "Bridge" and gs.day == 32, "the week of the goat")
	await wait(2.0)
	_route(current_scene.get_node("%Narrator"))
	check(current_scene.card_text() == "Wednesday. The Keeper is paid.", "weighed; the goat at every door; the envelope and a hymn number")
	await wait(3.5)
	check(current_scene.name == "Counter" and gs.day == 32, "Friday, February 11")

func _ruth(flags: Array, items: Array, choice: String) -> void:
	section("Key day 32: Ruth's lie (%s)" % choice)
	_reset(32, FEB_11, flags, items)
	var counter: Node = await open_scene("res://scenes/counter.tscn")
	var column: Node = counter.get_node("%DialogueColumn")
	_route(column)
	await wait(1.8)
	advance(column)
	advance(column)
	await process_frame
	check(_log(column).contains("Come after. Back door. I'm closed. R."), "a fasting day; at five, Ruth's note")
	ring_bell()
	advance(column)
	await process_frame
	counter._leave_for_the_evening()
	await wait(2.5)
	var visit: Node = current_scene
	check(visit.name == "Visit" and visit.current_room() == "gleaner", "the shut Gleaner, after dark")
	column = visit.get_node("%Narrator")
	for i in 50:
		if column._section != "":
			break
		await wait(0.1)
	_route(column)
	if items.has("letter_1989"):
		check(_log(column).contains("Dad kept it."), "you lay the 1989 letter on the table first")
	check(_log(column).contains("I drove him.") and _log(column).contains("In his chair. In the dark."), "her lie: she drove him to the highway; her mother sat in the empty shop")
	if flags.has("saw_locked_room"):
		check(_log(column).contains("You've been in my room."), "she knows you've been in her room")
	check(_log(column).contains("a chair creaks"), "at the end of the bar, in the dark, him")
	await pick(column, choice)
	_route(column)
	if choice.begins_with("It wasn"):
		check(gs.doors("ruth") == 3 and gs.flags.has("keys_returned"), "you forgive her: her third door; she gives you the keys")
	else:
		check(gs.doors("ruth") == 1 and not gs.flags.has("keys_returned"), "you don't: the keys back in her pocket")
	await wait(2.5)
	check(current_scene.name == "Night", "then the night")

func _duel(flags: Array, items: Array, choice: String) -> void:
	section("Key day 33: the duel (%s)" % choice)
	_reset(33, FEB_19, flags, items)
	var counter: Node = await open_scene("res://scenes/counter.tscn")
	var column: Node = counter.get_node("%DialogueColumn")
	_route(column)
	await wait(1.8)
	advance(column)
	advance(column)
	await process_frame
	check(column._section == "trooper_reads" and _log(column).contains("Lakeview Drive.") and _log(column).contains("I'm not leaving."), "the duel: her sister's address, once; she isn't leaving")
	check(_log(column).contains("I need the John night."), "then she asks you for the John night, for her case")
	if flags.has("pointed_gun"):
		check(_log(column).contains("That I can use."), "he has your gun: that she can use")
	await pick(column, choice)
	advance(column)
	if choice.begins_with("Tell"):
		check(gs.flags.has("told_olstad_john") and gs.faith_count("olstad") >= 1, "the truth: kept faith with Olstad")
		check(gs.flags.has("gave_deed") and not gs.has_item("church_deed"), "and the deed: motive")
	else:
		check(gs.is_faithless("olstad"), "a lie: she closes the notebook")
	ring_bell()
	check(column._section == "closing", "closing")

func _night_thirtythree() -> void:
	section("The thirty-third night: a drawing under the door")
	_reset(33, FEB_19 + 16 * 60, [])
	var night: Node = await _go("res://scenes/night.tscn")
	var column: Node = night.get_node("%Narrator")
	advance(column)
	await process_frame
	night.look("odd_drawing")
	advance(column)
	check(gs.flags.has("saw_drawing") and _log(column).contains("For the Sergeant's sister."), "out of place: a yellow house with a swing")
	night.look("bed")
	_route(column)
	await wait(5.2)
	check(current_scene.name == "Visit" and gs.day == 34, "Sunday, the scale")

func _lights(weigh: String, booth: String, hide: String) -> void:
	section("Key day 34: the lights on the ice (%s)" % booth)
	_reset(34, FEB_20, [])
	var visit: Node = await _go("res://scenes/visit.tscn")
	var column: Node = visit.get_node("%Narrator")
	_route(column)
	check(_log(column).contains("Your turn comes."), "the hall: everyone weighed on the scale")
	await pick(column, weigh)
	_route(column)
	await wait(0.7)
	check(gs.flags.has("weighed_hall") == weigh.begins_with("Step"), "the scale: %s" % weigh)
	visit.click("hall_scale_book")
	_route(column)
	await wait(0.2)
	check(_log(column).contains("already written, in pencil"), "the book: April's weight, already written")
	visit.click("hall_booth_sam")
	_route(column)
	check(_log(column).contains("The lights on the ice."), "the booth: who has the lights on the ice")
	await pick(column, booth)
	_route(column)
	if hide != "":
		check(gs.faith_count("sam") >= 1 and _log(column).contains("You keep things."), "you keep faith with Sam; at dusk, his notebooks in your arms")
		await pick(column, hide)
		_route(column)
		check(gs.flags.has("notebooks_bear"), "the notebooks, in the bear")
	else:
		check(gs.is_faithless("sam") and _log(column).contains("somebody bending over them with a match"), "you give him up: the lanterns go to the cabin")
	await wait(2.5)
	check(current_scene.name == "Night", "then the night")

func _night_thirtyfour() -> void:
	section("The thirty-fourth night: the open back door")
	await wait(2.0)
	var night: Node = current_scene
	var column: Node = night.get_node("%Narrator")
	advance(column)
	await process_frame
	night.look("odd_prints")
	advance(column)
	check(gs.flags.has("saw_prints") and _log(column).contains("It stands outside your door for a long time."), "at three, something walks the shop and stands outside your door")
	night.look("bed")
	_route(column)
	await wait(5.2)
	check(current_scene.name == "Bridge" and gs.day == 35, "the bridge into March")
	await wait(2.0)
	_route(current_scene.get_node("%Narrator"))
	await wait(4.0)
	check(current_scene.name == "Counter" and gs.day == 35, "into March: the counter, Saturday the eleventh")

func _finds() -> void:
	section("February finds: Ruth's diary, Abraham's letter, the bench notebook")
	_reset(31, FEB_5 + 16 * 60, ["saw_locked_room"], ["room_key"])
	var night: Node = await _go("res://scenes/night.tscn")
	var column: Node = night.get_node("%Narrator")
	advance(column)
	await process_frame
	night.look("walk_locked_room")
	advance(column)
	check(gs.has_item("ruth_diary"), "Ruth's room: the dressing table drawer, her 1989 diary")
	night.look("walk_freezer")
	advance(column)
	check(gs.has_item("abraham_letter"), "the freezer, once more: Abraham's letter to Ruth")
	night.look("walk_bench")
	advance(column)
	check(gs.has_item("bench_notebook") and _log(column).contains("And for the other thing"), "the bench drawer: the bear, and the other thing")
