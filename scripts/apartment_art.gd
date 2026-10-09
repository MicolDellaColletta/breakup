@tool
extends Control

# Placeholder art for the apartment upstairs, drawn in code until there are
# paintings: the main room (from the landing), the hall, the bathroom and the
# bedroom. Where things are drawn matches the apartment hotspots in
# spots.cfg. See docs/layout.md, "The apartment".

const DARK: Color = Color(0.02, 0.022, 0.03)
const WALL: Color = Color(0.05, 0.048, 0.055)
const FLOOR: Color = Color(0.045, 0.038, 0.035)
const NEON: Color = Color(0.9, 0.14, 0.16)
const NIGHT: Color = Color(0.03, 0.04, 0.07)
const AMBER: Color = Color(0.95, 0.62, 0.25)
const FURNITURE: Color = Color(0.03, 0.028, 0.03)
const STEEL: Color = Color(0.35, 0.36, 0.38)
const PAPER: Color = Color(0.7, 0.67, 0.6)

# Which room is on screen: "main", "hall", "bathroom" or "bedroom".
@export var view: String = "main":
	set(value):
		view = value
		queue_redraw()

var _time: float = 0.0

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE

func _process(delta: float) -> void:
	_time += delta
	queue_redraw()

func _flag(name: String) -> bool:
	if Engine.is_editor_hint():
		return false
	return get_node("/root/GameState").flags.has(name)

func _p(x: float, y: float) -> Vector2:
	return Vector2(x * size.x, y * size.y)

func _poly(points: Array, color: Color) -> void:
	var packed: PackedVector2Array = PackedVector2Array()
	for point in points:
		packed.append(_p(point.x, point.y))
	draw_colored_polygon(packed, color)

func _rect(x: float, y: float, w: float, h: float, color: Color, filled: bool = true) -> void:
	draw_rect(Rect2(_p(x, y), _p(w, h)), color, filled, -1.0 if filled else 1.5)

func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, size), DARK)
	match view:
		"main": _draw_main()
		"hall": _draw_hall()
		"bathroom": _draw_bathroom()
		"bedroom": _draw_bedroom()

