extends Control

# The shop's home screen: behind the counter, the shop on the left, the
# dialogue column on the right (and the shop the whole width while the column
# is away). The shelves are drawn (ShelfView): facing the front window with a
# shelf either side, or turned to the left wall, the right wall, the back
# shelf. Pick a thing up, put it down somewhere else, put it in the front
# window, or hand it over to whoever's waiting. On the counter: the register,
# the ledger (and the owner's catalogue in the back of it), and the bell.
# Nobody comes in on their own: between visits the shop is yours, and the
# bell lets the next person in. They stand across the counter (PersonArt).

const LOOKS_PATH: String = "res://story/shop_looks.txt"
const USE_PATH: String = "res://story/use.txt"
const EXAMINE_PATH: String = "res://story/examine.txt"
const STOCK_PATH: String = "res://story/stock.cfg"
const LEDGER_PATH: String = "res://story/ledger.cfg"
const MAP_SCENE: String = "res://scenes/map.tscn"
# Who comes through the door each day, in order: customers and visitors. The
# id is the speaker (and the start of their sections: widow_enters). "| if="
# keeps someone away unless it holds, the same as in story files.
const VISITS: Dictionary = {
	1: ["widow", "nephew", "trooper", "seller", "reverend"],
	2: ["nephew | if=sold:ice_picks", "widow | if=!sold:ice_picks", "ezra", "seller", "ruth"],
	# Day three: Olstad; the gift (whoever MC was kind to); the afternoon caller,
	# decided by what's in the front window; the warm jacket.
	3: ["trooper",
		"widow | if=sold:duck_call",
		"seller | if=!sold:duck_call and !broke:name",
		"boy | if=!sold:duck_call and broke:name",
		# (Visits are decided as they come: once Teague has bought the fox out
		# of the window, it's too late for June or the quiet afternoon.)
		"teague | if=window:fox",
		"june | if=!flag:teague_came and !window:fox and window:snowshoes or !flag:teague_came and !window:fox and window:ice_picks",
		"quiet | if=!flag:teague_came and !window:fox and !window:snowshoes and !window:ice_picks",
		"stranger"],
	# Day four, Saturday: the jacket comes home (Cody sees it on the shelf, or
	# Mrs. Hollis comes); Hanna Lund's braid; Sam's first door; the phone, in
	# daylight.
	4: ["nephew | if=flag:jacket_shelved and sold:ice_picks",
		"widow | if=!flag:jacket_shelved or !sold:ice_picks",
		"hanna",
		"sam",
		"phone"],
	# Day five is Sunday: no counter (GameState.DAY_SCENES).
	# Day six, Monday: Olstad (and the rental company, on the phone, while
	# she's there); Ezra, for a tooth; June, for a flannel shirt.
	6: ["trooper", "ezra", "june"],
	# Day seven, Tuesday: one small, warm visit. Then the John night.
	7: ["seller | if=!broke:name", "boy | if=broke:name"],
	# Key day 8, Thursday October 14 (week two): Ezra, the usual; Mrs.
	# Hollis's dish; Cody for the picks (alive, and they're held); June.
	8: ["ezra", "widow", "nephew | if=sold:ice_picks", "june"],
	# Key day 9 is the second Sunday: no counter (GameState.DAY_SCENES).
	# Key day 10, Saturday October 23 (week three): Olstad, stuck in town by
	# the road; Cody with the button (if he had the picks) or Mrs. Hollis;
	# Hanna, with the invitation. The evening is walked (GameState.EVENINGS).
	10: ["trooper", "nephew | if=flag:gave_picks_back", "widow | if=!flag:gave_picks_back", "hanna"],
	# Key day 11, Saturday October 30 (week four): the rental's due. Olstad;
	# Mrs. Hollis with a tape measure; Sam, who's worked out the trains; Ruth,
	# with candy for tomorrow (if faith with her holds).
	11: ["trooper", "widow", "sam | if=flag:knelt_with_sam or flag:door_sam_1",
		"ruth | if=flag:door_ruth_1 and !flag:broke_faith_ruth"],
	# Key day 12 is Halloween, a Sunday: no counter (GameState.DAY_SCENES).
	# Key day 13, Friday November 5: Olstad with the mail (the second money
	# order, from Wasilla); June, for the pageant; Sam, with his map.
	13: ["trooper", "june", "sam | if=flag:sam_map or flag:door_sam_1"],
	# Key day 14 is the fitting, a Sunday (GameState.DAY_SCENES).
	# Key day 15, Tuesday November 23: Mrs. Hollis; then, in the last of the
	# light, the man in the good coat.
	15: ["widow", "daniel"],
}
# From the bell to the door opening.
const CUSTOMER_GAP: float = 0.8

