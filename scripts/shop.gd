extends Control

# The shop on the first night, first person: four rooms you walk between with
# arrows (story/spots.cfg, scene "shop_night"): the floor, where you come in;
# the counter, where the phone rings the first time you get there; the
# hallway; and the office, where the letter waits. A room's enter_<room>
# section plays when you walk in. Until the letter's read, everything else
# points you back to the office (the story says how). The stairs, after it,
# lead up to the apartment.

const STORY_PATH: String = "res://story/shop.txt"
const APARTMENT_SCENE: String = "res://scenes/apartment.tscn"
const SCENE_ID: String = "shop_night"
const VIEW_FADE: float = 0.25

@onready var narrator: DialogueColumn = %Narrator
@onready var art: Control = %ShopArt
@onready var hotspots: HotspotLayer = %Hotspots
@onready var document_viewer: DocumentViewer = %DocumentViewer
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

var _room: String = "floor"
var _busy: bool = true
var _leaving: bool = false
# Things looked at in this room; they stay done until you walk out and back.
var _looked: Array[String] = []

func _ready() -> void:
	document_viewer.closed.connect(_on_document_closed)
	narrator.use_sounds(sounds)
	narrator.line_shown.connect(_on_line_shown)
	narrator.choice_made.connect(_on_choice_made)
	narrator.section_finished.connect(_on_section_finished)
	narrator.load_story(STORY_PATH)
	hotspots.spot_clicked.connect(click)
	art.view = _room
	_refresh()
	hotspots.interactive = false
	narrator.set_input_enabled(false)
	await Transition.fade_in(2.0)
	narrator.set_input_enabled(true)
	narrator.play("arrival")

# --- Public: what tests can use ---

func current_room() -> String:
	return _room

# Clicking a hotspot: walk somewhere, or look at something.
func click(spot_id: String) -> void:
	if _busy or _leaving:
		return
	var sound: String = Spots.sound(spot_id)
	if sound != "":
		narrator.play_sound(sound)
	var room: String = Spots.go(spot_id)
	if room != "":
		walk(room)
		return
	var section: String = Spots.section(spot_id)
	if section.begins_with("look_"):
		_looked.append(spot_id)
		hotspots.mark_used(spot_id)
	_busy = true
	hotspots.interactive = false
	narrator.start_conversation(section)

func walk(room: String) -> void:
	_busy = true
	hotspots.interactive = false
	await _show_room(room)
	var enter: String = "enter_" + room
	if narrator.has_section(enter):
		narrator.start_conversation(enter)
	else:
		_ready_to_move()

# --- Private: the machinery ---

func _show_room(room: String) -> void:
	var fade: Tween = create_tween()
	fade.tween_property(self, "modulate", Color(0.15, 0.15, 0.15), VIEW_FADE)
	await fade.finished
	_room = room
	_looked.clear()
	art.view = room
	_refresh()
	fade = create_tween()
	fade.tween_property(self, "modulate", Color.WHITE, VIEW_FADE)

# The hotspots that belong in this room right now (flags change what's there).
func _refresh() -> void:
	hotspots.fill(SCENE_ID, _room, narrator)
	for spot_id in _looked:
		hotspots.mark_used(spot_id)

func _ready_to_move() -> void:
	_refresh()
	_busy = false
	hotspots.interactive = true

# The story has nowhere left to go.
func _on_section_finished(section: String) -> void:
	match section:
		"office":
			await _show_room("office")
			_ready_to_move()
		"stairs_up":
			_go_upstairs()
		_:
			_ready_to_move()

func _on_choice_made(choice: Dictionary) -> void:
	match choice["target"]:
		"dead_line":
			_pick_up()
		"let_it_ring":
			GameState.answered_phone = false
		"after_call":
			sounds["deadline"].stop()
			sounds["hangup"].play()
		"@open_letter":
			_open_envelope()

func _pick_up() -> void:
	GameState.answered_phone = true
	sounds["ring"].stop()
	sounds["pickup"].play()
	# Hold the text until the pick-up sound ends.
	narrator.set_input_enabled(false)
	await _wait(_length_of("pickup"))
	narrator.set_input_enabled(true)

func _on_line_shown(line: Dictionary) -> void:
	if line.has("light"):
		art.flash()

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
	narrator.stop_sound("all")
	narrator.set_input_enabled(false)
	document_viewer.open("letter")

func _on_document_closed(_doc_id: String) -> void:
	narrator.set_input_enabled(true)
	narrator.play("after_letter")

func _go_upstairs() -> void:
	_leaving = true
	narrator.set_input_enabled(false)
	hotspots.interactive = false
	create_tween().tween_property(shop_hum, "volume_db", -80.0, 1.5)
	Transition.go_to(APARTMENT_SCENE, 1.5, 0.5)