func _draw_main() -> void:
	# The far wall with the two front windows, the neon painting the ceiling red.
	_poly([Vector2(0, 0), Vector2(1, 0), Vector2(1, 0.62), Vector2(0, 0.62)], WALL)
	for i in 4:
		_poly([Vector2(0, 0), Vector2(1, 0), Vector2(1, 0.05 + i * 0.04), Vector2(0, 0.05 + i * 0.04)], Color(NEON, 0.045))
	_poly([Vector2(0, 0.62), Vector2(1, 0.62), Vector2(1, 1), Vector2(0, 1)], FLOOR)
	var open: bool = _flag("window_open")
	for x in [0.34, 0.56]:
		_rect(x, 0.14, 0.13, 0.3, NIGHT)
		_rect(x, 0.36, 0.13, 0.08, Color(NEON, 0.18))
		for k in 6:
			var fx: float = x + 0.01 + fmod(k * 0.023 + _time * 0.004, 0.11)
			var fy: float = 0.15 + fmod(k * 0.047 + _time * 0.02 * (1 + k % 2), 0.28)
			draw_circle(_p(fx, fy), 1.5, Color(0.85, 0.87, 0.9, 0.6))
		_rect(x, 0.14, 0.13, 0.3, Color(0.12, 0.11, 0.1), false)
		draw_line(_p(x + 0.065, 0.14), _p(x + 0.065, 0.44), Color(0.12, 0.11, 0.1), 2.0)
	if open:
		_poly([Vector2(0.56, 0.14), Vector2(0.62, 0.17), Vector2(0.62, 0.47), Vector2(0.56, 0.44)], Color(0.15, 0.14, 0.13, 0.6))
	# The kitchen corner, left: stove, table, the calendar, the dog bowl.
	_rect(0.07, 0.42, 0.12, 0.2, Color(0.08, 0.08, 0.085))
	for x in [0.1, 0.15]:
		draw_circle(_p(x, 0.44), 7, Color(0.03, 0.03, 0.03))
	_rect(0.2, 0.5, 0.12, 0.03, Color(0.07, 0.055, 0.04))
	_rect(0.21, 0.53, 0.01, 0.1, Color(0.06, 0.05, 0.04))
	_rect(0.3, 0.53, 0.01, 0.1, Color(0.06, 0.05, 0.04))
	_rect(0.22, 0.2, 0.08, 0.13, PAPER)
	draw_line(_p(0.22, 0.24), _p(0.3, 0.24), Color(0.3, 0.27, 0.22), 1.0)
	for k in 9:
		draw_line(_p(0.225 + (k % 5) * 0.015, 0.26 + (k / 5) * 0.025), _p(0.235 + (k % 5) * 0.015, 0.27 + (k / 5) * 0.025), Color(0.25, 0.22, 0.18), 1.0)
	draw_arc(_p(0.285, 0.31), 6, 0, TAU, 12, Color(0.75, 0.1, 0.1), 1.5)
	var bowl: Vector2 = _p(0.13, 0.68)
	draw_colored_polygon(PackedVector2Array([bowl + Vector2(-16, -4), bowl + Vector2(16, -4), bowl + Vector2(12, 6), bowl + Vector2(-12, 6)]), STEEL)
	if not Engine.is_editor_hint() and get_node("/root/GameState").fed_dog:
		draw_colored_polygon(PackedVector2Array([bowl + Vector2(-13, -5), bowl + Vector2(13, -5), bowl + Vector2(10, -1), bowl + Vector2(-10, -1)]), Color(0.3, 0.2, 0.12))
	# The living area, right: armchair facing the TV, the radio on its table.
	_rect(0.7, 0.4, 0.14, 0.12, Color(0.06, 0.06, 0.065))
	_rect(0.72, 0.42, 0.1, 0.08, Color(0.1, 0.11, 0.12) if not _flag("tv_on") else Color(0.5, 0.52, 0.55, 0.8))
	_poly([Vector2(0.6, 0.58), Vector2(0.72, 0.56), Vector2(0.74, 0.82), Vector2(0.58, 0.84)], FURNITURE)
	_rect(0.86, 0.52, 0.08, 0.12, Color(0.07, 0.055, 0.04))
	_rect(0.865, 0.47, 0.07, 0.05, Color(0.09, 0.07, 0.05))
	var lit: bool = _flag("radio_on")
	_rect(0.875, 0.48, 0.05, 0.015, Color(AMBER, 0.85 if lit else 0.12))
	# The coat on its hook by the landing, near and to the left.
	_poly([Vector2(0.0, 0.3), Vector2(0.035, 0.28), Vector2(0.05, 0.62), Vector2(0.0, 0.66)], Color(0.08, 0.068, 0.055))
	draw_circle(_p(0.025, 0.27), 4, STEEL)

