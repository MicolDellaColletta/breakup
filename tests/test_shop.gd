extends "res://tests/test_base.gd"

# The shop's shelves, drawn: picking things up and putting them down, the
# front window, the people across the counter, and examining things in
# close-up while a customer waits.

func run() -> void:
	await _shelves()
	await _window_and_saves()
	await _customer_and_examine()

func _open(day: int) -> Node:
	gs.reset()
	gs.day = day
	return await open_scene("res://scenes/counter.tscn")

func _shelves() -> void:
	section("The shelves: pick up, put down, swap")
	var counter: Node = await _open(1)
	check(gs.shelf_floor.size() == 12 and gs.shelf_back.size() == 12 and gs.shelf_window.size() == 3, "twelve spots out front, twelve on the back shelf, three in the window")
	check(gs.shelf_floor.has("duck_call") and gs.shelf_back.has("tin_box") and not gs.shelf_back.has("silver_dollars"), "everything in the shop has a spot; what hasn't come in yet doesn't")
	counter._show_view("floor")
	var view: Node = counter.get_node("%ShelfView")
	var from: int = gs.shelf_floor.find("compass")
	var empty: int = gs.shelf_floor.find("")
	view.spot_clicked.emit("floor", from)
	check(counter._selected == "compass" and view.held == "compass", "clicking the compass picks it up")
	check(counter.get_node("%ItemName").text == "Brass compass", "and says what it is")
	view.spot_clicked.emit("floor", empty)
	check(gs.shelf_floor[empty] == "compass" and gs.shelf_floor[from] == "" and counter._selected == "", "clicking an empty spot puts it down there")
	view.spot_clicked.emit("floor", empty)
	view.spot_clicked.emit("floor", gs.shelf_floor.find("decoy"))
	check(gs.shelf_floor[empty] == "decoy" and gs.shelf_floor.has("compass"), "putting it on another thing swaps the two")
	counter._show_view("back")
	view.spot_clicked.emit("back", gs.shelf_back.find("tin_box"))
	counter._show_view("floor")
	view.spot_clicked.emit("floor", gs.shelf_floor.find(""))
	check(gs.shelf_back.has("tin_box") and counter._selected == "tin_box", "a held thing can't go out front: it stays in your hand")
	view.put_back.emit()
	check(counter._selected == "" and view.held == "", "a right-click puts it back")

func _window_and_saves() -> void:
	section("The front window")
	var counter: Node = await _open(1)
	var view: Node = counter.get_node("%ShelfView")
	var column: Node = counter.get_node("%DialogueColumn")
	counter._show_view("floor")
	view.spot_clicked.emit("floor", gs.shelf_floor.find("fox"))
	counter._show_view("counter")
	check(view.mode == "counter" and view.shelf_name() == "window", "the counter view shows the window's three spots")
	view.spot_clicked.emit("window", 1)
	check(gs.shelf_window[1] == "fox" and not gs.shelf_floor.has("fox"), "the fox goes in the window")
	check(column._condition_met("window:fox") and not column._condition_met("window:decoy"), "stories can ask what's in the window")
	var saved: Dictionary = gs.to_dict()
	gs.reset()
	gs.from_dict(saved)
	check(gs.shelf_window[1] == "fox" and gs.shelf_floor.size() == 12, "the arrangement is saved")
	gs.record_sale("Mounted fox", "fox", 60, "")
	check(not gs.shelf_window.has("fox"), "a sold thing leaves its spot")

func _customer_and_examine() -> void:
	section("Who's across the counter, and a closer look")
	var counter: Node = await _open(1)
	var column: Node = counter.get_node("%DialogueColumn")
	var view: Node = counter.get_node("%ShelfView")
	advance(column)
	await wait(1.8)
	check(view.person == "widow" and view.mode == "counter", "Mrs. Hollis stands across the counter as she comes in")
	advance(column, 10)
	await process_frame
	await pick(column, "That's right")
	advance(column)
	await pick(column, "sorry")
	advance(column)
	await pick(column, "Let me look")
	await process_frame
	counter._select("duck_call")
	check(counter.get_node("%ExamineButton").visible and counter.get_node("%OfferButton").visible, "while she waits, the duck call can be examined, or handed over")
	counter._on_examine_pressed()
	var spots: Node = counter.get_node("%ExamineSpots")
	check(counter.get_node("%Examine").visible and spots.spot_ids() == ["ex_call_letters", "ex_call_reed"], "a close-up: the scratched letters and the reed")
	counter._on_detail_clicked("ex_call_letters")
	advance(column)
	check(_log(column).contains("R.H.") and spots.interactive and spots.get_spot("ex_call_letters").used, "the letters: R.H.; then back to the close-up")
	check(counter._browsing and column._section == "examine_call_letters", "she's still waiting")
	counter.close_examine()
	view.counter_clicked.emit()
	check(column._section == "widow_given_duck_call", "clicking the counter hands it over")
	advance(column)
	await wait(0.8)
	check(view.person_alpha < 0.5, "and she goes")

func _log(column: Node) -> String:
	var text: String = ""
	for entry in column.get_node("%Log").get_children():
		text += entry.get_parsed_text() + "\n"
	return text
