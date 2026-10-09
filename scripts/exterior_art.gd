@tool
extends Control

# Placeholder art for the shop seen from the road at night, drawn in code
# until there's a painting: black spruce, snow, a low building, and the neon
# over the door, PAWN GUNS FURS TAXIDERMY, with one letter dead. Shown at the
# end of the drive, when the sign comes out of the snow.

const SKY_TOP: Color = Color(0.01, 0.012, 0.02)
const SKY_LOW: Color = Color(0.04, 0.035, 0.05)
const TREES: Color = Color(0.006, 0.008, 0.012)
const SNOW: Color = Color(0.13, 0.12, 0.14)
const BUILDING: Color = Color(0.03, 0.028, 0.032)
const NEON: Color = Color(1.0, 0.16, 0.18)
const SIGN: String = "PAWN  GUNS  FURS  TAXIDERMY"
# Which letter of SIGN is dead: the R in FURS.
const DEAD_LETTER: int = 14
const FLAKES: int = 90
# The building sits a little left of center, so the story column on the right
# doesn't cover it while the last lines of the drive are showing.
const SHIFT: float = -0.12

var _time: float = 0.0
var _flakes: Array = []

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	for i in FLAKES:
		_flakes.append(Vector3(randf(), randf(), randf_range(0.4, 1.0)))

func _process(delta: float) -> void:
	_time += delta
	for i in _flakes.size():
		var f: Vector3 = _flakes[i]
		f.y += delta * 0.05 * f.z
		f.x += delta * 0.01 * sin(_time + i)
		if f.y > 1.0:
			f = Vector3(randf(), 0.0, f.z)
		_flakes[i] = f
	queue_redraw()

func _p(x: float, y: float) -> Vector2:
	return Vector2(x * size.x, y * size.y)

func _poly(points: Array, color: Color) -> void:
	var packed: PackedVector2Array = PackedVector2Array()
	for point in points:
		packed.append(_p(point.x, point.y))
	draw_colored_polygon(packed, color)

func _draw() -> void:
	for i in 12:
		var t: float = i / 12.0
		draw_rect(Rect2(_p(0, t * 0.6), _p(1, 0.06)), SKY_TOP.lerp(SKY_LOW, t))
	# Spruce, a black wall on both sides.
	for k in 22:
		var x: float = k / 21.0
		var h: float = 0.22 + 0.12 * absf(sin(k * 1.7))
		_poly([Vector2(x - 0.035, 0.62), Vector2(x, 0.62 - h), Vector2(x + 0.035, 0.62)], TREES)
	_poly([Vector2(0, 0.6), Vector2(1, 0.6), Vector2(1, 1), Vector2(0, 1)], SNOW)
	# The building: low, flat-roofed, two windows and a door.
	_poly([Vector2(0.14, 0.38), Vector2(0.62, 0.38), Vector2(0.62, 0.66), Vector2(0.14, 0.66)], BUILDING)
	_poly([Vector2(0.12, 0.36), Vector2(0.64, 0.36), Vector2(0.64, 0.39), Vector2(0.12, 0.39)], Color(0.05, 0.05, 0.055))
	var buzz: float = 0.85 + 0.15 * sin(_time * 31.0) * sin(_time * 7.0)
	for x in [0.18, 0.48]:
		_poly([Vector2(x, 0.48), Vector2(x + 0.1, 0.48), Vector2(x + 0.1, 0.6), Vector2(x, 0.6)], Color(NEON, 0.12 * buzz))
	_poly([Vector2(0.35, 0.5), Vector2(0.41, 0.5), Vector2(0.41, 0.66), Vector2(0.35, 0.66)], Color(0.015, 0.012, 0.016))
	# The red on the snow in front of it.
	_poly([Vector2(0.1, 0.66), Vector2(0.66, 0.66), Vector2(0.78, 0.78), Vector2(-0.02, 0.78)], Color(NEON, 0.06 * buzz))
	_draw_sign(buzz)
	# Your headlights on the lot, one dimmer than the other.
	_poly([Vector2(0.18, 1), Vector2(0.3, 0.7), Vector2(0.36, 0.7), Vector2(0.38, 1)], Color(0.9, 0.9, 0.8, 0.07))
	_poly([Vector2(0.4, 1), Vector2(0.41, 0.7), Vector2(0.47, 0.7), Vector2(0.6, 1)], Color(0.9, 0.9, 0.8, 0.03))
	for f in _flakes:
		draw_circle(_p(f.x, f.y), 0.8 + f.z * 1.6, Color(0.85, 0.87, 0.92, 0.25 + f.z * 0.4))

func _draw_sign(buzz: float) -> void:
	var font: Font = ThemeDB.fallback_font
	var font_size: int = int(size.y * 0.045)
	var width: float = font.get_string_size(SIGN, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size).x
	var x: float = size.x * (0.5 + SHIFT) - width / 2.0
	var y: float = size.y * 0.33
	for i in SIGN.length():
		var letter: String = SIGN[i]
		var lit: bool = i != DEAD_LETTER
		var color: Color = Color(NEON, buzz) if lit else Color(0.25, 0.05, 0.06, 0.8)
		if lit:
			for glow in [6, 3]:
				draw_string(font, Vector2(x, y), letter, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size + glow, Color(NEON, 0.08 * buzz))
		draw_string(font, Vector2(x, y), letter, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size, color)
		x += font.get_string_size(letter, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size).x
