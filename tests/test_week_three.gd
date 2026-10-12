extends "res://tests/test_base.gd"

# Plays week three: the bridge from Monday to Friday (the swatch of wool, the
# road closing), key day 10 (the ice: Olstad stuck in town, Cody's brass
# button or Mrs. Hollis, Hanna's invitation), the first-ice party walked on
# the lake (the shape under the ice, four ways), night ten (a train outside
# the caller's window, a button by the bowl), and the bridge into week four.

const MONDAY: int = 13 * 24 * 60 + 7 * 60 + 30
const SATURDAY_DAWN: int = 18 * 24 * 60 + 6 * 60

func run() -> void:
	await _bridge_monday()
	await _saturday_cody()
	await _party("Kneel down", "knelt_with_sam", "That's Thomas.")
	await _party("Go and get Olstad", "showed_olstad_ice", "Log.")
	await _party("Join them", "skated_over", "in he goes")
	await _party("Walk away", "walked_from_ice", "The Keeper walked off the ice.")
	await _party_go_home()
	await _saturday_widow()
	await _night_ten()

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

func _bridge_monday() -> void:
	section("The bridge, Monday to Friday")
	_reset(10, MONDAY, [])
	var cash: int = gs.cash
	root.get_node("Transition").go_to("res://scenes/bridge.tscn", 0.1)
	await wait(2.0)
	var bridge: Node = current_scene
	var column: Node = bridge.get_node("%Narrator")
	_route(column)
	check(bridge.card_text() == "Friday. The road closes.", "five cards; the last: the road closes")
	check(gs.cash == cash + 150 and _log(column).contains("a strip of brown wool"), "Wednesday's envelope, with a swatch of brown wool")
	check(_log(column).contains("A stick, or a cane."), "Thursday's call: he's up, with a stick")
	check(gs.flags.has("road_closed"), "Kettle Lake is an island till Sunday")
	await wait(3.5)
	check(current_scene.name == "Counter" and gs.day == 10, "then key day 10")
	check(root.get_node("Hud").get_node("%ClockLabel").text.begins_with("Sat Oct 23"), "Saturday, October 23")

func _saturday_cody() -> void:
	section("Key day 10: the ice. Cody had the picks; the notebook")
	_reset(10, SATURDAY_DAWN, ["gave_picks_back", "met_sam"])
	gs.add_item("notebook")
	var counter: Node = await open_scene("res://scenes/counter.tscn")
	var column: Node = counter.get_node("%DialogueColumn")
	var route: Array = _route(column)
	check(route.has("morning_notebook") and _log(column).contains("It's not for you yet."), "the lake frozen shore to shore; a third line in the notebook")
	await wait(1.8)
	advance(column)
	await process_frame
	check(column._section == "trooper_enters" and _log(column).contains("Kids say a lot."), "Olstad, stuck in town: kids say a lot")
	await pick(column, "What kind")
	await _next(column)
	check(column._section == "nephew_enters" and _log(column).contains("A brass button."), "Cody, with a brass button chipped out of the ice")
	await pick(column, "Write him a ticket")
	advance(column)
	check(gs.acquired.has("brass_button"), "you take the button in")
	await _next(column)
	check(column._section == "hanna_enters", "Hanna, with the invitation")
	await pick(column, "I'll be there")
	advance(column)
	await wait(1.8)
	ring_bell()
	check(column._section == "closing" and gs.clock_text() == "6:20 PM", "closing at 6:20 PM")
	advance(column)
	await process_frame
	counter._leave_for_the_evening()
	await wait(2.5)
	check(current_scene.name == "Visit" and current_scene.current_room() == "shore", "the evening is walked: the shore, the bonfire")

func _open_party(flags: Array) -> Node:
	_reset(10, SATURDAY_DAWN + 13 * 60, flags)
	root.get_node("Transition").go_to("res://scenes/visit.tscn", 0.1)
	await wait(2.0)
	return current_scene

func _party(choice: String, flag: String, words: String) -> void:
	section("The first-ice party: %s" % flag)
	var visit: Node = await _open_party(["met_sam"])
	var column: Node = visit.get_node("%Narrator")
	_route(column)
	await wait(0.7)
	visit.click("shore_people")
	_route(column)
	await wait(0.7)
	check(_log(column).contains("nine's the Keeper, in he goes"), "the children skate the rhyme in a ring")
	visit.click("shore_out")
	await wait(0.8)
	check(visit.current_room() == "far_ice", "out past the lanterns")
	visit.click("far_shape")
	_route(column)
	check(_log(column).contains("A long coat.") and choices(column).size() == 4, "under the black ice: a shape in a long coat; four things to do")
	await pick(column, choice)
	_route(column)
	check(gs.flags.has(flag) and gs.flags.has("saw_shape") and _log(column).contains(words), "%s" % words)
	await wait(2.5)
	check(current_scene.name == "Night", "then the night")

func _party_go_home() -> void:
	section("The first-ice party: go home without looking")
	var visit: Node = await _open_party([])
	var column: Node = visit.get_node("%Narrator")
	_route(column)
	await wait(0.7)
	visit.click("shore_home")
	_route(column)
	check(not gs.flags.has("saw_shape") and _log(column).contains("You'll never know"), "you never go past the lanterns")
	await wait(2.5)
	check(current_scene.name == "Night", "then the night")

func _saturday_widow() -> void:
	section("Key day 10: Cody didn't have the picks: Mrs. Hollis")
	_reset(10, SATURDAY_DAWN, [])
	var counter: Node = await open_scene("res://scenes/counter.tscn")
	var column: Node = counter.get_node("%DialogueColumn")
	_route(column)
	await wait(1.8)
	advance(column)
	await pick(column, "Say nothing")
	await _next(column)
	check(_log(column).contains("not been home two nights"), "Mrs. Hollis: Cody's been out on the ice two nights")

func _night_ten() -> void:
	section("The tenth night: the train, the button, and the bridge into week four")
	_reset(10, SATURDAY_DAWN + 16 * 60, ["saw_shape"])
	gs.voices["appraisal"] = 3
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
	check(_log(column).contains("who came out on the ice with us tonight"), "the request hour: for the Keeper who came out on the ice")
	night.look("kitchen")
	advance(column)
	await pick(column, "Fill it")
	advance(column)
	night.look("bed")
	advance(column)
	await pick(column, "Go down to it")
	advance(column)
	await wait(0.7)
	night.click("night_shop_counter")
	await wait(0.7)
	night.click("night_shop_phone")
	advance(column)
	check(_log(column).contains("a train horn") and _log(column).contains("Through Wasilla."), "outside his window, a train; Appraisal knows the line")
	await pick(column, "Wait")
	var route: Array = _route(column)
	check(route.has("night_dog_fed") and _log(column).contains("a brass button"), "by the bowl in the morning: a brass button, damp")
	await wait(5.2)
	check(current_scene.name == "Bridge" and gs.day == 11, "the bridge into week four")
	await wait(2.0)
	var bridge: Node = current_scene
	_route(bridge.get_node("%Narrator"))
	check(bridge.card_text() == "Friday. The Keeper is due.", "Sunday to Friday: the Keeper is due")
	await wait(3.5)
	check(current_scene.name == "Counter" and gs.day == 11, "then key day 11, in week four")
