extends CanvasLayer

# Always on screen: the clock, the Pockets button, the pockets panel,
# and a short note when something is added to your pockets.

const TOAST_HOLD: float = 2.5

@onready var clock_label: Label = %ClockLabel
@onready var pockets_button: Button = %PocketsButton
@onready var toast: Label = %Toast
@onready var pockets_panel: ColorRect = %PocketsPanel
@onready var item_buttons: VBoxContainer = %ItemButtons
@onready var item_name: Label = %ItemName
@onready var item_description: Label = %ItemDescription
@onready var read_button: Button = %ReadButton
@onready var close_button: Button = %CloseButton
@onready var document_viewer: DocumentViewer = %DocumentViewer

var _selected: String = ""
var _toast_queue: Array[String] = []
var _toast_showing: bool = false

func _ready() -> void:
	pockets_panel.visible = false
	toast.modulate.a = 0.0
	pockets_button.pressed.connect(open_pockets)
	close_button.pressed.connect(close_pockets)
	read_button.pressed.connect(_on_read_pressed)
	document_viewer.closed.connect(_on_document_closed)
	GameState.time_changed.connect(_update_clock)
	GameState.item_added.connect(_on_item_added)
	_update_clock()

# --- Public: what other scenes can use ---

func open_pockets() -> void:
	for old in item_buttons.get_children():
		old.queue_free()
	for item_id in GameState.inventory:
		var button: Button = Button.new()
		button.text = GameState.item_info(item_id, "name")
		button.alignment = HORIZONTAL_ALIGNMENT_LEFT
		button.pressed.connect(_select.bind(item_id))
		item_buttons.add_child(button)
	_select(GameState.inventory[0] if not GameState.inventory.is_empty() else "")
	pockets_panel.visible = true
	# Holding focus here keeps Space/Enter from advancing the story underneath.
	close_button.grab_focus()

func close_pockets() -> void:
	pockets_panel.visible = false

# True while the pockets (or a paper read from them) cover the screen, so
# keys don't reach the story underneath.
func is_covering() -> bool:
	return pockets_panel.visible or document_viewer.visible

# --- Private: the machinery ---

func _update_clock() -> void:
	clock_label.text = GameState.clock_text()

func _select(item_id: String) -> void:
	_selected = item_id
	item_name.text = GameState.item_info(item_id, "name") if item_id != "" else "Nothing."
	item_description.text = GameState.item_info(item_id, "description") if item_id != "" else ""
	read_button.visible = item_id != "" and GameState.item_info(item_id, "document") != ""

func _on_read_pressed() -> void:
	document_viewer.open(GameState.item_info(_selected, "document"))

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
