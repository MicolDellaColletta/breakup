extends "res://tests/test_base.gd"

# Plays days six and seven, the end of week one. Monday: the snow, Olstad and
# the rental company's call, Ezra asking for a tooth, June and the flannel
# shirt; the town line; night six. Tuesday: Walt or the boy, the envelope a
# day early; and the John night (the revolver, the background settles, the
# first flash, the dog at the bedroom door).

# Monday, October 11, 6:00 AM, counted from midnight on October 5.
const MONDAY_DAWN: int = 6 * 24 * 60 + 6 * 60
const TUESDAY_DAWN: int = 7 * 24 * 60 + 6 * 60

func run() -> void:
	await _monday_date_tooth_shirt()
	await _monday_wrong_number_refusals()
	await _monday_evening()
	await _night_six()
	await _tuesday(false)
	await _tuesday(true)
	await _john_night("appraisal", "Wrap it", "witness", "Go on, sweetheart")
	await _john_night("tie", "snowbank", "guilt", "And laughs.")
	await _john_night("frayed", "Sit with it", "insanity", "3:12")

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

func _open_counter(day: int, dawn: int, flags: Array) -> Node:
	gs.reset()
	gs.day = day
	gs.minutes = dawn
	gs.voices["appraisal"] = 2
	gs.voices["warmth"] = 1
	gs.fray = 2
	for flag in flags:
		gs.flags.append(flag)
	return await open_scene("res://scenes/counter.tscn")

func _next(column: Node) -> void:
	advance(column)
	await wait(1.8)
	advance(column)
	await process_frame

func _monday_date_tooth_shirt() -> void:
	section("Monday: fed the dog, Teague came, weighed; shovel the walk, give a date, give the tooth, lend the shirt")
	var counter: Node = await _open_counter(6, MONDAY_DAWN, ["fed_five", "teague_came", "weighed"])
	var column: Node = counter.get_node("%DialogueColumn")
	check(root.get_node("Hud").get_node("%ClockLabel").text.begins_with("Mon Oct 11"), "the clock says Monday, October 11")
	_route(column)
	check(_log(column).contains("one set of footprints") and choices(column).size() == 2, "a foot of snow, footprints going out the back")
	var fray: int = gs.fray
	await pick(column, "Shovel the walk")
	_route(column)
	check(gs.fray == fray - 1, "shoveling: twenty minutes of nothing in your head (a comfort)")
	await wait(1.8)
	advance(column)
	await process_frame
	check(column._section == "trooper_enters" and _log(column).contains("Teague says it was opened twice."), "Olstad, at the bear: Teague told her")
	check(gs.flags.has("rental_call") and _log(column).contains("crackles on the surname"), "the rental company calls, in daylight, while she's there")
	await pick(column, "The thirtieth")
	advance(column)
	check(gs.flags.has("gave_return_date") and _log(column).contains("I burned them."), "you give a return date; she tells you about Thomas's photographs")
	await _next(column)
	check(column._section == "ezra_enters" and _log(column).contains("H.L. Eighty-nine."), "Ezra, for one tooth: Hanna's")
	await pick(column, "Get it for him")
	advance(column)
	check(gs.flags.has("gave_tooth"), "you give it to him")
	await _next(column)
	check(column._section == "june_enters", "June Merrill, for the pageant")
	await pick(column, "Fetch one")
	advance(column)
	check(gs.flags.has("lent_shirt"), "you lend her a Keeper's shirt, for the boy who plays the Keeper")
	await wait(1.8)
	ring_bell()
	check(column._section == "closing" and gs.clock_text() == "6:56 PM", "closing at sunset, 6:56 PM")

func _monday_wrong_number_refusals() -> void:
	section("Monday: leave the walk, \"wrong number\", refuse the tooth and the shirt")
	var counter: Node = await _open_counter(6, MONDAY_DAWN, [])
	var column: Node = counter.get_node("%DialogueColumn")
	_route(column)
	await pick(column, "Leave it")
	_route(column)
	await wait(1.8)
	advance(column)
	await process_frame
	check(_log(column).contains("Abraham ever tell you about the bear?"), "Olstad asks about the bear herself")
	await pick(column, "Wrong number")
	advance(column)
	check(_log(column).contains("Popular, aren't you."), "it rings again; Olstad watches you let it")
	await _next(column)
	await pick(column, "It's held")
	advance(column)
	check(gs.flags.has("refused_tooth") and _log(column).contains("By more of us."), "refused: it'll be asked again, on Sunday, by more of them")
	await _next(column)
	await pick(column, "I'm wearing them")
	advance(column)
	check(not gs.flags.has("lent_shirt"), "you keep the shirts")

