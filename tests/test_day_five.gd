extends "res://tests/test_base.gd"

# Plays day five, Sunday: no counter. Church (the hands, the scale, the
# doorframe) or the congregation praying at the shop window; Mrs. Hollis's
# kitchen; the Sunday evening (Ruth's house, Sam, the lake); and the fifth
# night (the phone, with a radio playing at the other end).

# Sunday, October 10, 6:00 AM, counted from midnight on October 5.
const SUNDAY_DAWN: int = 5 * 24 * 60 + 6 * 60

func run() -> void:
	await _church_bear_weighed()
	await _church_walk_out()
	await _stay_home(true)
	await _stay_home(false)
	await _evening()
	await _night()

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

func _open_sunday(flags: Array) -> Node:
	gs.reset()
	gs.day = 5
	gs.minutes = SUNDAY_DAWN
	gs.voices["appraisal"] = 2
	gs.voices["warmth"] = 1
	gs.fray = 2
	for flag in flags:
		gs.flags.append(flag)
	root.get_node("Transition").go_to("res://scenes/visit.tscn", 0.1)
	await wait(2.0)
	return current_scene

# Clicks a spot and plays what it says to the end (or to a choice).
func _click(visit: Node, column: Node, spot: String) -> Array:
	visit.click(spot)
	var route: Array = _route(column)
	await wait(0.7)
	return route

func _church_bear_weighed() -> void:
	section("Sunday: promised Ezra, left the bowl empty; church, bear the hands, step on the scale")
	var visit: Node = await _open_sunday(["promised_sunday", "widow_dish"])
	var column: Node = visit.get_node("%Narrator")
	check(root.get_node("Hud").get_node("%ClockLabel").text.begins_with("Sun Oct 10"), "the clock says Sunday, October 10")
	var route: Array = _route(column)
	check(route.has("morning_bowl_gone") and _log(column).contains("You told Ezra you'd be there."), "the bowl's gone; you promised Ezra")
	await pick(column, "Go up to church")
	route = _route(column)
	await wait(0.7)
	check(visit.current_room() == "church" and _log(column).contains("your bowl"), "the church; your bowl upside down on its steps")
	route = await _click(visit, column, "church_people")
	check(_log(column).contains("Four short lines, crossed."), "the congregation: the mark on wrist after wrist")
	route = await _click(visit, column, "church_pew")
	check(_log(column).contains("they put their hands on you"), "we pray for the Keeper: the whole town lays hands on you")
	await pick(column, "Bear it")
	_route(column)
	await wait(0.7)
	check(gs.flags.has("prayed_for") and visit.current_room() == "vestry", "you bear it; then the vestry")
	await _click(visit, column, "vestry_scale")
	await pick(column, "Step on the scale")
	_route(column)
	await wait(0.7)
	check(gs.flags.has("weighed") and _log(column).contains("Thomas was heavier."), "weighed: \"Thomas was heavier. By Christmas.\"")
	await _click(visit, column, "vestry_frame")
	check(gs.flags.has("measured") and _log(column).contains("JOHN. 1999."), "the doorframe: a pencil line, and the name")
	await _click(visit, column, "vestry_book")
	route = await _click(visit, column, "vestry_out")
	check(_log(column).contains("I told you to be busy.") and visit.current_room() == "hollis_kitchen", "the Reverend at the door; then Mrs. Hollis's kitchen")
	await _click(visit, column, "kitchen_chair")
	check(_log(column).contains("two round patches"), "by Ray's chair, two scrubbed patches on the floor")
	await _click(visit, column, "kitchen_rack")
	check(_log(column).contains("a dog's bowl") and _log(column).contains("hairpins"), "a dog's bowl on the rack, and no dog; hairpins")
	await _click(visit, column, "kitchen_door")
	check(_log(column).contains("Lunch is ready, honey"), "she talks through Cody's door")
	var fray: int = gs.fray
	visit.click("kitchen_table")
	_route(column)
	check(gs.fray == fray - 1 and _log(column).contains("You give her back her dish."), "lunch, and the dish back: a comfort")
	await wait(2.5)
	check(current_scene.name == "Map" and gs.day == 5, "the day ends: the evening, on the map")

