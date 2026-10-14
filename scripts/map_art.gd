@tool
extends Control

# Placeholder art for the town map, drawn in code until there's a painting:
# Kettle Lake from above, in the evening. The lake, the road in from the
# town line and the highway south, the lane up the hill to the church, the
# track round the shore to Sam's cabin, the trees, and a mark for every
# place in story/places.cfg (the buttons sit on top of them). Positions use
# the same 0 to 1 coordinates as places.cfg, over the Places box.

const PLACES_PATH: String = "res://story/places.cfg"
const LAND: Color = Color(0.085, 0.095, 0.11)
const SNOW: Color = Color(0.14, 0.15, 0.17)
const WATER: Color = Color(0.11, 0.15, 0.2)
const ICE_EDGE: Color = Color(0.32, 0.38, 0.45)
const ROAD: Color = Color(0.3, 0.29, 0.27)
const TRACK: Color = Color(0.25, 0.24, 0.22)
const TREE: Color = Color(0.05, 0.08, 0.07)
const ROOF: Color = Color(0.35, 0.3, 0.26)
const LIT: Color = Color(0.95, 0.75, 0.4)
const INK: Color = Color(0.6, 0.62, 0.66, 0.55)

# The shore, going round.
const LAKE: Array = [
	Vector2(0.24, 0.42), Vector2(0.36, 0.38), Vector2(0.5, 0.4), Vector2(0.6, 0.47),
	Vector2(0.63, 0.6), Vector2(0.57, 0.74), Vector2(0.45, 0.83), Vector2(0.3, 0.86),
	Vector2(0.15, 0.8), Vector2(0.08, 0.68), Vector2(0.12, 0.56), Vector2(0.17, 0.53),
]
# Roads, each a line of points: the main road from the town line into town,
# the highway south, the lane up to the church, the lake road, Ruth's street.
const ROADS: Array = [
	[Vector2(1.04, 0.66), Vector2(0.92, 0.62), Vector2(0.78, 0.52), Vector2(0.72, 0.4), Vector2(0.62, 0.24), Vector2(0.5, 0.2), Vector2(0.38, 0.22)],
	[Vector2(0.92, 0.62), Vector2(0.93, 0.78), Vector2(0.92, 0.86), Vector2(0.95, 1.08)],
	[Vector2(0.69, 0.33), Vector2(0.74, 0.31), Vector2(0.78, 0.3)],
	[Vector2(0.44, 0.21), Vector2(0.36, 0.28), Vector2(0.3, 0.34)],
	[Vector2(0.6, 0.21), Vector2(0.66, 0.18), Vector2(0.72, 0.16)],
]
# Sam's track round the north shore, out to the cabin.
const TRACK_POINTS: Array = [Vector2(0.3, 0.34), Vector2(0.22, 0.38), Vector2(0.17, 0.44), Vector2(0.18, 0.48)]
# Not a place you go in the evening, but on the map: the shop, across from
# the Gleaner.
const SHOP: Vector2 = Vector2(0.55, 0.19)

var _places: ConfigFile = ConfigFile.new()

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	_places.load(PLACES_PATH)
	resized.connect(queue_redraw)

# The box the places sit in, in this control's coordinates (the Places node
# beside this one, if it's there).
func _box() -> Rect2:
	var places: Control = get_parent().get_node_or_null("Places") as Control
	if places != null:
		return Rect2(places.position, places.size)
	return Rect2(Vector2(40, 100), size - Vector2(80, 240))

func _p(at: Vector2) -> Vector2:
	var box: Rect2 = _box()
	return box.position + at * box.size

