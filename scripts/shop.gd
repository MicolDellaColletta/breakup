extends Control

const STORY_PATH: String = "res://story/shop.txt"
const LETTER_PATH: String = "res://story/documents/letter.txt"
const APARTMENT_SCENE: String = "res://scenes/apartment.tscn"

const LIGHTS: Dictionary = {
	"office": Color(0.17, 0.14, 0.09),
}
const LIGHT_FLASH: Color = Color(0.55, 0.5, 0.4)

@onready var narrator: Narrator = %Narrator
@onready var letter_panel: ColorRect = %LetterPanel
@onready var letter_text: Label = %LetterText
@onready var fold_button: Button = %FoldButton
@onready var background: ColorRect = $Background
@onready var shop_hum: AudioStreamPlayer = %ShopHum

@onready var sounds: Dictionary = {
	"ring": %PhoneRing,
	"pickup": %PhonePickup,
	"hangup": %PhoneHangup,
	"deadline": %DeadLine,
	"bell": %DoorBell,
	"paper": %PaperSound,
	"tear": %EnvelopeTear,
	"door_shut": %DoorShut,
	"floorboards": %Floorboards,
	"knock": %Knock,
	"knock_back": %KnockBack,
}

func _ready() -> void:
	letter_panel.visible = false
	letter_text.text = _read_letter(LETTER_PATH)
	fold_button.pressed.connect(_on_fold_pressed)
	narrator.use_sounds(sounds)
	narrator.line_shown.connect(_on_line_shown)
	narrator.choice_made.connect(_on_choice_made)
	narrator.load_story(STORY_PATH)
	narrator.set_input_enabled(false)
	await Transition.fade_in(2.0)
	narrator.set_input_enabled(true)
	narrator.play("arrival")

# The first line of a document is its title; the letter panel only shows the body.
func _read_letter(path: String) -> String:
	var text: String = FileAccess.get_file_as_string(path)
	if text == "":
		push_error("Could not read the letter: " + path)
		return text
	var parts: PackedStringArray = text.split("\n", true, 1)
	return parts[1].strip_edges() if parts.size() > 1 else ""

# The story file decides where each choice leads; this only adds the sounds.
func _on_choice_made(choice: Dictionary) -> void:
	match choice["target"]:
		"dead_line":
			_pick_up()
		"let_it_ring":
			GameState.answered_phone = false
		"after_call":
			sounds["deadline"].stop()
			sounds["hangup"].play()
		"envelope_held":
			sounds["paper"].play()
		"@open_letter":
			_open_envelope()
		"@go_upstairs":
			_go_upstairs()

func _pick_up() -> void:
	GameState.answered_phone = true
	sounds["ring"].stop()
	sounds["pickup"].play()
	# Hold the text until the pick-up sound ends. No tone after it: the line is
	# open, and someone is on it (Daniel; see docs/story.md).
	narrator.set_input_enabled(false)
	await _wait(_length_of("pickup"))
	narrator.set_input_enabled(true)

func _on_line_shown(line: Dictionary) -> void:
	if line.has("light"):
		_set_light(line["light"])

func _set_light(light_name: String) -> void:
	if not LIGHTS.has(light_name):
		push_warning("Unknown light: " + light_name)
		return
	# A quick glare, then the eyes adjust to the room's light.
	background.color = LIGHT_FLASH
	var tween: Tween = create_tween()
	tween.tween_property(background, "color", LIGHTS[light_name], 1.2)

func _wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout

func _length_of(sound_name: String) -> float:
	var player: AudioStreamPlayer = sounds[sound_name]
	if player.stream == null:
		push_warning("No sound file in: " + sound_name)
		return 0.0
	return player.stream.get_length()

func _open_envelope() -> void:
	sounds["tear"].play()
	await _wait(_length_of("tear"))
	_open_letter()

func _open_letter() -> void:
	narrator.stop_sound("all")
	sounds["paper"].play()
	GameState.add_item("letter")
	narrator.set_input_enabled(false)
	letter_panel.visible = true

func _on_fold_pressed() -> void:
	sounds["paper"].play()
	letter_panel.visible = false
	narrator.set_input_enabled(true)
	narrator.play("after_letter")
	
func _go_upstairs() -> void:
	narrator.set_input_enabled(false)
	create_tween().tween_property(shop_hum, "volume_db", -80.0, 1.5)
	Transition.go_to(APARTMENT_SCENE, 1.5, 0.5)