# The ways you can face from behind the counter, turning right.
const FACINGS: Array[String] = ["counter", "right", "back", "left"]

# Placeholder text until there's art for each view.
const VIEWS: Dictionary = {
	"counter": {
		"title": "Behind the counter",
		"text": "The front window, three spots seen from the road; a shelf either side. Click a thing to pick it up, a spot to put it down. Right-click puts it back.",
	},
	"left": {
		"title": "The left wall",
		"text": "Shelves to the ceiling, for sale. Dust on the tops of things nobody's reached for in years.",
	},
	"right": {
		"title": "The right wall",
		"text": "More shelves, for sale, and at the end of them the front door, with its bell.",
	},
	"back": {
		"title": "The back shelf",
		"text": "Things people left as a promise to come back. Each one has a pawn tag. None of them are yours to sell.",
	},
	"ledger": {
		"title": "The ledger",
		"text": "A clothbound book, swollen with damp. Every item the shop holds, in the owner's small, careful hand.",
	},
	"catalogue": {
		"title": "The owner's catalogue",
		"text": "The back half of the ledger, turned upside down. His notes on things, half what the town believes and half what he knew. Blanks for what you haven't found.",
	},
	"register": {
		"title": "The register",
		"text": "Old brass, heavy as an anvil. The drawer sticks, then rolls open with a bell of its own.",
	},
}

# Money taken from the till at a time, for yourself.
const TAKE_AMOUNT: int = 20

@onready var column: DialogueColumn = %DialogueColumn
@onready var view_title: Label = %ViewTitle
@onready var view_text: Label = %ViewText
@onready var left_button: Button = %TurnLeftButton
@onready var around_button: Button = %TurnAroundButton
@onready var right_button: Button = %TurnRightButton
@onready var next_button: Button = %NextButton
@onready var ledger_button: Button = %LedgerButton
@onready var register_button: Button = %RegisterButton
@onready var catalogue_button: Button = %CatalogueButton
@onready var loupe_button: Button = %LoupeButton
@onready var handle_button: Button = %HandleButton
@onready var props_text: RichTextLabel = %PropsText
@onready var panel_bar: HBoxContainer = %PanelBar
@onready var flip_button: Button = %FlipButton
@onready var scene_margins: MarginContainer = $SceneArea/SceneMargins
@onready var shelf_panel: BoxContainer = %ShelfPanel
@onready var ledger_panel: ScrollContainer = %LedgerPanel
@onready var ledger_text: RichTextLabel = %LedgerText
@onready var register_panel: Control = %RegisterPanel
@onready var drawer_label: Label = %DrawerLabel
@onready var take_button: Button = %TakeButton
@onready var shelf_view: ShelfView = %ShelfView
@onready var examine_button: Button = %ExamineButton
@onready var examine_view: ExamineView = %Examine
@onready var examine_spots: HotspotLayer = %ExamineSpots
@onready var item_name: Label = %ItemName
@onready var item_description: Label = %ItemDescription
@onready var item_tag: Label = %ItemTag
@onready var voice_notes: VBoxContainer = %VoiceNotes
@onready var offer_button: Button = %OfferButton
@onready var nothing_button: Button = %NothingButton

@onready var explore_art: Control = %ExploreArt
@onready var explore_spots: HotspotLayer = %ExploreSpots
@onready var document_viewer: DocumentViewer = %DocumentViewer

@onready var sounds: Dictionary = {
	"bell": %Bell,
	"floorboards": %Floorboards,
	"ring": %PhoneRing,
	"pickup": %PhonePickup,
	"hangup": %PhoneHangup,
}