func _draw_hall() -> void:
	# A short hall toward the back: bathroom and bedroom on the left, the locked
	# door at the end on the right.
	_poly([Vector2(0, 0), Vector2(0.4, 0.22), Vector2(0.4, 0.72), Vector2(0, 1)], Color(0.045, 0.044, 0.05))
	_poly([Vector2(1, 0), Vector2(0.6, 0.22), Vector2(0.6, 0.72), Vector2(1, 1)], Color(0.05, 0.048, 0.055))
	_poly([Vector2(0, 1), Vector2(0.4, 0.72), Vector2(0.6, 0.72), Vector2(1, 1)], FLOOR)
	_poly([Vector2(0, 0), Vector2(1, 0), Vector2(0.6, 0.22), Vector2(0.4, 0.22)], Color(0.03, 0.03, 0.035))
	_rect(0.4, 0.22, 0.2, 0.5, Color(0.035, 0.034, 0.04))
	# Bathroom door (near) and bedroom door (far), on the left wall, open.
	_poly([Vector2(0.08, 0.2), Vector2(0.2, 0.26), Vector2(0.2, 0.82), Vector2(0.08, 0.9)], Color(0.01, 0.01, 0.014))
	_poly([Vector2(0.26, 0.3), Vector2(0.34, 0.33), Vector2(0.34, 0.74), Vector2(0.26, 0.78)], Color(0.01, 0.01, 0.014))
	# The locked door at the end, on the right: shut, a keyhole, cold.
	_poly([Vector2(0.62, 0.26), Vector2(0.72, 0.22), Vector2(0.72, 0.78), Vector2(0.62, 0.72)], Color(0.09, 0.08, 0.07))
	draw_circle(_p(0.64, 0.5), 3, Color(0.0, 0.0, 0.0))
	draw_circle(_p(0.645, 0.48), 3.5, Color(0.25, 0.22, 0.15))

func _draw_bathroom() -> void:
	draw_rect(Rect2(Vector2.ZERO, size), Color(0.06, 0.065, 0.068))
	_poly([Vector2(0, 0.7), Vector2(1, 0.7), Vector2(1, 1), Vector2(0, 1)], Color(0.07, 0.07, 0.072))
	# The mirror, silver going black at the edges, and the dark shape in it.
	_rect(0.38, 0.1, 0.24, 0.32, Color(0.14, 0.15, 0.16))
	_rect(0.39, 0.115, 0.22, 0.29, Color(0.07, 0.075, 0.08))
	_rect(0.39, 0.115, 0.22, 0.29, Color(0.0, 0.0, 0.0, 0.5), false)
	draw_circle(_p(0.5, 0.25), size.y * 0.06, Color(0.03, 0.03, 0.035))
	_rect(0.46, 0.3, 0.08, 0.1, Color(0.03, 0.03, 0.035))
	# The sink, and the toothbrush in its glass.
	_poly([Vector2(0.34, 0.5), Vector2(0.66, 0.5), Vector2(0.62, 0.6), Vector2(0.38, 0.6)], Color(0.2, 0.21, 0.22))
	_rect(0.48, 0.6, 0.04, 0.1, Color(0.15, 0.16, 0.17))
	_rect(0.6, 0.44, 0.025, 0.06, Color(0.4, 0.45, 0.5, 0.5))
	draw_line(_p(0.612, 0.43), _p(0.62, 0.38), Color(0.3, 0.55, 0.65), 3.0)

func _draw_bedroom() -> void:
	_poly([Vector2(0, 0), Vector2(1, 0), Vector2(1, 0.58), Vector2(0, 0.58)], WALL)
	_poly([Vector2(0, 0.58), Vector2(1, 0.58), Vector2(1, 1), Vector2(0, 1)], FLOOR)
	# The bed, pale sheets in the dark; the dresser against the wall.
	_poly([Vector2(0.22, 0.52), Vector2(0.62, 0.52), Vector2(0.7, 0.86), Vector2(0.14, 0.86)], Color(0.14, 0.14, 0.15))
	_rect(0.24, 0.42, 0.36, 0.1, Color(0.06, 0.05, 0.045))
	_poly([Vector2(0.26, 0.54), Vector2(0.4, 0.54), Vector2(0.41, 0.6), Vector2(0.25, 0.6)], Color(0.22, 0.22, 0.23))
	_rect(0.74, 0.34, 0.16, 0.26, Color(0.07, 0.055, 0.045))
	for k in 3:
		_rect(0.75, 0.37 + k * 0.075, 0.14, 0.004, Color(0.03, 0.025, 0.02))
	# Through the floor, the freezer: a faint cold line along the boards.
	_rect(0.0, 0.94, 1.0, 0.004, Color(0.4, 0.55, 0.7, 0.08 + 0.04 * sin(_time * 2.0)))
