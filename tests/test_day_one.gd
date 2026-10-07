extends "res://tests/test_base.gd"

# Plays day one at the counter: the morning, Mrs. Hollis three ways, the
# voices, and the colored choice rules.

func run() -> void:
	await _morning_and_pockets()
	await _widow_kind()
	await _widow_price()
	await _widow_john()
	for answer in ["That's right", "Take a second", "Who's asking"]:
		await _trooper(answer)
	await _colored_rules()

# Opens the counter and plays until Mrs. Hollis has come in.
func _until_widow(fed_dog: bool, voices: Dictionary = {}) -> Node:
	gs.reset()
	gs.day = 1
	gs.fed_dog = fed_dog
	for voice in voices:
		gs.voices[voice] = voices[voice]
	var counter: Node = await open_scene("res://scenes/counter.tscn")
	advance(counter.get_node("%DialogueColumn"))
	await wait(1.8)
	advance(counter.get_node("%DialogueColumn"), 10)
	await process_frame
	return counter

func _log(column: Node) -> String:
	var text: String = ""
	for entry in column.get_node("%Log").get_children():
		text += entry.get_parsed_text() + "\n"
	return text

func _morning_and_pockets() -> void:
	section("The morning, and keys while the pockets are open")
	var counter: Node = await _until_widow(false)
	var column: Node = counter.get_node("%DialogueColumn")
	check(column._section == "widow_enters", "Mrs. Hollis comes in after the morning")
	check(counter.sounds["bell"].playing, "the bell rings as she comes in")
	check(gs.cash == 38 + 150, "Management's first envelope puts $150 in your pocket")
	check(gs.clock_text() == "9:40 AM", "it's 9:40 AM")
	check(choices(column) == ["\"That's right.\"", "Say nothing"], "she asks if you're John")
	var hud: Node = root.get_node("Hud")
	hud.open_pockets()
	await press_key(KEY_1)
	check(column._section == "widow_enters", "pressing 1 does nothing while your pockets are open")
	hud.close_pockets()
	await press_key(KEY_1)
	check(column._section == "widow_ask", "pressing 1 picks \"That's right.\" once they're closed")

func _widow_kind() -> void:
	section("Mrs. Hollis: answers to John, kind, gives the duck call")
	var counter: Node = await _until_widow(true)
	var column: Node = counter.get_node("%DialogueColumn")
	await pick(column, "That's right")
	advance(column)
	check(choices(column) == ["Tell her you're sorry to hear it.", "Ask what it's worth to her."], "no [John] choice yet at 1 point")
	await pick(column, "sorry")
	advance(column)
	check(_log(column).contains("WARMTH"), "Warmth speaks up after being kind")
	check(gs.voices["warmth"] == 1 and gs.voices["john"] == 1, "kindness feeds Warmth, answering to John feeds John")
	await pick(column, "Let me look")
	await process_frame
	check(counter.get_node("%ViewTitle").text == "The shop floor", "looking opens the shop floor")
	counter._select("duck_call")
	counter._on_offer_pressed()
	advance(column)
	counter._show_view("floor")
	await process_frame
	var shelf: Array = counter.get_node("%ShelfItems").get_children().filter(
		func(b: Node) -> bool: return not b.is_queued_for_deletion()).map(func(b: Node) -> String: return b.text)
	check(not shelf.has("Duck call"), "the duck call is sold and leaves the shelf")
	check(gs.till == 15 and gs.till_by_ledger == 15, "her $15 goes in the till")
	check(gs.ledger_lines == ["Oct 6. Duck call, sold to Mrs. Hollis. $15"], "the ledger writes the sale down, dated")
	counter._show_view("ledger")
	var ledger: String = counter.get_node("%LedgerText").get_parsed_text()
	check(ledger.contains("R. Hollis") and ledger.contains("tag 0447"), "the ledger shows the owner's entries")
	check(ledger.contains("Duck call, sold"), "a sold item keeps its entry, marked sold")
	counter._show_view("register")
	check(counter.get_node("%DrawerLabel").text == "In the drawer: $15.", "the register shows what's in the drawer")
	counter._on_take_pressed()
	check(gs.till == 0 and gs.cash == 188 + 15, "taking from the till moves it to your pocket (only what's there)")
	check(gs.till_short == 15, "and the ledger no longer matches the drawer")
	var hud: Node = root.get_node("Hud")
	hud.open_pockets()
	await process_frame
	var last: Node = hud.get_node("%ItemButtons").get_children().filter(
		func(n: Node) -> bool: return not n.is_queued_for_deletion())[-1]
	check(last is Label and last.text.contains("Cash: $203"), "your cash shows in the pockets")
	hud.close_pockets()

