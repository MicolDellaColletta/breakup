extends "res://tests/test_base.gd"

# January (docs/january.md): key day 28 (the coat in the shop, or not; Ruth
# and the freezer three ways; him in the customer chair, quoting the
# notebook), night 28; key day 29 (Walt's name and dollars, Cody's knock or
# his picks for his place) and the evening at the ruins with Olstad and the
# vestry bolt, night 29; key day 30 in the church hall (the eye on faces, the
# queue, the booth, walking out), night 30 (goodnight by name); the bridge
# to the end of what's written. And Daniel on the phone in red.

const JAN_3: int = 90 * 24 * 60 + 6 * 60
const JAN_15: int = 102 * 24 * 60 + 6 * 60
const JAN_23: int = 110 * 24 * 60 + 6 * 60

func run() -> void:
	_phone_voice()
	await _disappointment(["ruth_saw_father", "notebook_there", "notebook_here", "has_books"], "All right", "ruth_grieving")
	await _disappointment(["door_ruth_1", "notebook_voice"], "Not in the shop", "ruth_told_late")
	await _disappointment(["door_ruth_1", "saw_stocking"], "Not in the shop", "ruth_lied_freezer")
	await _night_twentyeight()
	await _walt(["ida_pawned", "gave_picks_back"], true)
	await _walt(["kept_picks"], false)
	await _evening(["told_olstad_fire", "spectacles_to_olstad"], "Yes.", "will_testify")
	await _evening(["spectacles_to_church"], "I don't know.", "wont_promise")
	await _confession("Tell him a small true thing", 0, [])
	await _confession("Tell him about the John night", 3, ["kept_teeth_jar", "lied_in_church"])
	await _confession("", 5, [])
	await _night_thirty()

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

func _reset(day: int, minutes: int, flags: Array) -> void:
	gs.reset()
	gs.day = day
	gs.minutes = minutes
	gs.voices["appraisal"] = 2
	gs.voices["warmth"] = 1
	gs.fray = 2
	for flag in flags:
		gs.flags.append(flag)

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

func _phone_voice() -> void:
	section("Daniel on the phone: red, like ???")
	var info: Dictionary = load("res://scripts/narrator.gd").speaker_info("daniel_line")
	var unknown: Dictionary = load("res://scripts/narrator.gd").speaker_info("unknown")
	check(info.get("color") == unknown.get("color") and info.get("name") == "On the line", "on the line, his words are the colour of ???")

func _disappointment(flags: Array, coat: String, outcome: String) -> void:
	section("Key day 24: the Disappointment (%s)" % outcome)
	_reset(28, JAN_3, flags)
	var counter: Node = await open_scene("res://scenes/counter.tscn")
	var column: Node = counter.get_node("%DialogueColumn")
	check(root.get_node("Hud").get_node("%ClockLabel").text.begins_with("Mon Jan 3"), "Monday, January 3")
	_route(column)
	check(_log(column).contains("Breakup, friends."), "the radio: the Lord is waiting for the ice")
	await wait(1.8)
	advance(column)
	await process_frame
	check(column._section == "widow_enters" and _log(column).contains("So it's handy."), "Mrs. Hollis brings the coat to hang in the shop")
	await pick(column, coat)
	advance(column)
	check(gs.flags.has("coat_in_shop") == (coat == "All right"), "the coat: %s" % ("on the back of the door" if coat == "All right" else "taken home"))
	advance(column)
	match outcome:
		"ruth_grieving":
			check(column._section == "ruth_grieving" and _log(column).contains("You were the only one who showed me."), "Ruth, grieving out loud: you were the only one who showed her")
		_:
			check(_log(column).contains("He told me. Last night, at the bar."), "Ruth: he told her; he never lies")
			await pick(column, "I knew" if outcome == "ruth_told_late" else "I never opened it")
			advance(column)
			check(gs.flags.has(outcome), outcome)
			check(gs.is_faithless("ruth") == (outcome == "ruth_lied_freezer"), "a lie closes her for good; the truth keeps her, cold")
	advance(column)
	check(column._section.begins_with("daniel"), "at closing, him, in the customer chair")
	if flags.has("notebook_there"):
		check(_log(column).contains("\"There you are.\" In your notebook"), "the most intimate notebook line wins: \"There you are.\"")
		check(_log(column).contains("You went to Anchorage the day the road opened."), "he knows about Anchorage")
	elif flags.has("notebook_voice"):
		check(_log(column).contains("\"The voice.\""), "the notebook: \"The voice.\"")
	else:
		check(_log(column).contains("You kept the tooth."), "without the notebook: the tooth you didn't throw away")
	check(_log(column).contains("Your name. Not John.") or _log(column).contains("Not John. Yours."), "he says your real name, once")
	await pick(column, "Get out of my shop")
	advance(column)
	check(gs.flags.has("ordered_daniel_out") and _log(column).contains("I like hearing you try it on."), "you order him out; he likes hearing you try it on")
	ring_bell()
	check(column._section == "closing", "closing")

