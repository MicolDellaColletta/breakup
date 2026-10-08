@tool
extends Control

# Placeholder art for the open glovebox, a close-up, drawn in code until
# there's a painting. Where things are drawn matches the "glovebox" hotspots
# in spots.cfg. Things you take out (the ticket, the papers) stop being drawn.

const SURROUND: Color = Color(0.03, 0.03, 0.035)
const INSIDE: Color = Color(0.075, 0.065, 0.06)
const INSIDE_DEEP: Color = Color(0.045, 0.04, 0.038)
const LID: Color = Color(0.1, 0.1, 0.11)
const LID_EDGE: Color = Color(0.16, 0.16, 0.17)
const BULB: Color = Color(1.0, 0.82, 0.5)
const NAPKIN: Color = Color(0.72, 0.7, 0.66)
const NAPKIN_SHADE: Color = Color(0.55, 0.53, 0.5)
const METAL: Color = Color(0.5, 0.52, 0.55)
const CARD: Color = Color(0.82, 0.76, 0.62)
const INK: Color = Color(0.2, 0.15, 0.12)
const PAPER: Color = Color(0.8, 0.77, 0.7)

var _time: float = 0.0

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE

func _process(delta: float) -> void:
	_time += delta
	queue_redraw()

func _p(x: float, y: float) -> Vector2:
	return Vector2(x * size.x, y * size.y)

func _poly(points: Array, color: Color) -> void:
	var packed: PackedVector2Array = PackedVector2Array()
	for point in points:
		packed.append(_p(point.x, point.y))
	draw_colored_polygon(packed, color)

func _has(item_id: String) -> bool:
	if Engine.is_editor_hint():
		return false
	return get_node("/root/GameState").has_item(item_id)

func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, size), SURROUND)
	# The box itself, deeper at the back.
	_poly([Vector2(0.08, 0.2), Vector2(0.92, 0.2), Vector2(0.92, 0.84), Vector2(0.08, 0.84)], INSIDE)
	_poly([Vector2(0.16, 0.24), Vector2(0.84, 0.24), Vector2(0.88, 0.8), Vector2(0.12, 0.8)], INSIDE_DEEP)
	_draw_bulb()
	_draw_napkins()
	_draw_gauge()
	if not _has("pawn_ticket"):
		_draw_ticket()
	if not _has("rental_agreement"):
		_draw_papers()
	# The lid, hanging open toward you.
	_poly([Vector2(0.06, 0.84), Vector2(0.94, 0.84), Vector2(0.99, 1.0), Vector2(0.01, 1.0)], LID)
	draw_line(_p(0.06, 0.84), _p(0.94, 0.84), LID_EDGE, 3.0)
	draw_line(_p(0.42, 0.92), _p(0.58, 0.92), LID_EDGE, 4.0)

func _draw_bulb() -> void:
	var at: Vector2 = _p(0.5, 0.23)
	var flicker: float = 0.85 + 0.15 * sin(_time * 13.0) * sin(_time * 4.3)
	for i in range(5, 0, -1):
		draw_circle(at, size.y * 0.05 * i, Color(BULB, 0.03 * flicker))
	draw_circle(at, 5, Color(BULB, 0.9 * flicker))

func _draw_napkins() -> void:
	var blobs: Array = [Vector2(0.2, 0.5), Vector2(0.27, 0.56), Vector2(0.19, 0.59), Vector2(0.28, 0.48)]
	for i in blobs.size():
		var c: Vector2 = _p(blobs[i].x, blobs[i].y)
		var points: PackedVector2Array = PackedVector2Array()
		for j in 16:
			var a: float = TAU * j / 16.0
			var r: float = size.y * (0.05 + 0.006 * sin(j * 2.7 + i) + 0.004 * sin(j * 5.1))
			points.append(c + Vector2(cos(a) * r * 1.2, sin(a) * r))
		draw_colored_polygon(points, NAPKIN if i % 2 == 0 else NAPKIN_SHADE)
		draw_line(c + Vector2(-10, -4), c + Vector2(8, 6), NAPKIN_SHADE, 1.5)

func _draw_gauge() -> void:
	var from: Vector2 = _p(0.38, 0.64)
	var to: Vector2 = _p(0.54, 0.58)
	draw_line(from, to, Color(0.02, 0.02, 0.02, 0.6), 9.0)
	draw_line(from, to, METAL, 6.0)
	draw_line(from, from.lerp(to, 0.18), Color(0.3, 0.31, 0.33), 7.0)
	draw_line(to, to + (to - from).normalized() * 10, Color(0.65, 0.66, 0.68), 3.0)

func _draw_ticket() -> void:
	var c: Vector2 = _p(0.67, 0.47)
	var half: Vector2 = Vector2(size.x * 0.045, size.y * 0.075)
	var tilt: Transform2D = Transform2D(-0.12, c)
	var corners: PackedVector2Array = PackedVector2Array([
		tilt * Vector2(-half.x, -half.y), tilt * Vector2(half.x, -half.y),
		tilt * Vector2(half.x, half.y), tilt * Vector2(-half.x, half.y)])
	draw_colored_polygon(corners, CARD)
	draw_circle(tilt * Vector2(0, -half.y * 0.75), 4, INSIDE_DEEP)
	draw_line(tilt * Vector2(0, -half.y * 0.75), tilt * Vector2(-half.x * 1.6, -half.y * 1.6), Color(0.6, 0.55, 0.45), 1.5)
	draw_set_transform_matrix(tilt)
	draw_string(ThemeDB.fallback_font, Vector2(-half.x * 0.8, 0), "0527", HORIZONTAL_ALIGNMENT_LEFT, -1, 15, INK)
	draw_string(ThemeDB.fallback_font, Vector2(-half.x * 0.8, half.y * 0.5), "PAWN", HORIZONTAL_ALIGNMENT_LEFT, -1, 11, Color(INK, 0.7))
	draw_set_transform_matrix(Transform2D.IDENTITY)

func _draw_papers() -> void:
	_poly([Vector2(0.44, 0.71), Vector2(0.72, 0.69), Vector2(0.73, 0.79), Vector2(0.45, 0.81)], Color(0.6, 0.58, 0.53))
	_poly([Vector2(0.45, 0.7), Vector2(0.71, 0.68), Vector2(0.72, 0.775), Vector2(0.46, 0.795)], PAPER)
	draw_line(_p(0.54, 0.69), _p(0.55, 0.79), Color(0.62, 0.6, 0.55), 1.5)
	draw_line(_p(0.63, 0.685), _p(0.64, 0.78), Color(0.62, 0.6, 0.55), 1.5)
