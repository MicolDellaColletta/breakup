extends "res://tests/test_base.gd"

# Plays Thanksgiving week: key day 16 at the counter (Mrs. Hollis's place for
# whoever, three ways; the man in the good coat and Ezra's Thursday shells,
# both ways; whoever MC told: Olstad, Sam's note, or June's program), the
# evening (Ruth's mother's bowl, the rehearsal), night 16 (no call; the
# payphone's receiver hanging), key day 17 (the potluck, the empty place, the
# pie, the pageant, his voice on the radio in the hall, the vestry door),
# night 17 (the plate for the Keeper's dog), and the bridge to December.

const WEDNESDAY_DAWN: int = 50 * 24 * 60 + 6 * 60
const THANKSGIVING_DAWN: int = 51 * 24 * 60 + 6 * 60

func run() -> void:
	await _wednesday_olstad()
	await _wednesday_sam()
	await _wednesday_june()
	await _evening()
	await _night_sixteen()
	await _thanksgiving()
	await _night_seventeen()

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

func _open_counter(flags: Array) -> Array:
	_reset(16, WEDNESDAY_DAWN, flags)
	var counter: Node = await open_scene("res://scenes/counter.tscn")
	var column: Node = counter.get_node("%DialogueColumn")
	return [counter, column]

func _hand_over(counter: Node, column: Node, item_id: String) -> void:
	await pick(column, "Let me look")
	counter._show_view("back" if gs.shelf_spot_of(item_id)[0] == "back" else "left")
	counter._select(item_id)
	counter._on_offer_pressed()
	advance(column)

func _wednesday_olstad() -> void:
	section("Key day 16: the duck call, the shells sold, Olstad")
	var opened: Array = await _open_counter(["told_olstad_daniel", "door_daniel_1", "there_you_are", "met_sam"])
	var counter: Node = opened[0]
	var column: Node = opened[1]
	var cash: int = gs.cash
	check(root.get_node("Hud").get_node("%ClockLabel").text.begins_with("Wed Nov 24"), "the clock says Wednesday, November 24")
	_route(column)
	check(_log(column).contains("Olstad's cruiser, engine running") and _log(column).contains("In his rhythm."), "the morning reads last night: Olstad's cruiser; \"There you are\" in your mouth")
	check(gs.cash == cash + 150 and _log(column).contains("For the Keeper's table."), "the envelope, and a child's turkey card")
	await wait(1.8)
	advance(column)
	await process_frame
	check(column._section == "widow_enters" and _log(column).contains("Something of his."), "Mrs. Hollis: a place set for whoever, something of his")
	await _hand_over(counter, column, "duck_call")
	check(gs.flags.has("place_duck_call") and gs.sold.has("duck_call") and _log(column).contains("He'll hear that."), "the duck call: \"He'll hear that.\"")
	await _next(column)
	check(column._section == "daniel_asks" and _log(column).contains("the way you'd look at a word you'd taught someone"), "the man in the good coat says nothing of yesterday")
	check(_log(column).contains("whatever Mr. Lund buys on Thursdays."), "he asks for Ezra's Thursday box")
	await pick(column, "Sell him the box")
	advance(column)
	check(gs.flags.has("sold_ezra_shells") and gs.sold.has("shells"), "you sell him the shells")
	advance(column)
	await process_frame
	check(column._section == "trooper_enters" and _log(column).contains("Stay where I can see you."), "you told Olstad: a permit for everything, a hole nobody stitched")
	ring_bell()
	check(column._section == "closing", "closing")

