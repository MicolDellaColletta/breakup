class_name DocumentViewer
extends CanvasLayer

# A paper held up to read: a page over the dimmed scene, above everything but
# the pause menu and fades. Nothing underneath reacts while it's open. Put it
# away with the button, a click outside the page, or Esc.

signal closed(doc_id: String)

const DOCUMENTS_PATH: String = "res://story/documents/"

@onready var backdrop: ColorRect = %Backdrop
@onready var title_label: Label = %TitleLabel
@onready var body_label: Label = %BodyLabel
@onready var close_button: Button = %CloseButton
@onready var paper_sound: AudioStreamPlayer = %PaperSound

var _doc_id: String = ""

func _ready() -> void:
	visible = false
	close_button.pressed.connect(_on_close_pressed)
	backdrop.gui_input.connect(_on_backdrop_input)

# Esc puts the paper away before the pause menu sees it.
func _input(event: InputEvent) -> void:
	if visible and event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		_on_close_pressed()

func open(doc_id: String) -> void:
	var path: String = DOCUMENTS_PATH + doc_id + ".txt"
	var text: String = FileAccess.get_file_as_string(path)
	if text == "":
		push_error("Could not read document: " + path)
		# Act as if it was put away at once, so the story doesn't get stuck
		# waiting for a page that never opened.
		closed.emit.call_deferred(doc_id)
		return
	var parts: PackedStringArray = text.split("\n", true, 1)
	title_label.text = parts[0].strip_edges()
	body_label.text = parts[1].strip_edges() if parts.size() > 1 else ""
	_doc_id = doc_id
	GameState.add_item(doc_id)
	paper_sound.play()
	visible = true
	close_button.grab_focus()

func _on_backdrop_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		_on_close_pressed()

func _on_close_pressed() -> void:
	if not visible:
		return
	paper_sound.play()
	visible = false
	closed.emit(_doc_id)
