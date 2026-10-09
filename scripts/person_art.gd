class_name PersonArt
extends RefCounted

# Placeholder people, drawn in code from story/people.cfg until there are
# paintings: a body in a coat, a head, hair or a hat, eyes and a mouth. Seen
# from behind the counter, so only from the waist up; the bottom of the box
# is the counter's edge. Someone not in people.cfg is drawn as a dark shape.

const PATH: String = "res://story/people.cfg"

static var _file: ConfigFile

static func has(person_id: String) -> bool:
	return _people().has_section(person_id)

static func draw(ci: CanvasItem, person_id: String, r: Rect2, alpha: float = 1.0) -> void:
	var height: float = float(_value(person_id, "height", 0.9))
	var build: float = float(_value(person_id, "build", 1.0))
	var coat: Color = _color(person_id, "coat", "#2a2a30")
	var skin: Color = _color(person_id, "skin", "#d0b0a0")
	var extras: PackedStringArray = str(_value(person_id, "extras", "")).split(",", false)
	if not has(person_id):
		coat = Color(0.04, 0.04, 0.05)
		skin = Color(0.06, 0.06, 0.07)
	var head_r: float = r.size.y * 0.11
	var cx: float = r.get_center().x
	var head: Vector2 = Vector2(cx, r.position.y + r.size.y * (1.0 - height) + head_r)
	var shoulder_y: float = head.y + head_r * 1.55
	var shoulder_w: float = r.size.y * 0.24 * build
	var bottom: float = r.end.y
	var a: float = alpha
	# The body: shoulders down to the counter.
	var body: Array = [
		Vector2(cx - shoulder_w * 0.75, shoulder_y - head_r * 0.15),
		Vector2(cx + shoulder_w * 0.75, shoulder_y - head_r * 0.15),
		Vector2(cx + shoulder_w * 1.05, shoulder_y + head_r * 0.6),
		Vector2(cx + shoulder_w * 1.1, bottom),
		Vector2(cx - shoulder_w * 1.1, bottom),
		Vector2(cx - shoulder_w * 1.05, shoulder_y + head_r * 0.6),
	]
	if extras.has("pregnant"):
		body.insert(3, Vector2(cx + shoulder_w * 1.35, bottom - head_r * 0.8))
	_poly(ci, body, coat, a)
	_draw_style(ci, person_id, cx, shoulder_y, shoulder_w, bottom, head_r, coat, extras, a)
	# The neck, and the head.
	ci.draw_rect(Rect2(Vector2(cx - head_r * 0.35, head.y + head_r * 0.7), Vector2(head_r * 0.7, head_r * 0.8)), Color(skin.darkened(0.12), a))
	_ellipse(ci, head, Vector2(head_r * 0.82, head_r), skin, a)
	_draw_hair(ci, person_id, head, head_r, a)
	_draw_face(ci, person_id, head, head_r, extras, a)
	_draw_hat(ci, person_id, head, head_r, a)

static func _draw_style(ci: CanvasItem, person_id: String, cx: float, shoulder_y: float, w: float, bottom: float, head_r: float, coat: Color, extras: PackedStringArray, a: float) -> void:
	var line: Color = Color(coat.darkened(0.35), a)
	match str(_value(person_id, "style", "coat")):
		"parka":
			# A fur ruff at the collar.
			_ellipse(ci, Vector2(cx, shoulder_y - head_r * 0.1), Vector2(w * 0.85, head_r * 0.35), coat.lightened(0.25), a)
			ci.draw_line(Vector2(cx, shoulder_y + head_r * 0.2), Vector2(cx, bottom), line, 2.0)
		"jacket":
			# Plaid lines.
			for k in 4:
				var y: float = shoulder_y + head_r * 0.6 + k * head_r * 0.7
				ci.draw_line(Vector2(cx - w, y), Vector2(cx + w, y), Color(0.05, 0.05, 0.05, 0.6 * a), 2.0)
			ci.draw_line(Vector2(cx, shoulder_y), Vector2(cx, bottom), line, 2.0)
		"cassock":
			for k in 5:
				ci.draw_circle(Vector2(cx, shoulder_y + head_r * (0.6 + k * 0.55)), 1.5, Color(0.3, 0.3, 0.32, a))
		"uniform":
			# Open parka over a uniform shirt, a badge.
			_poly(ci, [Vector2(cx - w * 0.35, shoulder_y), Vector2(cx + w * 0.35, shoulder_y), Vector2(cx + w * 0.3, bottom), Vector2(cx - w * 0.3, bottom)], Color(0.55, 0.5, 0.38), a)
			_poly(ci, [Vector2(cx - w * 0.22, shoulder_y + head_r * 0.9), Vector2(cx - w * 0.08, shoulder_y + head_r * 0.85), Vector2(cx - w * 0.1, shoulder_y + head_r * 1.2), Vector2(cx - w * 0.2, shoulder_y + head_r * 1.25)], Color(0.8, 0.68, 0.3), a)
		_:
			# Lapels.
			ci.draw_line(Vector2(cx - w * 0.35, shoulder_y), Vector2(cx, shoulder_y + head_r * 1.5), line, 2.0)
			ci.draw_line(Vector2(cx + w * 0.35, shoulder_y), Vector2(cx, shoulder_y + head_r * 1.5), line, 2.0)
	if extras.has("collar"):
		ci.draw_rect(Rect2(Vector2(cx - head_r * 0.25, shoulder_y - head_r * 0.25), Vector2(head_r * 0.5, head_r * 0.25)), Color(0.95, 0.95, 0.92, a))

