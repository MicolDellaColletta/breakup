class_name ItemArt
extends RefCounted

# Placeholder pictures of the things in the shop, drawn in code until there
# are paintings: one simple shape per kind of object (shape= in stock.cfg).
# Each fits the box it's given, so the same drawing works small on a shelf and
# big in a close-up. A shape this doesn't know is drawn as a wrapped bundle.

const WOOD: Color = Color(0.45, 0.3, 0.17)
const WOOD_DARK: Color = Color(0.3, 0.19, 0.1)
const METAL: Color = Color(0.55, 0.57, 0.6)
const BRASS: Color = Color(0.72, 0.58, 0.28)
const PAPER: Color = Color(0.82, 0.78, 0.68)
const FUR: Color = Color(0.62, 0.32, 0.14)
const DARK: Color = Color(0.06, 0.05, 0.05)

# Draws one object in the box r on ci. faded: it's been picked up, and only its
# ghost is left on the shelf.
static func draw(ci: CanvasItem, shape: String, r: Rect2, faded: bool = false) -> void:
	var c: Vector2 = r.get_center()
	var u: float = minf(r.size.x, r.size.y) / 2.0
	var a: float = 0.25 if faded else 1.0
	match shape:
		"call":
			_poly(ci, [c + Vector2(-u * 0.8, -u * 0.18), c + Vector2(u * 0.5, -u * 0.25), c + Vector2(u * 0.5, u * 0.25), c + Vector2(-u * 0.8, u * 0.18)], WOOD, a)
			_poly(ci, [c + Vector2(u * 0.5, -u * 0.32), c + Vector2(u * 0.85, -u * 0.38), c + Vector2(u * 0.85, u * 0.38), c + Vector2(u * 0.5, u * 0.32)], WOOD_DARK, a)
			ci.draw_line(c + Vector2(-u * 0.4, -u * 0.05), c + Vector2(-u * 0.2, u * 0.05), Color(DARK, a), 1.5)
		"decoy":
			var body: PackedVector2Array = _ellipse(c + Vector2(0, u * 0.2), Vector2(u * 0.85, u * 0.4))
			ci.draw_colored_polygon(body, Color(0.4, 0.33, 0.22, a))
			ci.draw_circle(c + Vector2(u * 0.55, -u * 0.25), u * 0.28, Color(0.18, 0.38, 0.22, a))
			_poly(ci, [c + Vector2(u * 0.78, -u * 0.25), c + Vector2(u * 1.0, -u * 0.18), c + Vector2(u * 0.78, -u * 0.12)], Color(0.75, 0.6, 0.2), a)
			ci.draw_circle(c + Vector2(u * 0.6, -u * 0.32), u * 0.05, Color(DARK, a))
		"knife":
			_poly(ci, [c + Vector2(-u * 0.9, -u * 0.1), c + Vector2(-u * 0.1, -u * 0.12), c + Vector2(-u * 0.1, u * 0.12), c + Vector2(-u * 0.9, u * 0.1)], Color(0.3, 0.2, 0.12), a)
			_poly(ci, [c + Vector2(-u * 0.1, -u * 0.14), c + Vector2(u * 0.6, -u * 0.18), c + Vector2(u * 0.95, -u * 0.02), c + Vector2(u * 0.5, u * 0.12), c + Vector2(-u * 0.1, u * 0.1)], METAL, a)
		"snowshoes":
			for dx in [-0.4, 0.4]:
				var shoe: PackedVector2Array = _ellipse(c + Vector2(u * dx, 0), Vector2(u * 0.32, u * 0.9))
				ci.draw_colored_polygon(shoe, Color(WOOD, a))
				ci.draw_colored_polygon(_ellipse(c + Vector2(u * dx, 0), Vector2(u * 0.24, u * 0.78)), Color(0.75, 0.68, 0.52, a))
				for k in 5:
					var y: float = -u * 0.6 + k * u * 0.3
					ci.draw_line(c + Vector2(u * (dx - 0.22), y), c + Vector2(u * (dx + 0.22), y), Color(WOOD_DARK, a), 1.0)
		"picks":
			for dx in [-0.35, 0.35]:
				_poly(ci, [c + Vector2(u * (dx - 0.15), -u * 0.2), c + Vector2(u * (dx + 0.15), -u * 0.2), c + Vector2(u * (dx + 0.12), u * 0.55), c + Vector2(u * (dx - 0.12), u * 0.55)], Color(0.75, 0.3, 0.12), a)
				ci.draw_line(c + Vector2(u * dx, -u * 0.2), c + Vector2(u * dx, -u * 0.55), Color(METAL, a), 3.0)
			ci.draw_arc(c + Vector2(0, u * 0.55), u * 0.35, 0, PI, 16, Color(0.8, 0.78, 0.7, a), 1.5)
		"compass":
			ci.draw_circle(c, u * 0.7, Color(BRASS, a))
			ci.draw_circle(c, u * 0.58, Color(0.85, 0.82, 0.72, a))
			_poly(ci, [c + Vector2(0, -u * 0.5), c + Vector2(u * 0.08, 0), c + Vector2(0, u * 0.08), c + Vector2(-u * 0.08, 0)], Color(0.7, 0.1, 0.1), a)
			_poly(ci, [c + Vector2(0, u * 0.5), c + Vector2(u * 0.08, 0), c + Vector2(0, -u * 0.08), c + Vector2(-u * 0.08, 0)], Color(0.2, 0.2, 0.22), a)
			ci.draw_circle(c + Vector2(0, -u * 0.78), u * 0.1, Color(BRASS, a))
		"fox":
			_poly(ci, [c + Vector2(-u * 0.6, u * 0.7), c + Vector2(-u * 0.5, -u * 0.05), c + Vector2(u * 0.25, -u * 0.15), c + Vector2(u * 0.45, u * 0.7)], FUR, a)
			_poly(ci, [c + Vector2(u * 0.1, -u * 0.1), c + Vector2(u * 0.35, -u * 0.75), c + Vector2(u * 0.55, -u * 0.35), c + Vector2(u * 0.95, -u * 0.25), c + Vector2(u * 0.5, -u * 0.0)], FUR, a)
			_poly(ci, [c + Vector2(u * 0.35, -u * 0.75), c + Vector2(u * 0.42, -u * 0.95), c + Vector2(u * 0.5, -u * 0.62)], FUR.darkened(0.3), a)
			_poly(ci, [c + Vector2(-u * 0.55, u * 0.4), c + Vector2(-u * 1.0, u * 0.1), c + Vector2(-u * 0.9, u * 0.55)], FUR, a)
			ci.draw_circle(c + Vector2(-u * 0.95, u * 0.15), u * 0.08, Color(0.92, 0.9, 0.85, a))
			# One glass eye set a little wrong.
			ci.draw_circle(c + Vector2(u * 0.55, -u * 0.38), u * 0.06, Color(0.9, 0.7, 0.2, a))
		"rifle":
			_poly(ci, [c + Vector2(-u, u * 0.05), c + Vector2(-u * 0.45, -u * 0.05), c + Vector2(-u * 0.4, u * 0.08), c + Vector2(-u * 0.85, u * 0.3)], WOOD, a)
			ci.draw_line(c + Vector2(-u * 0.45, 0), c + Vector2(u, -u * 0.12), Color(0.2, 0.2, 0.22, a), maxf(2.0, u * 0.08))
		"tin":
			_poly(ci, [c + Vector2(-u * 0.65, -u * 0.35), c + Vector2(u * 0.65, -u * 0.35), c + Vector2(u * 0.65, u * 0.45), c + Vector2(-u * 0.65, u * 0.45)], Color(0.45, 0.5, 0.48), a)
			_poly(ci, [c + Vector2(-u * 0.7, -u * 0.45), c + Vector2(u * 0.7, -u * 0.45), c + Vector2(u * 0.7, -u * 0.3), c + Vector2(-u * 0.7, -u * 0.3)], Color(0.55, 0.6, 0.58), a)
			ci.draw_arc(c + Vector2(0, u * 0.45), u * 0.1, 0, PI, 8, Color(BRASS, a), 2.0)
			ci.draw_rect(Rect2(c + Vector2(-u * 0.07, u * 0.5), Vector2(u * 0.14, u * 0.14)), Color(BRASS, a))
			# The tag, on its string.
			ci.draw_line(c + Vector2(u * 0.6, -u * 0.3), c + Vector2(u * 0.85, u * 0.1), Color(0.6, 0.55, 0.45, a), 1.0)
			ci.draw_rect(Rect2(c + Vector2(u * 0.75, u * 0.1), Vector2(u * 0.22, u * 0.3)), Color(PAPER, a))
		"coins":
			for k in 6:
				ci.draw_circle(c + Vector2((k % 3 - 1) * u * 0.42, (k / 3) * u * 0.38 - u * 0.1), u * 0.22, Color(0.75, 0.76, 0.78, a))
				ci.draw_arc(c + Vector2((k % 3 - 1) * u * 0.42, (k / 3) * u * 0.38 - u * 0.1), u * 0.17, 0, TAU, 16, Color(0.5, 0.52, 0.55, a), 1.0)
		"box":
			_poly(ci, [c + Vector2(-u * 0.55, -u * 0.35), c + Vector2(u * 0.55, -u * 0.35), c + Vector2(u * 0.55, u * 0.4), c + Vector2(-u * 0.55, u * 0.4)], Color(0.6, 0.25, 0.15), a)
			ci.draw_rect(Rect2(c + Vector2(-u * 0.4, -u * 0.1), Vector2(u * 0.8, u * 0.25)), Color(0.9, 0.85, 0.7, a))
		"name":
			# A slip of paper with writing on it you can't read.
			_poly(ci, [c + Vector2(-u * 0.7, -u * 0.3), c + Vector2(u * 0.7, -u * 0.36), c + Vector2(u * 0.72, u * 0.3), c + Vector2(-u * 0.68, u * 0.34)], PAPER, a)
			for k in 2:
				ci.draw_line(c + Vector2(-u * 0.5, -u * 0.08 + k * u * 0.2), c + Vector2(u * (0.4 - k * 0.3), -u * 0.1 + k * u * 0.2), Color(0.25, 0.2, 0.2, a * 0.35), 1.5)
		"jacket":
			_poly(ci, [c + Vector2(-u * 0.35, -u * 0.8), c + Vector2(u * 0.35, -u * 0.8), c + Vector2(u * 0.85, -u * 0.4), c + Vector2(u * 0.65, u * 0.85), c + Vector2(-u * 0.65, u * 0.85), c + Vector2(-u * 0.85, -u * 0.4)], Color(0.4, 0.36, 0.2), a)
			ci.draw_line(c + Vector2(0, -u * 0.8), c + Vector2(0, u * 0.85), Color(0.25, 0.22, 0.12, a), 2.0)
		_:
			_poly(ci, [c + Vector2(-u * 0.6, -u * 0.4), c + Vector2(u * 0.6, -u * 0.45), c + Vector2(u * 0.65, u * 0.45), c + Vector2(-u * 0.62, u * 0.42)], Color(0.5, 0.45, 0.38), a)
			ci.draw_line(c + Vector2(-u * 0.6, 0), c + Vector2(u * 0.65, 0), Color(0.3, 0.26, 0.2, a), 2.0)

static func _poly(ci: CanvasItem, points: Array, color: Color, a: float) -> void:
	ci.draw_colored_polygon(PackedVector2Array(points), Color(color, color.a * a))

static func _ellipse(c: Vector2, radius: Vector2) -> PackedVector2Array:
	var points: PackedVector2Array = PackedVector2Array()
	for i in 24:
		var t: float = TAU * i / 24.0
		points.append(c + Vector2(cos(t) * radius.x, sin(t) * radius.y))
	return points
