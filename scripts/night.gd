extends Control

# The apartment at night, after the shop has closed and the evening is over:
# the rules (radio, the dog, the windows, the back door), things to look at,
# then bed, and whatever wakes you. First person, three rooms you walk between
# with arrows (story/spots.cfg, scene "night"): the main room, the hall and
# the bedroom. When the phone rings downstairs and you go to it, the shop
# itself, in the dark: the hallway and the counter (SHOP_ROOMS). A line with
# show=bedroom (or another room) takes the picture back without walking.
# Each day's night has its own story file
# (GameState.NIGHT_STORIES). In the morning, the next day at the counter, or
# the title screen if that day isn't written yet.

const TITLE_SCENE: String = "res://scenes/title.tscn"
const COUNTER_SCENE: String = "res://scenes/counter.tscn"
const SCENE_ID: String = "night"
const USE_PATH: String = "res://story/use.txt"
const VIEW_FADE: float = 0.25
# Flags the picture shows (an open window, the radio's dial) that belong to a
# single night: cleared when the next one starts.
const TONIGHT_FLAGS: Array[String] = ["window_open", "radio_on", "tv_on"]
# Rooms downstairs, and the shop picture (shop_art.gd) each one shows.
const SHOP_ROOMS: Dictionary = {
	"shop_hall": "hallway",
	"shop_counter": "counter",
}

@onready var narrator: DialogueColumn = %Narrator
@onready var art: Control = %ApartmentArt
@onready var shop_art: Control = %ShopArt
@onready var hotspots: HotspotLayer = %Hotspots
@onready var radio_night: AudioStreamPlayer = %RadioNight
@onready var wind: AudioStreamPlayer = %Wind

@onready var sounds: Dictionary = {
	"stairs": %Stairs,
	"floorboards": %Floorboards,
	"door_shut": %DoorShut,
	"bell": %Bell,
	"ring": %PhoneRing,
	"pickup": %PhonePickup,
	"hangup": %PhoneHangup,
	"deadline": %DeadLine,
}

var _looked: Array[String] = []
var _room: String = "main"
var _busy: bool = true
var _ending: bool = false

func _ready() -> void:
	# Tonight's bowl starts empty and the back door starts as the old man left
	# it, whatever happened last night. (The morning already read last night's.)
	GameState.fed_dog = false
	GameState.locked_back_door = false
	for flag in TONIGHT_FLAGS:
		GameState.flags.erase(flag)
	art.view = _room
	hotspots.spot_clicked.connect(click)
	hotspots.aside.connect(play_aside)
	hotspots.interactive = false
	narrator.use_sounds(sounds)
	narrator.section_finished.connect(_on_section_finished)
	narrator.choice_made.connect(_on_choice_made)
	narrator.line_shown.connect(_on_line_shown)
	narrator.load_story(GameState.NIGHT_STORIES.get(GameState.day, GameState.NIGHT_STORIES[1]))
	narrator.add_story(USE_PATH)
	narrator.set_input_enabled(false)
	await Transition.fade_in(1.5)
	narrator.set_input_enabled(true)
	narrator.play("arrival")

# --- Public: what tests and other scenes can use ---

func current_room() -> String:
	return _room

# Clicking a hotspot: walk to another room, or look at something there.
func click(spot_id: String) -> void:
	if _busy or _ending:
		return
	var room: String = Spots.go(spot_id)
	if room != "":
		walk(room)
	else:
		look(spot_id)

# Plays what's there to see (tests use it directly, from any room). Each
# thing can be looked at once a night.
func look(spot_id: String) -> void:
	_looked.append(spot_id)
	hotspots.mark_used(spot_id)
	_busy = true
	hotspots.interactive = false
	narrator.start_conversation(Spots.section(spot_id))

# A short scene that changes nothing: something from your pockets used on a
# hotspot, or a second look (story/use.txt).
func play_aside(section: String) -> void:
	if _busy or _ending:
		return
	_busy = true
	hotspots.interactive = false
	narrator.start_conversation(section)

func walk(room: String) -> void:
	_busy = true
	hotspots.interactive = false
	narrator.play_sound("floorboards")
	var fade: Tween = create_tween()
	fade.tween_property(self, "modulate", Color(0.15, 0.15, 0.15), VIEW_FADE)
	await fade.finished
	_show_room(room)
	fade = create_tween()
	fade.tween_property(self, "modulate", Color.WHITE, VIEW_FADE)
	_show_spots()

# --- Private: the machinery ---

# The story has nowhere left to go: back to the room, or the night is over.
func _on_section_finished(section: String) -> void:
	if section == "morning_after":
		_end_of_day()
	elif section == "phone_go_down":
		# Down the stairs, toward the ringing.
		walk("shop_hall")
	else:
		_show_spots()

# show=bedroom: the picture changes to that room, with no walking.
func _on_line_shown(line: Dictionary) -> void:
	var room: String = line.get("show", "")
	if room == "" or room == _room:
		return
	var fade: Tween = create_tween()
	fade.tween_property(self, "modulate", Color(0.15, 0.15, 0.15), VIEW_FADE)
	await fade.finished
	_show_room(room)
	fade = create_tween()
	fade.tween_property(self, "modulate", Color.WHITE, VIEW_FADE)

# Upstairs rooms are the apartment's picture; downstairs, the shop's.
func _show_room(room: String) -> void:
	_room = room
	var downstairs: bool = SHOP_ROOMS.has(room)
	art.visible = not downstairs
	shop_art.visible = downstairs
	if downstairs:
		shop_art.view = SHOP_ROOMS[room]
	else:
		art.view = room

func _show_spots() -> void:
	hotspots.fill(SCENE_ID, _room, narrator)
	for spot_id in _looked:
		hotspots.mark_used(spot_id)
	_busy = false
	hotspots.interactive = true

func _on_choice_made(choice: Dictionary) -> void:
	if choice["target"] == "radio_on":
		radio_night.play()

# Morning: the next day at the counter, or the title screen when that day
# isn't written yet.
func _end_of_day() -> void:
	_ending = true
	hotspots.interactive = false
	narrator.set_input_enabled(false)
	var tween: Tween = create_tween().set_parallel()
	tween.tween_property(radio_night, "volume_db", -80.0, 3.0)
	tween.tween_property(wind, "volume_db", -80.0, 3.0)
	GameState.end_night()
	GameState.day += 1
	var next: String = COUNTER_SCENE if GameState.DAY_STORIES.has(GameState.day) else TITLE_SCENE
	Transition.go_to(next, 3.0, 1.0)
