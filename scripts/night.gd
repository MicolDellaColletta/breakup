extends Control

# The apartment at night, after the shop has closed and the evening is over:
# the rules (radio, the dog, the windows, the back door), things to look at,
# then bed, and whatever wakes you. What's in the room comes from
# story/spots.cfg; each day's night has its own story file.

const STORIES: Dictionary = {
	1: "res://story/night_one.txt",
}
const TITLE_SCENE: String = "res://scenes/title.tscn"
const ROOM: String = "apartment"

@onready var narrator: DialogueColumn = %Narrator
@onready var objects: HBoxContainer = %Objects
@onready var radio_night: AudioStreamPlayer = %RadioNight
@onready var wind: AudioStreamPlayer = %Wind

@onready var sounds: Dictionary = {
	"stairs": %Stairs,
	"floorboards": %Floorboards,
	"door_shut": %DoorShut,
	"bell": %Bell,
}

var _looked: Array[String] = []

func _ready() -> void:
	# Tonight's bowl starts empty, whatever happened last night.
	GameState.fed_dog = false
	objects.visible = false
	narrator.use_sounds(sounds)
	narrator.section_finished.connect(_on_section_finished)
	narrator.choice_made.connect(_on_choice_made)
	narrator.load_story(STORIES.get(GameState.day, STORIES[1]))
	narrator.set_input_enabled(false)
	await Transition.fade_in(1.5)
	narrator.set_input_enabled(true)
	narrator.play("arrival")

# --- Public: what tests and other scenes can use ---

func look(spot_id: String) -> void:
	_looked.append(spot_id)
	objects.visible = false
	narrator.start_conversation(Spots.section(spot_id))

# --- Private: the machinery ---

# The story has nowhere left to go: back to the room, or the night is over.
func _on_section_finished(section: String) -> void:
	if section == "morning_after":
		_end_of_day()
	else:
		_show_spots()

func _show_spots() -> void:
	# Out now, not at the end of the frame, so the new buttons keep their names.
	for old in objects.get_children():
		objects.remove_child(old)
		old.queue_free()
	for spot_id in Spots.in_room("night", ROOM, narrator):
		var button: Button = Button.new()
		button.name = spot_id
		button.text = Spots.label(spot_id)
		button.disabled = _looked.has(spot_id)
		button.pressed.connect(look.bind(spot_id))
		objects.add_child(button)
	objects.visible = true

func _on_choice_made(choice: Dictionary) -> void:
	if choice["target"] == "radio_on":
		radio_night.play()

# Day two isn't written yet: the night ends on the title screen.
func _end_of_day() -> void:
	narrator.set_input_enabled(false)
	var tween: Tween = create_tween().set_parallel()
	tween.tween_property(radio_night, "volume_db", -80.0, 3.0)
	tween.tween_property(wind, "volume_db", -80.0, 3.0)
	GameState.day = 2
	Transition.go_to(TITLE_SCENE, 3.0, 1.0)
