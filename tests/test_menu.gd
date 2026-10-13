extends "res://tests/test_base.gd"

# The title screen, the pause menu, saving, loading and settings.

var saves: Node
var menu: Node

func run() -> void:
	saves = root.get_node("Saves")
	menu = root.get_node("Menu")
	_round_trip()
	await _title_and_new_game()
	await _pause_save_load()
	await _settings()
	await _back_to_title()
	await _mid_fade()
	await _title_with_saves()

func _press_escape() -> void:
	var event: InputEventAction = InputEventAction.new()
	event.action = "ui_cancel"
	event.pressed = true
	root.push_input(event)
	await process_frame

func _round_trip() -> void:
	section("Everything in GameState survives a save file")
	gs.reset()
	gs.break_rule("phone")
	gs.fed_dog = true
	gs.pass_time(95)
	gs.lean("john")
	gs.add_item("pawn_ticket")
	gs.add_cash(150)
	gs.record_sale("Duck call", "duck_call", 15, "Mrs. Hollis")
	gs.take_from_till(5)
	var before: Dictionary = gs.to_dict()
	var through_file: Variant = JSON.parse_string(JSON.stringify(before))
	gs.reset()
	gs.from_dict(through_file)
	check(gs.to_dict() == before, "saved and loaded, every value comes back the same")
	check(gs.minutes is int and gs.voices["john"] is int, "numbers come back as whole numbers")

func _title_and_new_game() -> void:
	section("The title screen")
	gs.reset()
	var title: Node = await open_scene("res://scenes/title.tscn", 1.7)
	check(not title.get_node("%ContinueButton").visible, "no Continue without any saves")
	check(title.get_node("%LoadButton").disabled, "Load is greyed out without saves")
	check(not root.get_node("Hud").visible, "the clock and pockets hide on the title screen")
	title._new_game()
	await wait(2.2)
	await process_frame
	check(current_scene.name == "Drive", "New game starts the drive")
	check(root.get_node("Hud").visible, "the clock and pockets come back")
	var autosave: Dictionary = saves.slot_info(0)
	check(autosave.get("label", "") == "The drive, Oct 5, 10:00 PM", "starting the drive autosaves")

func _pause_save_load() -> void:
	section("Pause, save, load")
	await wait(2.2)
	var column: Node = current_scene.get_node("Narrator")
	await _press_escape()
	check(menu.is_open() and paused, "Esc opens the pause menu and freezes the game")
	var line_before: int = column.get_line_index()
	menu.open_slots(true)
	check(menu.get_node("%SlotsNote").text.contains("The drive, Oct 5, 10:00 PM"), "the save screen says what a save keeps")
	menu._on_slot_pressed(1)
	check(saves.slot_info(1).get("scene", "") == "res://scenes/drive.tscn", "saving to slot 1")
	await _press_escape()
	check(menu.get_node("%PausePanel").visible, "Esc on the save screen goes back to the pause menu")
	await _press_escape()
	check(not menu.is_open() and not paused, "Esc again resumes")
	check(column.get_line_index() == line_before, "the story didn't move while paused")
	# Change things, then load the save: they come back as they were.
	gs.add_cash(500)
	gs.add_item("polaroid")
	menu.open_slots(false)
	var labels: Array = menu.get_node("%SlotList").get_children().filter(
		func(b: Node) -> bool: return not b.is_queued_for_deletion()).map(func(b: Node) -> String: return b.text)
	check(labels.size() == 4 and labels[0].begins_with("Autosave") and labels[2].ends_with("empty"), "the load screen lists the autosave and three slots")
	menu._on_slot_pressed(1)
	await wait(1.5)
	await process_frame
	check(current_scene.name == "Drive" and gs.cash == 38 and not gs.has_item("polaroid"), "loading slot 1 brings back the drive as it was saved")

func _settings() -> void:
	section("Settings")
	var settings: Node = root.get_node("Settings")
	var old: String = settings.text_speed
	menu.open_settings()
	menu._on_speed_selected(2)
	check(settings.text_speed == "Fast" and is_equal_approx(settings.speed_multiplier(), 1.7), "text speed can be set to Fast")
	settings.text_speed = old
	settings.save()
	menu.resume()

func _back_to_title() -> void:
	section("Quit to title")
	menu.open_pause()
	menu._quit_to_title()
	await wait(1.3)
	await process_frame
	check(current_scene.name == "Title", "Quit to title goes back to the title screen")
	await wait(1.6)
	check(current_scene.get_node("%ContinueButton").visible, "now there are saves, Continue shows")
	check(saves.latest_slot() == 0, "Continue picks the most recent save: the autosave from loading slot 1")

func _mid_fade() -> void:
	section("No menu in the middle of a scene change; the save's date")
	gs.reset()
	gs.day = 10
	gs.set_clock("20:00")
	var transition: Node = root.get_node("Transition")
	transition.go_to("res://scenes/counter.tscn", 0.4, 1.0)
	await wait(0.7)
	await _press_escape()
	check(transition.busy and not menu.is_open(), "Escape during the fade and the hold: no menu")
	await wait(1.2)
	await process_frame
	check(not transition.busy and current_scene.name == "Counter", "then the next scene, and the menu works again")
	check(saves.slot_info(0).get("label", "").contains("Oct 23"), "a key day's autosave has that day's date (Oct 23), not the night before's")

func _title_with_saves() -> void:
	section("The title screen with saves: New Game asks first; the end of what's written")
	var title: Node = await open_scene("res://scenes/title.tscn", 1.7)
	title._new_game()
	await wait(0.3)
	check(current_scene.name == "Title" and title.get_node("%NewGameButton").text.begins_with("Start over?"), "with a save there, New Game asks before replacing it")
	var script: GDScript = load("res://scripts/title.gd")
	# The last bridge in the table is the end of what's written; the one before leads on.
	var last: int = gs.BRIDGES.keys().max()
	var earlier: int = gs.BRIDGES.keys().filter(func(d: int) -> bool: return d < last).max()
	check(script.at_the_end({"scene": gs.BRIDGE_SCENE, "state": {"day": last}}), "a save on the last card is the end: no Continue")
	check(not script.at_the_end({"scene": gs.BRIDGE_SCENE, "state": {"day": earlier}}) and not script.at_the_end({"scene": "res://scenes/night.tscn", "state": {"day": earlier}}), "any other save can be continued")
