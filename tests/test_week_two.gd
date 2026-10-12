extends "res://tests/test_base.gd"

# Plays week two: the bridges (title cards), key day 8 (the second Thursday:
# Ezra, Mrs. Hollis, Cody and the picks, June's drawings; the Lunds' and the
# coat; Ruth, Sam and the camera; night eight's call), and key day 9 (the
# second Sunday: the coat under a sheet in the vestry, the tooth asked on the
# church steps), then the bridge to week three.

# Calendar days are counted from October 5 (the drive).
const WEDNESDAY: int = 8 * 24 * 60 + 7 * 60 + 30
const THURSDAY_DAWN: int = 9 * 24 * 60 + 6 * 60
const SUNDAY_DAWN: int = 12 * 24 * 60 + 6 * 60

func run() -> void:
	await _bridge_wednesday()
	await _thursday_picks_drawing()
	await _thursday_cold()
	await _thursday_evening("Sam asked me", "broke_faith_ruth")
	await _thursday_evening("my own copy", "broke_faith_sam")
	await _night_eight()
	await _bridge_weekend()
	await _sunday_tooth_refused()
	await _sunday_evening()
	await _night_nine()

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

func _bridge_wednesday() -> void:
	section("The bridge into week two: Wednesday")
	_reset(8, WEDNESDAY, ["hanna_priced"])
	gs.acquired.append("braid")
	var cash: int = gs.cash
	root.get_node("Transition").go_to("res://scenes/bridge.tscn", 0.1)
	await wait(1.8)
	var bridge: Node = current_scene
	var column: Node = bridge.get_node("%Narrator")
	advance(column, 1)
	await process_frame
	check(bridge.card_text() == "Wednesday. The Keeper is paid.", "a title card, in the town's voice")
	check(gs.cash == cash + 150, "the envelope: a hundred and fifty")
	_route(column)
	check(_log(column).contains("Seventy-nine days, friends."), "the Reverend's millennium sermon, through the wall")
	await wait(3.5)
	check(current_scene.name == "Counter" and gs.day == 8, "then key day 8, at the counter")
	check(root.get_node("Hud").get_node("%ClockLabel").text.begins_with("Thu Oct 14"), "the clock jumps to Thursday, October 14")

func _thursday_picks_drawing() -> void:
	section("Key day 8: witness, the notebook; Cody's picks held; give them back; the drawing in the window")
	_reset(8, THURSDAY_DAWN, [])
	gs.voices["appraisal"] = 4
	gs.settle_background()
	gs.add_item("notebook")
	gs.record_sale("Ice picks", "ice_picks", 12, "Cody Hollis")
	gs.record_pawn("Ice picks", "ice_picks_held", 6, "new", "Cody Hollis")
	var counter: Node = await open_scene("res://scenes/counter.tscn")
	var column: Node = counter.get_node("%DialogueColumn")
	var route: Array = _route(column)
	check(route.has("morning_flash_witness") and route.has("morning_notebook_line"), "one more detail of the John night; a line in the notebook you don't remember writing")
	await wait(1.8)
	route = _route(column)
	check(route.has("ezra_usual") and gs.ledger_lines[-1].contains(".22 shells"), "Ezra, the usual: your hand knows where the shells are")
	await wait(1.8)
	advance(column)
	await process_frame
	check(column._section == "widow_enters" and _log(column).contains("You've lost weight since Sunday."), "Mrs. Hollis's Thursday dish, and a brown thread on her sleeve")
	await pick(column, "Eat some")
	await _next(column)
	check(column._section == "nephew_enters", "Cody, for the picks")
	await pick(column, "Give them back")
	advance(column)
	check(gs.flags.has("gave_picks_back") and gs.sold.has("ice_picks_held"), "you give them back; he'll go out on the ice")
	await _next(column)
	check(column._section == "june_enters" and _log(column).contains("They love the coat."), "June's drawings: the Keeper in a long brown coat")
	await pick(column, "Tape the best one")
	advance(column)
	check(gs.flags.has("drawing_in_window"), "a drawing in the window")
	await wait(1.8)
	check(column._section == "closing" and gs.clock_text() == "6:47 PM", "closing at 6:47 PM")

func _thursday_cold() -> void:
	section("Key day 8: refused the tooth; no Cody")
	_reset(8, THURSDAY_DAWN, ["refused_tooth"])
	var counter: Node = await open_scene("res://scenes/counter.tscn")
	var column: Node = counter.get_node("%DialogueColumn")
	_route(column)
	await wait(1.8)
	var route: Array = _route(column)
	check(route.has("ezra_cold"), "Ezra buys the shells and looks at the jar the whole time")
	await wait(1.8)
	advance(column)
	await pick(column, "tonight")
	await _next(column)
	check(column._section == "june_enters", "no Cody (he went under on day two); June")

func _thursday_evening(answer: String, broken: String) -> void:
	section("The evening of key day 8: the Lunds', the coat; the camera (%s)" % broken)
	_reset(8, THURSDAY_DAWN + 13 * 60, ["door_sam_1", "met_sam"])
	var map: Node = await open_scene("res://scenes/map.tscn", 1.7)
	var column: Node = map.get_node("%DialogueColumn")
	advance(column)
	await process_frame
	check(map.shown_places().has("lunds"), "the Lunds' is on the map, Thursday")
	map.visit("lunds")
	_route(column)
	check(_log(column).contains("A coat. A long coat"), "through the window: the Ladies' Circle, sewing a coat")
	await pick(column, "Knock")
	advance(column)
	check(gs.flags.has("saw_coat") and _log(column).contains("Mine's in the hem."), "you knock; they measure your arm; Hanna's braid is in the hem")
	await process_frame
	map.visit("pub")
	_route(column)
	check(_log(column).contains("A disposable camera"), "Sam gives you a camera for Ruth's wall")
	await pick(column, answer)
	advance(column)
	check(gs.flags.has(broken), "the collision costs faith: %s" % broken)

