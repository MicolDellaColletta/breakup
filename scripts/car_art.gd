extends Control

# Placeholder art for the drive, drawn in code until there's a painting: the
# inside of the car at night, from the driver's seat. Snow rushing the
# headlights, the wipers, the radio's amber dial, the bundle on the passenger
# seat. Where things are drawn matches the drive's hotspots in spots.cfg.

const NIGHT: Color = Color(0.02, 0.025, 0.04)
const OUTSIDE: Color = Color(0.035, 0.045, 0.065)
const ROAD: Color = Color(0.09, 0.1, 0.12)
const BEAM: Color = Color(0.75, 0.75, 0.65, 0.07)
const FRAME: Color = Color(0.012, 0.014, 0.02)
const DASH: Color = Color(0.055, 0.055, 0.065)
const DASH_EDGE: Color = Color(0.1, 0.1, 0.11)
const AMBER: Color = Color(0.95, 0.62, 0.25)
const GAUGE: Color = Color(0.35, 0.75, 0.6, 0.6)
const SEAT: Color = Color(0.07, 0.065, 0.07)
const TOWEL: Color = Color(0.42, 0.4, 0.37)
const COAT: Color = Color(0.09, 0.075, 0.07)
const PAPER: Color = Color(0.78, 0.75, 0.68)
const SNOW: Color = Color(0.9, 0.92, 0.96)

# Where the road meets the dark: everything rushes out from here.
const VANISH: Vector2 = Vector2(0.42, 0.36)
const WINDSHIELD_BOTTOM: float = 0.56
const FLAKES: int = 140
const WIPER_PERIOD: float = 2.4

var _flakes: Array = []
var _time: float = 0.0
# Headlights far behind, now and then, in the mirror.
var _mirror_glow: float = 0.0

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	for i in FLAKES:
		_flakes.append(_new_flake(randf()))

func _new_flake(start: float) -> Dictionary:
	return {
		"angle": randf_range(-PI, PI),
		"dist": lerpf(0.005, 0.6, start * start),
		"speed": randf_range(0.6, 1.3),
	}

func _process(delta: float) -> void:
	_time += delta
	for flake in _flakes:
		flake["dist"] += flake["dist"] * flake["speed"] * delta * 1.6 + 0.004 * delta
		if flake["dist"] > 0.9:
			flake.merge(_new_flake(0.0), true)
	# The lights behind come and go, slowly. Mostly go.
	_mirror_glow = clampf(sin(_time * 0.21) * 1.6 - 0.9, 0.0, 1.0)
	queue_redraw()

func _p(x: float, y: float) -> Vector2:
	return Vector2(x * size.x, y * size.y)

func _poly(points: Array, color: Color) -> void:
	var packed: PackedVector2Array = PackedVector2Array()
	for point in points:
		packed.append(_p(point.x, point.y))
	draw_colored_polygon(packed, color)

func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, size), NIGHT)
	_draw_outside()
	_draw_wipers()
	_draw_frame()
	_draw_mirror()
	_draw_dash()
	_draw_passenger_side()
	_draw_coat()
	_draw_wheel()

func _draw_outside() -> void:
	_poly([Vector2(0.08, 0.08), Vector2(0.92, 0.08), Vector2(0.98, WINDSHIELD_BOTTOM), Vector2(0.02, WINDSHIELD_BOTTOM)], OUTSIDE)
	_poly([Vector2(0.405, VANISH.y), Vector2(0.435, VANISH.y), Vector2(0.86, WINDSHIELD_BOTTOM), Vector2(-0.02, WINDSHIELD_BOTTOM)], ROAD)
	# Two beams, and one of them dimmer than the other.
	_poly([Vector2(0.4, VANISH.y + 0.01), Vector2(0.06, WINDSHIELD_BOTTOM), Vector2(0.42, WINDSHIELD_BOTTOM)], BEAM)
	_poly([Vector2(0.44, VANISH.y + 0.01), Vector2(0.48, WINDSHIELD_BOTTOM), Vector2(0.78, WINDSHIELD_BOTTOM)], Color(BEAM, BEAM.a * 0.45))
	var vanish: Vector2 = _p(VANISH.x, VANISH.y)
	var top: float = 0.08 * size.y
	var bottom: float = WINDSHIELD_BOTTOM * size.y
	for flake in _flakes:
		var reach: float = flake["dist"] * size.x
		var at: Vector2 = vanish + Vector2(cos(flake["angle"]), sin(flake["angle"]) * 0.6) * reach
		if at.y < top or at.y > bottom or at.x < 0.04 * size.x or at.x > 0.96 * size.x:
			continue
		var radius: float = 0.6 + flake["dist"] * 5.0
		draw_circle(at, radius, Color(SNOW, clampf(flake["dist"] * 2.2, 0.15, 0.85)))

