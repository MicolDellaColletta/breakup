extends "res://tests/test_base.gd"

# April, part one (docs/april.md): key day 39 (the Keepers' names; the town
# line, by car or on foot, and Olstad's trust settling the plate; his note
# by fork 6); key day 40 (the race: Olstad's statement, Ruth's keys and her
# offer, Ray's ring, Sam's minute, Cody's truck); night 40 (the bear's
# paraffin; the sixth round); Palm Sunday (the plate; one attempt: Olstad,
# the town, the gun that fires or doesn't; the hall cellar); Good Friday's
# evening (the procession; the last face in the lake); the last night
# (leave, alone or with someone; he's in the car; burn it); the bridge to
# breakup, the end of what's written.

const APR_2: int = 180 * 24 * 60 + 6 * 60
const APR_8: int = 186 * 24 * 60 + 6 * 60
const APR_16: int = 194 * 24 * 60 + 6 * 60
const APR_21: int = 199 * 24 * 60 + 6 * 60
const TRUSTED: Array = ["showed_olstad_ticket", "told_olstad_daniel"]
const FOUR_KEPT: Array = ["walt_kind", "faith_hollis", "ezra_satisfied", "showed_olstad_ticket", "told_olstad_daniel"]

func run() -> void:
	await _light(TRUSTED + ["fork6_refuse"], "olstad_looks_away")
	await _light(["car_towed", "fork6_yes"], "")
	await _race()
	await _bear()
	await _palm(TRUSTED + ["olstad_case"], [], "Go out to the steps", "daniel_taken")
	await _palm([], ["daniel_file"], "anxious bench", "daniel_given")
	await _palm(["gun_six"], ["revolver"], "John's gun", "gun_failed")
	await _palm([], ["revolver"], "John's gun", "daniel_shot")
	await _palm(["gave_up_sam"], [], "Do nothing", "freed_sam")
	await _procession(["daniel_shot"], "It's you. Seventeen.")
	await _procession([], "It's him. Thirty. Laughing.")
	await _last_night(["olstad_looks_away", "daniel_taken"], [], "leave_now", "Go alone", "ran_alone")
	await _last_night(["car_forgotten"], [], "leave_now", "Drive.", "daniel_in_car")
	await _last_night(["cody_comes", "car_towed"], [], "cody_truck", "Get in.", "ran_with_cody")
	await _last_night(FOUR_KEPT + ["daniel_taken", "olstad_looks_away"], ["paraffin"], "burn_it", "Burn it.", "set_fire")

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
	gs.fray = 0
	for flag in flags:
		gs.flags.append(flag)
	for item in items:
		gs.add_item(item)

func _go(path: String) -> Node:
	root.get_node("Transition").go_to(path, 0.1)
	await wait(2.0)
	var scene: Node = current_scene
	if scene.has_node("%Narrator"):
		var column: Node = scene.get_node("%Narrator")
		for i in 50:
			if column._section != "":
				break
			await wait(0.1)
	return scene

func _light(flags: Array, outcome: String) -> void:
	section("Key day 39: the light comes back (%s)" % ", ".join(flags))
	_reset(39, APR_2, flags)
	var visit: Node = await _go("res://scenes/visit.tscn")
	var column: Node = visit.get_node("%Narrator")
	_route(column)
	check(_log(column).contains("The last name he reads is \"John.\""), "the Keepers' names from the ledger; the last one, John")
	visit.click("hall_to_line")
	_route(column)
	if flags.has("car_towed"):
		check(_log(column).contains("You've got no car to open it with."), "no car: you walk to the line")
	else:
		check(_log(column).contains("The car starts on the fourth try."), "the car: you drive to the line")
	if outcome != "":
		check(gs.flags.has(outcome) and _log(column).contains("I won't be looking."), "she trusts you: she won't be looking")
	else:
		check(not gs.flags.has("olstad_looks_away") and _log(column).contains("That car's still in my book"), "she doesn't: the car's in her book")
	if flags.has("fork6_refuse"):
		check(_log(column).contains("Friday the 21st, after dark"), "his note: Friday the 21st, after dark")
	else:
		check(_log(column).contains("Wait for me on the shore."), "his note: wait for me on the shore")
	await wait(2.5)
	check(current_scene.name == "Night", "then the night")

