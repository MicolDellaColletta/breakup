@tool
extends Control

# Placeholder art for places in town you walk around in by day, drawn in code
# until there are paintings: the church (the nave, from the back), the vestry
# behind it, and Mrs. Hollis's kitchen. Where things are drawn matches their
# hotspots in spots.cfg (scene "visit"). Daylight, for once: pale and flat.

const WALL: Color = Color(0.62, 0.6, 0.55)
const WALL_DARK: Color = Color(0.45, 0.43, 0.4)
const FLOOR: Color = Color(0.32, 0.25, 0.18)
const WOOD: Color = Color(0.36, 0.24, 0.14)
const WOOD_DARK: Color = Color(0.22, 0.14, 0.08)
const GLASS: Color = Color(0.82, 0.86, 0.9)
const IRON: Color = Color(0.2, 0.2, 0.22)
const PENCIL: Color = Color(0.25, 0.24, 0.24)
const CLOTH: Color = Color(0.55, 0.18, 0.16)

# Which place is on screen: "church", "vestry", "hollis_kitchen", or at night
# on the frozen lake, "shore" (the bonfire) and "far_ice" (past the lanterns).
@export var view: String = "church":
	set(value):
		view = value
		queue_redraw()

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE

func _p(x: float, y: float) -> Vector2:
	return Vector2(x * size.x, y * size.y)

func _rect(x: float, y: float, w: float, h: float, color: Color, filled: bool = true) -> void:
	draw_rect(Rect2(_p(x, y), _p(w, h)), color, filled, -1.0 if filled else 1.5)

func _poly(points: Array, color: Color) -> void:
	var packed: PackedVector2Array = PackedVector2Array()
	for point in points:
		packed.append(_p(point.x, point.y))
	draw_colored_polygon(packed, color)

func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, size), WALL)
	match view:
		"church": _draw_church()
		"vestry": _draw_vestry()
		"hollis_kitchen": _draw_kitchen()
		"shore": _draw_shore()
		"far_ice": _draw_far_ice()
		"hall": _draw_hall()
		"stage": _draw_stage()
		"cabin": _draw_cabin()
		"cabin_road": _draw_cabin_road()

func _draw_church() -> void:
	# White walls, tall plain windows on both sides, pews running to the altar.
	_poly([Vector2(0, 0.62), Vector2(1, 0.62), Vector2(1, 1), Vector2(0, 1)], FLOOR)
	for side in [0.04, 0.84]:
		for k in 2:
			_rect(side + k * 0.06, 0.12, 0.04, 0.36, GLASS)
	# The altar, the cross above it.
	_rect(0.42, 0.42, 0.16, 0.14, WOOD_DARK)
	_rect(0.42, 0.42, 0.16, 0.025, Color(0.9, 0.88, 0.82))
	_rect(0.495, 0.14, 0.01, 0.22, WOOD_DARK)
	_rect(0.465, 0.19, 0.07, 0.012, WOOD_DARK)
	# Pews, nearer and wider toward the bottom; the front one empty.
	for row in 5:
		var y: float = 0.6 + row * 0.07
		var spread: float = 0.08 + row * 0.04
		_rect(0.14 - spread * 0.5, y, 0.3 + spread * 0.3, 0.035, WOOD)
		_rect(0.56, y, 0.3 + spread * 0.3, 0.035, WOOD)
	# The vestry door, at the back on the right.
	_rect(0.7, 0.3, 0.07, 0.28, WOOD_DARK)

