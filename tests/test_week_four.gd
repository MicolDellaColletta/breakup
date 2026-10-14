extends "res://tests/test_base.gd"

# Plays week four: key day 11 (the rental due: Olstad's "Who's John?", Mrs.
# Hollis's tape measure, Sam's trains, Ruth's candy), the evening, night
# eleven (the double hour: the clocks fall back, two calls at 1:40, and hard
# fork 2, the tin, four ways), key day 12 (Halloween: the car reported
# stolen, the children at the door dressed as the Keeper), night twelve, and
# the bridge into November.

const SATURDAY_DAWN: int = 25 * 24 * 60 + 6 * 60
const SUNDAY_DAWN: int = 26 * 24 * 60 + 6 * 60

func run() -> void:
	await _saturday()
	await _saturday_evening()
	await _double_hour("Write it out of the ledger", "tin_opened", true)
	await _double_hour("Get the hammer", "tin_opened", false)
	await _double_hour("Put it back", "tin_shut", false)
	await _double_hour("Run.", "tried_to_run", false)
	await _halloween(true)
	await _halloween(false)
	await _night_twelve()

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

func _saturday() -> void:
	section("Key day 11: the rental is due")
	_reset(11, SATURDAY_DAWN, ["knelt_with_sam", "door_ruth_1", "met_sam"])
	gs.voices["appraisal"] = 4
	gs.settle_background()
	var counter: Node = await open_scene("res://scenes/counter.tscn")
	var column: Node = counter.get_node("%DialogueColumn")
	check(root.get_node("Hud").get_node("%ClockLabel").text.begins_with("Sat Oct 30"), "Saturday, October 30")
	var route: Array = _route(column)
	check(route.has("morning_flash_witness"), "brushing off the car: what soaked the rental agreement (witness: the rain)")
	await wait(1.8)
	advance(column)
	await process_frame
	check(_log(column).contains("Who's John?"), "Olstad: \"Who's John?\"")
	await pick(column, "Somebody who rented a car")
	await _next(column)
	check(column._section == "widow_enters" and _log(column).contains("For the shoulders."), "Mrs. Hollis, with a tape measure")
	await pick(column, "Let her finish")
	await _next(column)
	check(column._section == "sam_enters" and _log(column).contains("the siding at Wasilla"), "Sam has worked out the trains")
	await pick(column, "Show me")
	advance(column)
	check(gs.flags.has("sam_map"), "his map, with a circle at Wasilla: \"him\"")
	await _next(column)
	check(gs.flags.has("ruth_candy"), "Ruth, with candy for tomorrow, looking at the car")
	ring_bell()
	check(column._section == "closing" and gs.clock_text() == "5:58 PM", "closing at 5:58 PM, the last late sunset")

func _saturday_evening() -> void:
	section("The evening of key day 11")
	_reset(11, SATURDAY_DAWN + 12 * 60, ["met_sam"])
	gs.visited.append("lake")
	var map: Node = await open_scene("res://scenes/map.tscn", 1.7)
	var column: Node = map.get_node("%DialogueColumn")
	advance(column)
	await process_frame
	map.visit("pub")
	_route(column)
	check(_log(column).contains("It's the Keeper.") and _log(column).contains("Nobody laughs again."), "the Gleaner's party: Teague in a brown blanket, as the Keeper")
	await process_frame
	map.visit("church")
	_route(column)
	check(_log(column).contains("four short lines, crossed"), "the church's jack-o'-lanterns carry the mark")

