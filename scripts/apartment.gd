extends Control

# The apartment on the first night, first person: four rooms you walk between
# with arrows (story/spots.cfg, scene "apartment_first"): the main room, the
# hall, the bathroom and the bedroom. The bed waits until you've dealt with
# the window and the radio (rules one and seven); then sleep, and morning.

const STORY_PATH: String = "res://story/apartment.txt"
const COUNTER_SCENE: String = "res://scenes/counter.tscn"
const SCENE_ID: String = "apartment_first"
const VIEW_FADE: float = 0.25

@onready var narrator: DialogueColumn = %Narrator
@onready var art: Control = %ApartmentArt
@onready var hotspots: HotspotLayer = %Hotspots
@onready var radio_night: AudioStreamPlayer = %RadioNight
@onready var wind: AudioStreamPlayer = %Wind

@onready var sounds: Dictionary = {
	"stairs": %Stairs,
	"chimes": %Chimes,
	"tv": %TVStatic,
	"floorboards": %Floorboards,
}

var _room: String = "main"
var _busy: bool = true
var _ending: bool = false
# Everything clicked tonight that stays done, in any room.
var _used: Array[String] = []

func _ready() -> void:
	narrator.use_sounds(sounds)
	narrator.section_finished.connect(_on_section_finished)
	narrator.choice_made.connect(_on_choice_made)
	narrator.load_story(STORY_PATH)
	hotspots.spot_clicked.connect(click)
	art.view = _room
	_refresh()
	hotspots.interactive = false
	narrator.set_input_enabled(false)
	await Transition.fade_in(1.5)
	narrator.set_input_enabled(true)
	narrator.play("arrival")

# --- Public: what tests can use ---

func current_room() -> String:
	return _room

func click(spot_id: String) -> void:
	if _busy or _ending:
		return
	var room: String = Spots.go(spot_id)
	if room != "":
		walk(room)
		return
	var sound: String = Spots.sound(spot_id)
	if sound != "":
		narrator.play_sound(sound)
	if not Spots.again(spot_id):
		_used.append(spot_id)
		hotspots.mark_used(spot_id)
	_busy = true
	hotspots.interactive = false
	narrator.start_conversation(Spots.section(spot_id))

func walk(room: String) -> void:
	_busy = true
	hotspots.interactive = false
	narrator.play_sound("floorboards")
	var fade: Tween = create_tween()
	fade.tween_property(self, "modulate", Color(0.15, 0.15, 0.15), VIEW_FADE)
	await fade.finished
	_room = room
	art.view = room
	fade = create_tween()
	fade.tween_property(self, "modulate", Color.WHITE, VIEW_FADE)
	_ready_to_move()

# --- Private: the machinery ---

func _refresh() -> void:
	hotspots.fill(SCENE_ID, _room, narrator)
	for spot_id in _used:
		hotspots.mark_used(spot_id)

func _ready_to_move() -> void:
	_refresh()
	_busy = false
	hotspots.interactive = true

func _on_section_finished(section: String) -> void:
	match section:
		"wake_bed", "wake_standing":
			_end_night()
		_:
			_ready_to_move()

func _on_choice_made(choice: Dictionary) -> void:
	if choice["target"] == "radio_on":
		radio_night.play()

func _end_night() -> void:
	_ending = true
	hotspots.interactive = false
	narrator.set_input_enabled(false)
	var tween: Tween = create_tween().set_parallel()
	tween.tween_property(radio_night, "volume_db", -80.0, 2.0)
	tween.tween_property(wind, "volume_db", -80.0, 2.0)
	GameState.day = 1
	Transition.go_to(COUNTER_SCENE, 2.0, 1.0)