var _stock: ConfigFile = ConfigFile.new()
var _ledger_history: ConfigFile = ConfigFile.new()
var _visits: Array = []
var _customer_index: int = -1
var _customer: String = ""
var _browsing: bool = false
# Browsing that lets a held thing off the back shelf be handed over
# (> Let me look -> @browse_back), for someone come to take one back.
var _browsing_back: bool = false
var _view: String = ""
# The way you're facing (one of FACINGS), under the ledger or register if
# one of those is open.
var _facing: String = "counter"
# Nobody's in: the shop waits for the bell.
var _waiting: bool = false
# The wait from the bell to the door (tests ring with none).
var customer_gap: float = CUSTOMER_GAP
# The thing in your hand, picked up off a shelf ("" for nothing). It's also
# what the details under the shelves describe.
var _selected: String = ""
var _exploring: bool = false
var _looked: Array[String] = []
# After closing: which of the shop's rooms you're standing in.
var _room: String = "counter"
var _walking: bool = false
# A close-up is open (Examine).
var _examining: bool = false
# Details looked at in close-ups, as "item_id/spot_id": they stay looked at.
var _details_seen: Array[String] = []
# What the last tool told you about the thing in your hand ("" for nothing).
var _tool_note: String = ""

func _ready() -> void:
	if _stock.load(STOCK_PATH) != OK:
		push_error("Could not load stock: " + STOCK_PATH)
	if _ledger_history.load(LEDGER_PATH) != OK:
		push_error("Could not load the ledger's older pages: " + LEDGER_PATH)
	_visits = VISITS.get(GameState.day, VISITS[1])
	left_button.pressed.connect(turn.bind("left"))
	around_button.pressed.connect(turn.bind("around"))
	right_button.pressed.connect(turn.bind("right"))
	ledger_button.pressed.connect(_toggle_panel.bind("ledger"))
	register_button.pressed.connect(_toggle_panel.bind("register"))
	catalogue_button.pressed.connect(_toggle_panel.bind("catalogue"))
	loupe_button.pressed.connect(use_tool.bind("loupe"))
	handle_button.pressed.connect(use_tool.bind("handle"))
	next_button.pressed.connect(ring_bell)
	next_button.visible = false
	%CloseButton.pressed.connect(func() -> void: _show_view(_facing))
	flip_button.pressed.connect(func() -> void: _show_view("catalogue" if _view == "ledger" else "ledger"))
	take_button.pressed.connect(_on_take_pressed)
	offer_button.pressed.connect(_on_offer_pressed)
	examine_button.pressed.connect(_on_examine_pressed)
	shelf_view.setup(_stock, _tag)
	shelf_view.spot_clicked.connect(_on_spot_clicked)
	shelf_view.counter_clicked.connect(_on_counter_clicked)
	shelf_view.put_back.connect(_put_down)
	shelf_view.turned.connect(turn)
	shelf_view.object_clicked.connect(_on_object_clicked)
	examine_spots.spot_clicked.connect(_on_detail_clicked)
	examine_spots.aside.connect(_on_detail_aside)
	%PutDownButton.pressed.connect(close_examine)
	_fill_shelves()
	nothing_button.pressed.connect(_on_nothing_pressed)
	column.use_sounds(sounds)
	column.line_shown.connect(_on_line_shown)
	column.section_finished.connect(_on_section_finished)
	column.choice_made.connect(_on_choice_made)
	column.shown_changed.connect(_on_column_shown)
	explore_spots.spot_clicked.connect(click)
	explore_spots.aside.connect(play_aside)
	document_viewer.closed.connect(_on_page_closed)
	GameState.start_day()
	column.load_story(GameState.DAY_STORIES.get(GameState.day, GameState.DAY_STORIES[1]))
	column.add_story(LOOKS_PATH)
	column.add_story(USE_PATH)
	column.add_story(EXAMINE_PATH)
	_show_view("counter")
	column.set_input_enabled(false)
	await Transition.fade_in(2.0)
	column.set_input_enabled(true)
	column.play("morning")

# --- The day ---

# The story has nowhere left to go: whoever was in goes out, and the shop is
# yours until you ring the bell. Once closing's been said, straight on.
func _on_section_finished(_section: String) -> void:
	if _examining:
		examine_spots.interactive = true
		return
	if _browsing:
		return
	if _exploring:
		_fill_spots()
		return
	if shelf_view.person != "":
		_person_leaves()
	if _customer_index >= _visits.size():
		_next_customer()
	else:
		_wait_for_bell()

func _wait_for_bell() -> void:
	_waiting = true
	next_button.text = "Next customer" if _visits_left() else "Close up for the day"
	shelf_view.bell_closes = not _visits_left()
	shelf_view.bell_ready = true