func _night_twentyeight() -> void:
	section("The twenty-fourth night: the cards")
	_reset(28, JAN_3 + 16 * 60, [])
	var night: Node = await _go("res://scenes/night.tscn")
	var column: Node = night.get_node("%Narrator")
	advance(column)
	await process_frame
	night.look("odd_cards")
	advance(column)
	check(gs.flags.has("saw_cards"), "out of place: the Christmas cards, facing the bed")
	night.look("bed")
	_route(column)
	await wait(5.2)
	check(current_scene.name == "Bridge" and gs.day == 29, "the bridge: Olstad's baby")
	await wait(2.0)
	_route(current_scene.get_node("%Narrator"))
	check(current_scene.card_text() == "Friday. The light.", "a girl; the week without her; the light")
	await wait(3.5)
	check(current_scene.name == "Counter" and root.get_node("Hud").get_node("%ClockLabel").text.begins_with("Sat Jan 15"), "Saturday, January 15")

func _walt(flags: Array, cody_alive: bool) -> void:
	section("Key day 25: Walt; %s" % ("Cody's knock" if cody_alive else "Cody's picks for his place"))
	_reset(29, JAN_15, flags)
	if flags.has("ida_pawned"):
		gs.record_pawn("One name", "name_ida", 0, "new", "Walt Pruitt")
	gs.record_pawn("Silver dollars", "silver_dollars", 30, "0412", "Walt Pruitt")
	var counter: Node = await open_scene("res://scenes/counter.tscn")
	var column: Node = counter.get_node("%DialogueColumn")
	_route(column)
	await wait(1.8)
	advance(column)
	await process_frame
	if flags.has("ida_pawned"):
		check(_log(column).contains("I can't say her name."), "Walt can't say her name")
		await pick(column, "Tear up the ticket")
		advance(column)
		check(gs.flags.has("ida_returned") and _log(column).contains("Ida. Ida. Ida."), "you give it back: \"Ida.\"")
	check(column._section == "walt_dollars" and _log(column).contains("It's warm. Still."), "and her silver dollars, still warm")
	await pick(column, "Give them back")
	advance(column)
	check(gs.sold.has("silver_dollars") and gs.faith_count("walt") >= 1, "the dollars go home: kept faith with Walt")
	advance(column)
	check(column._section == "teague_enters" and _log(column).contains("Keeps the dead from following you in."), "Teague, with a wolf's skull")
	await pick(column, "Pay him")
	advance(column)
	check(gs.unshelved.has("wolf_skull"), "the skull, on the counter to put out")
	advance(column)
	if cody_alive:
		check(column._section == "nephew_enters" and _log(column).contains("Like knuckles on a door."), "Cody: something knocked under the ice")
	else:
		check(column._section == "widow_enters" and _log(column).contains("For his place at the table."), "Mrs. Hollis, for the picks, for his place")
		await pick(column, "Give them to her")
		advance(column)
		check(gs.flags.has("picks_for_place") and gs.faith_count("hollis") >= 1, "the picks for his place: kept faith with the Hollises")
	ring_bell()
	check(column._section == "closing", "closing")
	advance(column)
	await process_frame
	counter._leave_for_the_evening()
	await wait(2.5)
	check(current_scene.name == "Visit" and current_scene.current_room() == "ruins", "the evening: Olstad, at the ruins")

