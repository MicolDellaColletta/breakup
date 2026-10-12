extends "res://tests/test_base.gd"

# Plays day four: the morning after night three, the jacket coming home (Cody
# or Mrs. Hollis), Hanna Lund's braid, Sam's first door, the phone in
# daylight; the Saturday evening; and the fourth night (the phone again, the
# dog on its knees).

# Saturday, October 9, 6:00 AM, counted from midnight on October 5.
const SATURDAY_DAWN: int = 4 * 24 * 60 + 6 * 60

func run() -> void:
	await _cody_hanna_priced_sam_true()
	await _widow_jacket_hanna_refused_sam_crossed()
	await _widow_held_hanna_blank_sam_john()
	await _evening()
	await _night(false)
	await _night(true)

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

# Day four at the counter. flags: what day and night three left behind.
func _open_day_four(flags: Array, sold_picks: bool, jacket: bool) -> Node:
	gs.reset()
	gs.day = 4
	gs.minutes = SATURDAY_DAWN
	gs.voices["appraisal"] = 2
	gs.voices["warmth"] = 1
	for flag in flags:
		gs.flags.append(flag)
	if sold_picks:
		gs.record_sale("Ice picks", "ice_picks", 12, "Cody Hollis")
	if jacket:
		gs.break_rule("warm")
		gs.record_pawn("Hunting jacket", "hollis_jacket", 10, "new", "A stranger")
	var counter: Node = await open_scene("res://scenes/counter.tscn")
	return counter

# Waits for the next visitor to come through the door.
func _next(column: Node) -> void:
	advance(column)
	await wait(1.8)
	advance(column)
	await process_frame

func _cody_hanna_priced_sam_true() -> void:
	section("Day four: waved, fed the dog (an inch off the line), stayed in bed; the jacket tagged, Cody alive")
	var counter: Node = await _open_day_four(["fed_three", "met_sam", "stayed_in_bed", "jacket_shelved", "door_ruth_1"], true, true)
	gs.break_rule("wave")
	var column: Node = counter.get_node("%DialogueColumn")
	check(root.get_node("Hud").get_node("%ClockLabel").text.begins_with("Sat Oct 9"), "the clock says Saturday, October 9")
	var route: Array = _route(column)
	check(route.has("morning_mirror_late") and route.has("morning_bowl_line") and route.has("morning_tape"), "the mirror half a second late, the bowl back on the line, tape on the bell")
	await wait(1.8)
	advance(column)
	await process_frame
	check(column._section == "nephew_enters", "Cody sees his uncle's jacket on the back shelf")
	await pick(column, "A stranger")
	advance(column)
	await pick(column, "Give it to him")
	advance(column)
	check(gs.flags.has("faith_hollis") and gs.sold.has("hollis_jacket") and gs.shelf_spot_of("hollis_jacket")[1] == -1, "giving it to him keeps faith with the Hollises")
	check(gs.ledger_lines[-1].contains("Hunting jacket, given back to Cody Hollis"), "the ledger says it went home")
	await _next(column)
	check(column._section == "hanna_enters", "Hanna Lund, with a braid, for the church")
	await pick(column, "two dollars")
	advance(column)
	check(gs.acquired.has("braid") and not gs.rules_broken.has("price"), "a price on the braid keeps rule three")
	check(gs.ledger_lines.any(func(l: String) -> bool: return l.contains("Braid of hair, Hanna Lund. Held for the church. $2")), "the ledger writes the price")
	await _next(column)
	check(column._section == "sam_enters", "Sam, in the shop for the first time")
	check(_log(column).contains("October 5, 1999. \"John\"."), "his notebook: your line, already started")
	await pick(column, "real name")
	advance(column)
	check(gs.flags.has("door_sam_1"), "your real name opens Sam's first door")
	check(_log(column).contains("Three. Ruth has something true too."), "Ruth and Sam both hold something true, and neither knows")
	await _next(column)
	check(gs.flags.has("daylight_call"), "the phone, once, in daylight")
	ring_bell()
	check(column._section == "closing" and gs.clock_text() == "7:02 PM", "then closing at sunset, 7:02 PM")

func _widow_jacket_hanna_refused_sam_crossed() -> void:
	section("Day four: didn't wave, didn't feed the dog; the jacket set aside for Mrs. Hollis")
	var counter: Node = await _open_day_four(["faith_hollis"], false, true)
	var column: Node = counter.get_node("%DialogueColumn")
	var route: Array = _route(column)
	check(route.has("morning_mirror_still") and route.has("morning_knees") and not route.has("morning_tape"), "the mirror keeps up; knee marks on the bottom stair")
	await wait(1.8)
	route = _route(column)
	check(route[0] == "widow_enters", "Mrs. Hollis comes")
	check(route.has("widow_jacket") and _log(column).contains("It's warm."), "you give her the jacket: \"It's warm.\" It isn't")
	check(gs.sold.has("hollis_jacket"), "it leaves the shop")
	await wait(1.8)
	advance(column)
	await process_frame
	await pick(column, "child's hair")
	advance(column)
	check(gs.rules_broken.has("price") and gs.acquired.has("braid") and gs.flags.has("hanna_refused"), "refusing: she writes it in herself, no price")
	await _next(column)
	await pick(column, "cross out")
	advance(column)
	check(gs.flags.has("sam_crossed") and not gs.flags.has("door_sam_1"), "crossing out John is a different answer, not the door")

