extends "res://tests/test_base.gd"

# The nights' drift (docs/nights.md): what builds up when a rule's broken
# again, the order you do things in, stops that only show when they've
# something new, something out of place, the three notes, the notebook.

func run() -> void:
	_tallies()
	await _quiet_stops_and_out_of_place()
	await _note_one_the_bowl()
	await _order_and_note_three()

func _open_night(day: int, items: Array = []) -> Node:
	gs.reset()
	gs.day = day
	gs.set_clock("22:10")
	for item in items:
		gs.add_item(item)
	root.get_node("Transition").go_to("res://scenes/night.tscn", 0.1)
	await wait(2.0)
	var night: Node = current_scene
	advance(night.get_node("%Narrator"))
	await process_frame
	return night

func _tallies() -> void:
	section("Rules broken more than once: the tally")
	gs.reset()
	var column: Node = load("res://scenes/dialogue_column.tscn").instantiate()
	root.add_child(column)
	gs.break_rule("dog")
	check(column._condition_met("broken:dog>=1") and not column._condition_met("broken:dog>=2"), "once: broken:dog>=1, not >=2")
	gs.break_rule("dog")
	check(column._condition_met("broken:dog>=2") and gs.rule_tally["dog"] == 2, "twice: broken:dog>=2")
	var saved: Dictionary = gs.to_dict()
	gs.reset()
	gs.from_dict(saved)
	check(int(gs.rule_tally.get("dog", 0)) == 2, "the tally is saved")
	column.queue_free()

func _quiet_stops_and_out_of_place() -> void:
	section("Stops with nothing new stay hidden; something out of place")
	var night: Node = await _open_night(4)
	var hotspots: Node = night.get_node("%Hotspots")
	check(hotspots.spot_ids().has("odd_sink") and not hotspots.spot_ids().has("painting"), "night four: two cups in the sink; the painting has nothing new, so it isn't there")
	night.look("odd_sink")
	advance(night.get_node("%Narrator"))
	check(_log(night).contains("Two cups"), "the sink: two cups, and you live alone")
	night = await _open_night(11)
	night.walk("hall")
	await wait(0.7)
	check(not night.get_node("%Hotspots").spot_ids().has("locked_door"), "night eleven: the locked door is just locked, so no stop")

func _note_one_the_bowl() -> void:
	section("Note one: the bowl at the back door")
	var night: Node = await _open_night(8)
	var column: Node = night.get_node("%Narrator")
	night.look("kitchen")
	advance(column)
	check(gs.has_item("note_bowl") and _log(night).contains("At the back door. Not upstairs."), "under the bowl, a note in your own hand")
	check(choices(column).size() == 3, "the line, the back door, or leave it")
	await pick(column, "back door")
	advance(column)
	check(gs.flags.has("bowl_door") and gs.fed_dog and not gs.rules_broken.has("dog"), "at the back door: fed, rule five kept")
	column.start_conversation("night_dog")
	advance(column)
	check(column._section == "night_dog_door" or _log(night).contains("walks upright"), "and at three, the back door instead of the stairs")
	night = await _open_night(9, ["note_bowl"])
	column = night.get_node("%Narrator")
	night.look("kitchen")
	advance(column)
	check(choices(column).any(func(c: String) -> bool: return c.contains("back door")), "from then on, with the note, the back door is a choice every night")

func _order_and_note_three() -> void:
	section("Order, from the radio; note three: LOCK IT NOW")
	var night: Node = await _open_night(9)
	var column: Node = night.get_node("%Narrator")
	night.look("back_door")
	advance(column)
	await pick(column, "Leave it unlocked")
	advance(column)
	night.look("windows")
	advance(column)
	await pick(column, "latches")
	advance(column)
	check(column._condition_met("order:back_door<windows") and not column._condition_met("order:windows<back_door"), "doors before windows: the order is remembered")
	night = await _open_night(13, ["back_door_key"])
	column = night.get_node("%Narrator")
	night.look("back_door")
	advance(column)
	check(_log(night).contains("LOCK IT NOW"), "in the frost on the back door: LOCK IT NOW")
	await pick(column, "Lock it")
	check(gs.flags.has("obeyed_note_lock") and gs.rules_broken.has("back_door"), "obeying the note breaks rule one")

func _log(scene: Node) -> String:
	var text: String = ""
	for entry in scene.get_node("%Narrator").get_node("%Log").get_children():
		text += entry.get_parsed_text() + "\n"
	return text