func waiting_for_bell() -> bool:
	return _waiting

# Anyone still to come today (as things stand now: who comes is decided when
# the bell goes).
func _visits_left() -> bool:
	for i in range(_customer_index + 1, _visits.size()):
		if _visit_happens(_visits[i]):
			return true
	return false

# The bell: the next person comes in, or, with nobody left, closing time.
func ring_bell() -> void:
	if not _waiting:
		return
	_waiting = false
	shelf_view.bell_ready = false
	_next_customer()

func _next_customer() -> void:
	_customer_index += 1
	# Skip anyone whose "| if=" doesn't hold today.
	while _customer_index < _visits.size() and not _visit_happens(_visits[_customer_index]):
		_customer_index += 1
	# After the last visit, closing time; after closing, the shop is yours to
	# look around until you leave by the front door.
	if _customer_index > _visits.size():
		_start_exploring()
		return
	if _customer_index == _visits.size():
		column.start_conversation("closing")
		return
	_customer = _visits[_customer_index].get_slice("|", 0).strip_edges()
	if customer_gap > 0.0:
		await get_tree().create_timer(customer_gap).timeout
	_person_comes_in(_customer)
	column.start_conversation(_customer + "_enters")

func _visit_happens(visit: String) -> bool:
	var parts: PackedStringArray = visit.split("| if=", true, 1)
	return parts.size() < 2 or column._condition_met(parts[1])

func _on_choice_made(choice: Dictionary) -> void:
	if choice["target"] == "@browse" or choice["target"] == "@browse_back":
		_browsing = true
		_browsing_back = choice["target"] == "@browse_back"
		nothing_button.visible = true
		if _browsing_back:
			_show_view("back")
		elif not FACINGS.has(_view):
			_show_view(_facing)
		_refresh_offer()

func _on_offer_pressed() -> void:
	var item_id: String = _selected
	_put_down()
	_stop_browsing()
	var section: String = "%s_given_%s" % [_customer, item_id]
	if not column.has_section(section):
		section = _customer + "_given_other"
	column.play(section)

func _on_nothing_pressed() -> void:
	_stop_browsing()
	column.play(_customer + "_nothing")

func _stop_browsing() -> void:
	if _examining:
		close_examine()
	_browsing = false
	_browsing_back = false
	nothing_button.visible = false
	_refresh_offer()

func _on_line_shown(line: Dictionary) -> void:
	if line.has("sold"):
		var item_id: String = line["sold"]
		GameState.record_sale(_stock.get_value(item_id, "name"), item_id,
			int(_stock.get_value(item_id, "price", 0)), Narrator.speaker_info(_customer)["name"])
		if _selected == item_id:
			_put_down()
		_show_view(_view)
	if line.has("redeemed"):
		var given: String = line["redeemed"]
		GameState.record_release(_stock.get_value(given, "name"), given, Narrator.speaker_info(_customer)["name"])
		if _selected == given:
			_put_down()
		_fill_shelves()
	# misplace=tin_box: somebody put it back in the wrong spot.
	if line.has("misplace"):
		_misplace(line["misplace"])
	if line.has("pawned"):
		var pawned: String = line["pawned"]
		GameState.record_pawn(_stock.get_value(pawned, "name"), pawned, int(line.get("loan", "0")),
			_stock.get_value(pawned, "pawn_tag", "new"), Narrator.speaker_info(_customer)["name"])
		_fill_shelves()
		_show_view(_view)

# --- The shelves ---

func _show_view(view: String) -> void:
	_view = view
	if FACINGS.has(view):
		_facing = view
	view_title.text = VIEWS[view]["title"]
	view_text.text = VIEWS[view]["text"]
	shelf_panel.visible = FACINGS.has(view)
	panel_bar.visible = not FACINGS.has(view)
	flip_button.visible = view == "ledger" or view == "catalogue"
	flip_button.text = "Turn the book over: his notes" if view == "ledger" else "Turn it back: the ledger"
	ledger_panel.visible = view == "ledger" or view == "catalogue"
	register_panel.visible = view == "register"
	if view == "ledger":
		_write_ledger()
	if view == "catalogue":
		ledger_text.text = _catalogue_bbcode()
	if view == "register":
		_open_register()
	if shelf_panel.visible:
		shelf_view.mode = view
	_show_details()

