class_name Cursors
extends RefCounted

# The game's own mouse cursors, drawn in code: a small pale ring to look
# around with, a bigger bright ring with a dot over something you can click,
# and, with something from your pockets in your hand, a small diamond in the
# middle of each. Hud sets them (and swaps them when you take something out).

const SIZE: int = 32
const CENTER: Vector2 = Vector2(16, 16)
const PALE: Color = Color(0.96, 0.92, 0.82, 0.7)
const BRIGHT: Color = Color(0.98, 0.9, 0.65, 1.0)
const SHADOW: Color = Color(0.0, 0.0, 0.0, 0.75)

# Puts the cursors in place. holding: something from your pockets is in your hand.
static func apply(holding: bool) -> void:
	if DisplayServer.get_name() == "headless":
		return
	Input.set_custom_mouse_cursor(_draw(4.0, PALE, holding), Input.CURSOR_ARROW, CENTER)
	Input.set_custom_mouse_cursor(_draw(9.0, BRIGHT, holding, true), Input.CURSOR_POINTING_HAND, CENTER)

# A ring of this radius, with a dark edge so it shows on pale things too.
static func _draw(radius: float, color: Color, holding: bool, dot: bool = false) -> ImageTexture:
	var image: Image = Image.create(SIZE, SIZE, false, Image.FORMAT_RGBA8)
	image.fill(Color(0, 0, 0, 0))
	for y in SIZE:
		for x in SIZE:
			var at: Vector2 = Vector2(x + 0.5, y + 0.5)
			var d: float = at.distance_to(CENTER)
			var out: Color = Color(0, 0, 0, 0)
			# The shadow ring first, then the ring itself over it.
			out = _over(out, SHADOW, _band(d, radius, 2.4))
			out = _over(out, color, _band(d, radius, 1.1))
			if dot:
				out = _over(out, SHADOW, clampf(2.6 - d, 0.0, 1.0))
				out = _over(out, color, clampf(1.6 - d, 0.0, 1.0))
			if holding:
				# A small diamond: the thing in your hand.
				var k: float = absf(at.x - CENTER.x) + absf(at.y - CENTER.y)
				out = _over(out, SHADOW, clampf(4.2 - k, 0.0, 1.0))
				out = _over(out, BRIGHT, clampf(3.0 - k, 0.0, 1.0))
			image.set_pixel(x, y, out)
	return ImageTexture.create_from_image(image)

# How much of a pixel at distance d falls on a ring of this radius and width.
static func _band(d: float, radius: float, width: float) -> float:
	return clampf(width / 2.0 + 0.5 - absf(d - radius), 0.0, 1.0)

static func _over(under: Color, top: Color, amount: float) -> Color:
	var a: float = top.a * amount
	var alpha: float = a + under.a * (1.0 - a)
	if alpha <= 0.0:
		return Color(0, 0, 0, 0)
	var rgb: Color = (top * a + under * under.a * (1.0 - a)) / alpha
	return Color(rgb.r, rgb.g, rgb.b, alpha)