func _evening(flags: Array, choice: String, outcome: String) -> void:
	section("The evening of key day 29: Olstad at the ruins (%s)" % outcome)
	_reset(29, JAN_15 + 13 * 60, flags)
	var visit: Node = await _go("res://scenes/visit.tscn")
	var column: Node = visit.get_node("%Narrator")
	_route(column)
	if flags.has("told_olstad_fire"):
		check(_log(column).contains("You told me about the bolt."), "you told her about the bolt: she sawed it off the post")
	else:
		check(_log(column).contains("I found it myself"), "she found the bolt herself")
	if flags.has("spectacles_to_olstad"):
		check(_log(column).contains("Anchorage says ordinary glass"), "Anchorage and the spectacles")
	else:
		check(_log(column).contains("Ezra buried them."), "the spectacles, buried")
	await pick(column, choice)
	_route(column)
	var seen: String = _log(column)
	check(gs.flags.has(outcome) and seen.contains("watching you"), "%s; someone on the scaffold, watching" % outcome)
	await wait(2.5)
	check(current_scene.name == "Night", "then the night")

func _confession(choice: String, eye: int, flags: Array) -> void:
	section("Key day 26: the confession (eye %d, %s)" % [eye, choice if choice != "" else "walk out"])
	_reset(30, JAN_23, flags + ["door_ruth_1"])
	gs.eye = eye
	gs.set_flag("eye_seeded")
	var visit: Node = await _go("res://scenes/visit.tscn")
	var column: Node = visit.get_node("%Narrator")
	_route(column)
	await wait(0.7)
	match eye:
		0: check(_log(column).contains("They nod. Almost all of them."), "the eye on faces: almost everyone nods")
		3: check(_log(column).contains("The men look at the hymn boards."), "the eye on faces: the old women nod, the men don't")
		_: check(_log(column).contains("Nobody nods. Not one."), "the eye on faces: nobody nods but Mrs. Hollis")
	visit.click("queue_ruth")
	_route(column)
	await wait(0.2)
	check(_log(column).contains("stands beside you instead"), "Ruth steps out of the queue to stand with you")
	if flags.has("kept_teeth_jar"):
		visit.click("queue_ezra")
		_route(column)
		await wait(0.2)
		check(_log(column).contains("All but the shop's."), "Ezra: every child's teeth, all but the shop's")
	if choice == "":
		visit.click("queue_walk_out")
		_route(column)
		check(gs.eye == eye + 1 and _log(column).contains("It'll keep."), "you walk out: the eye; \"It'll keep.\"")
	else:
		visit.click("queue_booth")
		_route(column)
		await pick(column, choice)
		_route(column)
		if choice.contains("John"):
			check(gs.flags.has("offered_john_night") and _log(column).contains("That one I'll want in March."), "the John night: \"Not yet. That one I'll want in March.\"")
		else:
			check(_log(column).contains("he says it back to you. Exactly."), "a small true thing, said back to you exactly")
	await wait(2.5)
	check(current_scene.name == "Night", "then the night")

func _night_thirty() -> void:
	section("The twenty-sixth night: goodnight by name")
	await wait(2.0)
	var night: Node = current_scene
	var column: Node = night.get_node("%Narrator")
	advance(column)
	await process_frame
	night.look("radio")
	advance(column)
	await pick(column, "Turn it on")
	advance(column)
	check(_log(column).contains("Goodnight, Walt.") and _log(column).contains("He doesn't say yours."), "goodnight to the whole town by name; not yours")
	night.look("odd_toothbrush")
	advance(column)
	check(gs.flags.has("saw_toothbrush"), "out of place: a second toothbrush, wet")
	night.look("bed")
	_route(column)
	await wait(5.2)
	check(current_scene.name == "Bridge" and gs.day == 31, "the bridge into February")
	await wait(2.0)
	_route(current_scene.get_node("%Narrator"))
	check(current_scene.card_text() == "Tuesday. February.", "Ezra's hand, bandaged")
	await wait(4.0)
	check(current_scene.name == "Counter" and gs.day == 31, "then February, at the counter")
