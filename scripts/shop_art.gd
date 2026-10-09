@tool
extends Control

# Placeholder art for the shop on the first night, drawn in code until there
# are paintings: the shop floor (from just inside the front door), the
# counter, the hallway and the office. Where things are drawn matches the
# "shop_night" hotspots in spots.cfg. See docs/layout.md for the plan.

const DARK: Color = Color(0.018, 0.02, 0.028)
const WALL: Color = Color(0.04, 0.042, 0.05)
const FLOOR: Color = Color(0.032, 0.03, 0.034)
const NEON: Color = Color(0.9, 0.12, 0.15)
const SHAPE: Color = Color(0.012, 0.013, 0.018)
const GLASS: Color = Color(0.2, 0.24, 0.28, 0.25)
const WOOD: Color = Color(0.09, 0.07, 0.055)
const BULB: Color = Color(1.0, 0.86, 0.55)
const OFFICE_WALL: Color = Color(0.2, 0.17, 0.12)
const PAPER: Color = Color(0.85, 0.82, 0.74)
const METAL: Color = Color(0.16, 0.17, 0.19)

# Which room is on screen: "floor", "counter", "hallway" or "office".
@export var view: String = "floor":
	set(value):
		view = value
		queue_redraw()

var _time: float = 0.0
var _flash: float = 0.0

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE

func _process(delta: float) -> void:
	_time += delta
	_flash = maxf(0.0, _flash - delta * 0.8)
	queue_redraw()

# The bulb in the office, too bright after the dark: a glare that fades.
func flash() -> void:
	_flash = 1.0

func _flag(name: String) -> bool:
	if Engine.is_editor_hint():
		return true
	return get_node("/root/GameState").flags.has(name)

func _has(item_id: String) -> bool:
	if Engine.is_editor_hint():
		return false
	return get_node("/root/GameState").has_item(item_id)

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
		"floor": _draw_floor()
		"counter": _draw_counter()
		"hallway": _draw_hallway()
		"office": _draw_office()
	if _flash > 0.0:
		draw_rect(Rect2(Vector2.ZERO, size), Color(1, 0.95, 0.85, _flash * 0.7))

# The office door's blade of light, once you've noticed it, pulsing so slowly
# you're not sure it is.
func _office_light_alpha() -> float:
	return 0.55 + 0.25 * sin(_time * 1.3)

