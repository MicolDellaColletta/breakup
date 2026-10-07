extends "res://tests/test_base.gd"

# Plays the first night as Keeper: the rules (radio, dog, windows, back door),
# then what wakes you after three.

func run() -> void:
	await _rules(true)
	await _rules(false)
	await _three_am(true, "Wave back", "back_room_locked")
	await _three_am(false, "Don't wave", "back_room_open")
	await _stay_in_bed()

func _open_night(has_key: bool) -> Node:
	gs.reset()
	gs.day = 1
	gs.fed_dog = true
	gs.set_clock("22:10")
	if has_key:
		gs.add_item("back_door_key")
	# Arrive the way the game does, so the night's autosave is written.
	root.get_node("Transition").go_to("res://scenes/night.tscn", 0.1)
	await wait(0.3)
	await wait(1.7)
	var night: Node = current_scene
	advance(night.get_node("%Narrator"))
	await process_frame
	return night

func _rules(has_key: bool) -> void:
	section("The rules at night, " + ("with Olstad's key" if has_key else "without the key"))
	var night: Node = await _open_night(has_key)
	var column: Node = night.get_node("%Narrator")
	check(not gs.fed_dog, "tonight's bowl starts empty")
	check(night.get_node("%Objects").visible, "the apartment buttons show after arriving")
	var spots: Array = night.get_node("%Objects").get_children().filter(
		func(b: Node) -> bool: return not b.is_queued_for_deletion()).map(func(b: Node) -> String: return String(b.name))
	check(spots == ["radio", "kitchen", "windows", "dresser", "painting", "locked_door", "back_door", "bed"], "eight things to look at in the apartment")
	if has_key:
		night.look("dresser")
		advance(column)
		check(gs.has_item("church_bulletin"), "the dresser hides a church bulletin")
	check(root.get_node("Saves").slot_info(0).get("label", "").begins_with("The night"), "the night is a part of its own: it autosaves")
	night.look("radio")
	advance(column)
	await pick(column, "Turn it on")
	advance(column)
	check(night.get_node("%RadioNight").playing and not gs.rules_broken.has("radio"), "the radio plays; rule seven kept")
	night.look("back_door")
	advance(column)
	await process_frame
	if has_key:
		check(choices(column) == ["Leave it unlocked", "Lock it with the key on the red tag"], "with the key, you can lock the back door")
		await pick(column, "Lock it")
		check(gs.locked_back_door and gs.rules_broken.has("back_door"), "locking it breaks rule one")
	else:
		check(choices(column) == ["Leave it unlocked"], "without the key, there's no locking it")
		check(_log(column).contains("no key in the lock"), "and the story says why")
		await pick(column, "Leave it unlocked")
		check(not gs.locked_back_door, "the back door stays unlocked")
	advance(column)
	check(night.get_node("%Objects").visible, "back in the apartment afterwards")

func _three_am(lock: bool, wave: String, expected_room: String) -> void:
	section("After three: %s, %s" % ["door locked" if lock else "door unlocked", wave.to_lower()])
	var night: Node = await _open_night(lock)
	var column: Node = night.get_node("%Narrator")
	if lock:
		night.look("back_door")
		advance(column)
		await pick(column, "Lock it")
		advance(column)
	night.look("bed")
	advance(column)
	check(gs.clock_text() == "3:10 AM", "a sound wakes you after three")
	await pick(column, "Go down")
	advance(column)
	check(choices(column) == ["Wave back", "Don't wave", "Look away"], "your reflection waves: rule eight")
	var before: int = gs.voices["unknown"]
	await pick(column, wave)
	if wave == "Wave back":
		check(gs.rules_broken.has("wave") and gs.voices["unknown"] == before + 1, "waving back breaks rule eight and feeds ???")
	else:
		check(not gs.rules_broken.has("wave"), "not waving keeps rule eight")
	var route: Array = [column._section]
	for i in 40:
		column._on_advance_pressed()
		if route[-1] != column._section:
			route.append(column._section)
	check(route.has(expected_room), "the back room plays %s" % expected_room)
	check(route[-1] == "morning_after", "then morning")
	await wait(4.5)
	check(current_scene.name == "Counter" and gs.day == 2, "the end of night one leads to day two at the counter")

func _stay_in_bed() -> void:
	section("After three: staying in bed")
	var night: Node = await _open_night(false)
	var column: Node = night.get_node("%Narrator")
	night.look("bed")
	advance(column)
	var paranoia: int = gs.voices["paranoia"]
	await pick(column, "Stay in bed")
	check(gs.voices["paranoia"] == paranoia + 1, "staying in bed feeds Paranoia")
	advance(column)
	check(column._section == "morning_after", "and leads straight to morning")
	await wait(4.5)

func _log(column: Node) -> String:
	var text: String = ""
	for entry in column.get_node("%Log").get_children():
		text += entry.get_parsed_text() + "\n"
	return text