func _double_hour(choice: String, flag: String, redeem: bool) -> void:
	section("The double hour: %s" % choice)
	_reset(11, SATURDAY_DAWN + 16 * 60, [])
	gs.add_item("pawn_ticket")
	root.get_node("Transition").go_to("res://scenes/night.tscn", 0.1)
	await wait(2.0)
	var night: Node = current_scene
	var column: Node = night.get_node("%Narrator")
	advance(column)
	await process_frame
	night.look("kitchen")
	advance(column)
	await pick(column, "Fill it")
	advance(column)
	night.look("bed")
	_route(column)
	check(night.sounds["ring"].playing and gs.clock_text() == "1:40 AM", "1:40: the first call")
	await pick(column, "Go down to it")
	_route(column)
	check(gs.clock_text().begins_with("1:0") and _log(column).contains("it's 1:00 again"), "2:00, and the clocks go back: it's one o'clock again")
	await pick(column, choice)
	var route: Array = _route(column)
	check(gs.flags.has(flag), "hard fork 2: %s" % flag)
	if flag == "tin_opened":
		check(gs.has_item("locker_key") and _log(column).contains("LOCKER 114"), "inside: a key, and a locker at the Anchorage bus depot")
		if redeem:
			check(gs.ledger_lines[-1].contains("Tin box, redeemed. Ticket 0527.") and not gs.has_item("pawn_ticket"), "redeemed properly: the ledger line, the ticket in the drawer")
	if flag == "tried_to_run":
		check(_log(column).contains("headlights on, pointing back at town"), "at the town line, Olstad's headlights; the pass is a white wall")
	check(route[-1] == "call_two" and gs.clock_text() == "1:40 AM", "1:40, again: the second call")
	await pick(column, "Go down to it")
	route = _route(column)
	check(_log(column).contains("His fell back too.") and _log(column).contains("he laughs"), "his clock chimes one; he laughs")
	check(route[-1] == "morning_after", "then Halloween morning")
	await wait(5.2)
	check(current_scene.name == "Visit" and gs.day == 12, "Halloween: a walk-around day")

func _halloween(open_door: bool) -> void:
	section("Halloween: %s" % ("open the door" if open_door else "stay behind the counter"))
	_reset(12, SUNDAY_DAWN, ["ruth_candy", "tried_to_run"])
	root.get_node("Transition").go_to("res://scenes/visit.tscn", 0.1)
	await wait(2.0)
	var visit: Node = current_scene
	var column: Node = visit.get_node("%Narrator")
	_route(column)
	await wait(0.7)
	check(_log(column).contains("Stolen vehicle.") and _log(column).contains("I was saving you the trip."), "Olstad: the car's reported stolen; she's the only one who's read it")
	check(_log(column).contains("Every one of them is dressed as the Keeper.") and visit.current_room() == "shop", "at dark, the children, every one dressed as the Keeper")
	visit.click("halloween_door" if open_door else "halloween_hide")
	_route(column)
	if open_door:
		check(_log(column).contains("Are you the real one?"), "candy, the rhyme, and the smallest one: \"Are you the real one?\"")
	else:
		check(_log(column).contains("a little paper coat"), "they wait at the glass; in the morning, a paper coat on the step")
	await wait(2.5)
	check(current_scene.name == "Night", "then Halloween night")

func _night_twelve() -> void:
	section("Halloween night, and November")
	_reset(12, SUNDAY_DAWN + 13 * 60, ["tin_opened"])
	gs.add_item("locker_key")
	root.get_node("Transition").go_to("res://scenes/night.tscn", 0.1)
	await wait(2.0)
	var night: Node = current_scene
	var column: Node = night.get_node("%Narrator")
	advance(column)
	await process_frame
	check(_log(column).contains("two headlights, pointed at the shop"), "Olstad's headlights on the shop, all night")
	night.look("dresser")
	advance(column)
	check(_log(column).contains("Anchorage is three hours away."), "the locker key, from pocket to mattress to pocket")
	night.look("bed")
	var route: Array = _route(column)
	check(not night.sounds["ring"].playing and _log(column).contains("He's had his two."), "no call tonight")
	check(route[-1] == "morning_after", "then November")
	await wait(5.2)
	check(current_scene.name == "Bridge" and gs.day == 13, "the bridge into November")
	await wait(2.0)
	var bridge: Node = current_scene
	_route(bridge.get_node("%Narrator"))
	check(_log(bridge.get_node("%Narrator")).contains("Sixty days, friends.") and bridge.card_text() == "Wednesday. The Keeper is paid.", "November. The Keeper stays; then the first November envelope")
	await wait(3.5)
	check(current_scene.name == "Counter" and gs.day == 13, "then November: key day 13")