func _wednesday_sam() -> void:
	section("Key day 16: nothing on the place, the shells kept, Sam's note")
	var opened: Array = await _open_counter(["told_sam_daniel", "refused_bullet", "met_sam"])
	var counter: Node = opened[0]
	var column: Node = opened[1]
	_route(column)
	check(_log(column).contains("The curtains drawn."), "the morning: Sam's curtains drawn at noon")
	await wait(1.8)
	advance(column)
	await process_frame
	await pick(column, "Let me look")
	counter._on_nothing_pressed()
	advance(column)
	check(gs.flags.has("place_bare") and _log(column).contains("Then the place stays bare."), "nothing: the place stays bare")
	await _next(column)
	check(_log(column).contains("The matches kept me warm."), "you refused the bullet: the matches kept him warm")
	await pick(column, "That's spoken for")
	advance(column)
	check(gs.flags.has("kept_ezra_shells") and not gs.sold.has("shells") and _log(column).contains("Everything here is someone's."), "\"That's spoken for.\" \"Everything here is someone's.\"")
	advance(column)
	await process_frame
	check(column._section == "sam_enters" and gs.flags.has("sam_pie_note") and _log(column).contains("Don't eat the pie."), "you told Sam: a note under the door, \"Don't eat the pie.\"")

func _wednesday_june() -> void:
	section("Key day 16: the jacket, and June's program")
	var opened: Array = await _open_counter(["took_bullet", "lent_shirt"])
	var counter: Node = opened[0]
	var column: Node = opened[1]
	gs.record_pawn("Hunting jacket", "hollis_jacket", 10, "new", "A stranger")
	counter._fill_shelves()
	_route(column)
	check(_log(column).contains("Still warm."), "the morning: the bullet on the back shelf, still warm")
	await wait(1.8)
	advance(column)
	await process_frame
	await _hand_over(counter, column, "ice_picks")
	check(column._section == "widow_given_ice_picks" and _log(column).contains("Not those."), "the ice picks: \"Not those.\"")
	await pick(column, "Look again")
	counter._show_view("back")
	counter._select("hollis_jacket")
	counter._on_offer_pressed()
	advance(column)
	check(gs.flags.has("place_jacket") and gs.sold.has("hollis_jacket"), "Ray's jacket: \"Oh, he'll be warm.\"")
	await _next(column)
	check(_log(column).contains("Keeping well?"), "you took the bullet: \"Keeping well?\"")
	await pick(column, "Sell him the box")
	advance(column)
	advance(column)
	await process_frame
	check(column._section == "june_enters" and _log(column).contains("THE KEEPER ..... JOHN."), "you told no one: June, with the program, JOHN in capitals")
	check(_log(column).contains("Your shirt."), "the boy in your red flannel shirt, waving")

func _evening() -> void:
	section("The evening of key day 16: Ruth's bowl, the rehearsal")
	_reset(16, WEDNESDAY_DAWN + 10 * 60, ["told_sam_daniel", "met_sam"])
	var map: Node = await open_scene("res://scenes/map.tscn", 1.7)
	var column: Node = map.get_node("%DialogueColumn")
	advance(column)
	check(_log(column).contains("small figures crossing a white floor"), "the town: the hall lit, figures crossing a white floor")
	column.start_conversation("pub")
	advance(column)
	check(_log(column).contains("Mom's. She'd have wanted it out."), "the Gleaner: Ruth polishing her mother's bowl")
	column.start_conversation("church")
	advance(column)
	check(_log(column).contains("You get to nine."), "the hall: the pageant rehearsed, to nine")
	column.start_conversation("cabin")
	advance(column)
	check(_log(column).contains("Did you get my note."), "Sam, behind the door: \"Did you get my note.\"")

func _night_sixteen() -> void:
	section("The sixteenth night: no call; the payphone")
	_reset(16, WEDNESDAY_DAWN + 15 * 60, [])
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
	check(_log(column).contains("Bring your radios to the hall."), "the radio: tomorrow, our guest, on the Thursday watch")
	night.look("odd_payphone")
	advance(column)
	check(gs.flags.has("saw_payphone") and _log(column).contains("turning slowly in the wind"), "out of place: the payphone's receiver, hanging, turning")
	night.look("bed")
	var route: Array = _route(column)
	check(not night.sounds["ring"].playing and _log(column).contains("It doesn't ring."), "no call tonight")
	check(route[-1] == "morning_after" and _log(column).contains("The receiver back on its hook."), "then Thursday; somebody hung it up")
	await wait(5.2)
	check(current_scene.name == "Visit" and gs.day == 17, "then Thanksgiving, a walk-around day")
	check(root.get_node("Hud").get_node("%ClockLabel").text.begins_with("Thu Nov 25"), "Thursday, November 25")

