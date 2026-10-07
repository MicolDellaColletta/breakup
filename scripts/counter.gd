extends Control

# The shop's home screen: behind the counter, shelves on the left, the
# dialogue column on the right. Customers come in one at a time.

const STORY_PATH: String = "res://story/day_one.txt"
const STOCK_PATH: String = "res://story/stock.cfg"
const CUSTOMERS: Array[String] = ["widow"]
const CUSTOMER_GAP: float = 1.5

# Placeholder text until there's art for each view.
const VIEWS: Dictionary = {
	"counter": {
		"title": "Behind the counter",
		"text": "Glass under your hands. The register, open and empty. The phone. Past the shop floor, the front windows, and the neon on the snow.",
	},
	"floor": {
		"title": "The shop floor",
		"text": "Everything out here is for sale.",
	},
	"back": {
		"title": "The back shelves",
		"text": "Things people left as a promise to come back. Each one has a pawn tag. None of them are yours to sell.",
	},
}

@onready var column: DialogueColumn = %DialogueColumn
@onready var view_title: Label = %ViewTitle
@onready var view_text: Label = %ViewText
@onready var counter_button: Button = %CounterButton
@onready var floor_button: Button = %FloorButton
@onready var back_button: Button = %BackButton
@onready var shelf_panel: Control = %ShelfPanel
@onready var shelf_items: VBoxContainer = %ShelfItems
@onready var item_name: Label = %ItemName
@onready var item_description: Label = %ItemDescription
@onready var item_tag: Label = %ItemTag
@onready var offer_button: Button = %OfferButton
@onready var nothing_button: Button = %NothingButton

@onready var sounds: Dictionary = {
	"bell": %Bell,
}

var _stock: ConfigFile = ConfigFile.new()
var _sold: Array[String] = []
var _customer_index: int = -1
var _customer: String = ""
var _browsing: bool = false
var _view: String = ""
var _selected: String = ""

func _ready() -> void:
	if _stock.load(STOCK_PATH) != OK:
		push_error("Could not load stock: " + STOCK_PATH)
	counter_button.pressed.connect(_show_view.bind("counter"))
	floor_button.pressed.connect(_show_view.bind("floor"))
	back_button.pressed.connect(_show_view.bind("back"))
	offer_button.pressed.connect(_on_offer_pressed)
	nothing_button.pressed.connect(_on_nothing_pressed)
	column.use_sounds(sounds)
	column.line_shown.connect(_on_line_shown)
	column.section_finished.connect(_on_section_finished)
	column.choice_made.connect(_on_choice_made)
	column.load_story(STORY_PATH)
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
	_next_customer()

func _next_customer() -> void:
	_customer_index += 1
	if _customer_index > CUSTOMERS.size():
		return
	if _customer_index == CUSTOMERS.size():
		column.play("day_so_far")
		return
	_customer = CUSTOMERS[_customer_index]
	await get_tree().create_timer(CUSTOMER_GAP).timeout
	column.play(_customer + "_enters")

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
		_sold.append(line["sold"])
		if _selected == line["sold"]:
			_selected = ""
		_show_view(_view)

# --- The shelves ---

func _show_view(view: String) -> void:
	_view = view
	view_title.text = VIEWS[view]["title"]
	view_text.text = VIEWS[view]["text"]
	shelf_panel.visible = view != "counter"
	for old in shelf_items.get_children():
		old.queue_free()
	if view == "counter":
		return
	var first: String = ""
	for item_id in _stock.get_sections():
		if _stock.get_value(item_id, "shelf") != view or _sold.has(item_id):
			continue
		if first == "":
			first = item_id
		var button: Button = Button.new()
		button.text = _stock.get_value(item_id, "name")
		button.alignment = HORIZONTAL_ALIGNMENT_LEFT
		button.pressed.connect(_select.bind(item_id))
		shelf_items.add_child(button)
	_select(first if _stock.get_value(_selected, "shelf", "") != view or _sold.has(_selected) else _selected)

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
			item_tag.text = "Pawn tag no. %s. Held, not for sale." % _stock.get_value(item_id, "pawn_tag")
		else:
			item_tag.text = "$%d" % _stock.get_value(item_id, "price")
	_refresh_offer()

# Only floor items can be offered, and only while a customer is waiting.
func _refresh_offer() -> void:
	offer_button.visible = _browsing and _selected != "" and _stock.get_value(_selected, "shelf", "") == "floor"