# Turns "left", "right" or "around" from the way you're facing (closing the
# ledger or register if one's open).
func turn(direction: String) -> void:
	var steps: int = {"right": 1, "around": 2, "left": 3}[direction]
	_show_view(FACINGS[(FACINGS.find(_facing) + steps) % FACINGS.size()])

# The register, the ledger and the bell on the counter.
func _on_object_clicked(object: String) -> void:
	if object == "bell":
		ring_bell()
	else:
		_show_view(object)

# --- The shop takes the whole width while the column's away ---

const WIDE_TIME: float = 0.25
const NARROW_RIGHT: float = 0.62
# How much of the panel the shelves get, next to the details' 1.
const SHELF_SHARE_NARROW: float = 1.2
const SHELF_SHARE_WIDE: float = 1.7
var _width_tween: Tween

func _on_column_shown(shown: bool) -> void:
	if _width_tween:
		_width_tween.kill()
	_width_tween = create_tween().set_parallel()
	var right: float = NARROW_RIGHT if shown else 1.0
	_width_tween.tween_property(scene_margins, "anchor_right", right, WIDE_TIME)
	_width_tween.tween_property(examine_view, "anchor_right", right, WIDE_TIME)
	# Narrow: the details under the shelves. Wide: beside them, so the
	# shelves get the whole height.
	shelf_panel.vertical = shown
	shelf_view.size_flags_stretch_ratio = SHELF_SHARE_NARROW if shown else SHELF_SHARE_WIDE

# The ledger and the register open over the shelves; the same button again
# shuts them.
func _toggle_panel(view: String) -> void:
	_show_view(_facing if _view == view else view)

# Picks a thing up off its shelf (tests use it to choose what to offer).
func _select(item_id: String) -> void:
	_selected = item_id
	_tool_note = ""
	shelf_view.held = item_id
	_show_details()

# Puts down whatever you're holding: it stays where it was.
func _put_down() -> void:
	_selected = ""
	_tool_note = ""
	shelf_view.held = ""
	_show_details()

# A spot on a shelf (or in the window) was clicked: pick up what's there, or
# put what you're holding there (swapping with what was there).
func _on_spot_clicked(shelf: String, spot: int) -> void:
	var there: String = GameState.shelf(shelf)[spot]
	if _selected == "":
		if there != "":
			_select(there)
		return
	if there == _selected:
		_put_down()
		return
	if not _fits(_selected, shelf) or (there != "" and not _fits(there, GameState.shelf_spot_of(_selected)[0])):
		_tool_note = _wont_fit(_selected, shelf)
		_show_details()
		return
	GameState.place_on_shelf(_selected, shelf, spot)
	_put_down()

# Floor things (for sale) go on the floor shelves or in the window; held
# things only on the back shelf.
func _fits(item_id: String, shelf: String) -> bool:
	var kind: String = _stock.get_value(item_id, "shelf", "")
	if kind == "back":
		return shelf == "back"
	return shelf == "floor" or shelf == "window"

func _wont_fit(item_id: String, shelf: String) -> String:
	if _stock.get_value(item_id, "shelf", "") == "back":
		return "That's held against a ticket. It stays on the back shelf."
	return "Things for sale go out front, or in the window."

func _on_counter_clicked() -> void:
	if offer_button.visible:
		_on_offer_pressed()

# Moves a thing to another empty spot on its own shelf (the last one free).
func _misplace(item_id: String) -> void:
	var where: Array = GameState.shelf_spot_of(item_id)
	if where[1] == -1:
		return
	var spots: Array[String] = GameState.shelf(where[0])
	for spot in range(spots.size() - 1, -1, -1):
		if spots[spot] == "" and spot != where[1]:
			spots[where[1]] = ""
			spots[spot] = item_id
			break
	shelf_view.queue_redraw()

# Every thing in the shop has a spot: anything new (just pawned, or never
# arranged) goes in the first empty spot on its shelf; anything gone (sold,
# not arrived yet) comes off.
func _fill_shelves() -> void:
	GameState.ready_shelves()
	for item_id in _stock.get_sections():
		var kind: String = _stock.get_value(item_id, "shelf", "")
		if kind != "floor" and kind != "back":
			continue
		if not _in_shop(item_id) or GameState.sold.has(item_id):
			GameState.take_off_shelves(item_id)
			continue
		if GameState.shelf_spot_of(item_id)[1] == -1:
			var spot: int = GameState.empty_spot(kind)
			if spot != -1:
				GameState.shelf(kind)[spot] = item_id
	shelf_view.queue_redraw()

