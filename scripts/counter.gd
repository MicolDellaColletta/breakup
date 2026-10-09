extends Control

# The shop's home screen: behind the counter, shelves on the left, the
# dialogue column on the right. Customers come in one at a time.

const LOOKS_PATH: String = "res://story/shop_looks.txt"
const USE_PATH: String = "res://story/use.txt"
const STOCK_PATH: String = "res://story/stock.cfg"
const LEDGER_PATH: String = "res://story/ledger.cfg"
const MAP_SCENE: String = "res://scenes/map.tscn"
# Who comes through the door each day, in order: customers and visitors. The
# id is the speaker (and the start of their sections: widow_enters). "| if="
# keeps someone away unless it holds, the same as in story files.
const VISITS: Dictionary = {
	1: ["widow", "nephew", "trooper", "seller", "reverend"],
	2: ["nephew | if=sold:ice_picks", "widow | if=!sold:ice_picks", "ezra", "seller", "ruth"],
}
const CUSTOMER_GAP: float = 1.5

# Placeholder text until there's art for each view.
const VIEWS: Dictionary = {
	"counter": {
		"title": "Behind the counter",
		"text": "Glass under your hands. The register, open and empty. The phone. A brass balance at the end of the glass, the kind for weighing gold. Past the shop floor, the front windows, and the neon on the snow.",
	},
	"floor": {
		"title": "The shop floor",
		"text": "Everything out here is for sale.",
	},
	"back": {
		"title": "The back shelves",
		"text": "Things people left as a promise to come back. Each one has a pawn tag. None of them are yours to sell.",
	},
	"ledger": {
		"title": "The ledger",
		"text": "A clothbound book, swollen with damp. Every item the shop holds, in the owner's small, careful hand.",
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
@onready var counter_button: Button = %CounterButton
@onready var floor_button: Button = %FloorButton
@onready var back_button: Button = %BackButton
@onready var ledger_button: Button = %LedgerButton
@onready var register_button: Button = %RegisterButton
@onready var shelf_panel: Control = %ShelfPanel
@onready var ledger_panel: ScrollContainer = %LedgerPanel
@onready var ledger_text: RichTextLabel = %LedgerText
@onready var register_panel: Control = %RegisterPanel
@onready var drawer_label: Label = %DrawerLabel
@onready var take_button: Button = %TakeButton
@onready var shelf_items: VBoxContainer = %ShelfItems
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
}

var _stock: ConfigFile = ConfigFile.new()
var _ledger_history: ConfigFile = ConfigFile.new()
var _visits: Array = []
var _customer_index: int = -1
var _customer: String = ""
var _browsing: bool = false
var _view: String = ""
var _selected: String = ""
var _exploring: bool = false
var _looked: Array[String] = []
# After closing: which of the shop's rooms you're standing in.
var _room: String = "counter"
var _walking: bool = false

func _ready() -> void:
	if _stock.load(STOCK_PATH) != OK:
		push_error("Could not load stock: " + STOCK_PATH)
	if _ledger_history.load(LEDGER_PATH) != OK:
		push_error("Could not load the ledger's older pages: " + LEDGER_PATH)
	_visits = VISITS.get(GameState.day, VISITS[1])
	counter_button.pressed.connect(_show_view.bind("counter"))
	floor_button.pressed.connect(_show_view.bind("floor"))
	back_button.pressed.connect(_show_view.bind("back"))
	ledger_button.pressed.connect(_show_view.bind("ledger"))
	register_button.pressed.connect(_show_view.bind("register"))
	take_button.pressed.connect(_on_take_pressed)
	offer_button.pressed.connect(_on_offer_pressed)
	nothing_button.pressed.connect(_on_nothing_pressed)
	column.use_sounds(sounds)
	column.line_shown.connect(_on_line_shown)
	column.section_finished.connect(_on_section_finished)
	column.choice_made.connect(_on_choice_made)
	explore_spots.spot_clicked.connect(click)
	explore_spots.aside.connect(play_aside)
	document_viewer.closed.connect(_on_page_closed)
	column.load_story(GameState.DAY_STORIES.get(GameState.day, GameState.DAY_STORIES[1]))
	column.add_story(LOOKS_PATH)
	column.add_story(USE_PATH)
	_show_view("counter")
	column.set_input_enabled(false)
	await Transition.fade_in(2.0)
	column.set_input_enabled(true)
	column.play("morning")

# --- The day ---

# The story has nowhere left to go: the next customer comes in.
func _on_section_finished(_section: String) -> void:
	if _browsing:
		return
	if _exploring:
		_fill_spots()
		return
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
	await get_tree().create_timer(CUSTOMER_GAP).timeout
	column.start_conversation(_customer + "_enters")

func _visit_happens(visit: String) -> bool:
	var parts: PackedStringArray = visit.split("| if=", true, 1)
	return parts.size() < 2 or column._condition_met(parts[1])

func _on_choice_made(choice: Dictionary) -> void:
	if choice["target"] == "@browse":
		_browsing = true
		nothing_button.visible = true
		if _view != "floor" and _view != "back":
			_show_view("floor")
		_refresh_offer()

func _on_offer_pressed() -> void:
	var item_id: String = _selected
	_stop_browsing()
	var section: String = "%s_given_%s" % [_customer, item_id]
	if not column.has_section(section):
		section = _customer + "_given_other"
	column.play(section)

func _on_nothing_pressed() -> void:
	_stop_browsing()
	column.play(_customer + "_nothing")

func _stop_browsing() -> void:
	_browsing = false
	nothing_button.visible = false
	_refresh_offer()

func _on_line_shown(line: Dictionary) -> void:
	if line.has("sold"):
		var item_id: String = line["sold"]
		GameState.record_sale(_stock.get_value(item_id, "name"), item_id,
			int(_stock.get_value(item_id, "price", 0)), Narrator.speaker_info(_customer)["name"])
		if _selected == item_id:
			_selected = ""
		_show_view(_view)
	if line.has("pawned"):
		var pawned: String = line["pawned"]
		GameState.record_pawn(_stock.get_value(pawned, "name"), pawned, int(line.get("loan", "0")),
			_stock.get_value(pawned, "pawn_tag", "new"), Narrator.speaker_info(_customer)["name"])
		_show_view(_view)

# --- The shelves ---

func _show_view(view: String) -> void:
	_view = view
	view_title.text = VIEWS[view]["title"]
	view_text.text = VIEWS[view]["text"]
	shelf_panel.visible = view == "floor" or view == "back"
	ledger_panel.visible = view == "ledger"
	register_panel.visible = view == "register"
	for old in shelf_items.get_children():
		old.queue_free()
	if view == "ledger":
		_write_ledger()
	if view == "register":
		_open_register()
	if not shelf_panel.visible:
		return
	var first: String = ""
	for item_id in _stock.get_sections():
		if not _in_shop(item_id):
			continue
		if _stock.get_value(item_id, "shelf") != view or GameState.sold.has(item_id):
			continue
		if first == "":
			first = item_id
		var button: Button = Button.new()
		button.text = _stock.get_value(item_id, "name")
		button.alignment = HORIZONTAL_ALIGNMENT_LEFT
		button.pressed.connect(_select.bind(item_id))
		shelf_items.add_child(button)
	_select(first if _stock.get_value(_selected, "shelf", "") != view or GameState.sold.has(_selected) else _selected)

func _select(item_id: String) -> void:
	_selected = item_id
	if item_id == "":
		item_name.text = "Nothing left here."
		item_description.text = ""
		item_tag.text = ""
	else:
		item_name.text = _stock.get_value(item_id, "name")
		item_description.text = _stock.get_value(item_id, "description")
		if _stock.get_value(item_id, "shelf") == "back":
			item_tag.text = "Pawn tag no. %s. Held, not for sale." % _tag(item_id)
		else:
			item_tag.text = "$%d" % _stock.get_value(item_id, "price")
	_show_voice_notes(item_id)
	_refresh_offer()

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
	Transition.go_to(MAP_SCENE, 1.5, 0.5)

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
	offer_button.visible = _browsing and _selected != "" and _stock.get_value(_selected, "shelf", "") == "floor"