func _draw_vestry() -> void:
	_poly([Vector2(0, 0.66), Vector2(1, 0.66), Vector2(1, 1), Vector2(0, 1)], FLOOR)
	_rect(0.06, 0.16, 0.14, 0.2, GLASS)
	# The grain scale: a platform, a post, a beam, a weight.
	_rect(0.3, 0.7, 0.2, 0.05, IRON)
	_rect(0.39, 0.3, 0.02, 0.42, IRON)
	_rect(0.3, 0.3, 0.2, 0.015, IRON)
	draw_circle(_p(0.47, 0.34), size.y * 0.02, IRON)
	# The doorframe, white, its edge covered in pencil lines.
	_rect(0.64, 0.16, 0.2, 0.52, WALL_DARK)
	_rect(0.62, 0.16, 0.02, 0.52, Color(0.92, 0.91, 0.88))
	for k in 11:
		var y: float = 0.24 + k * 0.022 + (k % 3) * 0.004
		draw_line(_p(0.62, y), _p(0.66, y), PENCIL, 1.5)
	# The book of weights, on a lectern.
	_rect(0.86, 0.46, 0.08, 0.22, WOOD_DARK)
	_rect(0.85, 0.44, 0.1, 0.03, Color(0.85, 0.82, 0.74))

func _draw_kitchen() -> void:
	_poly([Vector2(0, 0.64), Vector2(1, 0.64), Vector2(1, 1), Vector2(0, 1)], Color(0.5, 0.46, 0.4))
	_rect(0.4, 0.14, 0.2, 0.22, GLASS)
	# The stove, the table, Ray's chair, the two bare patches by it.
	_rect(0.06, 0.42, 0.16, 0.24, IRON)
	_rect(0.34, 0.56, 0.3, 0.04, WOOD)
	_rect(0.36, 0.6, 0.02, 0.14, WOOD)
	_rect(0.6, 0.6, 0.02, 0.14, WOOD)
	_rect(0.7, 0.5, 0.08, 0.04, WOOD_DARK)
	_rect(0.7, 0.54, 0.015, 0.2, WOOD_DARK)
	_rect(0.765, 0.54, 0.015, 0.2, WOOD_DARK)
	draw_circle(_p(0.72, 0.84), size.y * 0.025, Color(0.62, 0.58, 0.5))
	draw_circle(_p(0.77, 0.84), size.y * 0.025, Color(0.62, 0.58, 0.5))
	# The drying rack by the sink, a bowl upside down on it.
	_rect(0.82, 0.44, 0.12, 0.02, WOOD)
	_poly([Vector2(0.85, 0.44), Vector2(0.91, 0.44), Vector2(0.9, 0.41), Vector2(0.86, 0.41)], Color(0.6, 0.62, 0.66))
	# Ray's boots by the back door; a shut door down the hall.
	_rect(0.24, 0.3, 0.08, 0.36, WOOD_DARK)
	_rect(0.25, 0.62, 0.025, 0.04, Color(0.18, 0.13, 0.09))
	_rect(0.285, 0.62, 0.025, 0.04, Color(0.18, 0.13, 0.09))
	_rect(0.9, 0.26, 0.07, 0.4, WOOD_DARK)
	# A tablecloth, red, folded at the corner.
	_rect(0.34, 0.545, 0.3, 0.015, CLOTH)

func _draw_shore() -> void:
	# Night on the ice: black sky, the white lake, the bonfire by the poles,
	# lanterns, and the town skating, small and dark against the glow.
	draw_rect(Rect2(Vector2.ZERO, size), Color(0.02, 0.025, 0.05))
	_poly([Vector2(0, 0.52), Vector2(1, 0.48), Vector2(1, 1), Vector2(0, 1)], Color(0.18, 0.2, 0.24))
	draw_circle(_p(0.22, 0.62), size.y * 0.16, Color(0.95, 0.5, 0.15, 0.18))
	_poly([Vector2(0.19, 0.66), Vector2(0.25, 0.66), Vector2(0.22, 0.52)], Color(0.98, 0.6, 0.2))
	_poly([Vector2(0.2, 0.66), Vector2(0.24, 0.66), Vector2(0.22, 0.57)], Color(1.0, 0.85, 0.4))
	# The four poles, lashed, under their tarp on the bank.
	for k in 4:
		draw_line(_p(0.06 + k * 0.012, 0.6), _p(0.1 + k * 0.006, 0.44), Color(0.3, 0.24, 0.18), 3.0)
	for k in 7:
		var x: float = 0.34 + k * 0.09
		draw_circle(_p(x, 0.56 + (k % 2) * 0.03), size.y * 0.008, Color(1.0, 0.8, 0.45))
	for k in 12:
		var x: float = 0.3 + (k * 37 % 60) / 100.0
		var y: float = 0.62 + (k * 13 % 20) / 100.0
		_rect(x, y, 0.012, 0.05, Color(0.04, 0.04, 0.05))

