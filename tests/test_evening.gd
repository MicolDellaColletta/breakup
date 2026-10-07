extends "res://tests/test_base.gd"

# Plays the first evening on the town map: which places show, travel time,
# the pub, the lake, going home.

func run() -> void:
	await _not_invited()
	await _pub_then_lake()

func _open_map(invited: bool) -> Node:
	gs.reset()
	gs.day = 1
	gs.invited_to_pub = invited
	gs.add_cash(150)
	gs.set_clock("17:00")
	var map: Node = await open_scene("res://scenes/map.tscn", 1.7)
	advance(map.get_node("%DialogueColumn"))
	await process_frame
	return map

func _not_invited() -> void:
	section("The map without Sgt. Olstad's invitation")
	var map: Node = await _open_map(false)
	check(map.shown_places() == ["lake"], "only the lake shows: the pub needs the invitation")
	check(map.get_node("%HomeButton").visible, "Go home is there")

func _pub_then_lake() -> void:
	section("The map: the pub, then the lake, then home")
	var map: Node = await _open_map(true)
	var column: Node = map.get_node("%DialogueColumn")
	check(map.shown_places() == ["pub", "lake"], "the pub and the lake show")
	check(map.get_node("%Details").text == "It's 5:00 PM. Where to?", "the map says the time")
	map.visit("pub")
	check(map.shown_places().is_empty() and not map.get_node("%HomeButton").visible, "the map clears while you're away")
	check(gs.clock_text() == "8:00 PM", "you get to the pub by eight")
	advance(column)
	check(choices(column).size() == 3, "the pub offers three ways to spend the evening")
	await pick(column, "round")
	check(gs.cash == 188 - 40, "buying a round costs $40")
	advance(column)
	await process_frame
	check(gs.clock_text() == "9:50 PM", "an evening at the pub, then the drive back (20 minutes)")
	check(map.shown_places() == ["lake"], "back at the map, the pub is done for tonight")
	map.visit("lake")
	advance(column)
	await process_frame
	check(map.shown_places().is_empty(), "every place visited")
	map._go_home()
	advance(column)
	check(column._section == "home", "going home ends the evening")
	await wait(2.3)
	check(current_scene.name == "Night", "and leads to the night at the shop")
