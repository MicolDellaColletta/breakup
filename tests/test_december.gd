extends "res://tests/test_base.gd"

# December to the ruling (docs/december.md, docs/december_revised.md): key
# day 18 (Ezra at the door at dawn; the third money order; Olstad and the
# car; the first candle; him, for the oldest Bible), the evening and night
# 18; key day 19 (Ruth, June) and Sam's wall, or the cabin from the road;
# night 19's frozen latch; key day 20 (the doctor's hands; the watch stopped
# at nine), night 20; key day 21, the Reverend exposed and the storm closing
# the road (every escape turned back), night 21; key day 22, the fire (his
# question if the Reverend's hidden; the front doors, the singing, the
# vestry door bolted from outside), night 22; key day 23, the ruling (the
# church's things, the doctor, Olstad with him in the chair: hard fork 4,
# and the thread on the step), and on into the shortest day.

const DEC_1: int = 57 * 24 * 60 + 6 * 60
const DEC_4: int = 60 * 24 * 60 + 6 * 60
const DEC_6: int = 62 * 24 * 60 + 6 * 60
const DEC_12: int = 68 * 24 * 60 + 6 * 60
const DEC_15: int = 71 * 24 * 60 + 6 * 60
const DEC_17: int = 73 * 24 * 60 + 6 * 60

func run() -> void:
	await _dawn("Forget it", ["told_olstad_daniel", "walked_out", "said_on_air"], "car_forgotten")
	await _dawn("Forget it", ["tried_to_run"], "car_towed")
	await _dawn("Show her the rental letter", [], "car_forgotten", ["rental_letter"])
	await _evening_eighteen()
	await _night_eighteen()
	await _saturday()
	await _wall()
	await _road()
	await _frozen_latch("Go down to the fuse box", "frozen_taped")
	await _frozen_latch("Leave it", "frozen_open")
	await _miracle("Write him a ticket", "took_watch")
	await _miracle("I don't buy things like that", "refused_watch")
	await _night_twenty()
	await _reverend("Go tonight", "reverend_warned")
	await _reverend("Give him the car keys", "gave_reverend_car")
	await _reverend("There's a room behind the steel door", "reverend_in_back_room")
	await _reverend("Sam Wakeman's cabin", "reverend_at_sam")
	await _reverend("", "reverend_gone")
	await _night_twentyone()
	await _fire(["reverend_hidden", "reverend_in_back_room"], "Yes.", "fire_front", "tried_church")
	await _fire(["reverend_hidden", "reverend_at_sam"], "No.", "fire_sing", "sang_at_fire")
	await _fire(["reverend_gone"], "", "fire_vestry", "saw_vestry_door")
	await _night_twentytwo()
	await _ruling(["saw_vestry_door", "door_sam_1"], "Tell her: the door was bolted", "told_olstad_fire")
	await _ruling([], "Say nothing", "silent_on_fire")
	await _ruling([], "It was the stove", "backed_doctor")
	await _night_twentythree()

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

func _reset(day: int, minutes: int, flags: Array, items: Array = []) -> void:
	gs.reset()
	gs.day = day
	gs.minutes = minutes
	gs.voices["appraisal"] = 2
	gs.voices["warmth"] = 1
	gs.fray = 2
	for flag in flags:
		gs.flags.append(flag)
	for item in items:
		gs.add_item(item)

func _go(path: String) -> Node:
	root.get_node("Transition").go_to(path, 0.1)
	await wait(2.0)
	return current_scene