func _night_eight() -> void:
	section("The eighth night: nine, the kettle, the thread")
	_reset(8, THURSDAY_DAWN + 15 * 60, [])
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
	check(_log(column).contains("And number nine."), "the Thursday hymns: one, five, and nine")
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
	check(_log(column).contains("A kettle") and _log(column).contains("pill bottle"), "the call has changed: a kettle, a pill bottle. He's hurt")
	await pick(column, "Wait")
	var route: Array = _route(column)
	check(route.has("night_dog_fed") and _log(column).contains("a single brown thread"), "a brown thread by the bowl")
	await wait(5.2)
	check(current_scene.name == "Bridge" and gs.day == 9, "then the weekend bridge")

func _bridge_weekend() -> void:
	section("The weekend bridge")
	await wait(2.0)
	var bridge: Node = current_scene
	var column: Node = bridge.get_node("%Narrator")
	advance(column, 1)
	await process_frame
	check(bridge.card_text() == "Friday. The Keeper dresses the window.", "Friday's card")
	_route(column)
	check(bridge.card_text() == "Saturday. The Keeper is seen.", "Saturday's card")
	await wait(3.5)
	check(current_scene.name == "Visit" and gs.day == 9, "then key day 9: the second Sunday")
	check(root.get_node("Hud").get_node("%ClockLabel").text.begins_with("Sun Oct 17"), "Sunday, October 17")

func _sunday_tooth_refused() -> void:
	section("Key day 9: church; the coat under a sheet; the tooth asked on the steps")
	_reset(9, SUNDAY_DAWN, ["refused_tooth"])
	root.get_node("Transition").go_to("res://scenes/visit.tscn", 0.1)
	await wait(2.0)
	var visit: Node = current_scene
	var column: Node = visit.get_node("%Narrator")
	_route(column)
	await pick(column, "Go up to church")
	_route(column)
	await wait(0.7)
	visit.click("church_pew")
	_route(column)
	check(_log(column).contains("Seventy-five days"), "the sermon counts down")
	await pick(column, "Bear it")
	_route(column)
	await wait(0.7)
	check(visit.current_room() == "vestry", "the vestry again")
	visit.click("vestry_scale")
	_route(column)
	await pick(column, "Step on")
	_route(column)
	await wait(0.7)
	check(gs.flags.has("weighed_again") and _log(column).contains("Up a pound."), "weighed: up a pound")
	visit.click("vestry_frame")
	_route(column)
	await pick(column, "Lift the sheet")
	_route(column)
	await wait(0.7)
	check(gs.flags.has("touched_coat") and _log(column).contains("It's warm."), "under the sheet, the coat, unfinished, warm")
	visit.click("vestry_out")
	_route(column)
	check(_log(column).contains("H.L. Eighty-nine. It's asked."), "on the steps, in front of everyone, the tooth is asked")
	await pick(column, "No.")
	_route(column)
	await wait(0.7)
	check(gs.flags.has("refused_tooth_public") and visit.current_room() == "hollis_kitchen", "you refuse it in public; then lunch")
	visit.click("kitchen_eat")
	_route(column)
	check(_log(column).contains("Every week till April."), "\"Thomas had seconds every week. Every week till April.\"")
	await wait(2.5)
	check(current_scene.name == "Map", "then the evening")

func _sunday_evening() -> void:
	section("The evening of key day 9: who's still speaking to you")
	_reset(9, SUNDAY_DAWN + 10 * 60 + 30, ["door_ruth_1", "broke_faith_ruth", "met_sam"])
	gs.visited.append("lake")
	var map: Node = await open_scene("res://scenes/map.tscn", 1.7)
	var column: Node = map.get_node("%DialogueColumn")
	advance(column)
	await process_frame
	var places: Array = map.shown_places()
	check(not places.has("ruth_house") and not places.has("pub") and not places.has("church"), "broke faith with Ruth: her house isn't on the map")
	map.visit("cabin")
	_route(column)
	check(_log(column).contains("In the vestry, on a hanger"), "Sam: the coat was in the vestry")

func _night_nine() -> void:
	section("The ninth night, and the bridge to week three")
	_reset(9, SUNDAY_DAWN + 15 * 60, [])
	root.get_node("Transition").go_to("res://scenes/night.tscn", 0.1)
	await wait(2.0)
	var night: Node = current_scene
	var column: Node = night.get_node("%Narrator")
	advance(column)
	await process_frame
	night.look("bed")
	advance(column)
	await pick(column, "Go down to it")
	advance(column)
	await wait(0.7)
	night.click("night_shop_counter")
	await wait(0.7)
	night.click("night_shop_phone")
	advance(column)
	check(_log(column).contains("humming"), "he hums the hymn, until it hurts")
	await pick(column, "Wait")
	_route(column)
	await wait(5.2)
	check(current_scene.name == "Bridge" and gs.day == 10, "the bridge into week three")
	await wait(2.0)
	var bridge: Node = current_scene
	advance(bridge.get_node("%Narrator"), 1)
	await process_frame
	check(bridge.card_text() == "Monday. The Keeper is in good health.", "Monday's card")
	_route(bridge.get_node("%Narrator"))
	await wait(3.5)
	check(current_scene.name == "Counter" and gs.day == 10, "then key day 10, in week three")