func _show_details() -> void:
	var item_id: String = _selected
	if item_id == "":
		item_name.text = "Nothing in your hands."
		item_description.text = ""
		item_tag.text = ""
	else:
		item_name.text = _stock.get_value(item_id, "name")
		item_description.text = _stock.get_value(item_id, "description")
		if _stock.get_value(item_id, "shelf") == "back":
			item_tag.text = "Pawn tag no. %s. Held, not for sale." % _tag(item_id)
		else:
			item_tag.text = "$%d" % _stock.get_value(item_id, "price")
	props_text.text = _props_bbcode(item_id)
	loupe_button.visible = item_id != ""
	handle_button.visible = item_id != ""
	_show_voice_notes(item_id)
	_refresh_offer()

# --- What things are: tools, and the owner's catalogue (scripts/props.gd) ---

const TOOL_NOTHING: Dictionary = {
	"loupe": "Under the loupe, nothing you haven't already seen.",
	"handle": "You turn it over, weigh it, smell it, hold it to your ear. Nothing new.",
}

# Uses a tool on the thing in your hand. Free: nobody's waiting on it.
func use_tool(tool: String) -> void:
	if _selected == "":
		return
	var found: Array[String] = Props.use_tool(_stock, _selected, tool)
	_tool_note = TOOL_NOTHING[tool] if found.is_empty() else ""
	_show_details()

# What you've found out about one thing, and how much is left to find.
func _props_bbcode(item_id: String) -> String:
	if item_id == "":
		return ""
	var lines: PackedStringArray = []
	var left: int = 0
	for kind in Props.kinds_of(_stock, item_id):
		if GameState.knows_prop(item_id, kind):
			lines.append("[b]%s:[/b] %s" % [Props.LABELS[kind], Props.text(_stock, item_id, kind).replace("[", "[lb]")])
		else:
			left += 1
	if left > 0:
		lines.append("[i]%s to find out.[/i]" % ("One more thing" if left == 1 else "%d more things" % left))
	if _tool_note != "":
		lines.append("[i]%s[/i]" % _tool_note)
	return "\n".join(lines)

# The back of the ledger: the owner's note on each thing he knew, then what
# you've found, with a blank for each thing still to find.
func _catalogue_bbcode() -> String:
	var text: String = "[i]In the same small, careful hand, from the back of the book forward. He didn't seem to tell belief from appraisal. Maybe there wasn't a difference, here.[/i]\n"
	var found: int = 0
	var total: int = 0
	for item_id in _stock.get_sections():
		if not _in_shop(item_id):
			continue
		var kinds: Array[String] = Props.kinds_of(_stock, item_id)
		if kinds.is_empty() and not _stock.has_section_key(item_id, "catalogue"):
			continue
		text += "\n[b]%s[/b]%s\n" % [_stock.get_value(item_id, "name"), ", sold" if GameState.sold.has(item_id) else ""]
		if _stock.has_section_key(item_id, "catalogue"):
			text += "[i]\"%s\"[/i]\n" % str(_stock.get_value(item_id, "catalogue")).replace("[", "[lb]")
		else:
			text += "[i]Nothing in his hand. It came in after him.[/i]\n"
		for kind in kinds:
			total += 1
			if GameState.knows_prop(item_id, kind):
				found += 1
				text += "%s: %s\n" % [Props.LABELS[kind], Props.text(_stock, item_id, kind).replace("[", "[lb]")]
			else:
				text += "%s: ________\n" % Props.LABELS[kind]
	text += "\n[b]FILLED IN[/b]\n\n%d of %d, in your hand." % [found, total]
	return text

# --- Examining: a close-up of the thing in your hand ---

func _on_examine_pressed() -> void:
	if _selected == "":
		return
	_examining = true
	examine_view.shape = _stock.get_value(_selected, "shape", "")
	%ExamineTitle.text = _stock.get_value(_selected, "name")
	examine_spots.fill("examine", _selected, column)
	for seen in _details_seen:
		if seen.begins_with(_selected + "/"):
			examine_spots.mark_used(seen.get_slice("/", 1))
	examine_spots.interactive = true
	examine_view.visible = true

