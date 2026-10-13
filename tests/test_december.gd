extends "res://tests/test_base.gd"

# December (docs/december.md), up to hard fork 4: key day 18 (Ezra at the
# door at dawn; the third money order; Olstad and the car three ways; the
# first candle; the man at the window), the evening and night 18; key day 19
# (Ruth, June and the window) and Sam's wall (his second door, a pin), or the
# cabin from the road; night 19's frozen latch; key day 20, the Reverend:
# the doors shut, the voice on the air, and the fork (warn him, give him the
# car, hide him in the back room or at Sam's, or walk away); night 20; the
# bridge to the end of what's written.

const DEC_1: int = 57 * 24 * 60 + 6 * 60
const DEC_4: int = 60 * 24 * 60 + 6 * 60
const DEC_12: int = 68 * 24 * 60 + 6 * 60

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
	await _reverend("Go tonight", "reverend_warned")
	await _reverend("Give him the car keys", "gave_reverend_car")
	await _reverend("There's a room behind the steel door", "reverend_in_back_room")
	await _reverend("Sam Wakeman's cabin", "reverend_at_sam")
	await _reverend("", "reverend_gone")
	await _night_twenty()

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
	check(column._section == "window_enters" and _log(column).contains("carrying a box of shells with a ribbon on it"), "the man in the good coat at the window, not coming in; Ezra with the shells")
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

func _reverend(choice: String, flag: String) -> void:
	section("Key day 20: the Reverend (%s)" % flag)
	var flags: Array = ["said_on_air", "ezra_doubts"]
	if flag == "reverend_at_sam":
		flags.append("door_sam_1")
	_reset(20, DEC_12, flags)
	var visit: Node = await _go("res://scenes/visit.tscn")
	var column: Node = visit.get_node("%Narrator")
	check(root.get_node("Hud").get_node("%ClockLabel").text.begins_with("Sun Dec 12"), "Sunday, December 12")
	_route(column)
	check(_log(column).contains("I don't lie. It's the one thing I don't do.") and _log(column).contains("I helped them live."), "the doors shut; he never lies; \"I helped them live.\"")
	check(_log(column).contains("Was he helping you too?"), "you spoke on the air in October: was he helping you too?")
	await pick(column, "Say nothing")
	_route(column)
	await wait(0.7)
	check(gs.eye >= 2 and visit.current_room() == "vestry", "silence is an answer (the eye); dusk, the vestry, a bag on the table")
	if choice == "":
		visit.click("reverend_walk_home")
	else:
		visit.click("reverend_bag")
		_route(column)
		check(_log(column).contains("The Keeper can't help anyone."), "\"The Keeper can't help anyone. That's the rule above the rules.\"")
		await pick(column, choice)
	_route(column)
	check(gs.flags.has(flag), "hard fork 4: %s" % flag)
	if flag.begins_with("reverend_in") or flag == "reverend_at_sam":
		check(gs.flags.has("reverend_hidden") and gs.eye >= 4, "hiding him: the town's eye")
	await wait(2.5)
	check(current_scene.name == "Night", "home; the night")

func _night_twenty() -> void:
	section("The twentieth night: after the Reverend")
	await wait(2.0)
	var night: Node = current_scene
	var column: Node = night.get_node("%Narrator")
	advance(column)
	await process_frame
	night.look("radio")
	advance(column)
	await pick(column, "Turn it on")
	advance(column)
	check(_log(column).contains("The Reverend has gone to rest. I'll sit with you now."), "the radio: him, alone, at night")
	night.look("odd_bulletin")
	advance(column)
	check(gs.flags.has("saw_bulletin"), "out of place: the bulletin, every hymn crossed out")
	night.look("bed")
	_route(column)
	await wait(5.2)
	check(current_scene.name == "Bridge" and gs.day == 21, "the bridge after the Reverend")
	await wait(2.0)
	_route(current_scene.get_node("%Narrator"))
	await wait(4.0)
	check(current_scene.name == "Title", "the end of what's written, for now")