func _draw_wipers() -> void:
	var swing: float = (sin(_time * TAU / WIPER_PERIOD) + 1.0) / 2.0
	var angle: float = lerpf(PI * 0.97, PI * 0.62, swing)
	for pivot_x in [0.3, 0.64]:
		var pivot: Vector2 = _p(pivot_x, WINDSHIELD_BOTTOM - 0.01)
		var tip: Vector2 = pivot + Vector2(cos(angle), -sin(angle)) * size.x * 0.27
		draw_line(pivot, tip, FRAME, 5.0)
		draw_line(pivot, tip, Color(0.15, 0.15, 0.17), 1.5)

func _draw_frame() -> void:
	draw_rect(Rect2(Vector2.ZERO, Vector2(size.x, 0.08 * size.y)), FRAME)
	_poly([Vector2(0, 0), Vector2(0.08, 0.08), Vector2(0.02, WINDSHIELD_BOTTOM), Vector2(0, WINDSHIELD_BOTTOM)], FRAME)
	_poly([Vector2(1, 0), Vector2(0.92, 0.08), Vector2(0.98, WINDSHIELD_BOTTOM), Vector2(1, WINDSHIELD_BOTTOM)], FRAME)

func _draw_mirror() -> void:
	draw_line(_p(0.505, 0.03), _p(0.505, 0.09), FRAME, 6.0)
	var rect: Rect2 = Rect2(_p(0.44, 0.085), _p(0.13, 0.055))
	draw_rect(rect.grow(3), Color(0.08, 0.08, 0.09))
	draw_rect(rect, Color(0.02, 0.025, 0.035))
	if _mirror_glow > 0.0:
		for x in [0.495, 0.515]:
			draw_circle(_p(x, 0.115), 2.5, Color(1, 0.95, 0.8, 0.6 * _mirror_glow))

func _draw_dash() -> void:
	_poly([Vector2(0, 0.6), Vector2(0.2, 0.55), Vector2(0.8, 0.55), Vector2(1, 0.58), Vector2(1, 0.76), Vector2(0, 0.78)], DASH)
	draw_line(_p(0.2, 0.55), _p(0.8, 0.55), DASH_EDGE, 2.0)
	# The gauges behind the wheel, faintly lit.
	for x in [0.25, 0.35]:
		draw_arc(_p(x, 0.64), 0.03 * size.x, PI * 1.1, PI * 1.9, 16, GAUGE, 2.0)
	# The radio: a dark face and an amber dial with its needle.
	var radio: Rect2 = Rect2(_p(0.465, 0.6), _p(0.1, 0.055))
	draw_rect(radio, Color(0.03, 0.03, 0.035))
	var flicker: float = 0.75 + 0.25 * sin(_time * 9.0) * sin(_time * 3.1)
	var dial: Rect2 = Rect2(radio.position + Vector2(6, 6), Vector2(radio.size.x - 12, radio.size.y * 0.4))
	draw_rect(dial, Color(AMBER, 0.55 * flicker))
	var needle_x: float = dial.position.x + dial.size.x * (0.45 + 0.08 * sin(_time * 0.7))
	draw_line(Vector2(needle_x, dial.position.y), Vector2(needle_x, dial.end.y), Color(0.2, 0.05, 0.02), 2.0)
	draw_circle(radio.position + Vector2(radio.size.x * 0.2, radio.size.y * 0.78), 4, DASH_EDGE)
	draw_circle(radio.position + Vector2(radio.size.x * 0.8, radio.size.y * 0.78), 4, DASH_EDGE)
	# The glovebox, on the passenger side.
	var glovebox: Rect2 = Rect2(_p(0.68, 0.615), _p(0.18, 0.09))
	draw_rect(glovebox, Color(0.07, 0.07, 0.08))
	draw_rect(glovebox, DASH_EDGE, false, 1.5)
	draw_line(glovebox.position + Vector2(glovebox.size.x * 0.4, 10), glovebox.position + Vector2(glovebox.size.x * 0.6, 10), Color(0.16, 0.16, 0.17), 3.0)

