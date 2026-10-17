extends Control

# A day with no counter (Sunday), or a walked evening (GameState.EVENINGS:
# the first-ice party): first person, walking between places.
# The day's story (GameState.DAY_STORIES) moves you: a line with show=church
# changes the picture to that room; spots in story/spots.cfg (scene "visit")
# are what you can click there, or walk to (go=). A line with end=map ends the
# day when its section finishes, and the evening starts on the town map.
# Rooms come from three placeholder pictures: the apartment upstairs, the shop
# downstairs, and places in town (place_art.gd).

const USE_PATH: String = "res://story/use.txt"
const MAP_SCENE: String = "res://scenes/map.tscn"
const NIGHT_SCENE: String = "res://scenes/night.tscn"
# Where an ending goes when it's over (end=title).
const TITLE_SCENE: String = "res://scenes/title.tscn"
const SCENE_ID: String = "visit"
const VIEW_FADE: float = 0.25
# Each room, and which picture shows it: [picture, view].
const ROOMS: Dictionary = {
	"apartment": ["apartment", "main"],
	"shop": ["shop", "counter"],
	"church": ["place", "church"],
	"vestry": ["place", "vestry"],
	"hollis_kitchen": ["place", "hollis_kitchen"],
	"shore": ["place", "shore"],
	"far_ice": ["place", "far_ice"],
	"hall": ["place", "hall"],
	"stage": ["place", "stage"],
	"cabin": ["place", "cabin"],
	"cabin_road": ["place", "cabin_road"],
	"booth": ["place", "booth"],
	"gleaner": ["place", "gleaner"],
	"church_fire": ["place", "church_fire"],
	"vestry_door": ["place", "vestry_door"],
	"ruins": ["place", "ruins"],
	"daniel_room": ["place", "daniel_room"],
	"lake_1988": ["place", "lake_1988"],
	"ice_tripod": ["place", "ice_tripod"],
	"hall_cellar": ["place", "hall_cellar"],
	"town_line": ["place", "town_line"],
	"highway": ["place", "highway"],
	"shore_breakup": ["place", "shore_breakup"],
	"tent": ["place", "tent"],
}

@onready var narrator: DialogueColumn = %Narrator
@onready var apartment_art: Control = %ApartmentArt
@onready var shop_art: Control = %ShopArt
@onready var place_art: Control = %PlaceArt
@onready var hotspots: HotspotLayer = %Hotspots

@onready var sounds: Dictionary = {
	"stairs": %Stairs,
	"floorboards": %Floorboards,
	"bell": %Bell,
	"door_shut": %DoorShut,
}

var _room: String = "apartment"
var _fading_to: String = ""
var _busy: bool = true
var _ending: bool = false
var _leaving: bool = false
var _leaving_to: String = MAP_SCENE
# Everything clicked today that stays done, in any room.
var _used: Array[String] = []

func _ready() -> void:
	narrator.use_sounds(sounds)
	narrator.section_finished.connect(_on_section_finished)
	narrator.line_shown.connect(_on_line_shown)
	GameState.start_day()
	if GameState.is_walked_evening():
		narrator.load_story(GameState.EVENINGS[GameState.day])
	else:
		narrator.load_story(GameState.DAY_STORIES.get(GameState.day, GameState.DAY_STORIES[5]))
	narrator.add_story(USE_PATH)
	hotspots.spot_clicked.connect(click)
	hotspots.aside.connect(play_aside)
	hotspots.interactive = false
	if GameState.is_walked_evening():
		_room = GameState.EVENING_ROOMS.get(GameState.day, "shore")
	_show_room(_room)
	narrator.set_input_enabled(false)
	await Transition.fade_in(1.5)
	narrator.set_input_enabled(true)
	narrator.play("evening" if GameState.is_walked_evening() else "morning")

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

# A short scene that changes nothing (story/use.txt).
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
	await _fade_to(room)
	_ready_to_move()

# --- Private: the machinery ---

func _fade_to(room: String) -> void:
	# Two show= lines read quickly: the later room wins, whichever fade ends last.
	_fading_to = room
	var fade: Tween = create_tween()
	fade.tween_property(self, "modulate", Color(0.15, 0.15, 0.15), VIEW_FADE)
	await fade.finished
	if _fading_to == "":
		return
	_show_room(_fading_to)
	_fading_to = ""
	# The section may have ended during the fade and set out the last room's
	# spots: set out this one's.
	if not _busy and not _ending:
		_ready_to_move()
	fade = create_tween()
	fade.tween_property(self, "modulate", Color.WHITE, VIEW_FADE)

func _show_room(room: String) -> void:
	if not ROOMS.has(room):
		push_error("No room called: " + room)
		return
	_room = room
	var picture: String = ROOMS[room][0]
	apartment_art.visible = picture == "apartment"
	shop_art.visible = picture == "shop"
	place_art.visible = picture == "place"
	match picture:
		"apartment": apartment_art.view = ROOMS[room][1]
		"shop": shop_art.view = ROOMS[room][1]
		"place": place_art.view = ROOMS[room][1]
	hotspots.fill(SCENE_ID, "", narrator)

func _ready_to_move() -> void:
	hotspots.fill(SCENE_ID, _room, narrator)
	for spot_id in _used:
		hotspots.mark_used(spot_id)
	_busy = false
	hotspots.interactive = true

# show=church: the picture changes, with no walking. end=map: when this
# section is over, so is the day (end=night: so is a walked evening).
func _on_line_shown(line: Dictionary) -> void:
	if line.get("end", "") in ["map", "night", "title"]:
		_leaving = true
		match line["end"]:
			"map": _leaving_to = MAP_SCENE
			"night": _leaving_to = NIGHT_SCENE
			"title":
				_leaving_to = TITLE_SCENE
				if GameState.day >= GameState.LAST_DAY:
					Saves.mark_finished()
	var room: String = line.get("show", "")
	if room != "" and room != (_fading_to if _fading_to != "" else _room):
		_fade_to(room)

func _on_section_finished(_section: String) -> void:
	if _leaving:
		_ending = true
		hotspots.interactive = false
		narrator.set_input_enabled(false)
		Transition.go_to(_leaving_to, 1.5, 0.5)
		return
	_ready_to_move()
