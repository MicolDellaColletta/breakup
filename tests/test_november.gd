extends "res://tests/test_base.gd"

# Plays November, up to Daniel's arrival: key day 13 (the Wasilla money
# order, June's pageant, Sam's map; Ruth's cellar and the car keys; the
# minister calls the night radio at eleven, and the shop phone doesn't
# ring), the fitting (key day 14), the wipers on the line, and key day 15:
# the man in the good coat and the sixth bullet, three ways (hard fork 3),
# telling Olstad, and the call from the payphone across the street.

const FRIDAY_DAWN: int = 31 * 24 * 60 + 6 * 60
const FITTING_DAWN: int = 47 * 24 * 60 + 6 * 60
const ARRIVAL_DAWN: int = 49 * 24 * 60 + 6 * 60

func run() -> void:
	await _friday()
	await _cellar()
	await _night_thirteen()
	await _fitting()
	await _night_fourteen()
	await _arrival("Write him a ticket", "took_bullet")
	await _arrival("I don't buy things like that", "refused_bullet")
	await _arrival("It came out of you", "door_daniel_1")
	await _night_fifteen()

func _log(column: Node) -> String:
	var text: String = ""
	for entry in column.get_node("%Log").get_children():
		text += entry.get_parsed_text() + "\n"
	return text

func _route(column: Node, times: int = 80) -> Array:
	var route: Array = [column._section]
	for i in times:
		column._on_advance_pressed()
		if route[-1] != column._section:
			route.append(column._section)
	return route

func _next(column: Node) -> void:
	advance(column)
	await wait(1.8)
	advance(column)
	await process_frame

func _reset(day: int, minutes: int, flags: Array) -> void:
	gs.reset()
	gs.day = day
	gs.minutes = minutes
	gs.voices["appraisal"] = 2
	gs.voices["warmth"] = 1
	gs.fray = 2
	for flag in flags:
		gs.flags.append(flag)

func _friday() -> void:
	section("Key day 13: Friday, November 5")
	_reset(13, FRIDAY_DAWN, ["sam_map", "met_sam"])
	var counter: Node = await open_scene("res://scenes/counter.tscn")
	var column: Node = counter.get_node("%DialogueColumn")
	check(root.get_node("Hud").get_node("%ClockLabel").text.begins_with("Fri Nov 5"), "the clock says Friday, November 5")
	_route(column)
	await wait(1.8)
	advance(column)
	await process_frame
	check(gs.has_item("money_order_wasilla") and _log(column).contains("Postmarked Wasilla"), "Olstad with the mail: a second money order, from Wasilla")
	await pick(column, "So would I")
	await _next(column)
	check(column._section == "june_enters" and _log(column).contains("the lights go down"), "June: the pageant, and the lights going down")
	await pick(column, "I'll be there")
	await _next(column)
	check(gs.flags.has("sam_arrow"), "Sam's map: an arrow up the valley")

func _cellar() -> void:
	section("The evening of key day 13: Ruth's cellar")
	_reset(13, FRIDAY_DAWN + 11 * 60, ["door_ruth_1"])
	var map: Node = await open_scene("res://scenes/map.tscn", 1.7)
	var column: Node = map.get_node("%DialogueColumn")
	advance(column)
	await process_frame
	map.visit("pub")
	_route(column)
	check(_log(column).contains("Every Keeper, twice."), "the cellar: every Keeper's Polaroid, twice, one for the church")
	await pick(column, "Why are you showing me")
	advance(column)
	check(gs.flags.has("door_ruth_2") and gs.flags.has("ruth_has_keys"), "Ruth's second door; she keeps your car keys")

func _night_thirteen() -> void:
	section("The thirteenth night: the minister calls the radio")
	_reset(13, FRIDAY_DAWN + 15 * 60, [])
	root.get_node("Transition").go_to("res://scenes/night.tscn", 0.1)
	await wait(2.0)
	var night: Node = current_scene
	var column: Node = night.get_node("%Narrator")
	advance(column)
	await process_frame
	night.look("radio")
	advance(column)
	await pick(column, "Turn it on")
	advance(column)
	check(_log(column).contains("I'm calling from a payphone on the highway.") and _log(column).contains("ye took me in"), "at eleven, a caller on the radio: a travelling minister")
	night.look("bed")
	var route: Array = _route(column)
	check(not night.sounds["ring"].playing and _log(column).contains("Not at eleven. Not at all."), "the shop phone doesn't ring")
	await wait(5.2)
	check(current_scene.name == "Bridge" and gs.day == 14, "the bridge to the fitting")
	await wait(2.0)
	_route(current_scene.get_node("%Narrator"))
	check(current_scene.card_text() == "Saturday. The count.", "two weeks of cards: the minister calls again, the road closes, the count")
	await wait(3.5)
	check(current_scene.name == "Visit" and root.get_node("Hud").get_node("%ClockLabel").text.begins_with("Sun Nov 21"), "Sunday, November 21")