func _race() -> void:
	section("Key day 40: the race")
	_reset(40, APR_8, ["told_olstad_john", "door_ruth_1", "door_ruth_2", "door_ruth_3", "ruth_has_keys", "door_sam_3", "kept_picks"], ["hollis_ring", "boy_photo"])
	var counter: Node = await open_scene("res://scenes/counter.tscn")
	var column: Node = counter.get_node("%DialogueColumn")
	check(root.get_node("Hud").get_node("%ClockLabel").text.begins_with("Sat Apr 8"), "Saturday, April 8")
	_route(column)
	await wait(1.8)
	advance(column)
	await process_frame
	check(column._section == "trooper_case" and _log(column).contains("Found."), "Olstad, the statement; the photograph: the witness, found")
	await pick(column, "Sign it")
	advance(column)
	check(gs.flags.has("olstad_case"), "you sign: the Olstad way is open")
	advance(column)
	check(_log(column).contains("Take me with you."), "Ruth: take me with you")
	check(gs.flags.has("keys_returned") and not gs.flags.has("ruth_has_keys"), "and your keys, back")
	await pick(column, "Be at the car")
	advance(column)
	check(gs.flags.has("ruth_comes"), "Ruth will be at the car")
	advance(column)
	check(column._section == "widow_enters", "Mrs. Hollis")
	await pick(column, "Give her Ray's ring")
	advance(column)
	check(not gs.has_item("hollis_ring") and gs.faith_count("hollis") >= 1, "Ray's ring, back on her thumb: the last kept moment")
	advance(column)
	check(_log(column).contains("five forty-one"), "Sam: the minute")
	await pick(column, "Be at the car")
	advance(column)
	check(gs.flags.has("sam_comes"), "Sam will be at the car")
	advance(column)
	check(_log(column).contains("We're going to my aunt's in Fairbanks."), "Cody: the truck to Fairbanks")
	await pick(column, "I'll be there")
	advance(column)
	check(gs.flags.has("cody_comes"), "Cody's truck")
	ring_bell()
	check(column._section == "closing", "closing")

func _bear() -> void:
	section("The fortieth night: the bear's other thing; the sixth round")
	_reset(40, APR_8 + 16 * 60, ["bear_known"], ["sixth_round", "revolver"])
	var night: Node = await _go("res://scenes/night.tscn")
	var column: Node = night.get_node("%Narrator")
	advance(column)
	await process_frame
	night.look("walk_bear")
	advance(column)
	check(gs.has_item("paraffin") and _log(column).contains("A square tin of paraffin"), "the bear's second seam: Abraham's paraffin and matches")
	night.look("odd_round")
	advance(column)
	await pick(column, "Put it in the empty chamber")
	advance(column)
	check(gs.flags.has("round_loaded"), "you load the round yourself, where it won't come round first")

func _palm(flags: Array, items: Array, choice: String, outcome: String) -> void:
	section("Palm Sunday: %s" % outcome)
	_reset(41, APR_16, flags, items)
	var visit: Node = await _go("res://scenes/visit.tscn")
	var column: Node = visit.get_node("%Narrator")
	_route(column)
	check(_log(column).contains("one child's tooth"), "the plate: money, rings, deeds, teeth")
	await pick(column, choice)
	_route(column)
	if outcome == "freed_sam":
		await pick(column, "Lift the hatch")
		_route(column)
	check(gs.flags.has(outcome), outcome)
	match outcome:
		"daniel_taken":
			check(_log(column).contains("You signed."), "Olstad takes him on the steps: see you in court")
		"daniel_given":
			check(_log(column).contains("Martha Lund stands up."), "you read Lund's page; Martha stands up")
		"gun_failed":
			check(not gs.has_item("revolver") and _log(column).contains("I never said it would fire."), "the flattened round comes round first")
		"daniel_shot":
			check(gs.background() == "guilt" and _log(column).contains("facing Abraham"), "it fires; the freezer; your background is guilt now")
	check(gs.daniel_beaten == (outcome in ["daniel_taken", "daniel_given", "daniel_shot"]), "beaten: %s" % gs.daniel_beaten)
	await wait(2.5)
	check(current_scene.name == "Night", "then the night")

func _procession(flags: Array, face: String) -> void:
	section("Good Friday: the procession (%s)" % face)
	_reset(42, APR_21 + 14 * 60, flags)
	var visit: Node = await _go("res://scenes/visit.tscn")
	var column: Node = visit.get_node("%Narrator")
	_route(column)
	await pick(column, "Watch from the step")
	_route(column)
	check(gs.flags.has("lake_three") and _log(column).contains(face), "the last piece: %s" % face)
	await wait(2.5)
	check(current_scene.name == "Night", "then the last night")

func _last_night(flags: Array, items: Array, spot: String, choice: String, outcome: String) -> void:
	section("The last night: %s" % outcome)
	_reset(42, APR_21 + 16 * 60, flags, items)
	var night: Node = await _go("res://scenes/night.tscn")
	var column: Node = night.get_node("%Narrator")
	advance(column)
	await process_frame
	night.look(spot)
	advance(column)
	await pick(column, choice)
	_route(column)
	check(gs.flags.has(outcome), outcome)
	if outcome != "daniel_in_car":
		check(gs.flags.has("left_kettle_lake"), "behind you, Kettle Lake")
	await wait(5.2)
	if current_scene.name == "Bridge":
		check(gs.day == 43, "the bridge to breakup")
		await wait(2.0)
		_route(current_scene.get_node("%Narrator"))
		await wait(4.0)
		check(current_scene.name == "Title", "the end of what's written")