func _monday_evening() -> void:
	section("The evening of day six: the town line, Sam's notebook, the poles")
	gs.reset()
	gs.day = 6
	gs.minutes = MONDAY_DAWN + 13 * 60
	gs.flags.append("met_sam")
	gs.visited.append("lake")
	var map: Node = await open_scene("res://scenes/map.tscn", 1.7)
	var column: Node = map.get_node("%DialogueColumn")
	advance(column)
	await process_frame
	check(map.shown_places().has("town_line"), "the town line is on the map")
	map.visit("town_line")
	_route(column)
	check(_log(column).contains("Two fingers. Hello."), "Olstad's cruiser in the turnout, lights off")
	await pick(column, "Keep driving")
	advance(column)
	check(gs.flags.has("tried_town_line") and _log(column).contains("Rental's not due till the thirtieth"), "you keep driving; she pulls you over, and sends you home")
	await process_frame
	map.visit("cabin")
	_route(column)
	check(gs.has_item("notebook"), "Sam gives you a notebook: KEEPER. 1999.")
	await process_frame
	map.visit("lake")
	_route(column)
	check(_log(column).contains("Not yet. December"), "men checking the poles: December, if it holds cold")

func _night_six() -> void:
	section("The sixth night: the notices, the light under the door, no phone")
	gs.reset()
	gs.day = 6
	gs.minutes = MONDAY_DAWN + 15 * 60
	gs.flags.append("weighed")
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
	check(_log(column).contains("was weighed yesterday"), "the notices: the Keeper's weight, between the plow and a lost dog")
	night.look("locked_door")
	advance(column)
	check(_log(column).contains("a line of light"), "a light under the locked door, for the first time")
	night.look("kitchen")
	advance(column)
	await pick(column, "Fill it")
	advance(column)
	night.look("bed")
	var route: Array = _route(column)
	check(not night.sounds["ring"].playing and route.has("night_dog_fed"), "no phone on Mondays; the dog comes up")
	check(_log(column).contains("Maybe \"there.\""), "and says something in the kitchen. Or breathes")
	check(route[-1] == "morning_after", "then Tuesday")
	await wait(5.2)
	check(current_scene.name == "Counter" and gs.day == 7, "Tuesday: day seven, at the counter")

func _tuesday(broke_name: bool) -> void:
	section("Tuesday: %s" % ("broke rule six: the boy" if broke_name else "kept rule six: Walt"))
	var counter: Node = await _open_counter(7, TUESDAY_DAWN, [])
	if broke_name:
		gs.break_rule("name")
	var column: Node = counter.get_node("%DialogueColumn")
	_route(column)
	await wait(1.8)
	advance(column)
	await process_frame
	if broke_name:
		check(column._section == "boy_enters" and _log(column).contains("Are you scared?"), "the boy: are you scared?")
		await pick(column, "Yes")
	else:
		check(column._section == "seller_enters" and _log(column).contains("Ida."), "Walt says her name out loud")
		await pick(column, "Tell me about her")
	advance(column)
	await wait(1.8)
	ring_bell()
	check(column._section == "closing", "then closing")
	advance(column)
	check(gs.clock_text() == "6:53 PM", "closing at 6:53 PM")
	counter._show_view("ledger")
	check(counter.get_node("%LedgerText").get_parsed_text().contains("Oct 12. One week."), "the ledger: a new line in the owner's hand, One week")
	if broke_name:
		return
	await process_frame
	await wait(0.5)
	gs.minutes = TUESDAY_DAWN + 13 * 60
	var map: Node = await open_scene("res://scenes/map.tscn", 1.7)
	var map_column: Node = map.get_node("%DialogueColumn")
	advance(map_column)
	await process_frame
	check(map.shown_places().is_empty(), "Tuesday evening: nowhere you want to go")

func _john_night(leaning: String, gun: String, background: String, flash_words: String) -> void:
	section("The John night: %s, %s" % [leaning, background])
	gs.reset()
	gs.day = 7
	gs.minutes = TUESDAY_DAWN + 15 * 60
	match leaning:
		"appraisal":
			gs.voices["appraisal"] = 3
		"tie":
			gs.voices["warmth"] = 2
			gs.voices["john"] = 2
		"frayed":
			gs.fray = 3
	root.get_node("Transition").go_to("res://scenes/night.tscn", 0.1)
	await wait(2.0)
	var night: Node = current_scene
	var column: Node = night.get_node("%Narrator")
	advance(column)
	await process_frame
	check(gs.has_item("revolver"), "John's revolver, up from the car, on the kitchen table")
	night.look("radio")
	advance(column)
	await pick(column, "Turn it on")
	advance(column)
	night.look("bed")
	_route(column)
	check(_log(column).contains("Even if you've put it down somewhere."), "the Reverend, late, unscheduled: the Lord knows your name")
	check(choices(column).size() == 5, "five things to do with the gun")
	await pick(column, gun)
	var route: Array = _route(column)
	check(gs.background_settled == background, "the background settles: %s" % background)
	check(route.has("flash_" + background) and _log(column).contains(flash_words), "the first flash of the night John died (%s)" % background)
	if background == "guilt":
		check(not gs.has_item("revolver"), "the gun's in the snowbank till May")
	check(_log(column).contains("It stops outside the bedroom door."), "the dog stops outside the bedroom door")
	check(route[-1] == "morning_after", "then Wednesday, and the second week")
	await wait(5.2)
	check(current_scene.name == "Bridge" and gs.day == 8, "then the bridge into week two")