func _dawn(choice: String, flags: Array, outcome: String, items: Array = []) -> void:
	section("Key day 18: the envelope at dawn; the car (%s)" % outcome)
	_reset(18, DEC_1, flags + ["sold_ezra_shells", "place_duck_call"], items)
	var cash: int = gs.cash
	var counter: Node = await open_scene("res://scenes/counter.tscn")
	var column: Node = counter.get_node("%DialogueColumn")
	check(root.get_node("Hud").get_node("%ClockLabel").text.begins_with("Wed Dec 1"), "the clock says Wednesday, December 1")
	check(gs.eye == (2 if flags.has("walked_out") else (1 if flags.has("tried_to_run") else 0)), "December 1: the town's eye remembers what it saw (eye %d)" % gs.eye)
	_route(column)
	check(_log(column).contains("Ezra.") and gs.cash == cash + 150, "dawn: through the glass, Ezra, pushing the envelope under the door")
	await wait(1.8)
	advance(column)
	await process_frame
	check(gs.has_item("money_order_kettle") and _log(column).contains("This one is postmarked Kettle Lake."), "Olstad brings the third money order: postmarked Kettle Lake")
	check(_log(column).contains("I could tow it. Or I could forget."), "and the car: tow it, or forget")
	await pick(column, choice)
	advance(column)
	check(gs.flags.has(outcome), "the car: %s" % outcome)
	if items.has("rental_letter"):
		check(gs.faith_count("olstad") == 1 and _log(column).contains("Not John. Just J."), "the letter, signed J.: a kept faith with Olstad")
	if outcome == "car_towed":
		check(_log(column).contains("I don't know you well enough to forget for you."), "without her trust, she can't forget")
		return
	advance(column)
	check(column._section == "widow_enters" and _log(column).contains("I heard it, you know."), "Mrs. Hollis and the first candle; she heard the duck call on the lake")
	advance(column)
	check(column._section == "daniel_enters" and _log(column).contains("One with Leviticus in it."), "him, coming in now: the oldest Bible, one with Leviticus in it")
	await pick(column, "Go up and get it")
	advance(column)
	check(gs.ledger_lines[-1].contains("Bible, family, calfskin. Sold to D."), "the ledger: the Bible, sold to D.")
	ring_bell()
	check(column._section == "closing", "closing")

func _evening_eighteen() -> void:
	section("The evening of key day 18")
	_reset(18, DEC_1 + 11 * 60, ["met_sam"])
	var map: Node = await open_scene("res://scenes/map.tscn", 1.7)
	var column: Node = map.get_node("%DialogueColumn")
	advance(column)
	column.start_conversation("pub")
	advance(column)
	check(_log(column).contains("Ezra hasn't not drunk in my bar in twenty years."), "the Gleaner: him and Ezra at the back table, not drinking")
	column.start_conversation("cabin")
	advance(column)
	check(_log(column).contains("Come Saturday."), "Sam: come Saturday")

func _night_eighteen() -> void:
	section("The eighteenth night: the mat")
	_reset(18, DEC_1 + 16 * 60, [])
	var night: Node = await _go("res://scenes/night.tscn")
	var column: Node = night.get_node("%Narrator")
	advance(column)
	await process_frame
	night.look("odd_mat")
	advance(column)
	check(gs.flags.has("saw_mat") and _log(column).contains("Boot heels."), "out of place: the mat, square to the door, two boot heels in it")
	night.look("bed")
	var route: Array = _route(column)
	check(route[-1] == "morning_after", "then Thursday")
	await wait(5.2)
	check(current_scene.name == "Bridge" and gs.day == 19, "the bridge to Saturday")
	await wait(2.0)
	_route(current_scene.get_node("%Narrator"))
	check(current_scene.card_text() == "Friday. Forty below.", "Thursday, Friday: the plow, forty below")
	await wait(3.5)
	check(current_scene.name == "Counter" and root.get_node("Hud").get_node("%ClockLabel").text.begins_with("Sat Dec 4"), "Saturday, December 4")

func _saturday() -> void:
	section("Key day 19: Ruth with your glass; June and the window")
	_reset(19, DEC_4, ["ruth_has_keys", "door_sam_1", "met_sam"])
	var counter: Node = await open_scene("res://scenes/counter.tscn")
	var column: Node = counter.get_node("%DialogueColumn")
	_route(column)
	await wait(1.8)
	advance(column)
	await process_frame
	check(column._section == "ruth_warm" and _log(column).contains("Yours. The rental's"), "Ruth, with your glass; your car keys in her pocket")
	advance(column)
	check(column._section == "june_enters" and choices(column).size() == 2, "June wants the window for the nativity")
	await pick(column, "The window's the shop's")
	advance(column)
	check(gs.eye == 1, "refusing the children's crib: the town's eye")
	ring_bell()
	check(column._section == "closing", "closing")
	advance(column)
	await process_frame
	counter._leave_for_the_evening()
	await wait(2.5)
	check(current_scene.name == "Visit" and current_scene.current_room() == "cabin_road", "the evening is walked: the shore path to Sam's")