func close_examine() -> void:
	_examining = false
	examine_view.visible = false
	_refresh_offer()

# A detail on the close-up: what it tells you plays in the column.
func _on_detail_clicked(spot_id: String) -> void:
	_details_seen.append(_selected + "/" + spot_id)
	examine_spots.mark_used(spot_id)
	examine_spots.interactive = false
	column.start_conversation(Spots.section(spot_id))

func _on_detail_aside(section: String) -> void:
	examine_spots.interactive = false
	column.start_conversation(section)

# --- Who's across the counter ---

const PERSON_FADE: float = 0.5

func _person_comes_in(person_id: String) -> void:
	if not PersonArt.has(person_id):
		return
	_show_view("counter")
	shelf_view.person = person_id
	shelf_view.person_alpha = 0.0
	create_tween().tween_property(shelf_view, "person_alpha", 1.0, PERSON_FADE)

func _person_leaves() -> void:
	var fade: Tween = create_tween()
	fade.tween_property(shelf_view, "person_alpha", 0.0, PERSON_FADE)
	await fade.finished
	shelf_view.person = ""

# appraisal="..." with appraisal_at=1 in stock.cfg: that voice comments on
# the item once it's strong enough. A weak voice stays quiet.
func _show_voice_notes(item_id: String) -> void:
	for old in voice_notes.get_children():
		old.queue_free()
	if item_id == "":
		return
	for voice in GameState.voices:
		if not _stock.has_section_key(item_id, voice):
			continue
		if GameState.voices[voice] < int(_stock.get_value(item_id, voice + "_at", 1)):
			continue
		if GameState.drowned(voice):
			continue
		var speaker: Dictionary = Narrator.speaker_info(voice)
		var note: RichTextLabel = RichTextLabel.new()
		note.bbcode_enabled = true
		note.fit_content = true
		note.scroll_active = false
		note.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		note.add_theme_font_size_override("normal_font_size", 17)
		note.add_theme_font_size_override("bold_font_size", 17)
		note.add_theme_color_override("default_color", speaker["color"])
		note.text = "[b]%s[/b] — %s" % [speaker["name"].to_upper(), _stock.get_value(item_id, voice).replace("[", "[lb]")]
		voice_notes.add_child(note)

# --- After closing: looking around (story/spots.cfg, scene "shop") ---
# The counter screen gives way to the shop itself, first person: the same four
# rooms as the first night (shop_art.gd), walked with arrows. The front door
# leads out to the town map.

const EXPLORE_FADE: float = 0.25

func _start_exploring() -> void:
	_exploring = true
	_room = "counter"
	explore_art.view = _room
	explore_art.visible = true
	explore_spots.visible = true
	_fill_spots()

# The room you're standing in after closing.
func current_room() -> String:
	return _room

# Clicking a hotspot after closing: walk, leave, read the ledger, or look.
func click(spot_id: String) -> void:
	if not _exploring or _walking or not explore_spots.interactive:
		return
	var sound: String = Spots.sound(spot_id)
	if sound != "":
		column.play_sound(sound)
	var to: String = Spots.go(spot_id)
	if to == "@leave":
		_leave_for_the_evening()
	elif to == "@ledger":
		read_ledger()
	elif to != "":
		walk(to)
	else:
		look(spot_id)

func walk(room: String) -> void:
	_walking = true
	explore_spots.interactive = false
	var fade: Tween = create_tween()
	fade.tween_property(explore_art, "modulate", Color(0.15, 0.15, 0.15), EXPLORE_FADE)
	await fade.finished
	_room = room
	explore_art.view = room
	fade = create_tween()
	fade.tween_property(explore_art, "modulate", Color.WHITE, EXPLORE_FADE)
	_walking = false
	_fill_spots()

# Looks at one thing in the room. Public so tests can use it.
func look(spot_id: String) -> void:
	_looked.append(spot_id)
	explore_spots.mark_used(spot_id)
	explore_spots.interactive = false
	column.start_conversation(Spots.section(spot_id))

# A short scene that changes nothing: something from your pockets used on a
# hotspot, or a second look (story/use.txt).
func play_aside(section: String) -> void:
	if not _exploring or _walking or not explore_spots.interactive:
		return
	explore_spots.interactive = false
	column.start_conversation(section)