func _thanksgiving() -> void:
	section("Key day 17: Thanksgiving")
	_reset(17, THANKSGIVING_DAWN, ["place_duck_call", "sam_pie_note", "met_sam", "there_you_are", "lent_shirt", "sold_ezra_shells"])
	root.get_node("Transition").go_to("res://scenes/visit.tscn", 0.1)
	await wait(2.0)
	var visit: Node = current_scene
	var column: Node = visit.get_node("%Narrator")
	_route(column)
	await wait(0.7)
	check(_log(column).contains("THE KEEPER IS AT TABLE."), "the sign: CLOSED FOR THANKSGIVING. THE KEEPER IS AT TABLE.")
	check(visit.current_room() == "hall" and _log(column).contains("And for the Keeper, who keeps."), "the hall; Ezra's grace, for the Keeper")
	visit.click("hall_place")
	_route(column)
	check(_log(column).contains("Ray's duck call"), "on the empty place: the duck call you gave her")
	await pick(column, "Sit in the empty place")
	_route(column)
	await wait(0.2)
	check(gs.flags.has("sat_in_place") and _log(column).contains("There. Now."), "you sit in the empty place: \"There. Now.\"")
	visit.click("hall_olstad")
	_route(column)
	await wait(0.2)
	check(_log(column).contains("The two bachelors."), "Olstad: \"The two bachelors.\" She doesn't take it back")
	visit.click("hall_him")
	_route(column)
	await wait(0.2)
	check(_log(column).contains("until it stops in front of you"), "he passes the salt down the table, to you")
	visit.click("hall_pies")
	_route(column)
	await pick(column, "Put it down")
	_route(column)
	await wait(0.2)
	check(gs.flags.has("refused_pie") and _log(column).contains("I'll keep it for you."), "Sam's note: you refuse the pie, and Mrs. Hollis's face")
	visit.click("hall_pageant")
	_route(column, 120)
	await wait(0.7)
	check(_log(column).contains("Your shirt. Tommy Pruitt.") and _log(column).contains("And then the lights go down."), "the pageant: Tommy in your shirt, out to the edge, the lights go down")
	check(_log(column).contains("The boy is at the edge of the stage, bowing."), "the lights come up; the boy is bowing")
	check(gs.flags.has("pageant_done"), "the pageant's done")
	check(visit.current_room() == "hall", "back in the hall for the Thursday watch (in %s)" % visit.current_room())
	check(_log(column).contains("You need someone to carry it for you. And you have one."), "his voice on the radio on the pie table: Leviticus 16, and the goat")
	visit.click("hall_vestry")
	_route(column)
	await wait(0.2)
	check(_log(column).contains("ON AIR"), "the vestry door: the red bulb, his back")
	visit.click("hall_home")
	_route(column)
	await wait(2.5)
	check(current_scene.name == "Night", "the walk home; then the night")

func _night_seventeen() -> void:
	section("The seventeenth night: for the Keeper's dog; the bridge to December")
	var night: Node = current_scene
	await wait(2.0)
	night = current_scene
	var column: Node = night.get_node("%Narrator")
	advance(column)
	await process_frame
	night.look("odd_plate")
	advance(column)
	check(gs.flags.has("saw_plate") and _log(column).contains("For the Keeper's dog."), "out of place: a plate on the back step, for the Keeper's dog")
	night.look("bed")
	var route: Array = _route(column)
	check(route[-1] == "morning_after", "then Friday")
	await wait(5.2)
	check(current_scene.name == "Bridge" and gs.day == 18, "the bridge to December")
	await wait(2.0)
	_route(current_scene.get_node("%Narrator"))
	check(current_scene.card_text() == "Tuesday. The Keeper is paid.", "Friday, Sunday, Tuesday: the envelope, and nothing with it")
	check(root.get_node("Hud").get_node("%ClockLabel").text.begins_with("Tue Nov 30"), "the clock says Tuesday, November 30")
	await wait(4.0)
	check(current_scene.name == "Counter" and gs.day == 18, "then December, at the counter")