func _wall() -> void:
	section("The evening of key day 19: Sam's wall")
	await wait(1.0)
	var visit: Node = current_scene
	gs.set_flag("sam_crossed")
	var column: Node = visit.get_node("%Narrator")
	for i in 50:
		if column._section != "":
			break
		await wait(0.1)
	_route(column)
	await wait(0.7)
	check(visit.current_room() == "cabin" and _log(column).contains("That's the chair."), "Sam's doors are open: inside, one chair, and it's yours (%s, %s)" % [visit.current_room(), column._section])
	visit.click("cabin_envelopes")
	_route(column)
	await wait(0.2)
	check(_log(column).contains("You're sitting in my chair."), "six unopened envelopes: \"You're sitting in my chair.\"")
	visit.click("cabin_wall")
	_route(column)
	await pick(column, "Pin the bullet")
	_route(column)
	await wait(0.2)
	check(gs.doors("sam") == 2 and gs.flags.has("pin_bullet"), "you pin the bullet where the strings cross: Sam's second door")
	check(gs.flags.has("sam_never_touches") and _log(column).contains("Nobody does. That's the point of it."), "he never touches the clock (for March)")
	visit.click("cabin_line")
	_route(column)
	await wait(0.2)
	check(_log(column).contains("in capitals: your own"), "your line: the name you crossed out, and your own above it")
	visit.click("cabin_leave")
	_route(column)
	await wait(2.5)
	check(current_scene.name == "Night", "home, on the road; the night")

func _road() -> void:
	section("The evening of key day 19, without Sam's doors: from the road")
	_reset(19, DEC_4 + 13 * 60, [])
	var visit: Node = await _go("res://scenes/visit.tscn")
	var column: Node = visit.get_node("%Narrator")
	_route(column)
	var seen: String = _log(column)
	await wait(2.5)
	check(seen.contains("pinning something, very carefully") and current_scene.name == "Night", "a shadow at the wall through the curtain; then home")

func _frozen_latch(choice: String, flag: String) -> void:
	section("The nineteenth night: the frozen latch (%s)" % flag)
	_reset(19, DEC_4 + 16 * 60, [])
	var night: Node = await _go("res://scenes/night.tscn")
	var column: Node = night.get_node("%Narrator")
	advance(column)
	await process_frame
	night.look("windows")
	advance(column)
	check(_log(column).contains("The third one won't close."), "one window frozen open")
	await pick(column, choice)
	advance(column)
	check(gs.flags.has(flag) and gs.rules_broken.has("window") == (flag == "frozen_open"), "%s: rule one %s" % [flag, "broken" if flag == "frozen_open" else "kept, with tape from the fuse box"])

func _miracle(choice: String, flag: String) -> void:
	section("Key day 20: the first miracle; the watch (%s)" % flag)
	_reset(20, DEC_6, [])
	var counter: Node = await open_scene("res://scenes/counter.tscn")
	var column: Node = counter.get_node("%DialogueColumn")
	check(root.get_node("Hud").get_node("%ClockLabel").text.begins_with("Mon Dec 6"), "Monday, December 6")
	_route(column)
	check(_log(column).contains("a whole street of doors standing open"), "in the night, every door on the road open")
	await wait(1.8)
	advance(column)
	await process_frame
	check(column._section == "widow_enters" and _log(column).contains("Still as a table."), "Mrs. Hollis: the doctor's hands, still as a table")
	advance(column)
	check(column._section == "brekke_enters" and _log(column).contains("Like you'd hold a bird."), "Dr. Brekke shows you his hands: they don't move")
	advance(column)
	check(column._section == "daniel_enters" and _log(column).contains("Stopped. Nine o'clock."), "him: his father's watch, stopped at nine")
	await pick(column, choice)
	advance(column)
	check(gs.flags.has(flag), flag)
	if flag == "took_watch":
		check(gs.acquired.has("father_watch") and gs.rules_broken.has("warm"), "the watch on the back shelf, warm; rule two")
	else:
		check(_log(column).contains("It's very faithful."), "he winds it: a minute, then nine again")
	ring_bell()
	advance(column)
	check(column._section == "closing" and _log(column).contains("Stopped at nine. You've never seen it stopped."), "the Gleaner's clock, stopped at nine")

