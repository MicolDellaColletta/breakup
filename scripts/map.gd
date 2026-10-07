extends Control

# The town map, in the evening after the shop closes. Places come from
# story/places.cfg; each visit costs travel time there and back, and plays
# that place's section from story/town.txt. "Go home" ends the evening and
# leads to the night (night.tscn).

const STORY_PATH: String = "res://story/town.txt"
const PLACES_PATH: String = "res://story/places.cfg"
const NIGHT_SCENE: String = "res://scenes/night.tscn"

@onready var column: DialogueColumn = %DialogueColumn
@onready var places_layer: Control = %Places
@onready var details: Label = %Details
@onready var home_button: Button = %HomeButton

var _places: ConfigFile = ConfigFile.new()
var _visited: Array[String] = []
var _away: String = ""
var _going_home: bool = false

func _ready() -> void:
	if _places.load(PLACES_PATH) != OK:
		push_error("Could not load places: " + PLACES_PATH)
	home_button.pressed.connect(_go_home)
	column.section_finished.connect(_on_section_finished)
	column.load_story(STORY_PATH)
	_hide_places()
	column.set_input_enabled(false)
	await Transition.fade_in(1.5)
	column.set_input_enabled(true)
	column.start_conversation("map_first")

# --- Public: what tests and other scenes can use ---

# The places on the map right now, by id.
func shown_places() -> Array:
	var out: Array = []
	for button in places_layer.get_children():
		if not button.is_queued_for_deletion():
			out.append(String(button.name))
	return out

func visit(place_id: String) -> void:
	_away = place_id
	_visited.append(place_id)
	if not GameState.visited.has(place_id):
		GameState.visited.append(place_id)
	_hide_places()
	GameState.pass_time(_travel(place_id))
	column.start_conversation(place_id)

# --- Private: the machinery ---

# The story has nowhere left to go: back to the map (after the trip home
# from wherever you were), or the evening is over.
func _on_section_finished(_section: String) -> void:
	if _going_home:
		Transition.go_to(NIGHT_SCENE, 1.5, 0.5)
		return
	if _away != "":
		GameState.pass_time(_travel(_away))
		_away = ""
	_show_places()

func _show_places() -> void:
	_hide_places()
	for place_id in _places.get_sections():
		if _visited.has(place_id):
			continue
		var condition: String = _places.get_value(place_id, "if", "")
		if condition != "" and not column._condition_met(condition):
			continue
		var button: Button = Button.new()
		button.name = place_id
		button.text = _places.get_value(place_id, "name")
		button.position = Vector2(
			float(_places.get_value(place_id, "x", 0.5)) * places_layer.size.x,
			float(_places.get_value(place_id, "y", 0.5)) * places_layer.size.y)
		button.pressed.connect(visit.bind(place_id))
		button.mouse_entered.connect(_describe.bind(place_id))
		places_layer.add_child(button)
	home_button.visible = true
	details.text = "It's %s. Where to?" % GameState.clock_text()

func _hide_places() -> void:
	# Out now, not at the end of the frame, so new buttons keep their names.
	for old in places_layer.get_children():
		places_layer.remove_child(old)
		old.queue_free()
	home_button.visible = false
	details.text = ""

func _describe(place_id: String) -> void:
	details.text = "%s  ·  %d minutes away\n%s" % [_places.get_value(place_id, "name"),
		_travel(place_id), _places.get_value(place_id, "description", "")]

func _travel(place_id: String) -> int:
	return int(_places.get_value(place_id, "travel", 0))

func _go_home() -> void:
	_going_home = true
	_hide_places()
	column.start_conversation("home")
