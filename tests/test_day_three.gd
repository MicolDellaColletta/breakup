extends "res://tests/test_base.gd"

# Plays day three: the morning after night two, window day, the counter
# (Olstad and the money order, the gift, the caller the window brings, the
# warm jacket), the Friday evening (Ruth's question, Sam, the dark church),
# and the third night (no call, ??? in a cadence MC knows, the window).

# Friday, October 8, 6:00 AM, counted from midnight on October 5.
const FRIDAY_DAWN: int = 3 * 24 * 60 + 6 * 60

func run() -> void:
	await _widow_june_jacket_set_aside()
	await _boy_teague_jacket_refused()
	await _walt_quiet_afternoon()
	await _evening()
	await _night(true)
	await _night(false)

func _log(column: Node) -> String:
	var text: String = ""
	for entry in column.get_node("%Log").get_children():
		text += entry.get_parsed_text() + "\n"
	return text

# Plays on until a choice or the end; returns the route it took.
func _route(column: Node, times: int = 40) -> Array:
	ring_bell()
	var route: Array = [column._section]
	for i in times:
		column._on_advance_pressed()
		if route[-1] != column._section:
			route.append(column._section)
	return route

# Day three at the counter. flags: what night two left behind.
func _open_day_three(flags: Array, sold_call: bool, pawned_name: bool) -> Node:
	gs.reset()
	gs.day = 3
	gs.minutes = FRIDAY_DAWN
	gs.voices["appraisal"] = 2
	gs.voices["warmth"] = 1
	gs.fray = 2
	for flag in flags:
		gs.flags.append(flag)
	gs.add_item("pawn_ticket")
	if sold_call:
		gs.record_sale("Duck call", "duck_call", 15, "Mrs. Hollis")
	if pawned_name:
		gs.break_rule("name")
		gs.record_pawn("One name", "name_ida", 0, "new", "Walt Pruitt")
	var counter: Node = await open_scene("res://scenes/counter.tscn")
	return counter

# Puts things in the front window, the way the player would before opening.
func _dress_window(items: Array) -> void:
	for i in items.size():
		gs.place_on_shelf(items[i], "window", i)

# Waits for the next visitor to come through the door.
func _next(column: Node) -> void:
	advance(column)
	await wait(1.8)
	advance(column)
	await process_frame

func _open_up(column: Node) -> void:
	await pick(column, "Open up")
	advance(column)
	await wait(1.8)
	advance(column)
	await process_frame

