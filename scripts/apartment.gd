extends Control

const STORY_PATH: String = "res://story/apartment.txt"

const CHOICES: Dictionary = {
	"window": ["Close it", "Leave it open"],
	"radio": ["Turn it on", "Leave it off"],
}

@onready var narrator: Narrator = %Narrator
@onready var fade: ColorRect = %Fade
@onready var objects: HBoxContainer = %Objects
@onready var window_button: Button = %WindowButton
@onready var radio_button: Button = %RadioButton
@onready var calendar_button: Button = %CalendarButton
@onready var bed_button: Button = %BedButton
@onready var mirror_button: Button = %MirrorButton
@onready var coat_button: Button = %CoatButton
@onready var choice_box: HBoxContainer = %ChoiceBox
@onready var choice_a: Button = %ChoiceA
@onready var choice_b: Button = %ChoiceB
@onready var radio_night: AudioStreamPlayer = %RadioNight

var _pending_choice: String = ""
var _decided: Array[String] = []

func _ready() -> void:
	objects.visible = false
	choice_box.visible = false
	bed_button.visible = false
	window_button.pressed.connect(_examine.bind("window", window_button))
	radio_button.pressed.connect(_examine.bind("radio", radio_button))
	calendar_button.pressed.connect(_examine.bind("calendar", calendar_button))
	mirror_button.pressed.connect(_examine.bind("mirror", mirror_button))
	coat_button.pressed.connect(_examine.bind("coat", coat_button))
	bed_button.pressed.connect(_on_bed_pressed)
	choice_a.pressed.connect(_on_choice.bind(0))
	choice_b.pressed.connect(_on_choice.bind(1))
	narrator.section_finished.connect(_on_section_finished)
	narrator.load_story(STORY_PATH)
	narrator.set_input_enabled(false)
	fade.color = Color.BLACK
	fade.visible = true
	fade.modulate.a = 1.0
	var tween: Tween = create_tween()
	tween.tween_property(fade, "modulate:a", 0.0, 1.5)
	await tween.finished
	narrator.set_input_enabled(true)
	narrator.play("arrival")

func _on_section_finished(section: String) -> void:
	match section:
		"arrival":
			var echo: String = "echo_answered" if GameState.answered_phone else "echo_ignored"
			narrator.play(echo)
		"window", "radio":
			_offer_choice(section)
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

func _offer_choice(choice_id: String) -> void:
	_pending_choice = choice_id
	var labels: Array = CHOICES[choice_id]
	choice_a.text = labels[0]
	choice_b.text = labels[1]
	narrator.set_input_enabled(false)
	choice_box.visible = true

func _on_choice(index: int) -> void:
	choice_box.visible = false
	narrator.set_input_enabled(true)
	_decided.append(_pending_choice)
	match _pending_choice:
		"window":
			if index == 0:
				narrator.play("window_closed")
			else:
				GameState.break_rule("window")
				narrator.play("window_open")
		"radio":
			if index == 0:
				radio_night.play()
				narrator.play("radio_on")
			else:
				GameState.break_rule("radio")
				narrator.play("radio_off")
	_check_bed()

func _check_bed() -> void:
	if _decided.has("window") and _decided.has("radio"):
		bed_button.visible = true

func _on_bed_pressed() -> void:
	objects.visible = false
	narrator.play("sleep")

func _end_night() -> void:
	narrator.set_input_enabled(false)
	var tween: Tween = create_tween()
	tween.tween_property(fade, "modulate:a", 1.0, 2.0)
	tween.parallel().tween_property(radio_night, "volume_db", -80.0, 2.0)
	await tween.finished
	print("End of the first night. Prologue complete!")
