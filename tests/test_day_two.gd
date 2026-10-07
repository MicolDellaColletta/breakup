extends "res://tests/test_base.gd"

# Plays day two: the morning after night one, the counter (Cody or Mrs.
# Hollis, Ezra Lund, Walt Pruitt, Ruth), the evening (the church, Sam's
# cabin), and the second night (the Thursday broadcast, the phone, the dog).

# Thursday, October 7, 6:00 AM, counted from midnight on October 5.
const THURSDAY_DAWN: int = 2 * 24 * 60 + 6 * 60

func run() -> void:
	await _cody_ezra_found_walt_accepts_ruth_upstairs()
	await _widow_ezra_fails_walt_refused_ruth_refused()
	await _evening()
	await _night("Wait", true, "phone_neighbour")
	await _night("Wait", false, "phone_open_line")
	await _night("Hello", false, "phone_spoke")

func _log(column: Node) -> String:
	var text: String = ""
	for entry in column.get_node("%Log").get_children():
		text += entry.get_parsed_text() + "\n"
	return text

# Day two at the counter, after a first night that went one way or the other.
func _open_day_two(good_night: bool, sold_picks: bool, took_coins: bool) -> Node:
	gs.reset()
	gs.day = 2
	gs.minutes = THURSDAY_DAWN
	gs.fed_dog = good_night
	gs.locked_back_door = good_night
	if not good_night:
		gs.break_rule("wave")
	gs.voices["appraisal"] = 2
	if sold_picks:
		gs.record_sale("Ice picks", "ice_picks", 12, "Cody Hollis")
	if took_coins:
		gs.break_rule("warm")
		gs.record_pawn("Thirty silver dollars", "silver_dollars", 30, "0432", "Walt Pruitt")
	var counter: Node = await open_scene("res://scenes/counter.tscn")
	return counter

# Plays the morning; returns the route it took.
func _morning(column: Node) -> Array:
	var route: Array = [column._section]
	for i in 30:
		column._on_advance_pressed()
		if route[-1] != column._section:
			route.append(column._section)
	return route

# Waits for the next visitor to come through the door.
func _next(column: Node) -> void:
	advance(column)
	await wait(1.8)
	advance(column)
	await process_frame

func _cody_ezra_found_walt_accepts_ruth_upstairs() -> void:
	section("Day two: fed the dog, locked the door, sold Cody the picks, took the coins")
	var counter: Node = await _open_day_two(true, true, true)
	var column: Node = counter.get_node("%DialogueColumn")
	check(root.get_node("Hud").get_node("%ClockLabel").text.begins_with("Thu Oct 7"), "the clock says Thursday, October 7")
	var route: Array = _morning(column)
	check(route.has("morning_fed") and route.has("morning_door_locked") and route.has("morning_still"), "the morning remembers the dog, the lock and the window")
	check(_log(column).contains("Not a dog's"), "a strong Appraisal knows the hairs aren't a dog's")
	await wait(1.8)
	advance(column)
	await process_frame
	check(column._section == "nephew_enters", "Cody comes in alive: he had the picks")
	await pick(column, "all right")
	advance(column)
	await pick(column, "ticket")
	check(gs.pawn_tag_of("ice_picks_held") == "0433", "the picks get the next ticket after Walt's 0432")
	check(gs.ledger_lines[-1].contains("Ice picks, pawned by Cody Hollis, tag 0433. $6 loan"), "the ledger writes Cody's pawn")
	await _next(column)
	check(column._section == "ezra_enters", "then Ezra Lund: 'The usual.'")
	check(choices(column) == ["Check the ledger", "\"The usual what?\""], "no drawer choice before you've seen the shells")
	await pick(column, "ledger")
	advance(column)
	await pick(column, "drawer")
	advance(column)
	check(gs.sold.has("shells") and gs.flags.has("ezra_satisfied"), "the shells in the drawer: Ezra is satisfied")
	await pick(column, "be there")
	check(gs.flags.has("promised_sunday"), "promising Sunday is remembered")
	await _next(column)
	check(column._section == "walt_asks", "then Walt Pruitt")
	check(_log(column).contains("The silver didn't help"), "Walt remembers you took the silver")
	await pick(column, "Write him a ticket")
	advance(column)
	check(gs.flags.has("ida_pawned") and gs.rules_broken.has("name"), "taking the name breaks rule six")
	check(gs.acquired.has("name_ida") and gs.ledger_lines[-1].contains("One name, pawned by Walt Pruitt, tag 0434. No loan"), "one name, held, no loan")
	await _next(column)
	check(column._section == "ruth_enters", "then Ruth, with the mail")
	check(gs.has_item("rental_letter"), "the rental company's letter goes in your pocket")
	await pick(column, "Go ahead")
	var ruth_route: Array = _morning(column)
	check(gs.flags.has("ruth_upstairs") and ruth_route.has("ruth_bowl_fed"), "upstairs, she sees the bowl you've been filling")
	await wait(1.8)
	check(column._section == "closing" and gs.clock_text() == "7:08 PM", "closing at sunset, 7:08 PM")
	advance(column)
	await process_frame
	counter._show_view("back")
	var shelf: Array = counter.get_node("%ShelfItems").get_children().filter(
		func(b: Node) -> bool: return not b.is_queued_for_deletion()).map(func(b: Node) -> String: return b.text)
	check(shelf.has("Ice picks") and shelf.has("One name"), "the picks and the name are on the back shelf")
	counter._show_view("ledger")
	var ledger: String = counter.get_node("%LedgerText").get_parsed_text()
	check(ledger.contains("OLDER PAGES") and ledger.contains("E. Lund. .22 shells"), "the ledger's older pages show Ezra's Thursdays")