# The ledger, open on the counter after closing: as often as you like.
func read_ledger() -> void:
	explore_spots.interactive = false
	column.set_input_enabled(false)
	document_viewer.open_page("ledger", "The ledger", _ledger_bbcode())

func _on_page_closed(_page_id: String) -> void:
	column.set_input_enabled(true)
	explore_spots.interactive = _exploring

# The things to look at in the room you're in, once the shop is closed.
func _fill_spots() -> void:
	if not _exploring:
		return
	explore_spots.fill("shop", _room, column)
	for spot_id in _looked:
		explore_spots.mark_used(spot_id)
	explore_spots.interactive = true

func _leave_for_the_evening() -> void:
	explore_spots.interactive = false
	create_tween().tween_property($ShopHum, "volume_db", -80.0, 1.5)
	Transition.go_to(GameState.evening_scene(), 1.5, 0.5)

# The ticket number: the one written this season, or the owner's.
func _tag(item_id: String) -> String:
	var written: String = GameState.pawn_tag_of(item_id)
	return written if written != "" else str(_stock.get_value(item_id, "pawn_tag", ""))

# Items marked arrives=true in stock.cfg aren't in the shop until someone brings
# them in (pawned= in a story file).
func _in_shop(item_id: String) -> bool:
	return not _stock.get_value(item_id, "arrives", false) or GameState.acquired.has(item_id)

# --- The ledger and the register ---

# Every item the shop holds, with the owner's entry for it, then this
# season's sales, then what the drawer should hold by the book.
func _write_ledger() -> void:
	ledger_text.text = _ledger_bbcode()

func _ledger_bbcode() -> String:
	var text: String = "[b]HELD BY THE SHOP[/b]\n"
	for item_id in _stock.get_sections():
		if not _in_shop(item_id):
			continue
		# A ledger never erases: a sold item keeps its entry, marked sold.
		var price: String
		if GameState.sold.has(item_id):
			price = "sold"
		elif _stock.get_value(item_id, "shelf") == "back":
			price = "tag %s" % _tag(item_id)
		else:
			price = "$%d" % _stock.get_value(item_id, "price")
		text += "\n[b]%s[/b], %s\n[i]%s[/i]\n" % [_stock.get_value(item_id, "name"), price,
			_stock.get_value(item_id, "ledger", "No entry.").replace("[", "[lb]")]
	var older: Array = _ledger_history.get_value("older_pages", "lines", [])
	if not older.is_empty():
		text += "\n[b]OLDER PAGES[/b]\n"
		for line in older:
			text += "\n[i]%s[/i]" % line.replace("[", "[lb]")
		text += "\n"
	text += "\n[b]THIS SEASON[/b]\n"
	if GameState.ledger_lines.is_empty():
		text += "\nNothing yet. The last line in the owner's hand is three weeks old.\n"
	for line in GameState.ledger_lines:
		text += "\n" + line.replace("[", "[lb]")
	# From day two, a line you didn't write, in the owner's small, careful hand.
	if GameState.day >= 2:
		text += "\n[i]Oct 6. Keeper settling in.[/i]"
	if GameState.day >= 7:
		text += "\n[i]Oct 12. One week.[/i]"
	text += "\n\n[b]THE DRAWER, BY THE BOOK[/b]\n\n$%d" % GameState.till_by_ledger
	return text

func _open_register() -> void:
	if GameState.till == 0:
		drawer_label.text = "The drawer is empty."
	else:
		drawer_label.text = "In the drawer: $%d." % GameState.till
	take_button.visible = GameState.till > 0

# Not written in the ledger. The book and the drawer stop agreeing.
func _on_take_pressed() -> void:
	GameState.take_from_till(TAKE_AMOUNT)
	_open_register()

# Only floor items can be offered, and only while a customer is waiting.
func _refresh_offer() -> void:
	var kind: String = _stock.get_value(_selected, "shelf", "")
	offer_button.visible = _browsing and _selected != "" and (kind == "floor" or (_browsing_back and kind == "back"))
	shelf_view.can_hand_over = offer_button.visible
	# Examining while someone waits: the close-up plays in the column, so only
	# once they've asked and you're looking.
	examine_button.visible = _browsing and _selected != "" and not Spots.in_room("examine", _selected, column).is_empty()
