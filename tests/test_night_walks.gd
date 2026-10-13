extends "res://tests/test_base.gd"

# Night walks (docs/night_walks.md): the stairs down every night from the
# John night on; the shop's rooms in the dark; the finds (the drawer's false
# bottom, the key under the register, the desk's letters, the safe and the
# church's deed, the crate, the ash pan, the key in Abraham's coat and the
# locked room); John's gun put somewhere on night 7, and taken back; the
# furnace firing it on its own; and once, the Gleaner's back window: ask
# him, accuse him on air, or the gun.


func run() -> void:
	await _gun_in_the_bear()
	await _finds_in_december()
	await _finds_later()
	await _locked_room()
	await _furnace_fires()
	await _confront("Did you bolt the door?", ["gun_dresser"], "asked_daniel")
	await _confront("Switch on the transmitter", [], "accused_on_air")
	await _confront("Take out John's gun", ["has_revolver"], "pointed_gun")
	await _confront("Go back for John's gun", ["gun_floorboard"], "pointed_gun")

func _log(column: Node) -> String:
	var text: String = ""
	for entry in column.get_node("%Log").get_children():
		text += entry.get_parsed_text() + "\n"
	return text

func _night(day: int, flags: Array, items: Array = []) -> Node:
	gs.reset()
	gs.day = day
	gs.set_clock("22:10")
	for flag in flags:
		gs.flags.append(flag)
	for item in items:
		gs.add_item(item)
	root.get_node("Transition").go_to("res://scenes/night.tscn", 0.1)
	await wait(2.0)
	var night: Node = current_scene
	advance(night.get_node("%Narrator"))
	await process_frame
	return night

func _spots_in(night: Node, room: String) -> Array:
	return load("res://scripts/spots.gd").in_room("night", room, night.get_node("%Narrator"))

# Plays a spot's section (as clicking it would) and reads it.
func _look(night: Node, spot: String) -> String:
	var column: Node = night.get_node("%Narrator")
	night.look(spot)
	advance(column)
	await process_frame
	return _log(column)

func _use_gun(night: Node, spot: String) -> void:
	night._busy = false
	night.play_aside(load("res://scripts/spots.gd").use_section(spot, "revolver"))
	advance(night.get_node("%Narrator"))
	await process_frame

func _gun_in_the_bear() -> void:
	section("Night 7: John's gun, put somewhere")
	var night: Node = await _night(7, [], ["revolver"])
	check(_spots_in(night, "main").has("walk_down"), "the John night: the stairs go down to the shop")
	await night.walk("shop_hall")
	await wait(0.6)
	check(night.current_room() == "shop_hall" and _spots_in(night, "shop_hall").has("walk_hall_back"), "the shop's hallway, in the dark: the steel door, the counter, the stairs up")
	check(_spots_in(night, "shop_floor").has("walk_bear"), "the bear, on the shop floor")
	await _use_gun(night, "walk_bear")
	check(gs.flags.has("gun_bear") and not gs.has_item("revolver"), "you push it into the bear's new seam, into the straw")
	var seen: String = await _look(night, "bed")
	check(seen.contains("You sit down at the kitchen table without it."), "at the table without it: no choosing, it's put away")
	check(gs.background_settled != "", "the background still settles")

func _finds_in_december() -> void:
	section("December nights: the drawer, the register, the desk, the safe")
	var night: Node = await _night(20, [])
	check(not _spots_in(night, "shop_office").is_empty(), "the office, at night")
	var seen: String = await _look(night, "walk_drawer")
	check(gs.has_item("abraham_rules") and seen.contains("Nine of them."), "the drawer's false bottom: Abraham's rules, nine of them")
	seen = await _look(night, "walk_register")
	check(gs.has_item("desk_key"), "under the register: a desk key")
	seen = await _look(night, "walk_desk")
	check(gs.has_item("letter_1989") and seen.contains("Never posted."), "the desk: the Keepers' letters, never posted; 1989's on top")
	seen = await _look(night, "walk_safe")
	check(not gs.has_item("church_deed") and seen.contains("You don't know the numbers."), "the safe: you don't know the numbers yet")

func _finds_later() -> void:
	section("Later: the safe, the crate, the ash pan; the gun taken back")
	var night: Node = await _night(24, ["saw_bulletin", "gun_bear", "found_desk_key"])
	var seen: String = await _look(night, "walk_safe")
	check(gs.has_item("church_deed") and seen.contains("held in trust for the Keeper"), "the Reverend's last hymns open the safe: the church's deed to the shop")
	seen = await _look(night, "walk_crate")
	check(gs.has_item("keeper_photo") and seen.contains("Brown."), "the crate: J.W.'s suitcase, his photograph, brown eyes")
	seen = await _look(night, "walk_furnace")
	check(gs.has_item("burned_corner") and seen.contains("Thomas's hand"), "the ash pan: a corner in Thomas's hand")
	seen = await _look(night, "walk_bear")
	check(gs.has_item("revolver") and not gs.flags.has("gun_bear"), "the gun, taken back out of the bear")
	check(not _spots_in(night, "shop_counter").has("walk_register"), "the register's key, found: no more to find there")

func _locked_room() -> void:
	section("January: the key from Abraham's coat; the locked room")
	var night: Node = await _night(28, [], ["room_key"])
	check(_spots_in(night, "hall").has("walk_locked_room"), "the locked door, with the key on its string")
	var seen: String = await _look(night, "walk_locked_room")
	check(gs.flags.has("saw_locked_room") and seen.contains("The Keeper's coat. Not yours. His. 1989.") and seen.contains("That's the light under the door."), "Ruth's room, kept: his coat, his name on the wall, a lamp on a timer")

func _furnace_fires() -> void:
	section("The gun behind the furnace goes off on its own")
	var night: Node = await _night(20, ["gun_furnace"])
	var column: Node = night.get_node("%Narrator")
	night.look("bed")
	for i in 80:
		column._on_advance_pressed()
	check(_log(column).contains("The empty chamber came round on its own."), "at four in the morning, a crack from the back room")

func _confront(choice: String, flags: Array, outcome: String) -> void:
	section("Facing him, at the Gleaner's back window (%s)" % outcome)
	var items: Array = []
	if flags.has("has_revolver"):
		items.append("revolver")
		flags = []
	var night: Node = await _night(25, flags, items)
	check(_spots_in(night, "shop_floor").has("walk_confront"), "between the ruling and the confession: the back window, lit red")
	var column: Node = night.get_node("%Narrator")
	night.look("walk_confront")
	advance(column)
	await process_frame
	check(_log(column).contains("they think I'm praying"), "the back room: the transmitter, the teeth in their jars, him")
	await pick(column, choice)
	advance(column)
	await process_frame
	if outcome == "pointed_gun":
		check(_log(column).contains("There you are."), "the muzzle against his shirt: \"There you are.\"")
		await pick(column, "Pull the trigger")
		advance(column)
		await process_frame
		check(_log(column).contains("Click.") and not gs.has_item("revolver"), "the sixth chamber: click. He takes the gun, gently")
	check(gs.flags.has(outcome) and gs.flags.has("confronted"), outcome)
	match outcome:
		"asked_daniel": check(_log(column).contains("Yes."), "he never lies: \"Yes.\"")
		"accused_on_air": check(gs.eye >= 5 and _log(column).contains("Now everybody knows everything."), "you say it to every kitchen; he answers with John")
	check(not _spots_in(night, "shop_floor").has("walk_confront"), "once: the window doesn't open again")
