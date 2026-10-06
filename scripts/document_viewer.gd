class_name DocumentViewer
extends Control

signal closed(doc_id: String)

const DOCUMENTS_PATH: String = "res://story/documents/"

@onready var title_label: Label = %TitleLabel
@onready var body_label: Label = %BodyLabel
@onready var close_button: Button = %CloseButton
@onready var paper_sound: AudioStreamPlayer = %PaperSound

var _doc_id: String = ""

func _ready() -> void:
	visible = false
	close_button.pressed.connect(_on_close_pressed)

func open(doc_id: String) -> void:
	var path: String = DOCUMENTS_PATH + doc_id + ".txt"
	var text: String = FileAccess.get_file_as_string(path)
	if text == "":
		push_error("Could not read document: " + path)
		return
	var parts: PackedStringArray = text.split("\n", true, 1)
	title_label.text = parts[0].strip_edges()
	body_label.text = parts[1].strip_edges() if parts.size() > 1 else ""
	_doc_id = doc_id
	GameState.add_evidence(doc_id)
	paper_sound.play()
	visible = true

func _on_close_pressed() -> void:
	paper_sound.play()
	visible = false
	closed.emit(_doc_id)