func _fitting() -> void:
	section("Key day 14: the fitting")
	_reset(14, FITTING_DAWN, [])
	root.get_node("Transition").go_to("res://scenes/visit.tscn", 0.1)
	await wait(2.0)
	var visit: Node = current_scene
	var column: Node = visit.get_node("%Narrator")
	_route(column)
	await wait(0.7)
	check(visit.current_room() == "vestry" and _log(column).contains("the coat"), "the vestry: the coat on a dressmaker's form, finished")
	visit.click("fitting_coat")
	_route(column)
	await pick(column, "Put your arms in")
	_route(column)
	check(gs.flags.has("wore_coat") and _log(column).contains("Now you look like him."), "you wear it: \"Now you look like him.\"")
	await wait(2.5)
	check(current_scene.name == "Night", "then the night")

func _night_fourteen() -> void:
	section("The fourteenth night: wipers on the line")
	await wait(2.0)
	var night: Node = current_scene
	var column: Node = night.get_node("%Narrator")
	await wait(0.5)
	advance(column)
	await process_frame
	night.look("bed")
	advance(column)
	await pick(column, "Go down to it")
	var route: Array = _route(column)
	check(_log(column).contains("Wipers, slow"), "a car, wipers, sleet: the road you drove in on")
	await wait(5.2)
	check(current_scene.name == "Bridge" and gs.day == 15, "the bridge into Thanksgiving week")
	await wait(2.0)
	_route(current_scene.get_node("%Narrator"))
	await wait(3.5)
	check(current_scene.name == "Counter" and root.get_node("Hud").get_node("%ClockLabel").text.begins_with("Tue Nov 23"), "Tuesday, November 23")

func _arrival(choice: String, flag: String) -> void:
	section("Key day 15: he arrives (%s)" % flag)
	_reset(15, ARRIVAL_DAWN, ["met_sam"])
	gs.voices["appraisal"] = 4
	gs.settle_background()
	var cash: int = gs.cash
	var counter: Node = await open_scene("res://scenes/counter.tscn")
	var column: Node = counter.get_node("%DialogueColumn")
	_route(column)
	await wait(1.8)
	advance(column)
	await process_frame
	check(_log(column).contains("He's coming today."), "Mrs. Hollis, in her best coat, with a pie for the minister")
	await _next(column)
	check(column._section == "daniel_offer" and _log(column).contains("What will you give me for this?"), "the man in the good coat: a flattened bullet on the counter")
	check(_log(column).contains("Good wool."), "and you know the coat (witness)")
	check(choices(column).size() == 3, "take it, refuse it, or break the pretence")
	await pick(column, choice)
	_route(column)
	check(gs.flags.has(flag), "hard fork 3: %s" % flag)
	match flag:
		"took_bullet":
			check(gs.acquired.has("sixth_bullet") and gs.rules_broken.has("warm"), "the bullet on the back shelf; rule two broken")
		"refused_bullet":
			check(gs.cash == cash + 1, "he buys matches: \"Keep the change. I'd hate to owe you.\"")
		"door_daniel_1":
			check(gs.flags.has("there_you_are"), "\"There you are.\"")
	check(gs.flags.has("daniel_in_town"), "a room above the Gleaner; the Thursday watch")
	if flag != "door_daniel_1":
		return
	ring_bell()
	check(column._section == "closing", "closing")
	await pick(column, "Olstad")
	advance(column)
	check(gs.flags.has("told_olstad_daniel") and _log(column).contains("I'll look at him real close."), "you tell Olstad; her headlights turn to the church")

func _night_fifteen() -> void:
	section("The fifteenth night: the payphone across the street")
	_reset(15, ARRIVAL_DAWN + 15 * 60, ["door_daniel_1"])
	root.get_node("Transition").go_to("res://scenes/night.tscn", 0.1)
	await wait(2.0)
	var night: Node = current_scene
	var column: Node = night.get_node("%Narrator")
	advance(column)
	await process_frame
	night.look("bed")
	advance(column)
	await pick(column, "Go down to it")
	var route: Array = _route(column)
	check(_log(column).contains("through the shop window behind you, the same bell"), "the bell on the line, then through the window, half a second later")
	check(_log(column).contains("A man in it, in a good coat"), "across the road, in the payphone: him")
	check(route[-1] == "morning_after", "then Wednesday")
	await wait(5.2)
	check(current_scene.name == "Bridge" and gs.day == 16, "the last bridge")
	await wait(2.0)
	_route(current_scene.get_node("%Narrator"))
	check(_log(current_scene.get_node("%Narrator")).contains("He's here."), "He's here.")
	await wait(3.5)
	check(current_scene.name == "Title", "what's written ends here: back to the title screen")