func _night_twenty() -> void:
	section("The twentieth night: the sick, by name; the clock")
	_reset(20, DEC_6 + 16 * 60, [])
	var night: Node = await _go("res://scenes/night.tscn")
	var column: Node = night.get_node("%Narrator")
	advance(column)
	await process_frame
	night.look("radio")
	advance(column)
	await pick(column, "Turn it on")
	advance(column)
	check(_log(column).contains("And for the Keeper. Who isn't sick."), "the radio: a list of the sick, and the Keeper")
	night.look("odd_clock")
	advance(column)
	check(gs.flags.has("saw_clock"), "out of place: the alarm clock, stopped at nine")
	night.look("bed")
	_route(column)
	await wait(5.2)
	check(current_scene.name == "Bridge" and gs.day == 21, "the week before the Reverend")
	await wait(2.0)
	_route(current_scene.get_node("%Narrator"))
	check(current_scene.card_text() == "Saturday. The second candle.", "the car; no hymn numbers; the rhyme's tenth line; the second candle")
	await wait(3.5)
	check(current_scene.name == "Visit" and root.get_node("Hud").get_node("%ClockLabel").text.begins_with("Sun Dec 12"), "Sunday, December 12")

func _reverend(choice: String, flag: String) -> void:
	section("Key day 21: the Reverend; the storm (%s)" % flag)
	var flags: Array = ["said_on_air", "ezra_doubts"]
	if flag == "reverend_at_sam":
		flags.append("door_sam_1")
	_reset(21, DEC_12, flags)
	var visit: Node = await _go("res://scenes/visit.tscn")
	var column: Node = visit.get_node("%Narrator")
	_route(column)
	check(_log(column).contains("I don't lie. It's the one thing I don't do.") and _log(column).contains("I helped them live."), "the doors barred; he never lies; \"I helped them live.\"")
	await pick(column, "Say nothing")
	_route(column)
	await wait(0.7)
	check(visit.current_room() == "vestry", "dusk, the vestry, a bag on the table")
	if choice == "":
		visit.click("reverend_walk_home")
	else:
		visit.click("reverend_bag")
		_route(column)
		await pick(column, choice)
	_route(column)
	check(gs.flags.has(flag), "the fork on the 12th: %s" % flag)
	if flag == "reverend_warned" or flag == "gave_reverend_car":
		check(gs.flags.has("road_turned_back"), "the storm: the plow buried at the town line; he turns back")
	check(_log(column).contains("the road's closed, both ways"), "by midnight, the road closed")
	await wait(2.5)
	check(current_scene.name == "Night", "home; the night")

func _night_twentyone() -> void:
	section("The twenty-first night; the road closed")
	await wait(2.0)
	var night: Node = current_scene
	var column: Node = night.get_node("%Narrator")
	advance(column)
	await process_frame
	night.look("radio")
	advance(column)
	await pick(column, "Turn it on")
	advance(column)
	check(_log(column).contains("The Reverend won't be at this microphone again. You'll have me instead"), "the radio: him, alone, at night")
	night.look("bed")
	_route(column)
	await wait(5.2)
	check(current_scene.name == "Bridge" and gs.day == 22, "the bridge: the road closed")
	await wait(2.0)
	_route(current_scene.get_node("%Narrator"))
	check(current_scene.card_text() == "Tuesday. Doors.", "an island; every door open again")
	await wait(3.5)
	check(current_scene.name == "Visit" and gs.day == 22, "Wednesday, December 15")

func _fire(flags: Array, answer: String, spot: String, outcome: String) -> void:
	section("Key day 22: the fire (%s)" % outcome)
	_reset(22, DEC_15, flags)
	var visit: Node = await _go("res://scenes/visit.tscn")
	var column: Node = visit.get_node("%Narrator")
	_route(column)
	if answer != "":
		check(_log(column).contains("Is he in your back room?") or _log(column).contains("Is he at Sam Wakeman's?"), "the Reverend's hidden: he asks you plainly where")
		await pick(column, answer)
		_route(column)
		check(gs.flags.has("told_daniel_hidden" if answer == "Yes." else "lied_to_daniel"), "you %s" % ("tell him" if answer == "Yes." else "lie; he smiles"))
	await wait(0.7)
	check(visit.current_room() == "church_fire" and _log(column).contains("The church is burning."), "two in the morning, the bell ringing by itself: the church burning")
	check(_log(column).contains("Singing louder than anyone."), "the town in the snow, singing; him among them, soot on his cuffs")
	if spot == "fire_vestry":
		visit.click("fire_round_back")
		await wait(0.8)
		check(visit.current_room() == "vestry_door", "round the back: the vestry door")
	visit.click(spot)
	_route(column)
	var seen: String = _log(column)
	check(gs.flags.has(outcome), outcome)
	match outcome:
		"tried_church":
			check(seen.contains("It's in His hands."), "the front doors: they pull you back, kindly")
		"sang_at_fire":
			check(seen.contains("You didn't know you knew the words."), "you sing with them")
		"saw_vestry_door":
			check(seen.contains("Bolted from the outside.") and seen.contains("a short length of red wool"), "bolted from the outside; prints going away; a red thread")
	await wait(2.5)
	check(current_scene.name == "Night", "then the night")

