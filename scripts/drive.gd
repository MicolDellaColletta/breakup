extends Control

const STORY_PATH: String = "res://story/drive.txt"
const SHOP_SCENE: String = "res://scenes/shop.tscn"
const MANDATORY: Array[String] = ["radio", "glovebox", "mirror"]

const STATIC_LEVELS: Dictionary = {
	"silent": -80.0,
	"normal": -18.0,
	"loud": -6.0,
}

@onready var narrator: Narrator = $Narrator
@onready var objects: HBoxContainer = $Objects
@onready var radio_button: Button = $Objects/RadioButton
@onready var glovebox_button: Button = $Objects/GloveboxButton
@onready var mirror_button: Button = $Objects/MirrorButton
@onready var passenger_button: Button = $Objects/PassengerButton
@onready var wheel_button: Button = $Objects/WheelButton
@onready var radio_static: AudioStreamPlayer = $RadioStatic
@onready var car_interior: AudioStreamPlayer = $CarInterior
@onready var fade: ColorRect = $Fade
@onready var document_viewer: DocumentViewer = %DocumentViewer

var _examining: bool = false
var _main_index: int = 0
var _static_tween: Tween
var _examined: Array[String] = []
var _main_finished: bool = false
var _ending: bool = false
var _arriving: bool = false

func _ready() -> void:
	radio_button.pressed.connect(_examine.bind("radio", radio_button))
	glovebox_button.pressed.connect(_examine.bind("glovebox", glovebox_button))
	mirror_button.pressed.connect(_examine.bind("mirror", mirror_button))
	passenger_button.pressed.connect(_examine.bind("passenger", passenger_button))
	document_viewer.closed.connect(_on_document_closed)
	wheel_button.pressed.connect(_on_wheel_pressed)
	wheel_button.visible = false
	narrator.line_shown.connect(_on_line_shown)
	narrator.section_finished.connect(_on_section_finished)
	narrator.load_story(STORY_PATH)
	narrator.set_input_enabled(false)
	objects.visible = false
	fade.modulate.a = 1.0
	var tween: Tween = create_tween()
	tween.tween_property(fade, "modulate:a", 0.0, 2.0)
	await tween.finished
	objects.visible = true
	narrator.set_input_enabled(true)
	narrator.play("main")

func _on_line_shown(line: Dictionary) -> void:
	if line.has("static"):
		_set_static(line["static"])

func _on_section_finished(section: String) -> void:
	if section == "main":
		_main_finished = true
		_check_wheel()
	elif section == "wheel":
		_arrive()
	elif section == "glovebox":
		narrator.set_input_enabled(false)
		document_viewer.open("rental_agreement")
	else:
		_return_to_main()

func _on_document_closed(_doc_id: String) -> void:
	narrator.set_input_enabled(true)
	_return_to_main()

func _return_to_main() -> void:
	_examining = false
	narrator.play("main", _main_index, true)
	_check_wheel()

func _examine(object_id: String, button: Button) -> void:
	if _examining or _ending:
		return
	button.disabled = true
	_examining = true
	_examined.append(object_id)
	_main_index = narrator.get_line_index()
	narrator.play(object_id)

func _on_wheel_pressed() -> void:
	if _examining:
		return
	_ending = true
	objects.visible = false
	narrator.play("wheel")

func _check_wheel() -> void:
	if not _main_finished:
		return
	for object_id in MANDATORY:
		if not _examined.has(object_id):
			return
	wheel_button.visible = true

func _set_static(level: String) -> void:
	var target_db: float = STATIC_LEVELS[level]
	var duration: float = 0.05 if level == "silent" else 0.6
	if _static_tween:
		_static_tween.kill()
	_static_tween = create_tween()
	_static_tween.tween_property(radio_static, "volume_db", target_db, duration)

func _arrive() -> void:
	if _arriving:
		return
	_arriving = true
	narrator.set_input_enabled(false)
	if _static_tween:
		_static_tween.kill()
	var tween: Tween = create_tween()
	tween.tween_property(fade, "modulate:a", 1.0, 2.0)
	tween.parallel().tween_property(car_interior, "volume_db", -80.0, 2.0)
	tween.parallel().tween_property(radio_static, "volume_db", -80.0, 2.0)
	tween.tween_interval(1.0)
	tween.tween_callback(_go_to_shop)

func _go_to_shop() -> void:
	get_tree().change_scene_to_file(SHOP_SCENE)