func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, size), LAND)
	var box: Rect2 = _box()
	# Snow on open ground, in soft patches.
	for k in 14:
		var at: Vector2 = Vector2(fmod(k * 0.37, 1.0), fmod(k * 0.61 + 0.1, 1.0))
		draw_circle(_p(at), box.size.x * 0.07, Color(SNOW, 0.18))
	# The lake: the ice edge, then the water.
	var shore: PackedVector2Array = PackedVector2Array()
	for point in LAKE:
		shore.append(_p(point))
	var edge: PackedVector2Array = PackedVector2Array()
	var middle: Vector2 = _p(Vector2(0.36, 0.62))
	for point in shore:
		edge.append(point + (point - middle).normalized() * 6.0)
	draw_colored_polygon(edge, ICE_EDGE)
	draw_colored_polygon(shore, WATER)
	# The path of holes, out to the middle (they cut them for the Run).
	for k in 6:
		draw_circle(_p(Vector2(0.3, 0.38).lerp(Vector2(0.38, 0.62), k / 5.0)), 2.5, Color(0.05, 0.07, 0.1))
	draw_string(ThemeDB.fallback_font, _p(Vector2(0.27, 0.7)), "KETTLE LAKE", HORIZONTAL_ALIGNMENT_LEFT, -1, 15, Color(0.45, 0.55, 0.65, 0.5))
	# Trees: the forest round the edges, thick to the west and north.
	for k in 90:
		var at: Vector2 = Vector2(fmod(k * 0.618, 1.0), fmod(k * 0.381 + k * 0.013, 1.0))
		if Geometry2D.is_point_in_polygon(_p(at), edge) or _near_road(at):
			continue
		var t: Vector2 = _p(at)
		var s: float = 7.0 + fmod(k * 3.7, 5.0)
		draw_colored_polygon(PackedVector2Array([t + Vector2(0, -s), t + Vector2(s * 0.6, s * 0.5), t + Vector2(-s * 0.6, s * 0.5)]), TREE)
	# Roads and the track.
	for road in ROADS:
		var line: PackedVector2Array = PackedVector2Array()
		for point in road:
			line.append(_p(point))
		draw_polyline(line, ROAD, 5.0, true)
	var track: PackedVector2Array = PackedVector2Array()
	for point in TRACK_POINTS:
		track.append(_p(point))
	for k in track.size() - 1:
		draw_dashed_line(track[k], track[k + 1], TRACK, 2.0, 6.0)
	draw_string(ThemeDB.fallback_font, _p(Vector2(0.95, 0.98)), "to Anchorage", HORIZONTAL_ALIGNMENT_RIGHT, -1, 12, INK)
	# The shop, and every place: a small roof each, lit if anyone's home.
	_draw_building(_p(SHOP), 1.2, true)
	draw_string(ThemeDB.fallback_font, _p(SHOP) + Vector2(-16, 22), "the shop", HORIZONTAL_ALIGNMENT_LEFT, -1, 12, Color(0.85, 0.3, 0.3, 0.7))
	for place in _places.get_sections():
		if place in ["lake", "way_out", "town_line"]:
			continue
		var at: Vector2 = Vector2(float(_places.get_value(place, "x", 0.5)), float(_places.get_value(place, "y", 0.5)))
		_draw_building(_p(at) + Vector2(-14, 14), 1.4 if place == "church" else 1.0, true)
		if place == "church":
			draw_line(_p(at) + Vector2(-14, -3), _p(at) + Vector2(-14, -13), ROOF, 2.0)
			draw_line(_p(at) + Vector2(-18, -9), _p(at) + Vector2(-10, -9), ROOF, 2.0)
	# The sign at the town line.
	var line_at: Vector2 = _p(Vector2(0.92, 0.62)) + Vector2(14, -6)
	draw_line(line_at, line_at + Vector2(0, -14), ROOF, 2.0)
	draw_rect(Rect2(line_at + Vector2(-8, -22), Vector2(16, 8)), Color(0.6, 0.58, 0.5))

func _draw_building(at: Vector2, scale: float, lit: bool) -> void:
	var w: float = 14.0 * scale
	var h: float = 10.0 * scale
	draw_rect(Rect2(at - Vector2(w / 2, h / 2), Vector2(w, h)), Color(0.18, 0.16, 0.15))
	draw_colored_polygon(PackedVector2Array([at + Vector2(-w / 2 - 2, -h / 2), at + Vector2(0, -h / 2 - 7 * scale), at + Vector2(w / 2 + 2, -h / 2)]), ROOF)
	if lit:
		draw_rect(Rect2(at + Vector2(-w * 0.25, -h * 0.15), Vector2(w * 0.2, h * 0.3)), LIT)

func _near_road(at: Vector2) -> bool:
	for road in ROADS + [TRACK_POINTS]:
		for k in road.size() - 1:
			var closest: Vector2 = Geometry2D.get_closest_point_to_segment(at, road[k], road[k + 1])
			if closest.distance_to(at) < 0.035:
				return true
	for place in _places.get_sections():
		var spot: Vector2 = Vector2(float(_places.get_value(place, "x", 0.5)), float(_places.get_value(place, "y", 0.5)))
		if spot.distance_to(at) < 0.07:
			return true
	return SHOP.distance_to(at) < 0.06