func _widow_held_hanna_blank_sam_john() -> void:
	section("Day four: the jacket tagged, Cody under the ice: Mrs. Hollis sees it")
	var counter: Node = await _open_day_four(["jacket_shelved"], false, true)
	var column: Node = counter.get_node("%DialogueColumn")
	_route(column)
	await wait(1.8)
	advance(column)
	await process_frame
	check(column._section == "widow_sees_it", "Mrs. Hollis sees Ray's jacket on the back shelf")
	var till: int = gs.till
	await pick(column, "It's held")
	advance(column)
	check(gs.flags.has("broke_faith_hollis") and gs.till == till + 10, "selling it back to her for ten dollars breaks faith")
	check(gs.ledger_lines.any(func(l: String) -> bool: return l.contains("Hunting jacket, sold to Mrs. Hollis. $10")), "the ledger: sold to Mrs. Hollis")
	await _next(column)
	await pick(column, "Leave the price blank")
	advance(column)
	check(gs.rules_broken.has("price") and gs.flags.has("hanna_blank"), "no price breaks rule three")
	await _next(column)
	await pick(column, "\"John.\"")
	advance(column)
	check(_log(column).contains("Then I'll leave it blank."), "\"John.\": he leaves it blank")

func _evening() -> void:
	section("The evening of day four: the Gleaner, the cabin, the church, the lake")
	gs.reset()
	gs.day = 4
	gs.minutes = SATURDAY_DAWN + 13 * 60 + 2
	for flag in ["door_ruth_1", "met_sam", "door_sam_1", "hanna_priced"]:
		gs.flags.append(flag)
	gs.visited.append("lake")
	gs.voices["warmth"] = 1
	var map: Node = await open_scene("res://scenes/map.tscn", 1.7)
	var column: Node = map.get_node("%DialogueColumn")
	advance(column)
	await process_frame
	check(_log(column).contains("Saturday night."), "the map: Saturday night")
	map.visit("pub")
	var route: Array = _route(column)
	check(route.has("pub_four_napkin") and _log(column).contains("The word you told her last night."), "Ruth writes your word on a napkin, for you alone")
	check(_log(column).contains("They like a clean Keeper."), "Olstad: wear something clean")
	await process_frame
	map.visit("cabin")
	route = _route(column)
	check(route.has("cabin_four_notebook") and _log(column).contains("The ten."), "with Sam's door open, he shows you the ten names")
	await process_frame
	map.visit("church")
	route = _route(column)
	check(route.has("church_four") and _log(column).contains("pencil lines"), "the church on Saturday: the scale and the doorframe, through a door")
	await process_frame
	map.visit("lake")
	route = _route(column)
	check(route.has("lake_four") and _log(column).contains("nine's the Keeper"), "kids on the ice, playing the rhyme")

func _night(spoke_first: bool) -> void:
	section("The fourth night: %s" % ("spoke first on night two: silence" if spoke_first else "the phone at eleven"))
	gs.reset()
	gs.day = 4
	gs.minutes = SATURDAY_DAWN + 15 * 60
	if spoke_first:
		gs.flags.append("spoke_first")
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
	check(_log(column).contains("For the Keeper, who's settling in. Number three."), "the request hour: hymn three, for the Keeper")
	night.look("kitchen")
	advance(column)
	await pick(column, "Fill the bowl")
	advance(column)
	night.look("bed")
	var route: Array = _route(column)
	if spoke_first:
		check(route.has("sleep_silent") and not night.sounds["ring"].playing, "two nights of silence")
		check(route.has("night_dog_fed") and route[-1] == "morning_after", "the dog, then Sunday morning")
		await wait(5.2)
		check(current_scene.name == "Visit" and gs.day == 5, "Sunday morning: day five, no counter")
		return
	check(night.sounds["ring"].playing, "at eleven, the phone rings again")
	await pick(column, "Go down to it")
	advance(column)
	await wait(0.7)
	var hotspots: Node = night.get_node("%Hotspots")
	check(night.current_room() == "shop_hall" and hotspots.has_node("night_shop_counter") and not hotspots.has_node("night_shop_front"), "down the stairs, the way to the phone")
	night.click("night_shop_counter")
	await wait(0.7)
	night.click("night_shop_phone")
	advance(column)
	check(gs.rules_broken.has("phone") and _log(column).contains("Longer than last time."), "the open line, longer than before")
	await pick(column, "Wait")
	route = _route(column)
	check(_log(column).contains("a match struck"), "waiting: he strikes a match")
	check(route.has("night_dog_fed") and _log(column).contains("Knees."), "fed, it comes up the stairs on its knees")
	check(route[-1] == "morning_after", "then Sunday morning")