func _widow_price() -> void:
	section("Mrs. Hollis: silent, asks the price, offers the decoy")
	var counter: Node = await _until_widow(true)
	var column: Node = counter.get_node("%DialogueColumn")
	await pick(column, "Say nothing")
	advance(column)
	await pick(column, "worth")
	advance(column)
	check(_log(column).count("APPRAISAL") == 2, "Appraisal speaks twice, including the duck call hint")
	await pick(column, "Let me look")
	counter._select("decoy")
	await process_frame
	var notes: Array = counter.get_node("%VoiceNotes").get_children().filter(
		func(n: Node) -> bool: return not n.is_queued_for_deletion())
	check(notes.size() == 1 and notes[0].get_parsed_text().contains("isn't his"), "Appraisal comments on the decoy's stamp")
	counter._on_offer_pressed()
	check(column._section == "widow_given_decoy", "the decoy gets its own reaction")

func _widow_john() -> void:
	section("Mrs. Hollis: John strong enough for his colored choice")
	var counter: Node = await _until_widow(true, {"john": 2})
	var column: Node = counter.get_node("%DialogueColumn")
	await pick(column, "That's right")
	advance(column)
	check(choices(column).size() == 3 and choices(column)[2].begins_with("[John]"), "at 3 points the [John] choice appears")
	await pick(column, "[John]")
	advance(column)
	check(_log(column).contains("JOHN —"), "John speaks after the lie")
	check(gs.voices["john"] == 4, "the lie feeds John again")

const TROOPER_ROUTES: Dictionary = {
	"That's right": ["trooper_john", "john"],
	"Take a second": ["trooper_slow", "paranoia"],
	"Who's asking": ["trooper_who", "animal"],
}

func _trooper(answer: String) -> void:
	section("Sgt. Olstad, answering: " + answer)
	var counter: Node = await _until_widow(true)
	var column: Node = counter.get_node("%DialogueColumn")
	# Mrs. Hollis leaves quickly.
	await pick(column, "Say nothing")
	advance(column)
	await pick(column, "sorry")
	advance(column)
	await pick(column, "I don't think I can help")
	advance(column)
	await wait(1.8)
	advance(column)
	await process_frame
	check(column._section == "trooper_enters", "the Trooper comes in after Mrs. Hollis")
	check(choices(column) == ["\"That's right.\"", "Take a second too long.", "\"Who's asking?\""], "she asks if you're John: three ways to answer")
	var before: int = gs.voices[TROOPER_ROUTES[answer][1]]
	await pick(column, answer)
	check(column._section == TROOPER_ROUTES[answer][0], "the answer plays its own reaction")
	check(gs.voices[TROOPER_ROUTES[answer][1]] == before + 1, "it feeds " + TROOPER_ROUTES[answer][1].capitalize())
	advance(column)
	check(choices(column) == ["\"It's a rental.\"", "\"Must have been somebody else.\""], "then the dim headlight")
	await pick(column, "rental")
	advance(column)
	check(choices(column).size() == 2 and _log(column).contains("What's in the tin"), "she finds the tin box with tag 0447")
	await pick(column, "not for sale")
	advance(column)
	check(gs.has_item("back_door_key"), "she leaves you the back door key")
	check(gs.invited_to_pub, "and you're invited to the pub tonight")
	await wait(1.8)
	advance(column)
	check(column._section == "day_so_far", "then the day carries on")

func _colored_rules() -> void:
	section("Colored choice rules (docs/voices.md)")
	var column: Node = load("res://scenes/dialogue_column.tscn").instantiate()
	root.add_child(column)
	var file: FileAccess = FileAccess.open("user://test_rules.txt", FileAccess.WRITE)
	file.store_string("=== t\nnarration: x\n> Plain -> t\n> [John] a -> t | needs=john\n> [Appraisal] b -> t | needs=appraisal\n> [???] c -> t | needs=unknown\n> [Warmth] d -> t | needs=warmth\n")
	file.close()
	column.load_story("user://test_rules.txt")
	column._section = "t"
	var cases: Array = [
		[{}, ["Plain"], "nothing shows below 3 points"],
		[{"john": 3}, ["Plain", "[John] a"], "John's shows at 3 points"],
		[{"john": 3, "appraisal": 5}, ["Plain", "[Appraisal] b"], "only the strongest voice's shows"],
		[{"john": 4, "warmth": 4}, ["Plain", "[John] a"], "a tie goes to the one written first"],
		[{"appraisal": 9, "unknown": 3}, ["Plain", "[???] c"], "??? beats every other voice"],
	]
	for case in cases:
		gs.reset()
		for voice in case[0]:
			gs.voices[voice] = case[0][voice]
		var shown: Array = column._visible_choices().map(func(c: Dictionary) -> String: return c["label"])
		check(shown == case[1], case[2])
	column.queue_free()