func _draw_floor() -> void:
	# Back wall, floor, and the red the neon throws in through the windows behind you.
	_poly([Vector2(0.1, 0.12), Vector2(0.9, 0.12), Vector2(0.9, 0.5), Vector2(0.1, 0.5)], WALL)
	_poly([Vector2(0.1, 0.5), Vector2(0.9, 0.5), Vector2(1, 1), Vector2(0, 1)], FLOOR)
	_poly([Vector2(0, 0), Vector2(0.1, 0.12), Vector2(0.1, 0.5), Vector2(0, 1)], Color(0.03, 0.03, 0.038))
	_poly([Vector2(1, 0), Vector2(0.9, 0.12), Vector2(0.9, 0.5), Vector2(1, 1)], Color(0.03, 0.03, 0.038))
	for i in 5:
		var reach: float = 0.06 + i * 0.045
		_poly([Vector2(0.05, 1), Vector2(0.95, 1), Vector2(0.8, 1 - reach), Vector2(0.2, 1 - reach)], Color(NEON, 0.035))
	# The office door behind the counter, and the hallway opening.
	_rect(0.2, 0.22, 0.09, 0.26, Color(0.025, 0.025, 0.03))
	if _flag("office_noticed"):
		_rect(0.285, 0.22, 0.006, 0.26, Color(BULB, 0.5 * _office_light_alpha()))
		_poly([Vector2(0.29, 0.48), Vector2(0.3, 0.48), Vector2(0.42, 0.56), Vector2(0.36, 0.56)], Color(BULB, 0.12 * _office_light_alpha()))
	_rect(0.74, 0.2, 0.08, 0.3, Color(0.008, 0.008, 0.012))
	# Shelves of pawned things behind the counter.
	for row in 3:
		_rect(0.32, 0.2 + row * 0.08, 0.38, 0.008, Color(0.07, 0.065, 0.06))
		for k in 6:
			_rect(0.34 + k * 0.06, 0.155 + row * 0.08, 0.03, 0.045, SHAPE)
	# The counter, and the phone on it.
	_poly([Vector2(0.18, 0.46), Vector2(0.82, 0.46), Vector2(0.84, 0.55), Vector2(0.16, 0.55)], Color(0.06, 0.065, 0.075))
	_poly([Vector2(0.18, 0.46), Vector2(0.82, 0.46), Vector2(0.84, 0.48), Vector2(0.16, 0.48)], GLASS)
	_rect(0.58, 0.43, 0.04, 0.03, SHAPE)
	_rect(0.4, 0.42, 0.06, 0.04, SHAPE)
	# Display cases on the floor.
	for c in [Vector2(0.3, 0.64), Vector2(0.58, 0.66)]:
		_poly([c + Vector2(-0.1, 0), c + Vector2(0.1, 0), c + Vector2(0.11, 0.08), c + Vector2(-0.11, 0.08)], Color(0.035, 0.038, 0.045))
		_poly([c + Vector2(-0.1, 0), c + Vector2(0.1, 0), c + Vector2(0.1, 0.015), c + Vector2(-0.1, 0.015)], Color(NEON, 0.12))
	# Fur coats on racks along the right wall: in the dark, people standing.
	for k in 4:
		var x: float = 0.86 - k * 0.025
		var top: float = 0.3 + k * 0.03
		_poly([Vector2(x, top), Vector2(x + 0.03, top), Vector2(x + 0.04, top + 0.3 + k * 0.03), Vector2(x - 0.015, top + 0.3 + k * 0.03)], SHAPE)
		draw_circle(_p(x + 0.015, top - 0.02), 0.014 * size.x, SHAPE)
	# Antlers on the left wall.
	for k in 2:
		var base: Vector2 = _p(0.05, 0.25 + k * 0.12)
		for side in [-1, 1]:
			draw_line(base, base + Vector2(side * 18, -22), Color(0.12, 0.11, 0.1), 3.0)
			draw_line(base + Vector2(side * 9, -11), base + Vector2(side * 22, -8), Color(0.12, 0.11, 0.1), 2.0)
	# The bear, in the front corner, reared up.
	var bear: Array = [Vector2(0.03, 1), Vector2(0.05, 0.62), Vector2(0.02, 0.5), Vector2(0.06, 0.45),
		Vector2(0.08, 0.36), Vector2(0.11, 0.34), Vector2(0.14, 0.37), Vector2(0.16, 0.44), Vector2(0.21, 0.42),
		Vector2(0.19, 0.5), Vector2(0.17, 0.6), Vector2(0.19, 1)]
	_poly(bear, Color(0.006, 0.006, 0.008))
	draw_circle(_p(0.115, 0.38), 2.0, Color(NEON, 0.6))