func _widow_ezra_fails_walt_refused_ruth_refused() -> void:
	section("Day two: left the dog unfed and the door open, waved, didn't sell the picks or take the coins")
	var counter: Node = await _open_day_two(false, false, false)
	var column: Node = counter.get_node("%DialogueColumn")
	var route: Array = _morning(column)
	check(route.has("morning_unfed") and route.has("morning_door_open") and route.has("morning_waved"), "the morning remembers it all")
	await wait(1.8)
	advance(column)
	await process_frame
	check(column._section == "widow_enters", "Mrs. Hollis comes instead: Cody didn't come home")
	await pick(column, "Leave the price blank")
	check(gs.ledger_lines[-1].ends_with("Cody Hollis went out on the ice.") and gs.rules_broken.has("price"), "a ledger line with no price breaks rule three")
	await _next(column)
	check(column._section == "ezra_enters", "then Ezra")
	await pick(column, "usual what")
	check(gs.flags.has("ezra_doubts") and not gs.sold.has("shells"), "Ezra leaves doubting you")
	await _next(column)
	check(_log(column).contains("You were right not to take those"), "Walt remembers you refused the silver")
	await pick(column, "I'm sorry")
	check(not gs.rules_broken.has("name") and not gs.acquired.has("name_ida"), "refusing kindly keeps rule six")
	await _next(column)
	await pick(column, "rather you didn't")
	check(gs.flags.has("ruth_refused"), "keeping Ruth out is remembered")

func _evening() -> void:
	section("The evening of day two: the church and the cabin")
	gs.reset()
	gs.day = 2
	gs.minutes = THURSDAY_DAWN + 13 * 60 + 10
	gs.flags.append("ezra_satisfied")
	var map: Node = await open_scene("res://scenes/map.tscn", 1.7)
	var column: Node = map.get_node("%DialogueColumn")
	advance(column)
	await process_frame
	check(map.shown_places() == ["pub", "lake", "church"], "the pub (no invitation needed now), the lake and the church")
	map.visit("lake")
	advance(column)
	await process_frame
	check(map.shown_places() == ["pub", "church", "cabin"], "after the lake, the cabin on the shore")
	map.visit("cabin")
	advance(column)
	await pick(column, "Who are you")
	advance(column)
	check(_log(column).contains("Ten. I have them in the notebook"), "Sam counts the Keepers")
	await process_frame
	map.visit("church")
	advance(column)
	await pick(column, "Say nothing")
	advance(column)
	check(gs.flags.has("at_church") and not gs.flags.has("said_on_air"), "at the church, and nothing said on the air")
	check(gs.visited.has("lake") and gs.visited.has("cabin") and gs.visited.has("church"), "every place is remembered as visited")

func _night(answer: String, ida: bool, expected: String) -> void:
	section("The second night: %s%s" % [answer.to_lower(), ", Ida's name pawned" if ida else ""])
	gs.reset()
	gs.day = 2
	gs.minutes = THURSDAY_DAWN + 15 * 60
	gs.flags.append("at_church")
	if ida:
		gs.flags.append("ida_pawned")
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
	check(_log(column).contains("One. Five. Four.") and _log(column).contains("thank you to our visitor"), "the Thursday broadcast reads the rules as hymn numbers, and thanks the visitor")
	night.look("kitchen")
	advance(column)
	await pick(column, "Fill the bowl")
	advance(column)
	night.look("bed")
	advance(column)
	check(night.sounds["ring"].playing, "at eleven, the shop phone rings")
	await pick(column, "answer it")
	advance(column)
	await pick(column, answer)
	check(not night.sounds["ring"].playing, "picking up stops the ringing")
	var route: Array = [column._section]
	for i in 40:
		column._on_advance_pressed()
		if route[-1] != column._section:
			route.append(column._section)
	check(route.has(expected), "the call plays %s" % expected)
	check(route.has("night_dog_fed"), "fed, the dog comes up the stairs in the night")
	check(route[-1] == "morning_after", "then Friday morning")
	await wait(4.5)
	check(current_scene.name == "Title" and gs.day == 3, "day three isn't written yet: back to the title screen")
