extends Control

# The apartment at night, after the shop has closed and the evening is over:
# the rules (radio, the dog, the windows, the back door), then bed, and
# whatever wakes you. Each day's night has its own story file.

const STORIES: Dictionary = {
	1: "res://story/night_one.txt",
}
const TITLE_SCENE: String = "res://scenes/title.tscn"

@onready var narrator: DialogueColumn = %Narrator
@onready var objects: HBoxContainer = %Objects
@onready var radio_button: Button = %RadioButton
@onready var kitchen_button: Button = %KitchenButton
@onready var windows_button: Button = %WindowsButton
@onready var back_door_button: Button = %BackDoorButton
@onready var bed_button: Button = %BedButton
@onready var radio_night: AudioStreamPlayer = %RadioNight
@onready var wind: AudioStreamPlayer = %Wind

@onready var sounds: Dictionary = {
	"stairs": %Stairs,
	"floorboards": %Floorboards,
	"door_shut": %DoorShut,
}

func _ready() -> void:
	# Tonight's bowl starts empty, whatever happened last night.
	GameState.fed_dog = false
	objects.visible = false
	radio_button.pressed.connect(_examine.bind("radio", radio_button))
	kitchen_button.pressed.connect(_examine.bind("kitchen", kitchen_button))
	windows_button.pressed.connect(_examine.bind("windows", windows_button))
	back_door_button.pressed.connect(_examine.bind("back_door", back_door_button))
	bed_button.pressed.connect(_on_bed_pressed)
	narrator.use_sounds(sounds)
	narrator.section_finished.connect(_on_section_finished)
	narrator.choice_made.connect(_on_choice_made)
	narrator.load_story(STORIES.get(GameState.day, STORIES[1]))
	narrator.set_input_enabled(false)
	await Transition.fade_in(1.5)
	narrator.set_input_enabled(true)
	narrator.play("arrival")

# The story has nowhere left to go: back to the apartment, or the night is over.
func _on_section_finished(section: String) -> void:
	if section == "morning_after":
		_end_of_day()
	else:
		objects.visible = true

func _examine(object_id: String, button: Button) -> void:
	button.disabled = true
	objects.visible = false
	narrator.start_conversation(object_id)

func _on_choice_made(choice: Dictionary) -> void:
	if choice["target"] == "radio_on":
		radio_night.play()

func _on_bed_pressed() -> void:
	objects.visible = false
	narrator.start_conversation("sleep")

# Day two isn't written yet: the night ends on the title screen.
func _end_of_day() -> void:
	narrator.set_input_enabled(false)
	var tween: Tween = create_tween().set_parallel()
	tween.tween_property(radio_night, "volume_db", -80.0, 3.0)
	tween.tween_property(wind, "volume_db", -80.0, 3.0)
	GameState.day = 2
	Transition.go_to(TITLE_SCENE, 3.0, 1.0)
