extends CanvasLayer

# Always on screen: the clock, the Pockets button, the pockets panel,
# and a short note when something is added to your pockets. From the
# pockets you can take something out to use on a thing in the room: it stays
# in your hand (its name follows the mouse) until you click something with
# it, or put it back with a right-click or Esc.

signal held_changed(item_id: String)

const TOAST_HOLD: float = 2.5
# Where the held item's name sits, from the mouse.
const HELD_OFFSET: Vector2 = Vector2(18, 14)

@onready var clock_label: Label = %ClockLabel
@onready var pockets_button: Button = %PocketsButton
@onready var toast: Label = %Toast
@onready var pockets_panel: ColorRect = %PocketsPanel
@onready var item_buttons: VBoxContainer = %ItemButtons
@onready var item_name: Label = %ItemName
@onready var item_description: Label = %ItemDescription
@onready var read_button: Button = %ReadButton
@onready var use_button: Button = %UseButton
@onready var held_label: Label = %HeldLabel
@onready var close_button: Button = %CloseButton
@onready var document_viewer: DocumentViewer = %DocumentViewer

var _selected: String = ""
# The item in your hand, ready to use on something. "" when your hands are empty.
var held_item: String = ""
var _toast_queue: Array[String] = []
var _toast_showing: bool = false

func _ready() -> void:
	pockets_panel.visible = false
	toast.modulate.a = 0.0
	pockets_button.pressed.connect(open_pockets)
	close_button.pressed.connect(close_pockets)
	read_button.pressed.connect(_on_read_pressed)
	use_button.pressed.connect(_on_use_pressed)
	get_tree().scene_changed.connect(drop)
	document_viewer.closed.connect(_on_document_closed)
	GameState.time_changed.connect(_update_clock)
	GameState.item_added.connect(_on_item_added)
	_update_clock()

# --- Public: what other scenes can use ---

func open_pockets() -> void:
	drop()
	for old in item_buttons.get_children():
		old.queue_free()
	for item_id in GameState.inventory:
		var button: Button = Button.new()
		button.text = GameState.item_info(item_id, "name")
		button.alignment = HORIZONTAL_ALIGNMENT_LEFT
		button.pressed.connect(_select.bind(item_id))
		item_buttons.add_child(button)
	var cash: Label = Label.new()
	cash.text = "\nCash: $%d" % GameState.cash
	cash.add_theme_color_override("font_color", Color(0.79, 0.71, 0.35, 0.9))
	cash.add_theme_font_size_override("font_size", 18)
	item_buttons.add_child(cash)
	_select(GameState.inventory[0] if not GameState.inventory.is_empty() else "")
	pockets_panel.visible = true
	# Holding focus here keeps Space/Enter from advancing the story underneath.
	close_button.grab_focus()

func close_pockets() -> void:
	pockets_panel.visible = false

# Takes an item out of your pockets, to use on something.
func hold(item_id: String) -> void:
	held_item = item_id
	held_label.text = "Holding: %s  (right-click to put it back)" % GameState.item_info(item_id, "name")
	held_label.visible = true
	_follow_mouse()
	held_changed.emit(item_id)

# Puts it back.
func drop() -> void:
	if held_item == "":
		return
	held_item = ""
	held_label.visible = false
	held_changed.emit("")

# True while the pockets (or a paper read from them) cover the screen, so
# keys don't reach the story underneath.
func is_covering() -> bool:
	return pockets_panel.visible or document_viewer.visible

# --- Private: the machinery ---

func _process(_delta: float) -> void:
	if held_item != "":
		_follow_mouse()

# A right-click or Esc puts the held item back, before the pause menu sees it.
func _input(event: InputEvent) -> void:
	if held_item == "":
		return
	var right_click: bool = event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT
	if right_click or event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		drop()

func _follow_mouse() -> void:
	held_label.position = get_viewport().get_mouse_position() + HELD_OFFSET

func _update_clock() -> void:
	clock_label.text = "%s  ·  %s" % [GameState.weekday_text(), GameState.clock_text()]

func _select(item_id: String) -> void:
	_selected = item_id
	item_name.text = GameState.item_info(item_id, "name") if item_id != "" else "Nothing."
	item_description.text = GameState.item_info(item_id, "description") if item_id != "" else ""
	read_button.visible = item_id != "" and GameState.item_info(item_id, "document") != ""
	use_button.visible = item_id != ""

func _on_read_pressed() -> void:
	document_viewer.open(GameState.item_info(_selected, "document"))

func _on_use_pressed() -> void:
	close_pockets()
	hold(_selected)

func _on_document_closed(_doc_id: String) -> void:
	close_button.grab_focus()

# Notes wait their turn, so two items picked up close together both get seen.
func _on_item_added(item_id: String) -> void:
	_toast_queue.append("Added to your pockets: " + GameState.item_info(item_id, "name"))
	if not _toast_showing:
		_show_toasts()

func _show_toasts() -> void:
	_toast_showing = true
	while not _toast_queue.is_empty():
		toast.text = _toast_queue.pop_front()
		var tween: Tween = create_tween()
		tween.tween_property(toast, "modulate:a", 1.0, 0.3)
		tween.tween_interval(TOAST_HOLD)
		tween.tween_property(toast, "modulate:a", 0.0, 0.6)
		await tween.finished
	_toast_showing = false
