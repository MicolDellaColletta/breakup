class_name ItemArt
extends RefCounted

# Placeholder pictures of the things in the shop, drawn in code until there
# are paintings: one simple shape per kind of object (shape= in stock.cfg):
# call, decoy, knife, snowshoes, picks, compass, fox, rifle, tin, coins, box,
# name, jacket, musicbox, mirror, watch, jar, braid, shells, bible, spectacles,
# button, clapper, microphone, collar, bullet, batteries, lantern, radio,
# thermos, trap, scarf, globe, book, mitten, camera, tackle, skull, envelopes,
# plate.
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
			# Lying across the box, stock left: wood stock and fore-end, the
			# barrel and the scope, the trigger guard, the bolt.
			var w: float = r.size.x / 2.0 * 0.95
			var gun: Color = Color(0.42, 0.43, 0.46)
			_poly(ci, [c + Vector2(-w, -u * 0.02), c + Vector2(-w * 0.45, -u * 0.12), c + Vector2(-w * 0.3, -u * 0.12), c + Vector2(-w * 0.3, u * 0.06), c + Vector2(-w * 0.5, u * 0.08), c + Vector2(-w * 0.95, u * 0.3)], WOOD, a)
			_poly(ci, [c + Vector2(-w * 0.3, -u * 0.1), c + Vector2(w * 0.35, -u * 0.12), c + Vector2(w * 0.35, -u * 0.02), c + Vector2(-w * 0.3, u * 0.04)], WOOD_DARK, a)
			ci.draw_line(c + Vector2(-w * 0.3, -u * 0.13), c + Vector2(w, -u * 0.15), Color(gun, a), maxf(2.0, u * 0.07))
			ci.draw_rect(Rect2(c + Vector2(-w * 0.32, -u * 0.32), Vector2(w * 0.42, u * 0.11)), Color(gun.darkened(0.3), a))
			ci.draw_arc(c + Vector2(-w * 0.3, u * 0.08), u * 0.1, 0, PI, 8, Color(gun, a), 2.0)
			ci.draw_line(c + Vector2(-w * 0.18, -u * 0.13), c + Vector2(-w * 0.12, u * 0.04), Color(METAL, a), 2.0)
		"shells":
			# A small cardboard box of .22s, lid off: rows of brass rims.
			_poly(ci, [c + Vector2(-u * 0.6, -u * 0.35), c + Vector2(u * 0.6, -u * 0.35), c + Vector2(u * 0.6, u * 0.45), c + Vector2(-u * 0.6, u * 0.45)], Color(0.62, 0.22, 0.14), a)
			ci.draw_rect(Rect2(c + Vector2(-u * 0.5, -u * 0.27), Vector2(u * 1.0, u * 0.36)), Color(0.12, 0.1, 0.08, a))
			for k in 10:
				ci.draw_circle(c + Vector2(-u * 0.4 + (k % 5) * u * 0.2, -u * 0.18 + (k / 5) * u * 0.18), u * 0.07, Color(BRASS, a))
			ci.draw_rect(Rect2(c + Vector2(-u * 0.45, u * 0.18), Vector2(u * 0.9, u * 0.16)), Color(0.9, 0.85, 0.7, a))
			# The slip under the rubber band.
			ci.draw_line(c + Vector2(-u * 0.6, u * 0.12), c + Vector2(u * 0.6, u * 0.12), Color(0.55, 0.4, 0.3, a), 2.0)
		"bible":
			# A thick black book, a ribbon, and a dark notch where pages are cut.
			_poly(ci, [c + Vector2(-u * 0.55, -u * 0.7), c + Vector2(u * 0.5, -u * 0.7), c + Vector2(u * 0.55, u * 0.7), c + Vector2(-u * 0.5, u * 0.7)], Color(0.16, 0.14, 0.14), a)
			_poly(ci, [c + Vector2(u * 0.5, -u * 0.66), c + Vector2(u * 0.62, -u * 0.62), c + Vector2(u * 0.66, u * 0.66), c + Vector2(u * 0.55, u * 0.7)], Color(0.82, 0.78, 0.66), a)
			_poly(ci, [c + Vector2(u * 0.56, -u * 0.1), c + Vector2(u * 0.64, -u * 0.08), c + Vector2(u * 0.65, u * 0.12), c + Vector2(u * 0.57, u * 0.1)], DARK, a)
			ci.draw_line(c + Vector2(-u * 0.1, -u * 0.45), c + Vector2(-u * 0.1, -u * 0.05), Color(BRASS, a), 2.0)
			ci.draw_line(c + Vector2(-u * 0.28, -u * 0.3), c + Vector2(u * 0.08, -u * 0.3), Color(BRASS, a), 2.0)
			ci.draw_line(c + Vector2(u * 0.2, u * 0.7), c + Vector2(u * 0.25, u * 0.95), Color(0.6, 0.12, 0.1, a), 3.0)
		"spectacles":
			# Wire frames, one arm bent.
			var wire: Color = Color(0.55, 0.5, 0.42, a)
			for dx in [-0.42, 0.42]:
				ci.draw_circle(c + Vector2(u * dx, 0), u * 0.3, Color(0.75, 0.82, 0.86, 0.35 * a))
				ci.draw_arc(c + Vector2(u * dx, 0), u * 0.3, 0, TAU, 20, wire, 2.0)
			ci.draw_arc(c + Vector2(0, u * 0.02), u * 0.13, PI * 1.1, PI * 1.9, 8, wire, 2.0)
			ci.draw_line(c + Vector2(-u * 0.72, -u * 0.05), c + Vector2(-u * 0.95, u * 0.15), wire, 2.0)
			ci.draw_line(c + Vector2(u * 0.72, -u * 0.05), c + Vector2(u * 0.88, -u * 0.35), wire, 2.0)
		"button":
			# One big brass coat button, four holes, a scrap of wool on the shank.
			ci.draw_circle(c, u * 0.5, Color(BRASS, a))
			ci.draw_arc(c, u * 0.4, 0, TAU, 24, Color(BRASS.darkened(0.3), a), 2.0)
			for k in 4:
				ci.draw_circle(c + Vector2((k % 2 - 0.5) * u * 0.24, (k / 2 - 0.5) * u * 0.24), u * 0.06, Color(DARK, a))
			_poly(ci, [c + Vector2(u * 0.35, u * 0.35), c + Vector2(u * 0.75, u * 0.45), c + Vector2(u * 0.6, u * 0.75), c + Vector2(u * 0.3, u * 0.55)], Color(0.45, 0.32, 0.2), a)
		"clapper":
			# The church bell's iron clapper: a ring at the top, a long shaft,
			# a heavy ball at the end.
			var iron: Color = Color(0.3, 0.28, 0.27)
			ci.draw_arc(c + Vector2(0, -u * 0.72), u * 0.14, 0, TAU, 12, Color(iron, a), maxf(2.0, u * 0.06))
			_poly(ci, [c + Vector2(-u * 0.06, -u * 0.6), c + Vector2(u * 0.06, -u * 0.6), c + Vector2(u * 0.1, u * 0.4), c + Vector2(-u * 0.1, u * 0.4)], iron, a)
			ci.draw_colored_polygon(_ellipse(c + Vector2(0, u * 0.58), Vector2(u * 0.26, u * 0.3)), Color(iron, a))
			ci.draw_circle(c + Vector2(-u * 0.08, u * 0.5), u * 0.06, Color(0.5, 0.45, 0.42, a))
		"microphone":
			# An old desk microphone, half melted: a round grille on a stand,
			# slumped on one side, the cord a black stub.
			var chrome: Color = Color(0.55, 0.55, 0.57)
			ci.draw_rect(Rect2(c + Vector2(-u * 0.45, u * 0.6), Vector2(u * 0.9, u * 0.15)), Color(0.35, 0.35, 0.37, a))
			ci.draw_line(c + Vector2(0, u * 0.6), c + Vector2(0, u * 0.05), Color(chrome, a), maxf(2.0, u * 0.08))
			_poly(ci, [c + Vector2(-u * 0.35, -u * 0.55), c + Vector2(u * 0.3, -u * 0.6), c + Vector2(u * 0.4, -u * 0.1), c + Vector2(u * 0.15, u * 0.15), c + Vector2(-u * 0.2, u * 0.05), c + Vector2(-u * 0.45, u * 0.2)], chrome, a)
			for k in 4:
				ci.draw_line(c + Vector2(-u * 0.28, -u * 0.42 + k * u * 0.13), c + Vector2(u * 0.28, -u * 0.45 + k * u * 0.13), Color(0.28, 0.28, 0.3, a), 1.0)
			ci.draw_line(c + Vector2(u * 0.45, u * 0.68), c + Vector2(u * 0.8, u * 0.6), Color(DARK, a), maxf(2.0, u * 0.07))
		"collar":
			# A white clerical collar, folded once: a band, yellowed inside.
			ci.draw_arc(c + Vector2(0, -u * 0.05), u * 0.55, PI * 0.05, PI * 0.95, 20, Color(0.93, 0.92, 0.88, a), maxf(3.0, u * 0.2))
			ci.draw_arc(c + Vector2(0, -u * 0.05), u * 0.45, PI * 0.15, PI * 0.85, 16, Color(0.85, 0.78, 0.5, a), maxf(1.5, u * 0.05))
			ci.draw_rect(Rect2(c + Vector2(-u * 0.12, u * 0.42), Vector2(u * 0.24, u * 0.12)), Color(0.93, 0.92, 0.88, a))
		"bullet":
			# A revolver bullet, flattened: a mushroomed lead head, a short base.
			_poly(ci, [c + Vector2(-u * 0.2, u * 0.1), c + Vector2(u * 0.2, u * 0.1), c + Vector2(u * 0.18, u * 0.55), c + Vector2(-u * 0.18, u * 0.55)], Color(0.62, 0.55, 0.4), a)
			_poly(ci, [c + Vector2(-u * 0.5, u * 0.12), c + Vector2(-u * 0.35, -u * 0.25), c + Vector2(-u * 0.05, -u * 0.38), c + Vector2(u * 0.3, -u * 0.3), c + Vector2(u * 0.55, -u * 0.05), c + Vector2(u * 0.4, u * 0.15)], Color(0.5, 0.5, 0.53), a)
			ci.draw_line(c + Vector2(-u * 0.25, -u * 0.1), c + Vector2(u * 0.2, -u * 0.18), Color(0.32, 0.32, 0.34, a), 1.5)
		"scarf":
			# A grey wool scarf, folded in a loose S, fringed at the ends.
			var wool: Color = Color(0.55, 0.55, 0.58)
			_poly(ci, [c + Vector2(-u * 0.7, -u * 0.5), c + Vector2(u * 0.6, -u * 0.6), c + Vector2(u * 0.65, -u * 0.25), c + Vector2(-u * 0.65, -u * 0.15)], wool, a)
			_poly(ci, [c + Vector2(-u * 0.65, -u * 0.15), c + Vector2(u * 0.6, -u * 0.05), c + Vector2(u * 0.55, u * 0.3), c + Vector2(-u * 0.7, u * 0.2)], wool.darkened(0.15), a)
			_poly(ci, [c + Vector2(-u * 0.7, u * 0.2), c + Vector2(u * 0.55, u * 0.3), c + Vector2(u * 0.6, u * 0.62), c + Vector2(-u * 0.6, u * 0.55)], wool, a)
			for k in 6:
				ci.draw_line(c + Vector2(u * (0.6 + k * 0.0), u * (0.32 + k * 0.05)), c + Vector2(u * 0.78, u * (0.34 + k * 0.05)), Color(wool, a), 1.5)
		"globe":
			# A snow globe: the glass ball, a pine and a little red-signed shop,
			# on a dark base.
			ci.draw_rect(Rect2(c + Vector2(-u * 0.45, u * 0.45), Vector2(u * 0.9, u * 0.3)), Color(0.2, 0.15, 0.1, a))
			ci.draw_circle(c + Vector2(0, -u * 0.05), u * 0.55, Color(0.75, 0.85, 0.95, 0.35 * a))
			ci.draw_rect(Rect2(c + Vector2(-u * 0.4, u * 0.2), Vector2(u * 0.8, u * 0.2)), Color(0.9, 0.92, 0.95, a))
			_poly(ci, [c + Vector2(-u * 0.25, u * 0.2), c + Vector2(-u * 0.12, -u * 0.25), c + Vector2(0.0, u * 0.2)], Color(0.15, 0.35, 0.2), a)
			ci.draw_rect(Rect2(c + Vector2(u * 0.05, u * 0.02), Vector2(u * 0.22, u * 0.18)), Color(0.35, 0.25, 0.18, a))
			ci.draw_rect(Rect2(c + Vector2(u * 0.05, -u * 0.02), Vector2(u * 0.22, u * 0.04)), Color(0.85, 0.15, 0.15, a))
			for k in 7:
				ci.draw_circle(c + Vector2(((k * 37) % 9 - 4) * u * 0.1, ((k * 23) % 7 - 4) * u * 0.1), u * 0.025, Color(1, 1, 1, a))
		"book":
			# A hymnal: dark blue cloth, a scorched corner, pencil slips sticking out.
			_poly(ci, [c + Vector2(-u * 0.5, -u * 0.65), c + Vector2(u * 0.5, -u * 0.65), c + Vector2(u * 0.5, u * 0.65), c + Vector2(-u * 0.5, u * 0.65)], Color(0.15, 0.2, 0.35), a)
			_poly(ci, [c + Vector2(u * 0.2, -u * 0.65), c + Vector2(u * 0.5, -u * 0.65), c + Vector2(u * 0.5, -u * 0.35)], Color(0.08, 0.06, 0.05), a)
			ci.draw_rect(Rect2(c + Vector2(-u * 0.3, -u * 0.3), Vector2(u * 0.5, u * 0.08)), Color(BRASS, a))
			for k in 3:
				ci.draw_rect(Rect2(c + Vector2(-u * 0.3 + k * u * 0.25, -u * 0.8), Vector2(u * 0.06, u * 0.18)), Color(PAPER, a))
		"mitten":
			# A child's red knitted mitten, the thumb worn through.
			var red: Color = Color(0.7, 0.15, 0.12)
			ci.draw_colored_polygon(_ellipse(c + Vector2(0, -u * 0.1), Vector2(u * 0.35, u * 0.5)), Color(red, a))
			ci.draw_colored_polygon(_ellipse(c + Vector2(u * 0.38, u * 0.05), Vector2(u * 0.14, u * 0.22)), Color(red, a))
			ci.draw_circle(c + Vector2(u * 0.42, -u * 0.08), u * 0.05, Color(DARK, a))
			ci.draw_rect(Rect2(c + Vector2(-u * 0.32, u * 0.32), Vector2(u * 0.64, u * 0.3)), Color(0.85, 0.82, 0.75, a))
			for k in 5:
				ci.draw_line(c + Vector2(-u * 0.26 + k * u * 0.13, u * 0.34), c + Vector2(-u * 0.26 + k * u * 0.13, u * 0.6), Color(0.7, 0.66, 0.6, a), 1.0)
		"camera":
			# An Instamatic: a flat black body, the lens, the flash cube on top.
			ci.draw_rect(Rect2(c + Vector2(-u * 0.7, -u * 0.25), Vector2(u * 1.4, u * 0.6)), Color(0.12, 0.12, 0.13, a))
			ci.draw_rect(Rect2(c + Vector2(-u * 0.7, -u * 0.25), Vector2(u * 1.4, u * 0.12)), Color(0.6, 0.6, 0.62, a))
			ci.draw_circle(c + Vector2(-u * 0.15, u * 0.08), u * 0.2, Color(0.3, 0.3, 0.32, a))
			ci.draw_circle(c + Vector2(-u * 0.15, u * 0.08), u * 0.11, Color(0.15, 0.2, 0.3, a))
			ci.draw_rect(Rect2(c + Vector2(u * 0.3, -u * 0.55), Vector2(u * 0.3, u * 0.3)), Color(0.85, 0.88, 0.9, a))
			ci.draw_rect(Rect2(c + Vector2(u * 0.35, u * 0.0), Vector2(u * 0.2, u * 0.12)), Color(0.4, 0.4, 0.42, a))
		"tackle":
			# A green steel tackle box, the lid up, the trays cantilevered out.
			var green: Color = Color(0.22, 0.4, 0.28)
			ci.draw_rect(Rect2(c + Vector2(-u * 0.7, u * 0.05), Vector2(u * 1.4, u * 0.5)), Color(green, a))
			_poly(ci, [c + Vector2(-u * 0.7, u * 0.05), c + Vector2(u * 0.7, u * 0.05), c + Vector2(u * 0.55, -u * 0.25), c + Vector2(-u * 0.55, -u * 0.25)], Color(0.5, 0.5, 0.52), a)
			for k in 5:
				ci.draw_circle(c + Vector2(-u * 0.45 + k * u * 0.22, -u * 0.1), u * 0.04, Color([Color(0.85, 0.2, 0.15), Color(0.9, 0.8, 0.2), Color(0.8, 0.8, 0.85)][k % 3], a))
			ci.draw_rect(Rect2(c + Vector2(-u * 0.12, u * 0.2), Vector2(u * 0.24, u * 0.08)), Color(METAL, a))
		"skull":
			# A wolf skull in profile: the long snout, the eye socket, the teeth.
			var bone: Color = Color(0.85, 0.82, 0.72)
			_poly(ci, [c + Vector2(-u * 0.75, -u * 0.25), c + Vector2(-u * 0.2, -u * 0.4), c + Vector2(u * 0.85, -u * 0.05), c + Vector2(u * 0.85, u * 0.08), c + Vector2(-u * 0.2, u * 0.15), c + Vector2(-u * 0.75, u * 0.15)], bone, a)
			ci.draw_circle(c + Vector2(-u * 0.25, -u * 0.12), u * 0.11, Color(DARK, a))
			ci.draw_circle(c + Vector2(-u * 0.6, -u * 0.25), u * 0.04, Color(DARK, a))
			for k in 6:
				_poly(ci, [c + Vector2(u * (0.0 + k * 0.13), u * 0.1), c + Vector2(u * (0.06 + k * 0.13), u * 0.1), c + Vector2(u * (0.03 + k * 0.13), u * (0.22 if k == 4 else 0.16))], bone, a)
		"envelopes":
			# A bundle of cream envelopes in a rubber band, the top one typed.
			for k in 4:
				ci.draw_rect(Rect2(c + Vector2(-u * 0.65 + k * u * 0.03, -u * 0.35 + k * u * 0.05), Vector2(u * 1.2, u * 0.7)), Color(0.88, 0.84, 0.72, a))
				ci.draw_rect(Rect2(c + Vector2(-u * 0.65 + k * u * 0.03, -u * 0.35 + k * u * 0.05), Vector2(u * 1.2, u * 0.7)), Color(0.6, 0.55, 0.45, a), false, 1.0)
			ci.draw_line(c + Vector2(-u * 0.2, -u * 0.25), c + Vector2(u * 0.4, -u * 0.25), Color(0.25, 0.22, 0.2, a), 1.5)
			ci.draw_line(c + Vector2(u * 0.0, -u * 0.4), c + Vector2(u * 0.05, u * 0.55), Color(0.6, 0.3, 0.2, a), 3.0)
		"plate":
			# A brass collection plate, full: rings, folded papers, a key.
			ci.draw_colored_polygon(_ellipse(c, Vector2(u * 0.85, u * 0.45)), Color(BRASS, a))
			ci.draw_colored_polygon(_ellipse(c, Vector2(u * 0.65, u * 0.32)), Color(BRASS.darkened(0.25), a))
			ci.draw_rect(Rect2(c + Vector2(-u * 0.45, -u * 0.15), Vector2(u * 0.35, u * 0.2)), Color(PAPER, a))
			ci.draw_rect(Rect2(c + Vector2(-u * 0.05, -u * 0.05), Vector2(u * 0.3, u * 0.18)), Color(PAPER.darkened(0.1), a))
			for k in 3:
				ci.draw_arc(c + Vector2(u * (0.3 + k * 0.08), u * (-0.08 + k * 0.06)), u * 0.06, 0, TAU, 10, Color(0.85, 0.75, 0.35, a), 2.0)
			ci.draw_line(c + Vector2(-u * 0.3, u * 0.15), c + Vector2(-u * 0.05, u * 0.2), Color(METAL, a), 2.0)
		"lantern":
			# A green camp lantern: the tank, the glass globe with two mantles,
			# the vented cap and the bail handle.
			var green: Color = Color(0.2, 0.4, 0.25)
			ci.draw_colored_polygon(_ellipse(c + Vector2(0, u * 0.6), Vector2(u * 0.42, u * 0.16)), Color(green, a))
			ci.draw_rect(Rect2(c + Vector2(-u * 0.38, u * 0.3), Vector2(u * 0.76, u * 0.3)), Color(green, a))
			ci.draw_rect(Rect2(c + Vector2(-u * 0.24, -u * 0.25), Vector2(u * 0.48, u * 0.55)), Color(0.85, 0.85, 0.75, 0.45 * a))
			for dx in [-0.08, 0.08]:
				ci.draw_circle(c + Vector2(u * dx, u * 0.0), u * 0.07, Color(0.95, 0.92, 0.8, a))
			_poly(ci, [c + Vector2(-u * 0.32, -u * 0.25), c + Vector2(u * 0.32, -u * 0.25), c + Vector2(u * 0.12, -u * 0.45), c + Vector2(-u * 0.12, -u * 0.45)], green, a)
			ci.draw_arc(c + Vector2(0, -u * 0.45), u * 0.38, PI, TAU, 16, Color(METAL, a), 2.0)
		"radio":
			# A CB set: a squat box, a dial, the knobs, the mic on its curly cord.
			ci.draw_rect(Rect2(c + Vector2(-u * 0.75, -u * 0.25), Vector2(u * 1.25, u * 0.55)), Color(0.18, 0.18, 0.2, a))
			ci.draw_rect(Rect2(c + Vector2(-u * 0.65, -u * 0.15), Vector2(u * 0.45, u * 0.2)), Color(0.75, 0.55, 0.2, a))
			for k in 3:
				ci.draw_circle(c + Vector2(u * (0.0 + k * 0.17), u * 0.05), u * 0.06, Color(0.6, 0.6, 0.62, a))
			ci.draw_rect(Rect2(c + Vector2(-u * 0.55, u * 0.12), Vector2(u * 0.3, u * 0.08)), Color(0.85, 0.8, 0.65, a))
			for k in 6:
				ci.draw_arc(c + Vector2(u * (0.55 + k * 0.05), u * (0.1 + k * 0.06)), u * 0.05, 0, TAU, 8, Color(0.1, 0.1, 0.1, a), 1.5)
			ci.draw_rect(Rect2(c + Vector2(u * 0.75, u * 0.35), Vector2(u * 0.2, u * 0.32)), Color(0.15, 0.15, 0.16, a))
		"thermos":
			# A green steel flask, the cup on top, a dent in the side.
			var paint: Color = Color(0.25, 0.42, 0.3)
			ci.draw_rect(Rect2(c + Vector2(-u * 0.22, -u * 0.55), Vector2(u * 0.44, u * 1.35)), Color(paint, a))
			ci.draw_rect(Rect2(c + Vector2(-u * 0.25, -u * 0.8), Vector2(u * 0.5, u * 0.27)), Color(paint.darkened(0.25), a))
			ci.draw_rect(Rect2(c + Vector2(-u * 0.22, -u * 0.1), Vector2(u * 0.44, u * 0.12)), Color(0.6, 0.62, 0.64, a))
			ci.draw_colored_polygon(_ellipse(c + Vector2(u * 0.1, u * 0.35), Vector2(u * 0.08, u * 0.12)), Color(paint.darkened(0.35), a))
		"trap":
			# A leg-hold trap from above, set: the jaws open in a ring, the pan,
			# the springs either side, the chain.
			var steel: Color = Color(0.45, 0.43, 0.4)
			ci.draw_arc(c, u * 0.45, 0, TAU, 24, Color(steel, a), maxf(2.0, u * 0.07))
			ci.draw_circle(c, u * 0.14, Color(steel.darkened(0.2), a))
			for side in [-1.0, 1.0]:
				_poly(ci, [c + Vector2(side * u * 0.45, -u * 0.08), c + Vector2(side * u * 0.95, -u * 0.05), c + Vector2(side * u * 0.95, u * 0.05), c + Vector2(side * u * 0.45, u * 0.08)], steel, a)
			for k in 4:
				ci.draw_arc(c + Vector2(0, u * (0.55 + k * 0.1)), u * 0.05, 0, TAU, 8, Color(steel, a), 1.5)
		"batteries":
			# A card of D-cells, two of them gone.
			ci.draw_rect(Rect2(c + Vector2(-u * 0.7, -u * 0.7), Vector2(u * 1.4, u * 1.4)), Color(0.85, 0.8, 0.3, a))
			for k in 4:
				var x: float = -u * 0.55 + k * u * 0.3
				if k == 1 or k == 2:
					ci.draw_rect(Rect2(c + Vector2(x, -u * 0.45), Vector2(u * 0.22, u * 0.9)), Color(0.6, 0.55, 0.2, a), false, 1.0)
					continue
				ci.draw_rect(Rect2(c + Vector2(x, -u * 0.45), Vector2(u * 0.22, u * 0.9)), Color(0.15, 0.15, 0.16, a))
				ci.draw_rect(Rect2(c + Vector2(x, -u * 0.45), Vector2(u * 0.22, u * 0.3)), Color(0.75, 0.55, 0.15, a))
				ci.draw_rect(Rect2(c + Vector2(x + u * 0.07, -u * 0.52), Vector2(u * 0.08, u * 0.07)), Color(METAL, a))
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
		"braid":
			# A plait, tied with red wool at both ends.
			for k in 6:
				var y: float = -u * 0.7 + k * u * 0.24
				ci.draw_colored_polygon(_ellipse(c + Vector2((k % 2 - 0.5) * u * 0.12, y), Vector2(u * 0.16, u * 0.14)), Color(0.85, 0.74, 0.45, a))
			ci.draw_rect(Rect2(c + Vector2(-u * 0.1, -u * 0.86), Vector2(u * 0.2, u * 0.07)), Color(0.7, 0.12, 0.1, a))
			ci.draw_rect(Rect2(c + Vector2(-u * 0.1, u * 0.62), Vector2(u * 0.2, u * 0.07)), Color(0.7, 0.12, 0.1, a))
		"jar":
			# A small glass jar, full of little twists of paper.
			ci.draw_rect(Rect2(c + Vector2(-u * 0.32, -u * 0.62), Vector2(u * 0.64, u * 0.14)), Color(METAL, a))
			_poly(ci, [c + Vector2(-u * 0.4, -u * 0.48), c + Vector2(u * 0.4, -u * 0.48), c + Vector2(u * 0.42, u * 0.6), c + Vector2(-u * 0.42, u * 0.6)], Color(0.7, 0.78, 0.8, 0.35), a)
			for k in 7:
				ci.draw_circle(c + Vector2(((k * 37) % 7 - 3) * u * 0.1, u * 0.45 - (k / 2) * u * 0.16), u * 0.09, Color(0.92, 0.9, 0.84, a))
		"box":
			_poly(ci, [c + Vector2(-u * 0.55, -u * 0.35), c + Vector2(u * 0.55, -u * 0.35), c + Vector2(u * 0.55, u * 0.4), c + Vector2(-u * 0.55, u * 0.4)], Color(0.6, 0.25, 0.15), a)
			ci.draw_rect(Rect2(c + Vector2(-u * 0.4, -u * 0.1), Vector2(u * 0.8, u * 0.25)), Color(0.9, 0.85, 0.7, a))
		"name":
			# A slip of paper with writing on it you can't read.
			_poly(ci, [c + Vector2(-u * 0.7, -u * 0.3), c + Vector2(u * 0.7, -u * 0.36), c + Vector2(u * 0.72, u * 0.3), c + Vector2(-u * 0.68, u * 0.34)], PAPER, a)
			for k in 2:
				ci.draw_line(c + Vector2(-u * 0.5, -u * 0.08 + k * u * 0.2), c + Vector2(u * (0.4 - k * 0.3), -u * 0.1 + k * u * 0.2), Color(0.25, 0.2, 0.2, a * 0.35), 1.5)
		"musicbox":
			_poly(ci, [c + Vector2(-u * 0.7, -u * 0.25), c + Vector2(u * 0.7, -u * 0.25), c + Vector2(u * 0.7, u * 0.4), c + Vector2(-u * 0.7, u * 0.4)], WOOD, a)
			_poly(ci, [c + Vector2(-u * 0.74, -u * 0.38), c + Vector2(u * 0.74, -u * 0.38), c + Vector2(u * 0.7, -u * 0.25), c + Vector2(-u * 0.7, -u * 0.25)], WOOD_DARK, a)
			ci.draw_rect(Rect2(c + Vector2(-u * 0.08, -u * 0.22), Vector2(u * 0.16, u * 0.1)), Color(BRASS, a))
			ci.draw_line(c + Vector2(u * 0.7, 0), c + Vector2(u * 0.88, 0), Color(BRASS, a), maxf(2.0, u * 0.05))
			ci.draw_circle(c + Vector2(u * 0.9, 0), u * 0.07, Color(BRASS, a))
		"mirror":
			ci.draw_colored_polygon(_ellipse(c + Vector2(0, -u * 0.25), Vector2(u * 0.42, u * 0.5)), Color(0.75, 0.76, 0.78, a))
			ci.draw_colored_polygon(_ellipse(c + Vector2(0, -u * 0.25), Vector2(u * 0.34, u * 0.42)), Color(0.42, 0.45, 0.48, a))
			_poly(ci, [c + Vector2(-u * 0.07, u * 0.22), c + Vector2(u * 0.07, u * 0.22), c + Vector2(u * 0.09, u * 0.85), c + Vector2(-u * 0.09, u * 0.85)], Color(0.7, 0.71, 0.73), a)
		"watch":
			ci.draw_circle(c, u * 0.55, Color(0.78, 0.66, 0.34, a))
			ci.draw_circle(c, u * 0.45, Color(0.9, 0.88, 0.8, a))
			ci.draw_line(c, c + Vector2(0, -u * 0.32), Color(DARK, a), 2.0)
			ci.draw_line(c, c + Vector2(u * 0.2, u * 0.1), Color(DARK, a), 2.0)
			ci.draw_circle(c + Vector2(0, -u * 0.62), u * 0.08, Color(0.78, 0.66, 0.34, a))
			ci.draw_arc(c + Vector2(0, -u * 0.75), u * 0.1, 0, TAU, 12, Color(0.78, 0.66, 0.34, a), 2.0)
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