func _widow_june_jacket_set_aside() -> void:
	section("Day three: spoke first, fed the dog, the bulletin; the duck call sold; snowshoes in the window")
	var counter: Node = await _open_day_three(["spoke_first", "fed_two"], true, false)
	gs.add_item("church_bulletin")
	var column: Node = counter.get_node("%DialogueColumn")
	check(root.get_node("Hud").get_node("%ClockLabel").text.begins_with("Fri Oct 8"), "the clock says Friday, October 8")
	var route: Array = _route(column, 80)
	check(route.has("morning_off_hook") and route.has("morning_fed") and route.has("morning_bulletin_out"), "the morning remembers the phone, the bowl and the bulletin")
	check(route[-1] == "window_day" and choices(column) == ["Open up"], "Friday is window day: dress it, then open up")
	_dress_window(["snowshoes"])
	await _open_up(column)
	check(column._section == "trooper_enters", "Olstad first, with the mail")
	check(gs.has_item("money_order"), "the money order goes in your pocket: interest, ticket 0527")
	check(choices(column).has("Show her the ticket"), "you can show her the ticket, since you have it")
	var tin_before: Array = gs.shelf_spot_of("tin_box")
	await pick(column, "Show her the ticket")
	advance(column)
	check(gs.flags.has("showed_olstad_ticket"), "showing Olstad the ticket is remembered")
	var tin_after: Array = gs.shelf_spot_of("tin_box")
	check(tin_after[0] == "back" and tin_after[1] != tin_before[1], "she puts the tin back in the wrong spot")
	check(_log(column).contains("Snowshoes. Practical."), "she says something about the window")
	await _next(column)
	check(column._section == "widow_enters", "the gift: Mrs. Hollis, with a dish, for the duck call")
	var fray: int = gs.fray
	await pick(column, "Eat some")
	advance(column)
	check(gs.fray == fray - 1, "eating it is the first comfort: fray goes down")
	await _next(column)
	check(column._section == "june_enters", "the snowshoes bring June Merrill")
	await pick(column, "Let me look")
	counter._show_view("back")
	counter._select("pocket_watch")
	check(counter.get_node("%OfferButton").visible, "a held thing on the back shelf can be handed over")
	counter._on_offer_pressed()
	advance(column)
	check(column._section == "june_given_other", "the watch isn't hers")
	await pick(column, "Look again")
	counter._show_view("back")
	counter._select("music_box")
	counter._on_offer_pressed()
	advance(column)
	await pick(column, "Give it to her")
	advance(column)
	check(gs.flags.has("gave_music_box") and gs.sold.has("music_box") and gs.shelf_spot_of("music_box")[1] == -1, "the music box goes home with her")
	check(gs.ledger_lines[-1].contains("Music box, given back to June Merrill. No ticket."), "the ledger says it was given back")
	await _next(column)
	check(column._section == "stranger_offer" and _log(column).contains("Both of them warm."), "the stranger with the warm jacket, beside the warm dish")
	await pick(column, "Buy it")
	check(gs.rules_broken.has("warm") and gs.acquired.has("hollis_jacket"), "buying it breaks rule two")
	advance(column)
	await pick(column, "Set it aside")
	advance(column)
	check(gs.flags.has("faith_hollis"), "setting it aside for Mrs. Hollis keeps faith with the Hollises")
	await wait(1.8)
	ring_bell()
	check(column._section == "closing" and gs.clock_text() == "7:05 PM", "closing at sunset, 7:05 PM")

func _boy_teague_jacket_refused() -> void:
	section("Day three: let it ring, the dog unfed, Ida's name pawned; the fox in the window")
	var counter: Node = await _open_day_three(["phone_ignored", "heard_neighbour"], false, true)
	var column: Node = counter.get_node("%DialogueColumn")
	var route: Array = _route(column, 80)
	check(route.has("morning_message") and route.has("morning_unfed") and not route.has("morning_bulletin_out"), "a message slip under the door, gray hair on the step")
	_dress_window(["fox", "snowshoes"])
	await pick(column, "Open up")
	route = _route(column, 80)
	check(route.has("opening_walt"), "Walt at the door: somebody called for him last night")
	await wait(1.8)
	advance(column)
	await process_frame
	check(column._section == "trooper_enters", "then Olstad")
	await pick(column, "I don't know")
	advance(column)
	check(_log(column).contains("The fox. With the eyes."), "she sees the fox in the window")
	await _next(column)
	check(column._section == "boy_enters", "the gift: a boy with fry bread")
	await pick(column, "Take it")
	await _next(column)
	check(column._section == "teague_enters", "the fox brings Teague, before June")
	await pick(column, "ledger says")
	advance(column)
	check(_log(column).contains("mounted twice"), "he says the bear was mounted twice")
	await pick(column, "Sixty dollars")
	check(gs.sold.has("fox") and gs.shelf_window.find("fox") == -1, "he buys the fox out of the window")
	await _next(column)
	check(column._section == "stranger_offer" and not _log(column).contains("Both of them warm."), "then the stranger")
	await pick(column, "anything warm")
	check(not gs.rules_broken.has("warm") and not gs.acquired.has("hollis_jacket"), "refusing keeps rule two")

func _walt_quiet_afternoon() -> void:
	section("Day three: kept the duck call, refused the name; an empty window")
	var counter: Node = await _open_day_three([], false, false)
	var column: Node = counter.get_node("%DialogueColumn")
	_route(column, 80)
	await _open_up(column)
	await pick(column, "Something somebody pawned")
	advance(column)
	check(_log(column).contains("Nothing in the window. Abraham always had something"), "an empty window: Olstad notices")
	await _next(column)
	check(column._section == "seller_enters", "the gift: Walt, with birch and coffee")
	await pick(column, "Drink a cup")
	await _next(column)
	check(column._section == "quiet_enters", "nothing in the window, nobody comes: a quiet afternoon")
	check(_log(column).contains("You'd talk to anyone."), "and it's lonely")
	await _next(column)
	check(column._section == "stranger_offer", "the stranger still comes, near closing")

