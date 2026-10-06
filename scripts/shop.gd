extends Control

const STORY_PATH: String = "res://story/shop.txt"
const LETTER_PATH: String = "res://story/letter.txt"
const APARTMENT_SCENE: String = "res://scenes/apartment.tscn"

@onready var narrator: Narrator = %Narrator
@onready var letter_panel: ColorRect = %LetterPanel
@onready var letter_text: Label = %LetterText
@onready var fold_button: Button = %FoldButton
@onready var hang_up_button: Button = %HangUpButton
@onready var phone_choices: HBoxContainer = %PhoneChoices
@onready var pick_up_button: Button = %PickUpButton
@onready var let_it_ring_button: Button = %LetItRingButton
@onready var fade: ColorRect = %Fade
@onready var shop_hum: AudioStreamPlayer = %ShopHum
@onready var action_button: Button = %ActionButton
var _action: Callable

@onready var sounds: Dictionary = {
	"ring": %PhoneRing,
	"pickup": %PhonePickup,
	"hangup": %PhoneHangup,
	"deadline": %DeadLine,
	"bell": %DoorBell,
	"paper": %PaperSound,
	"tear": %EnvelopeTear,
}

func _ready() -> void:
	letter_panel.visible = false
	hang_up_button.visible = false
	phone_choices.visible = false
	action_button.visible = false
	action_button.pressed.connect(_on_action_pressed)
	letter_text.text = _read_letter(LETTER_PATH)
	fold_button.pressed.connect(_on_fold_pressed)
	hang_up_button.pressed.connect(_on_hang_up_pressed)
	pick_up_button.pressed.connect(_on_pick_up_pressed)
	let_it_ring_button.pressed.connect(_on_let_it_ring_pressed)
	narrator.line_shown.connect(_on_line_shown)
	narrator.section_finished.connect(_on_section_finished)
	narrator.load_story(STORY_PATH)
	narrator.set_input_enabled(false)
	fade.modulate.a = 1.0
	var tween: Tween = create_tween()
	tween.tween_property(fade, "modulate:a", 0.0, 2.0)
	await tween.finished
	narrator.set_input_enabled(true)
	narrator.play("arrival")

func _read_letter(path: String) -> String:
	var text: String = FileAccess.get_file_as_string(path)
	if text == "":
		push_error("Could not read the letter: " + path)
	return text

func _on_section_finished(section: String) -> void:
	match section:
		"arrival":
			narrator.set_input_enabled(false)
			phone_choices.visible = true
		"dead_line":
			narrator.set_input_enabled(false)
			hang_up_button.visible = true
		"after_call", "let_it_ring":
			narrator.play("envelope")
		"envelope":
			_prompt("Take the envelope", _take_envelope)
		"envelope_held":
			_prompt("Open it", _open_envelope)
		"after_letter_answered", "after_letter_ignored":
			_go_upstairs()

func _on_pick_up_pressed() -> void:
	GameState.answered_phone = true
	GameState.break_rule("phone")
	phone_choices.visible = false
	sounds["ring"].stop()
	sounds["pickup"].play()
	narrator.play("dead_line")
	await _wait(_length_of("pickup"))
	sounds["deadline"].play()
	narrator.set_input_enabled(true)

func _on_let_it_ring_pressed() -> void:
	GameState.answered_phone = false
	phone_choices.visible = false
	narrator.set_input_enabled(true)
	narrator.play("let_it_ring")

func _on_hang_up_pressed() -> void:
	hang_up_button.visible = false
	sounds["deadline"].stop()
	sounds["hangup"].play()
	await _wait(_length_of("hangup"))
	narrator.set_input_enabled(true)
	narrator.play("after_call")

func _on_line_shown(line: Dictionary) -> void:
	if line.has("stop"):
		_stop_sound(line["stop"])
	if line.has("sound"):
		_play_sound(line["sound"])

func _play_sound(sound_name: String) -> void:
	if not sounds.has(sound_name):
		push_warning("Unknown sound: " + sound_name)
		return
	sounds[sound_name].play()

func _stop_sound(sound_name: String) -> void:
	if sound_name == "all":
		for player in sounds.values():
			player.stop()
		return
	if not sounds.has(sound_name):
		push_warning("Unknown sound: " + sound_name)
		return
	sounds[sound_name].stop()

func _wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout

func _length_of(sound_name: String) -> float:
	var player: AudioStreamPlayer = sounds[sound_name]
	if player.stream == null:
		push_warning("No sound file in: " + sound_name)
		return 0.0
	return player.stream.get_length()

func _prompt(label: String, action: Callable) -> void:
	_action = action
	action_button.text = label
	narrator.set_input_enabled(false)
	action_button.visible = true

func _on_action_pressed() -> void:
	action_button.visible = false
	_action.call()

func _take_envelope() -> void:
	sounds["paper"].play()
	narrator.set_input_enabled(true)
	narrator.play("envelope_held")

func _open_envelope() -> void:
	sounds["tear"].play()
	await _wait(_length_of("tear"))
	_open_letter()

func _open_letter() -> void:
	_stop_sound("all")
	sounds["paper"].play()
	narrator.set_input_enabled(false)
	letter_panel.visible = true

func _on_fold_pressed() -> void:
	sounds["paper"].play()
	letter_panel.visible = false
	narrator.set_input_enabled(true)
	var reaction: String = "after_letter_answered" if GameState.answered_phone else "after_letter_ignored"
	narrator.play(reaction)
	
func _go_upstairs() -> void:
	narrator.set_input_enabled(false)
	var tween: Tween = create_tween()
	tween.tween_property(fade, "modulate:a", 1.0, 1.5)
	tween.parallel().tween_property(shop_hum, "volume_db", -80.0, 1.5)
	await tween.finished
	await _wait(0.5)
	get_tree().change_scene_to_file(APARTMENT_SCENE)