func _night_twentytwo() -> void:
	section("The twenty-second night: static; ash")
	await wait(2.0)
	var night: Node = current_scene
	var column: Node = night.get_node("%Narrator")
	advance(column)
	await process_frame
	night.look("radio")
	advance(column)
	await pick(column, "Turn it on")
	advance(column)
	check(_log(column).contains("Static. The whole dial."), "the booth burned: nothing on the radio but static")
	night.look("odd_ash")
	advance(column)
	check(gs.flags.has("saw_ash"), "out of place: ash on the inside of the sill, warm")
	night.look("bed")
	_route(column)
	await wait(5.2)
	check(current_scene.name == "Bridge" and gs.day == 23, "the bridge: ash")
	await wait(2.0)
	_route(current_scene.get_node("%Narrator"))
	check(current_scene.card_text() == "Thursday. Ash.", "ash with the snow; the first red thread, on Ezra's wrist")
	await wait(3.5)
	check(current_scene.name == "Counter" and gs.day == 23, "Friday, December 17")

func _ruling(flags: Array, choice: String, outcome: String) -> void:
	section("Key day 23: the ruling; hard fork 4 (%s)" % outcome)
	_reset(23, DEC_17, flags)
	var counter: Node = await open_scene("res://scenes/counter.tscn")
	var column: Node = counter.get_node("%DialogueColumn")
	_route(column)
	await wait(1.8)
	advance(column)
	await process_frame
	check(column._section == "ezra_enters" and gs.acquired.has("spectacles") and gs.acquired.has("bell_clapper") and gs.acquired.has("microphone") and gs.acquired.has("reverend_collar"), "Ezra's box of church things, held: the spectacles, the clapper, the microphone, the collar")
	check(_log(column).contains("The lenses are whole."), "the spectacles' lenses, whole")
	advance(column)
	check(column._section == "brekke_enters" and _log(column).contains("He wouldn't have woken."), "Dr. Brekke: the stove; he wouldn't have woken")
	advance(column)
	check(column._section.begins_with("trooper") and _log(column).contains("I want to know what you saw."), "Olstad, with him in the customer chair: what did you see")
	await pick(column, choice)
	advance(column)
	check(gs.flags.has(outcome), "hard fork 4: %s" % outcome)
	if outcome == "told_olstad_fire":
		check(gs.faith_count("olstad") >= 1 and gs.eye >= 2, "the truth: kept faith with Olstad; the town's eye")
		advance(column)
		check(column._section == "sam_enters" and _log(column).contains("Petrol."), "Sam, at closing: petrol, under the vestry")
	ring_bell()
	check(column._section == "closing", "closing")
	advance(column)
	if outcome == "backed_doctor":
		check(_log(column).contains("a loop of red wool"), "the thread on the step")
		await pick(column, "Put it on")
		advance(column)
		check(gs.flags.has("wears_thread") and gs.has_item("red_thread") and gs.eye == 0, "you put it on: the town warm to you again")

func _night_twentythree() -> void:
	section("The twenty-third night: the radio from the Gleaner; the door handle")
	_reset(23, DEC_17 + 16 * 60, ["wears_thread"])
	var night: Node = await _go("res://scenes/night.tscn")
	var column: Node = night.get_node("%Narrator")
	advance(column)
	await process_frame
	night.look("radio")
	advance(column)
	await pick(column, "Turn it on")
	advance(column)
	check(_log(column).contains("Talking keeps a fire alive."), "the radio, from the Gleaner's back room: don't talk about the fire")
	night.look("odd_door")
	advance(column)
	check(gs.flags.has("saw_door_thread") and _log(column).contains("This is another."), "out of place: a red thread on the door handle")
	night.look("bed")
	_route(column)
	await wait(5.2)
	check(current_scene.name == "Bridge" and gs.day == 24, "the bridge: the thread spreads")
	await wait(2.0)
	_route(current_scene.get_node("%Narrator"))
	await wait(3.5)
	check(current_scene.name == "Counter" and gs.day == 24, "then the shortest day, at the counter")