func _draw_counter() -> void:
	# Behind the counter: shelves, the office door (left), the hallway (right).
	_poly([Vector2(0, 0), Vector2(1, 0), Vector2(1, 0.62), Vector2(0, 0.62)], WALL)
	for row in 4:
		_rect(0.3, 0.12 + row * 0.11, 0.4, 0.012, Color(0.08, 0.075, 0.07))
		for k in 7:
			var h: float = 0.04 + 0.02 * ((k * 7 + row * 3) % 3)
			_rect(0.315 + k * 0.055, 0.12 + row * 0.11 - h, 0.035, h, SHAPE)
			_rect(0.322 + k * 0.055, 0.12 + row * 0.11 - h * 0.5, 0.012, 0.02, Color(0.55, 0.5, 0.42, 0.5))
	_rect(0.06, 0.08, 0.17, 0.54, Color(0.03, 0.03, 0.036))
	_rect(0.06, 0.08, 0.17, 0.54, Color(0.07, 0.07, 0.08), false)
	_rect(0.115, 0.22, 0.06, 0.025, Color(0.3, 0.3, 0.32, 0.6))
	if _flag("office_noticed"):
		var a: float = _office_light_alpha()
		_rect(0.224, 0.08, 0.008, 0.54, Color(BULB, 0.65 * a))
		_poly([Vector2(0.225, 0.62), Vector2(0.235, 0.62), Vector2(0.4, 0.75), Vector2(0.3, 0.75)], Color(BULB, 0.16 * a))
	_rect(0.78, 0.06, 0.16, 0.56, Color(0.006, 0.006, 0.01))
	# The counter top, close: glass, the register (drawer hanging open), the phone.
	_poly([Vector2(0, 0.62), Vector2(1, 0.62), Vector2(1, 1), Vector2(0, 1)], Color(0.05, 0.055, 0.065))
	_poly([Vector2(0, 0.62), Vector2(1, 0.62), Vector2(1, 0.66), Vector2(0, 0.66)], GLASS)
	_poly([Vector2(0.24, 0.5), Vector2(0.42, 0.5), Vector2(0.44, 0.68), Vector2(0.22, 0.68)], Color(0.08, 0.075, 0.06))
	_rect(0.26, 0.53, 0.14, 0.05, Color(0.04, 0.035, 0.03))
	_poly([Vector2(0.23, 0.68), Vector2(0.43, 0.68), Vector2(0.46, 0.76), Vector2(0.2, 0.76)], Color(0.11, 0.1, 0.08))
	_rect(0.22, 0.69, 0.23, 0.05, Color(0.02, 0.02, 0.02))
	# The phone: black, heavy, old.
	_poly([Vector2(0.6, 0.6), Vector2(0.74, 0.6), Vector2(0.76, 0.7), Vector2(0.58, 0.7)], Color(0.02, 0.02, 0.022))
	draw_arc(_p(0.67, 0.6), 0.055 * size.x, PI, TAU, 24, Color(0.03, 0.03, 0.033), 10.0)
	draw_circle(_p(0.67, 0.655), 0.022 * size.x, Color(0.06, 0.06, 0.065))
	# A drawer in the front of the counter, under the phone.
	_rect(0.62, 0.78, 0.16, 0.08, Color(0.04, 0.042, 0.05))
	_rect(0.62, 0.78, 0.16, 0.08, Color(0.09, 0.09, 0.1), false)
	_rect(0.68, 0.815, 0.04, 0.012, Color(0.25, 0.25, 0.27))
	# The brass balance at the end of the counter, for weighing gold.
	var pivot: Vector2 = _p(0.885, 0.54)
	draw_line(pivot, _p(0.885, 0.64), Color(0.45, 0.36, 0.18), 3.0)
	draw_line(pivot + Vector2(-0.045 * size.x, 2), pivot + Vector2(0.045 * size.x, -2), Color(0.5, 0.4, 0.2), 3.0)
	for side in [-1, 1]:
		var hang: Vector2 = pivot + Vector2(side * 0.045 * size.x, -side * 2)
		draw_line(hang, hang + Vector2(0, 26 + side * 3), Color(0.35, 0.28, 0.15), 1.0)
		draw_arc(hang + Vector2(0, 26 + side * 3), 14, 0, PI, 12, Color(0.5, 0.4, 0.2), 3.0)
	_rect(0.86, 0.64, 0.05, 0.015, Color(0.35, 0.28, 0.15))
	# The neon behind you, reflected faintly in the glass.
	_poly([Vector2(0.5, 0.62), Vector2(0.62, 0.62), Vector2(0.66, 0.66), Vector2(0.46, 0.66)], Color(NEON, 0.08))

