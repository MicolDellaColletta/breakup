class_name HotspotLayer
extends Control

# The clickable things in one room, laid over its picture. Reads them from
# story/spots.cfg (rect= says where, as fractions of the screen), so moving a
# hotspot is a text edit. Hold Tab to see everything clickable.

signal spot_clicked(spot_id: String)

var _spots: Dictionary = {}
# False while the story is talking: hotspots stay on screen but don't react.
var interactive: bool = true:
	set(value):
		interactive = value
		for spot in _spots.values():
			spot.mouse_filter = Control.MOUSE_FILTER_STOP if value else Control.MOUSE_FILTER_IGNORE
			if not value:
				spot._hovered = false
				spot.queue_redraw()

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	resized.connect(_place_all)

func _process(_delta: float) -> void:
	var showing: bool = interactive and Input.is_key_pressed(KEY_TAB)
	for spot in _spots.values():
		spot.show_all = showing and spot.visible

# --- Public: what scenes can use ---

# Makes a hotspot for every spot in this scene and room whose condition holds.
# Spots marked hidden=true start invisible (show them with set_shown).
func fill(scene: String, room: String, narrator: Narrator) -> void:
	for old in get_children():
		remove_child(old)
		old.queue_free()
	_spots.clear()
	for spot_id in Spots.in_room(scene, room, narrator):
		var spot: Hotspot = Hotspot.new()
		spot.name = spot_id
		spot.spot_id = spot_id
		spot.label_text = Spots.label(spot_id)
		spot.visible = not Spots.starts_hidden(spot_id)
		spot.clicked.connect(_on_clicked)
		add_child(spot)
		_spots[spot_id] = spot
	_place_all()
	interactive = interactive

func get_spot(spot_id: String) -> Hotspot:
	return _spots.get(spot_id)

func spot_ids() -> Array:
	return _spots.keys()

func set_shown(spot_id: String, shown: bool) -> void:
	if _spots.has(spot_id):
		_spots[spot_id].visible = shown

func mark_used(spot_id: String) -> void:
	if _spots.has(spot_id):
		_spots[spot_id].used = true

# --- Private ---

func _on_clicked(spot_id: String) -> void:
	if interactive:
		spot_clicked.emit(spot_id)

func _place_all() -> void:
	for spot_id in _spots:
		var r: Rect2 = Spots.rect(spot_id)
		_spots[spot_id].position = r.position * size
		_spots[spot_id].size = r.size * size
