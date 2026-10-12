extends "res://tests/test_base.gd"

# The shop's shelves, drawn: picking things up and putting them down, the
# front window, turning to the other walls, the bell, the people across the
# counter, and examining things in close-up while a customer waits.

func run() -> void:
	await _shelves()
	await _window_and_saves()
	await _turning()
	await _bell()
	await _customer_and_examine()

func _open(day: int) -> Node:
	gs.reset()
	gs.day = day
	return await open_scene("res://scenes/counter.tscn")

func _shelves() -> void:
	section("The shelves: pick up, put down, swap")
	var counter: Node = await _open(1)
	check(gs.shelf_floor.size() == 16 and gs.shelf_back.size() == 12 and gs.shelf_window.size() == 3, "sixteen spots out front, twelve on the back shelf, three in the window")
	check(gs.shelf_floor.has("duck_call") and gs.shelf_back.has("tin_box") and not gs.shelf_back.has("silver_dollars"), "everything in the shop has a spot; what hasn't come in yet doesn't")
	counter._show_view("left")
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
	counter._show_view("left")
	view.spot_clicked.emit("floor", gs.shelf_floor.find(""))
	check(gs.shelf_back.has("tin_box") and counter._selected == "tin_box", "a held thing can't go out front: it stays in your hand")
	view.put_back.emit()
	check(counter._selected == "" and view.held == "", "a right-click puts it back")

func _window_and_saves() -> void:
	section("The front window")
	var counter: Node = await _open(1)
	var view: Node = counter.get_node("%ShelfView")
	var column: Node = counter.get_node("%DialogueColumn")
	counter._show_view("left")
	view.spot_clicked.emit("floor", gs.shelf_floor.find("fox"))
	counter._show_view("counter")
	check(view.mode == "counter" and view.shelf_name() == "window", "the counter view shows the window's three spots")
	view.spot_clicked.emit("window", 1)
	check(gs.shelf_window[1] == "fox" and not gs.shelf_floor.has("fox"), "the fox goes in the window")
	check(column._condition_met("window:fox") and not column._condition_met("window:decoy"), "stories can ask what's in the window")
	var saved: Dictionary = gs.to_dict()
	gs.reset()
	gs.from_dict(saved)
	check(gs.shelf_window[1] == "fox" and gs.shelf_floor.size() == 16, "the arrangement is saved")
	gs.record_sale("Mounted fox", "fox", 60, "")
	check(not gs.shelf_window.has("fox"), "a sold thing leaves its spot")

func _turning() -> void:
	section("Turning: the window and its shelves, the walls, the back")
	var counter: Node = await _open(1)
	var view: Node = counter.get_node("%ShelfView")
	var shown: Array = view.spots().map(func(s: Dictionary) -> String: return "%s%d" % [s["shelf"], s["spot"]])
	check(view.mode == "counter" and shown == ["window0", "window1", "window2", "floor0", "floor1", "floor2", "floor3"], "facing the front: the window's three spots, and a shelf either side")
	check(gs.shelf_floor[0] != "" and gs.shelf_floor[3] != "", "things for sale stand beside the window from the start")
	view.turned.emit("left")
	shown = view.spots().map(func(s: Dictionary) -> String: return "%s%d" % [s["shelf"], s["spot"]])
	check(view.mode == "left" and shown.size() == 6 and shown[0] == "floor4" and shown[5] == "floor9", "turning left: the left wall's six spots")
	counter.turn("around")
	check(view.mode == "right" and view.spots()[0]["spot"] == 10, "turning around from there: the right wall, with the door")
	counter.turn("right")
	check(view.mode == "back" and view.spots().size() == 12 and view.spots()[0]["shelf"] == "back", "turning right again: the back shelf")
	counter.get_node("%LedgerButton").pressed.emit()
	check(counter.get_node("%LedgerPanel").visible and not counter.get_node("%ShelfPanel").visible, "the ledger opens over the shelves")
	counter.get_node("%LedgerButton").pressed.emit()
	check(view.mode == "back" and counter.get_node("%ShelfPanel").visible, "and the same button shuts it, facing where you were")
	counter.get_node("%TurnAroundButton").pressed.emit()
	check(view.mode == "counter", "turning around: the front again")
	var item: String = gs.shelf_floor[4]
	view.spot_clicked.emit("floor", 4)
	view.spot_clicked.emit("window", 0)
	check(gs.shelf_window[0] == item, "a thing off the left wall can go in the window")

func _bell() -> void:
	section("The bell: nobody comes in until you ring")
	var counter: Node = await _open(1)
	var column: Node = counter.get_node("%DialogueColumn")
	var view: Node = counter.get_node("%ShelfView")
	var next: Button = counter.get_node("%NextButton")
	check(not next.visible, "no bell during the morning")
	for i in 60:
		column._on_advance_pressed()
	await wait(2.0)
	check(counter.waiting_for_bell() and next.visible and next.text == "Next customer", "after the morning, the shop waits: \"Next customer\"")
	check(view.person == "" and not column._section.ends_with("_enters"), "and nobody comes in on their own")
	counter.turn("left")
	counter.turn("left")
	check(counter.waiting_for_bell(), "looking round doesn't bring anyone")
	next.pressed.emit()
	check(not next.visible and not counter.waiting_for_bell(), "ringing: the button goes")
	await wait(1.2)
	check(column._section == "widow_enters" and view.person == "widow" and view.mode == "counter", "Mrs. Hollis comes in, and you turn to face her")
	counter.ring_bell()
	check(column._section == "widow_enters", "the bell does nothing while someone's in")
	# Play out the rest of the day without ringing, to see the last bell.
	counter._customer_index = counter._visits.size() - 1
	counter._customer = "reverend"
	counter._on_section_finished("reverend_nothing")
	check(next.visible and next.text == "Close up for the day", "after the last visit, the bell closes up")
	next.pressed.emit()
	check(column._section == "closing" or column._section.begins_with("closing"), "and closing time plays")

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