func _draw_hallway() -> void:
	# A narrow corridor: stairs climbing on the left, the fuse box on the right,
	# the steel door at the end.
	_poly([Vector2(0, 0), Vector2(0.38, 0.2), Vector2(0.38, 0.75), Vector2(0, 1)], Color(0.035, 0.036, 0.042))
	_poly([Vector2(1, 0), Vector2(0.62, 0.2), Vector2(0.62, 0.75), Vector2(1, 1)], Color(0.038, 0.039, 0.046))
	_poly([Vector2(0, 1), Vector2(0.38, 0.75), Vector2(0.62, 0.75), Vector2(1, 1)], FLOOR)
	_poly([Vector2(0, 0), Vector2(1, 0), Vector2(0.62, 0.2), Vector2(0.38, 0.2)], Color(0.02, 0.02, 0.026))
	# The steel door.
	_rect(0.43, 0.27, 0.14, 0.48, METAL)
	for y in [0.3, 0.72]:
		for x in [0.445, 0.555]:
			draw_circle(_p(x, y), 2.5, Color(0.25, 0.26, 0.28))
	_rect(0.545, 0.5, 0.012, 0.05, Color(0.3, 0.31, 0.33))
	# The stairs, rising toward you along the left wall.
	for k in 9:
		var t: float = k / 9.0
		var y: float = lerpf(0.74, 0.3, t)
		var x0: float = lerpf(0.37, 0.05, t)
		_poly([Vector2(x0, y), Vector2(x0 + 0.09 + t * 0.05, y), Vector2(x0 + 0.09 + t * 0.05, y + 0.02), Vector2(x0, y + 0.02)], Color(0.07, 0.06, 0.05))
	draw_line(_p(0.36, 0.62), _p(0.02, 0.2), Color(0.1, 0.09, 0.08), 3.0)
	# The fuse box, gray, on the right wall.
	_poly([Vector2(0.74, 0.36), Vector2(0.82, 0.32), Vector2(0.82, 0.48), Vector2(0.74, 0.5)], Color(0.12, 0.125, 0.13))
	draw_line(_p(0.76, 0.4), _p(0.8, 0.38), Color(0.6, 0.55, 0.3, 0.5), 3.0)

func _draw_office() -> void:
	# Lit: the bare bulb, the desk, the chair pushed back, the ram's head.
	draw_rect(Rect2(Vector2.ZERO, size), OFFICE_WALL)
	_poly([Vector2(0, 0.66), Vector2(1, 0.66), Vector2(1, 1), Vector2(0, 1)], Color(0.15, 0.12, 0.08))
	var bulb: Vector2 = _p(0.5, 0.2)
	draw_line(_p(0.5, 0.0), bulb, Color(0.1, 0.08, 0.06), 2.0)
	for i in range(6, 0, -1):
		draw_circle(bulb, size.y * 0.06 * i, Color(BULB, 0.05))
	draw_circle(bulb, 9, BULB)
	# The ram's head, horns curling back on themselves.
	var ram: Vector2 = _p(0.5, 0.42)
	_poly([Vector2(0.47, 0.36), Vector2(0.53, 0.36), Vector2(0.52, 0.5), Vector2(0.48, 0.5)], Color(0.32, 0.28, 0.22))
	for side in [-1, 1]:
		draw_arc(ram + Vector2(side * size.x * 0.05, -size.y * 0.04), size.x * 0.03, 0, TAU * 0.85, 24, Color(0.42, 0.37, 0.3), 7.0)
	draw_circle(ram + Vector2(-8, -6), 2.5, Color(0.05, 0.04, 0.03))
	draw_circle(ram + Vector2(8, -6), 2.5, Color(0.05, 0.04, 0.03))
	# The desk, and the chair pushed back as if someone just stood up.
	_poly([Vector2(0.25, 0.62), Vector2(0.75, 0.62), Vector2(0.78, 0.7), Vector2(0.22, 0.7)], WOOD)
	_rect(0.24, 0.7, 0.03, 0.22, Color(0.07, 0.055, 0.04))
	_rect(0.73, 0.7, 0.03, 0.22, Color(0.07, 0.055, 0.04))
	_poly([Vector2(0.8, 0.5), Vector2(0.9, 0.52), Vector2(0.89, 0.72), Vector2(0.81, 0.7)], Color(0.1, 0.09, 0.08))
	_rect(0.79, 0.72, 0.11, 0.03, Color(0.1, 0.09, 0.08))
	if not _has("letter"):
		_poly([Vector2(0.45, 0.635), Vector2(0.55, 0.63), Vector2(0.56, 0.665), Vector2(0.44, 0.67)], PAPER)
	# The door back out, dark, on the left.
	_rect(0.0, 0.18, 0.12, 0.5, Color(0.02, 0.02, 0.025))