func _church_walk_out() -> void:
	section("Sunday: church, then walk out")
	var visit: Node = await _open_sunday(["promised_sunday", "fed_four"])
	var column: Node = visit.get_node("%Narrator")
	var route: Array = _route(column)
	check(route.has("morning_bowl_fed"), "the bowl licked clean, a gray hair on the rim")
	await pick(column, "Go up to church")
	_route(column)
	await wait(0.7)
	await _click(visit, column, "church_pew")
	await pick(column, "walk out")
	_route(column)
	await wait(0.7)
	check(gs.flags.has("walked_out") and _log(column).contains("The Keeper wouldn't be prayed for."), "you walk out; Ezra: the Keeper wouldn't be prayed for")
	check(_log(column).contains("level with the top of your head") and visit.current_room() == "hollis_kitchen", "Ezra marks the doorframe as you pass; lunch anyway")

func _stay_home(go_out: bool) -> void:
	section("Sunday: stay in the shop, %s" % ("go out to them" if go_out else "watch them pray"))
	var visit: Node = await _open_sunday(["promised_sunday"] if not go_out else [])
	var column: Node = visit.get_node("%Narrator")
	_route(column)
	await pick(column, "Stay in the shop")
	_route(column)
	await wait(0.7)
	check(visit.current_room() == "shop" and _log(column).contains("they turn to face the window"), "the congregation comes down the hill and prays at the window")
	if go_out:
		await _click(visit, column, "shop_sunday_door")
		check(_log(column).contains("They part for you."), "they part for you; Mrs. Hollis holds your hand")
	else:
		await _click(visit, column, "shop_sunday_window")
		check(_log(column).contains("writes in it, standing in the road"), "you promised: Ezra writes in his little book")
	check(visit.current_room() == "hollis_kitchen", "at one, she knocks: lunch")

func _evening() -> void:
	section("The evening of day five: Ruth's house, Sam, the lake")
	gs.reset()
	gs.day = 5
	gs.minutes = SUNDAY_DAWN + 10 * 60 + 30
	for flag in ["door_ruth_1", "met_sam", "prayed_for", "weighed"]:
		gs.flags.append(flag)
	gs.visited.append("lake")
	var map: Node = await open_scene("res://scenes/map.tscn", 1.7)
	var column: Node = map.get_node("%DialogueColumn")
	advance(column)
	await process_frame
	var places: Array = map.shown_places()
	check(places.has("ruth_house") and not places.has("pub") and not places.has("church"), "Sunday: the Gleaner and the church are shut; Ruth's house is open")
	map.visit("ruth_house")
	_route(column)
	check(_log(column).contains("I saw them put their hands on you."), "Ruth saw the hands, from the back")
	await pick(column, "Lift the lid")
	advance(column)
	check(_log(column).contains("\"David.\"") and _log(column).contains("Not one of them sent."), "the shoebox: letters to \"David\", never sent")
	await process_frame
	map.visit("cabin")
	_route(column)
	check(_log(column).contains("They weighed you."), "Sam watched the church through binoculars")
	await process_frame
	map.visit("lake")
	_route(column)
	check(_log(column).contains("red wool"), "a wreath on the poles, tied with red wool")

func _night() -> void:
	section("The fifth night: the phone, a radio at the other end")
	gs.reset()
	gs.day = 5
	gs.minutes = SUNDAY_DAWN + 15 * 60
	gs.flags.append("spoke_first")
	gs.flags.append("fed_four")
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
	night.look("kitchen")
	advance(column)
	await pick(column, "Fill the bowl")
	advance(column)
	night.look("bed")
	advance(column)
	check(night.sounds["ring"].playing and _log(column).contains("As if your sentence were served."), "spoke first on night two, and still it rings: the sentence is served")
	await pick(column, "Go down to it")
	advance(column)
	await wait(0.7)
	night.click("night_shop_counter")
	await wait(0.7)
	night.click("night_shop_phone")
	advance(column)
	check(_log(column).contains("A second behind."), "at the other end, your radio's hymn, a second behind")
	await pick(column, "Wait")
	var route: Array = _route(column)
	check(route.has("night_dog_fed") and _log(column).contains("humming"), "fed: something on the stairs, humming the hymn")
	check(route[-1] == "morning_after", "then Monday")
	await wait(5.2)
	check(current_scene.name == "Counter" and gs.day == 6, "Monday morning: day six, at the counter")