func _draw_passenger_side() -> void:
	_poly([Vector2(0.64, 0.78), Vector2(0.97, 0.76), Vector2(1, 1), Vector2(0.62, 1)], SEAT)
	_poly([Vector2(0.9, 0.7), Vector2(1, 0.68), Vector2(1, 1), Vector2(0.94, 1)], Color(0.05, 0.047, 0.05))
	# Something wrapped in a towel. About the size of a loaf of bread: a lumpy
	# bundle, the towel folded over it and tucked under.
	var c: Vector2 = _p(0.8, 0.86)
	var w: float = 0.065 * size.x
	var h: float = 0.045 * size.y
	var bundle: PackedVector2Array = PackedVector2Array([
		c + Vector2(-w, -h * 0.3), c + Vector2(-w * 0.7, -h), c + Vector2(w * 0.2, -h * 1.1),
		c + Vector2(w * 0.9, -h * 0.7), c + Vector2(w * 1.05, h * 0.3), c + Vector2(w * 0.6, h),
		c + Vector2(-w * 0.5, h * 0.95), c + Vector2(-w * 1.1, h * 0.4)])
	draw_colored_polygon(bundle, TOWEL)
	draw_line(c + Vector2(-w * 0.6, -h * 0.9), c + Vector2(-w * 0.1, h * 0.9), Color(0.3, 0.28, 0.26), 2.0)
	draw_line(c + Vector2(w * 0.3, -h), c + Vector2(w * 0.6, h * 0.8), Color(0.33, 0.31, 0.29), 1.5)
	# A corner of the towel, flipped back over the top.
	draw_colored_polygon(PackedVector2Array([c + Vector2(w * 0.2, -h * 1.1), c + Vector2(w * 0.9, -h * 0.7),
		c + Vector2(w * 0.45, -h * 0.2)]), Color(0.5, 0.48, 0.45))

func _draw_coat() -> void:
	_poly([Vector2(0, 0.8), Vector2(0.12, 0.84), Vector2(0.17, 1), Vector2(0, 1)], COAT)
	draw_line(_p(0.03, 0.88), _p(0.13, 0.9), Color(0.05, 0.04, 0.04), 3.0)
	# A corner of the folded letter, showing at the pocket.
	_poly([Vector2(0.07, 0.875), Vector2(0.1, 0.87), Vector2(0.105, 0.885), Vector2(0.075, 0.89)], PAPER)

func _draw_wheel() -> void:
	var center: Vector2 = _p(0.3, 0.92)
	var radius: float = 0.2 * size.y
	draw_arc(center, radius, PI, TAU, 48, Color(0.03, 0.03, 0.035), 16.0)
	draw_arc(center, radius, PI, TAU, 48, Color(0.08, 0.08, 0.09), 3.0)
	draw_line(center + Vector2(-radius, 0), center, Color(0.03, 0.03, 0.035), 12.0)
	draw_line(center + Vector2(radius, 0), center, Color(0.03, 0.03, 0.035), 12.0)
	draw_circle(center, radius * 0.22, Color(0.04, 0.04, 0.045))