func _draw_far_ice() -> void:
	# Out past the lanterns: black, clear ice, the fire small behind, and under
	# the ice, a long dark shape.
	draw_rect(Rect2(Vector2.ZERO, size), Color(0.015, 0.018, 0.03))
	_poly([Vector2(0, 0.4), Vector2(1, 0.4), Vector2(1, 1), Vector2(0, 1)], Color(0.04, 0.05, 0.07))
	draw_circle(_p(0.12, 0.38), size.y * 0.01, Color(0.98, 0.6, 0.2))
	for k in 5:
		draw_line(_p(0.1 + k * 0.18, 0.5 + k * 0.06), _p(0.3 + k * 0.15, 0.55 + k * 0.07), Color(0.12, 0.14, 0.18), 1.0)
	_poly([Vector2(0.4, 0.66), Vector2(0.62, 0.62), Vector2(0.64, 0.68), Vector2(0.42, 0.74)], Color(0.09, 0.07, 0.05))
	draw_circle(_p(0.39, 0.7), size.y * 0.025, Color(0.1, 0.09, 0.08))
	# Sam, kneeling, with his flashlight pointed down.
	_rect(0.72, 0.6, 0.03, 0.06, Color(0.08, 0.08, 0.07))
	_poly([Vector2(0.735, 0.66), Vector2(0.7, 0.74), Vector2(0.76, 0.74)], Color(0.9, 0.9, 0.7, 0.25))

func _draw_hall() -> void:
	# The church hall at Thanksgiving: long tables under paper, the lake window
	# at the end, one place set facing it, the radio on the pie table.
	_poly([Vector2(0, 0.6), Vector2(1, 0.6), Vector2(1, 1), Vector2(0, 1)], FLOOR)
	_rect(0.38, 0.12, 0.24, 0.3, GLASS)
	for row in 2:
		var y: float = 0.62 + row * 0.14
		_rect(0.06, y, 0.88, 0.05, Color(0.92, 0.9, 0.85))
		for k in 7:
			draw_circle(_p(0.12 + k * 0.12, y + 0.025), size.y * 0.012, Color(0.8, 0.78, 0.72))
	# The empty place, at the window end, its chair turned to the glass.
	_rect(0.46, 0.5, 0.08, 0.04, Color(0.95, 0.94, 0.9))
	_rect(0.47, 0.42, 0.06, 0.08, WOOD_DARK)
	# The pie table, and the radio on it.
	_rect(0.78, 0.46, 0.16, 0.04, WOOD)
	_rect(0.83, 0.4, 0.06, 0.06, Color(0.3, 0.22, 0.16))
	# The door, and whoever's standing in it.
	_rect(0.02, 0.2, 0.1, 0.4, WALL_DARK)

func _draw_stage() -> void:
	# The stage, painted white like ice, a row of small chairs, the dark hall.
	draw_rect(Rect2(Vector2.ZERO, size), Color(0.06, 0.06, 0.08))
	_poly([Vector2(0.1, 0.5), Vector2(0.9, 0.5), Vector2(1, 0.72), Vector2(0, 0.72)], Color(0.86, 0.9, 0.94))
	for k in 5:
		draw_line(_p(0.2 + k * 0.15, 0.52), _p(0.24 + k * 0.15, 0.7), Color(0.7, 0.76, 0.82), 1.5)
	_rect(0.08, 0.1, 0.06, 0.4, CLOTH)
	_rect(0.86, 0.1, 0.06, 0.4, CLOTH)
	# The rows of heads, from behind, and the front seat: the Keeper's.
	for row in 3:
		for k in 9:
			draw_circle(_p(0.1 + k * 0.1, 0.8 + row * 0.07), size.y * 0.025, Color(0.12, 0.12, 0.14))

