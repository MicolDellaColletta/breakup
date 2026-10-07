extends Control

const STORY_PATH: String = "res://story/apartment.txt"

@onready var narrator: Narrator = %Narrator
@onready var objects: HBoxContainer = %Objects
@onready var window_button: Button = %WindowButton
@onready var radio_button: Button = %RadioButton
@onready var calendar_button: Button = %CalendarButton
@onready var bed_button: Button = %BedButton
@onready var mirror_button: Button = %MirrorButton
@onready var coat_button: Button = %CoatButton
@onready var radio_night: AudioStreamPlayer = %RadioNight

var _decided: Array[String] = []

func _ready() -> void:
	objects.visible = false
	bed_button.visible = false
	window_button.pressed.connect(_examine.bind("window", window_button))
	radio_button.pressed.connect(_examine.bind("radio", radio_button))
	calendar_button.pressed.connect(_examine.bind("calendar", calendar_button))
	mirror_button.pressed.connect(_examine.bind("mirror", mirror_button))
	coat_button.pressed.connect(_examine.bind("coat", coat_button))
	bed_button.pressed.connect(_on_bed_pressed)
	narrator.section_finished.connect(_on_section_finished)
	narrator.choice_made.connect(_on_choice_made)
	narrator.load_story(STORY_PATH)
	narrator.set_input_enabled(false)
	await Transition.fade_in(1.5)
	narrator.set_input_enabled(true)
	narrator.play("arrival")

func _on_section_finished(section: String) -> void:
	match section:
		"arrival":
			var echo: String = "echo_answered" if GameState.answered_phone else "echo_ignored"
			narrator.play(echo)
		"sleep":
			var wake: String = "wake_standing" if GameState.rules_broken.size() >= 2 else "wake_bed"
			narrator.play(wake)
		"wake_bed", "wake_standing":
			_end_night()
		_:
			objects.visible = true

func _examine(object_id: String, button: Button) -> void:
	button.disabled = true
	objects.visible = false
	narrator.play(object_id)

func _on_choice_made(choice: Dictionary) -> void:
	_decided.append(choice["from"])
	if choice["target"] == "radio_on":
		radio_night.play()
	_check_bed()

func _check_bed() -> void:
	if _decided.has("window") and _decided.has("radio"):
		bed_button.visible = true

func _on_bed_pressed() -> void:
	objects.visible = false
	narrator.play("sleep")

func _end_night() -> void:
	narrator.set_input_enabled(false)
	create_tween().tween_property(radio_night, "volume_db", -80.0, 2.0)
	await Transition.fade_out(2.0)
	print("End of the first night. Prologue complete!")