static func _draw_hair(ci: CanvasItem, person_id: String, head: Vector2, head_r: float, a: float) -> void:
	var color: Color = _color(person_id, "hair_color", "#3a2a1e")
	match str(_value(person_id, "hair", "short")):
		"short":
			_poly(ci, _arc_points(head, head_r * 1.02, PI * 1.05, PI * 1.95), color, a)
		"long":
			_poly(ci, _arc_points(head, head_r * 1.05, PI * 0.95, PI * 2.05), color, a)
			ci.draw_rect(Rect2(head + Vector2(-head_r * 1.0, -head_r * 0.1), Vector2(head_r * 0.3, head_r * 2.0)), Color(color, a))
			ci.draw_rect(Rect2(head + Vector2(head_r * 0.7, -head_r * 0.1), Vector2(head_r * 0.3, head_r * 2.0)), Color(color, a))
		"bun":
			_poly(ci, _arc_points(head, head_r * 1.02, PI * 1.05, PI * 1.95), color, a)
			ci.draw_circle(head + Vector2(0, -head_r * 1.05), head_r * 0.35, Color(color, a))
		"bald":
			ci.draw_rect(Rect2(head + Vector2(-head_r * 0.85, -head_r * 0.2), Vector2(head_r * 0.22, head_r * 0.5)), Color(color, a))
			ci.draw_rect(Rect2(head + Vector2(head_r * 0.63, -head_r * 0.2), Vector2(head_r * 0.22, head_r * 0.5)), Color(color, a))

static func _draw_face(ci: CanvasItem, person_id: String, head: Vector2, head_r: float, extras: PackedStringArray, a: float) -> void:
	var ink: Color = Color(0.08, 0.06, 0.06, a)
	var eye_y: float = head.y - head_r * 0.05
	for side in [-1, 1]:
		var eye: Vector2 = Vector2(head.x + side * head_r * 0.35, eye_y)
		match str(_value(person_id, "eyes", "tired")):
			"tired":
				ci.draw_circle(eye, head_r * 0.08, ink)
				ci.draw_line(eye + Vector2(-head_r * 0.15, -head_r * 0.08), eye + Vector2(head_r * 0.15, -head_r * 0.05), ink, 1.5)
				ci.draw_arc(eye + Vector2(0, head_r * 0.12), head_r * 0.12, 0, PI, 6, Color(0.3, 0.2, 0.2, 0.5 * a), 1.0)
			"sharp":
				ci.draw_line(eye + Vector2(-head_r * 0.14, 0), eye + Vector2(head_r * 0.14, 0), ink, 2.5)
				ci.draw_line(eye + Vector2(-head_r * 0.18, -head_r * 0.16), eye + Vector2(head_r * 0.15, -head_r * 0.2 * side * -0.5 - head_r * 0.1), ink, 1.5)
			"kind":
				ci.draw_arc(eye, head_r * 0.12, PI, TAU, 8, ink, 1.8)
			"down":
				ci.draw_line(eye + Vector2(-head_r * 0.13, head_r * 0.04), eye + Vector2(head_r * 0.13, head_r * 0.04), ink, 2.0)
			"wide":
				ci.draw_circle(eye, head_r * 0.13, Color(0.92, 0.9, 0.86, a))
				ci.draw_circle(eye, head_r * 0.07, ink)
	if extras.has("glasses"):
		for side in [-1, 1]:
			ci.draw_arc(Vector2(head.x + side * head_r * 0.35, eye_y), head_r * 0.2, 0, TAU, 12, Color(0.6, 0.55, 0.4, a), 1.2)
		ci.draw_line(Vector2(head.x - head_r * 0.15, eye_y), Vector2(head.x + head_r * 0.15, eye_y), Color(0.6, 0.55, 0.4, a), 1.2)
	if extras.has("beard"):
		var color: Color = _color(person_id, "hair_color", "#3a2a1e")
		_poly(ci, _arc_points(head + Vector2(0, head_r * 0.15), head_r * 0.85, PI * 0.05, PI * 0.95), color, a)
	var mouth_y: float = head.y + head_r * 0.5
	var mw: float = head_r * 0.28
	match str(_value(person_id, "mouth", "flat")):
		"thin":
			ci.draw_line(Vector2(head.x - mw, mouth_y), Vector2(head.x + mw, mouth_y), ink, 1.2)
		"frown":
			ci.draw_arc(Vector2(head.x, mouth_y + head_r * 0.12), mw, PI * 1.15, PI * 1.85, 8, ink, 1.6)
		"smile":
			ci.draw_arc(Vector2(head.x, mouth_y - head_r * 0.12), mw, PI * 0.15, PI * 0.85, 8, ink, 1.6)
		_:
			ci.draw_line(Vector2(head.x - mw, mouth_y), Vector2(head.x + mw, mouth_y), ink, 2.0)