func _draw_cabin() -> void:
	# Sam's cabin, inside: the wall of string and pins across the back, the
	# table with the six envelopes, one chair, the stove going red.
	draw_rect(Rect2(Vector2.ZERO, size), Color(0.36, 0.3, 0.24))
	_poly([Vector2(0, 0.58), Vector2(1, 0.58), Vector2(1, 1), Vector2(0, 1)], FLOOR)
	# The wall: cards, and red and white string between them.
	_rect(0.04, 0.08, 0.92, 0.44, Color(0.5, 0.44, 0.36))
	var cards: Array = []
	for k in 26:
		var x: float = 0.06 + fmod(k * 0.137, 0.86)
		var y: float = 0.1 + fmod(k * 0.073, 0.38)
		cards.append(Vector2(x, y))
		_rect(x, y, 0.035, 0.03, Color(0.86, 0.82, 0.7))
	for k in cards.size() - 1:
		var a: Vector2 = cards[k] + Vector2(0.017, 0.015)
		var b: Vector2 = cards[(k * 7 + 3) % cards.size()] + Vector2(0.017, 0.015)
		draw_line(_p(a.x, a.y), _p(b.x, b.y), CLOTH if k % 2 == 0 else Color(0.9, 0.9, 0.88), 1.0)
	# The faces cut out of the Polaroids, top right.
	for k in 3:
		_rect(0.78 + k * 0.05, 0.14, 0.04, 0.05, Color(0.92, 0.92, 0.9))
		_rect(0.79 + k * 0.05, 0.15, 0.02, 0.02, Color(0.5, 0.44, 0.36))
	# The names, bottom left, a line each.
	for k in 4:
		draw_line(_p(0.07, 0.38 + k * 0.025), _p(0.22, 0.38 + k * 0.025), PENCIL, 1.5)
	# The table and the six envelopes.
	_rect(0.34, 0.66, 0.32, 0.04, WOOD)
	_rect(0.36, 0.7, 0.02, 0.18, WOOD_DARK)
	_rect(0.62, 0.7, 0.02, 0.18, WOOD_DARK)
	for k in 6:
		_rect(0.37 + k * 0.045, 0.62, 0.035, 0.04, Color(0.9, 0.86, 0.74))
	# The one chair.
	_rect(0.24, 0.62, 0.06, 0.24, WOOD_DARK)
	# The stove.
	_rect(0.8, 0.56, 0.12, 0.2, IRON)
	_rect(0.83, 0.62, 0.06, 0.06, Color(0.85, 0.3, 0.1))
	_rect(0.85, 0.08, 0.02, 0.48, IRON)

func _draw_cabin_road() -> void:
	# The cabin from the shore path at night: snow, the cabin dark against the
	# trees, a lamp behind the curtain and a shadow at the wall.
	draw_rect(Rect2(Vector2.ZERO, size), Color(0.05, 0.06, 0.1))
	_poly([Vector2(0, 0.62), Vector2(1, 0.58), Vector2(1, 1), Vector2(0, 1)], Color(0.72, 0.76, 0.84))
	for k in 9:
		var x: float = 0.02 + k * 0.12
		_poly([Vector2(x, 0.6), Vector2(x + 0.05, 0.28), Vector2(x + 0.1, 0.6)], Color(0.03, 0.05, 0.06))
	_rect(0.36, 0.38, 0.28, 0.24, Color(0.12, 0.1, 0.09))
	_poly([Vector2(0.33, 0.39), Vector2(0.5, 0.26), Vector2(0.67, 0.39)], Color(0.1, 0.08, 0.07))
	# The curtain, lit; the shadow with one arm up.
	_rect(0.44, 0.44, 0.12, 0.1, Color(0.85, 0.66, 0.36))
	_rect(0.49, 0.46, 0.025, 0.08, Color(0.3, 0.2, 0.12))
	draw_line(_p(0.5, 0.48), _p(0.54, 0.445), Color(0.3, 0.2, 0.12), 3.0)
