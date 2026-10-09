@tool
extends Control

# Placeholder art for the rearview mirror, a close-up, drawn in code until
# there's a painting: the road behind you through the back window, the
# headlights following far back, and a strip of your own eyes at the bottom of
# the glass. Where things are drawn matches the "mirror" hotspots in
# spots.cfg. The drive turns `lights` down to nothing when they go out.

const SURROUND: Color = Color(0.025, 0.025, 0.03)
const HEADLINER: Color = Color(0.06, 0.058, 0.062)
const FRAME: Color = Color(0.09, 0.09, 0.1)
const FRAME_EDGE: Color = Color(0.17, 0.17, 0.18)
const GLASS: Color = Color(0.03, 0.035, 0.05)
const SNOW_GROUND: Color = Color(0.11, 0.115, 0.13)
const ROAD: Color = Color(0.05, 0.05, 0.06)
const SNOW: Color = Color(0.82, 0.84, 0.88)
const TAIL: Color = Color(0.85, 0.08, 0.06)
const LAMP: Color = Color(1.0, 0.95, 0.8)
const SKIN: Color = Color(0.32, 0.26, 0.23)

# The mirror's glass, in fractions of the screen.
const GLASS_RECT: Rect2 = Rect2(0.1, 0.2, 0.5, 0.42)
const VANISH: Vector2 = Vector2(0.35, 0.34)

# How bright the headlights behind are: 1 when they're there, 0 once they're gone.
@export var lights: float = 1.0:
	set(value):
		lights = value
		queue_redraw()

var _time: float = 0.0
var _flakes: Array = []

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	for i in 50:
		_flakes.append(Vector3(randf(), randf(), randf_range(0.5, 1.4)))

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

func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, size), SURROUND)
	# The roof lining above, the top of the windshield below.
	_poly([Vector2(0, 0), Vector2(1, 0), Vector2(1, 0.12), Vector2(0, 0.16)], HEADLINER)
	_poly([Vector2(0, 0.78), Vector2(1, 0.74), Vector2(1, 1), Vector2(0, 1)], Color(0.012, 0.014, 0.02))
	# The stem.
	draw_line(_p(0.35, 0.0), _p(0.35, 0.19), FRAME, 14.0)
	# The frame, then the glass.
	var glass: Rect2 = Rect2(_p(GLASS_RECT.position.x, GLASS_RECT.position.y), _p(GLASS_RECT.size.x, GLASS_RECT.size.y))
	draw_rect(glass.grow(14), FRAME)
	draw_rect(glass.grow(14), FRAME_EDGE, false, 2.0)
	draw_rect(glass, GLASS)
	_draw_behind()
	_draw_eyes()
	# A smear of light across the glass, and its dark edge.
	_poly([Vector2(0.12, 0.2), Vector2(0.2, 0.2), Vector2(0.14, 0.62), Vector2(0.1, 0.62)], Color(1, 1, 1, 0.025))
	draw_rect(glass, Color(0, 0, 0, 0.6), false, 3.0)

func _draw_behind() -> void:
	var top: float = GLASS_RECT.position.y
	var bottom: float = GLASS_RECT.end.y
	var left: float = GLASS_RECT.position.x
	var right: float = GLASS_RECT.end.x
	# The back window's frame cuts the view: dark posts at the sides.
	_poly([Vector2(left, VANISH.y), Vector2(right, VANISH.y), Vector2(right, bottom), Vector2(left, bottom)], SNOW_GROUND)
	_poly([Vector2(VANISH.x - 0.01, VANISH.y), Vector2(VANISH.x + 0.01, VANISH.y), Vector2(right - 0.06, bottom), Vector2(left + 0.06, bottom)], ROAD)
	# Your own taillights, red on the snow just behind the car.
	_poly([Vector2(left + 0.04, bottom - 0.06), Vector2(right - 0.04, bottom - 0.06), Vector2(right, bottom), Vector2(left, bottom)], Color(TAIL, 0.16))
	# Whoever's behind you: two lamps, low and steady, and their glow.
	if lights > 0.0:
		var flicker: float = lights * (0.92 + 0.08 * sin(_time * 7.0))
		for x in [VANISH.x - 0.012, VANISH.x + 0.012]:
			var at: Vector2 = _p(x, VANISH.y + 0.02)
			for i in range(4, 0, -1):
				draw_circle(at, 4.0 * i, Color(LAMP, 0.05 * flicker))
			draw_circle(at, 3.0, Color(LAMP, 0.95 * flicker))
		# Their light on the road between you, faint.
		_poly([Vector2(VANISH.x - 0.02, VANISH.y + 0.025), Vector2(VANISH.x + 0.02, VANISH.y + 0.025), Vector2(VANISH.x + 0.08, bottom - 0.08), Vector2(VANISH.x - 0.08, bottom - 0.08)], Color(LAMP, 0.04 * flicker))
	# Snow, swirling in the wake.
	for flake in _flakes:
		var x: float = left + fmod(flake.x + _time * 0.03 * flake.z, 1.0) * GLASS_RECT.size.x
		var y: float = top + fmod(flake.y + _time * 0.05 * flake.z, 1.0) * GLASS_RECT.size.y
		draw_circle(_p(x, y), 1.2 * flake.z, Color(SNOW, 0.35))
	_poly([Vector2(left, top), Vector2(left + 0.04, top), Vector2(left + 0.07, bottom), Vector2(left, bottom)], Color(0.015, 0.015, 0.02))
	_poly([Vector2(right - 0.04, top), Vector2(right, top), Vector2(right, bottom), Vector2(right - 0.07, bottom)], Color(0.015, 0.015, 0.02))

# A strip of your own face along the bottom of the glass: just the eyes.
func _draw_eyes() -> void:
	var y: float = GLASS_RECT.end.y - 0.055
	_poly([Vector2(0.2, y - 0.04), Vector2(0.5, y - 0.04), Vector2(0.52, GLASS_RECT.end.y), Vector2(0.18, GLASS_RECT.end.y)], Color(SKIN, 0.55))
	for x in [0.29, 0.41]:
		var c: Vector2 = _p(x, y)
		var w: float = size.x * 0.035
		var h: float = size.y * 0.016
		draw_colored_polygon(PackedVector2Array([c + Vector2(-w, 0), c + Vector2(0, -h), c + Vector2(w, 0), c + Vector2(0, h * 0.8)]), Color(0.55, 0.5, 0.48))
		draw_circle(c, h * 0.85, Color(0.12, 0.1, 0.09))
		draw_circle(c, h * 0.35, Color(0.01, 0.01, 0.01))
		# Tired: a dark line under each.
		draw_line(c + Vector2(-w * 0.8, h * 1.6), c + Vector2(w * 0.8, h * 1.6), Color(0.15, 0.1, 0.1, 0.6), 2.0)