static func _draw_hat(ci: CanvasItem, person_id: String, head: Vector2, head_r: float, a: float) -> void:
	var color: Color = _color(person_id, "hat_color", "#333333")
	match str(_value(person_id, "hat", "none")):
		"cap":
			_poly(ci, _arc_points(head, head_r * 1.04, PI, TAU), color, a)
			ci.draw_rect(Rect2(head + Vector2(-head_r * 1.1, -head_r * 0.12), Vector2(head_r * 1.3, head_r * 0.18)), Color(color.darkened(0.2), a))
		"toque":
			_poly(ci, _arc_points(head + Vector2(0, -head_r * 0.15), head_r * 1.0, PI, TAU), color, a)
			ci.draw_rect(Rect2(head + Vector2(-head_r * 0.95, -head_r * 0.3), Vector2(head_r * 1.9, head_r * 0.3)), Color(color.darkened(0.15), a))
			ci.draw_circle(head + Vector2(0, -head_r * 1.2), head_r * 0.2, Color(color.lightened(0.2), a))
		"hood":
			_poly(ci, _arc_points(head, head_r * 1.3, PI * 0.85, PI * 2.15), color, a)
			_ellipse(ci, head, Vector2(head_r * 0.82, head_r), _color(person_id, "skin", "#d0b0a0"), a)
			_draw_face(ci, person_id, head, head_r, str(_value(person_id, "extras", "")).split(",", false), a)
		"scarf":
			_poly(ci, _arc_points(head, head_r * 1.12, PI * 0.9, PI * 2.1), color, a)
			_ellipse(ci, head + Vector2(0, head_r * 0.08), Vector2(head_r * 0.7, head_r * 0.82), _color(person_id, "skin", "#d0b0a0"), a)
			_draw_face(ci, person_id, head, head_r, PackedStringArray(), a)
		"fur":
			_ellipse(ci, head + Vector2(0, -head_r * 0.7), Vector2(head_r * 1.1, head_r * 0.55), color, a)
			ci.draw_rect(Rect2(head + Vector2(-head_r * 1.05, -head_r * 0.5), Vector2(head_r * 0.3, head_r * 0.9)), Color(color, a))
			ci.draw_rect(Rect2(head + Vector2(head_r * 0.75, -head_r * 0.5), Vector2(head_r * 0.3, head_r * 0.9)), Color(color, a))

# --- Pieces ---

static func _poly(ci: CanvasItem, points: Array, color: Color, a: float) -> void:
	ci.draw_colored_polygon(PackedVector2Array(points), Color(color, color.a * a))

static func _ellipse(ci: CanvasItem, c: Vector2, radius: Vector2, color: Color, a: float) -> void:
	var points: Array = []
	for i in 24:
		var t: float = TAU * i / 24.0
		points.append(c + Vector2(cos(t) * radius.x, sin(t) * radius.y))
	_poly(ci, points, color, a)

# Points along a circle from one angle to another, closed through the centre
# line: a cap of hair, a hat, a hood.
static func _arc_points(c: Vector2, radius: float, from: float, to: float) -> Array:
	var points: Array = []
	for i in 17:
		var t: float = lerpf(from, to, i / 16.0)
		points.append(c + Vector2(cos(t), sin(t)) * radius)
	return points

static func _value(person_id: String, key: String, fallback: Variant) -> Variant:
	return _people().get_value(person_id, key, fallback)

static func _color(person_id: String, key: String, fallback: String) -> Color:
	return Color.from_string(str(_value(person_id, key, fallback)), Color(fallback))

static func _people() -> ConfigFile:
	if _file == null:
		_file = ConfigFile.new()
		if _file.load(PATH) != OK:
			push_error("Could not load people: " + PATH)
	return _file