func _evening() -> void:
	section("The evening of day three: the Gleaner on a Friday, the cabin, the church")
	gs.reset()
	gs.day = 3
	gs.minutes = FRIDAY_DAWN + 13 * 60 + 5
	gs.flags.append("ruth_upstairs")
	gs.flags.append("met_sam")
	gs.flags.append("fed_two")
	gs.visited.append("lake")
	gs.voices["warmth"] = 1
	var map: Node = await open_scene("res://scenes/map.tscn", 1.7)
	var column: Node = map.get_node("%DialogueColumn")
	advance(column)
	await process_frame
	check(_log(column).contains("Friday. Every porch light"), "the map: Friday night")
	map.visit("pub")
	var route: Array = _route(column)
	check(route.has("pub_three_warm") and route[-1] == "pub_three_late", "the Gleaner, warm: she let you go upstairs")
	check(_log(column).contains("What did they call you?"), "after last call, Ruth asks what they called you before")
	await pick(column, "Tell her something true")
	advance(column)
	check(gs.flags.has("door_ruth_1"), "telling her something true opens Ruth's first door")
	await process_frame
	map.visit("cabin")
	route = _route(column)
	check(route.has("cabin_three"), "Sam again, at the door this time")
	await pick(column, "the bowl")
	advance(column)
	check(_log(column).contains("an inch off the line"), "he says to set the bowl off the line, and see")
	await process_frame
	map.visit("church")
	route = _route(column)
	check(route.has("church_three") and _log(column).contains("AND FOR THE WINDOW"), "the dark church: somebody prays for the window")

func _night(wave: bool) -> void:
	section("The third night: %s" % ("wave back" if wave else "don't wave"))
	gs.reset()
	gs.day = 3
	gs.minutes = FRIDAY_DAWN + 15 * 60
	gs.flags.append("spoke_first")
	gs.fray = 3
	gs.ready_shelves()
	gs.place_on_shelf("fox", "window", 0)
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
	check(_log(column).contains("Mind the windows."), "Friday static, and once the calm voice: mind the windows")
	night.look("kitchen")
	advance(column)
	await pick(column, "Fill the bowl")
	advance(column)
	night.look("bed")
	advance(column)
	check(not night.sounds["ring"].playing, "eleven, and the phone doesn't ring")
	check(_log(column).contains("Last night you spoke first."), "you spoke first last night: tonight, nothing")
	check(_log(column).contains("Missing him already, sweetheart?"), "??? says sweetheart, in a cadence MC knows")
	await pick(column, "Go down for water")
	advance(column)
	await wait(0.7)
	check(night.current_room() == "shop_hall", "down the stairs, into the dark shop")
	var hotspots: Node = night.get_node("%Hotspots")
	check(hotspots.has_node("night_shop_steel_three") and not hotspots.has_node("night_shop_phone"), "tonight's way through the shop, not last night's")
	night.click("night_shop_steel_three")
	for i in 6:
		advance(column)
	await wait(1.0)
	check(night.current_room() == "shop_back" and hotspots.has_node("night_sink_three"), "through the steel door: the sink, in the back room")
	night.click("night_sink_three")
	advance(column)
	check(_log(column).contains("Its glass eyes have caught the neon"), "the window you dressed: the fox, looking in")
	await pick(column, "Wave back" if wave else "Don't wave")
	var route: Array = _route(column)
	check(gs.rules_broken.has("wave") == wave, "waving back breaks rule eight" if wave else "not waving keeps rule eight")
	check(route.has("night_dog_fed") and route[-1] == "morning_after", "fed, the stairs in the night; then Saturday morning")
	await wait(5.2)
	check(current_scene.name == "Counter" and gs.day == 4, "Saturday morning: day four, at the counter")
