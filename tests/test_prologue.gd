extends "res://tests/test_base.gd"

# Plays the prologue: the drive, the shop (both phone routes and both doors)
# and the first night (with and without feeding the dog).

func run() -> void:
	await _drive()
	await _missing_document()
	await _shop(true, "Knock")
	await _shop(false, "Push it open")
	await _night(true)
	await _night(false)

func _drive() -> void:
	section("The drive")
	gs.reset()
	var drive: Node = await open_scene("res://scenes/drive.tscn")
	var column: Node = drive.get_node("Narrator")
	var objects: Control = drive.get_node("Objects")
	check(objects.visible, "the car buttons show after the fade-in")
	check(gs.clock_text() == "10:40 PM", "the clock starts at 10:40 PM")

	drive._examine("glovebox", drive.get_node("Objects/GloveboxButton"))
	advance(column)
	check(gs.has_item("pawn_ticket"), "the glovebox puts pawn ticket 0527 in your pockets")
	check(drive.get_node("%DocumentViewer").visible, "the rental agreement opens")
	drive.get_node("%DocumentViewer")._on_close_pressed()
	check(gs.has_item("rental_agreement"), "the rental agreement goes in your pockets")

	drive._examine("coat", drive.get_node("Objects/CoatButton"))
	advance(column)
	await process_frame
	check(choices(column) == ["Take it out", "Leave it"], "the coat pocket offers Take it out / Leave it")
	check(not objects.visible, "the car buttons hide while choices show")
	await press_key(KEY_2)
	check(column._section == "coat_left", "pressing 2 picks the second choice")
	check(gs.voices["paranoia"] == 4, "leaving the job offer feeds Paranoia")
	advance(column)

	drive._examine("passenger", drive.get_node("Objects/PassengerButton"))
	advance(column)
	await process_frame
	check(choices(column) == ["Count the bullets", "Leave it wrapped"], "the passenger seat offers counting the bullets")
	await pick(column, "Count the bullets")
	check(column._section == "passenger_count", "counting the bullets plays its scene")
	advance(column)

	for object in ["radio", "mirror"]:
		drive._examine(object, drive.get_node("Objects/%sButton" % object.capitalize()))
		advance(column)
	advance(column)
	check(drive.get_node("Objects/WheelButton").visible, "the wheel appears once the radio, glovebox, mirror and coat are done")
	var others: int = gs.voices["john"] + gs.voices["appraisal"] + gs.voices["warmth"] + gs.voices["animal"]
	check(others == 0, "the prologue feeds no voice but Paranoia")

func _missing_document() -> void:
	section("A missing document doesn't freeze the game")
	var drive: Node = await open_scene("res://scenes/drive.tscn")
	var column: Node = drive.get_node("Narrator")
	drive._on_choice_made({"target": "@read_no_such_paper"})
	await process_frame
	await process_frame
	check(column._input_enabled, "the story carries on when a paper can't be found")

func _shop(pick_up: bool, door: String) -> void:
	section("The shop: " + ("picks up, knocks" if pick_up else "lets it ring, pushes the door"))
	gs.reset()
	var shop: Node = await open_scene("res://scenes/shop.tscn")
	var column: Node = shop.get_node("%Narrator")
	advance(column)
	check(choices(column) == ["Pick up", "Let it ring"], "the phone rings: Pick up / Let it ring")
	if pick_up:
		await pick(column, "Pick up")
		check(gs.answered_phone and gs.rules_broken.has("phone"), "picking up breaks rule four")
		await wait(shop._length_of("pickup") + 0.2)
		advance(column)
		check(shop.get_node("%DeadLine").playing, "after the breathing, the line goes dead: the tone plays")
		await pick(column, "Hang up")
		check(not shop.get_node("%DeadLine").playing, "hanging up stops it")
	else:
		await pick(column, "Let it ring")
		check(not gs.answered_phone and gs.rules_broken.is_empty(), "letting it ring breaks no rule")
	advance(column)
	check(column._section == "office_door", "then the office door")
	await pick(column, door)
	advance(column)
	advance(column)
	check(column._section == "office", door + " leads into the office")
	await pick(column, "Take the envelope")
	advance(column)
	await pick(column, "Open it")
	await wait(shop._length_of("tear") + 0.3)
	check(shop.get_node("%LetterPanel").visible and gs.has_item("letter"), "the letter opens and goes in your pockets")
	check(shop.get_node("%LetterText").text.begins_with("If you're reading this"), "the letter starts as the story bible says")
	shop._on_fold_pressed()
	var reaction: String = "after_letter_answered" if pick_up else "after_letter_ignored"
	check(column._section == reaction, "folding it plays " + reaction)
	advance(column)
	check(choices(column) == ["Go upstairs"], "and ends on Go upstairs")
	await pick(column, "Go upstairs")
	await wait(2.3)
	check(current_scene.name == "Apartment", "going upstairs leads to the apartment")

func _night(feed: bool) -> void:
	section("The first night: " + ("feeds the dog" if feed else "doesn't feed the dog"))
	gs.reset()
	gs.break_rule("phone")
	var apartment: Node = await open_scene("res://scenes/apartment.tscn", 1.7)
	var column: Node = apartment.get_node("%Narrator")
	advance(column)
	advance(column)
	check(apartment.get_node("%Objects").visible, "the apartment buttons show after arriving")
	apartment._examine("kitchen", apartment.get_node("%KitchenButton"))
	advance(column)
	await pick(column, "Fill the bowl" if feed else "Leave it")
	advance(column)
	check(gs.fed_dog == feed, "the dog bowl choice is remembered")
	apartment._examine("window", apartment.get_node("%WindowButton"))
	advance(column)
	await pick(column, "Close it")
	advance(column)
	apartment._examine("radio", apartment.get_node("%RadioButton"))
	advance(column)
	await pick(column, "Turn it on")
	advance(column)
	check(apartment.get_node("%BedButton").visible, "the bed appears after the window and the radio")
	apartment._on_bed_pressed()
	var route: Array = [column._section]
	for i in 40:
		column._on_advance_pressed()
		if route[-1] != column._section:
			route.append(column._section)
	var expected: Array = ["sleep", "sleep_end", "wake_bed"] if feed else ["sleep", "scratching", "sleep_end", "wake_standing"]
	check(route == expected, "the night goes " + " > ".join(expected))
	await wait(3.3)
	check(current_scene.name == "Counter" and gs.day == 1, "morning comes: day one at the counter")
