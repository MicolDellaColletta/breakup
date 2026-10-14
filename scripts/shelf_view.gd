class_name ShelfView
extends Control

# The shop's shelves, drawn, with every object on its spot (placeholder art
# from ItemArt). Standing behind the counter, you face one way at a time:
#   "counter" the front: the window in the middle with its three spots (seen
#             from the road), a shelf either side of it (floor spots 0 to 3),
#             whoever is standing across the counter (PersonArt), and the
#             counter top: the register, the ledger, the bell, and the space
#             in the middle where things are handed over
#   "left"    the left wall: shelves for sale (floor spots 4 to 9)
#   "right"   the right wall: shelves for sale (floor spots 10 to 15), and the
#             front door at the end of it, with its bell
#   "back"    turned around: the back shelf, held things with their pawn tags
# Arrows at the edges turn you left and right; the tab at the top turns you
# around. It only draws and reports
# clicks; the counter scene decides what they do. The arrangement lives in
# GameState (shelf_floor, shelf_back, shelf_window).

signal spot_clicked(shelf: String, spot: int)
# The counter top, in the "counter" picture: where you hand things over.
signal counter_clicked
# A right-click: put back whatever you're holding.
signal put_back
# An arrow at the edge ("left", "right") or the tab at the top ("around").
signal turned(direction: String)
# Something on the counter: "register", "ledger" or "bell".
signal object_clicked(object: String)

# What's on the counter, and what it says when you point at it.
const COUNTER_OBJECTS: Array[String] = ["register", "ledger", "bell"]

# Which floor spots each wall shows, and how they're laid out (rows, columns).
const WALL_SPOTS: Dictionary = {"left": [4, 2, 3], "right": [10, 2, 3]}
const ARROW_WIDTH: float = 26.0
const PLANK: Color = Color(0.2, 0.14, 0.09)
const PLANK_EDGE: Color = Color(0.3, 0.21, 0.13)
const BACK_WALL: Color = Color(0.09, 0.08, 0.075)
const HOVER: Color = Color(0.95, 0.85, 0.6, 0.55)
const TAG: Color = Color(0.82, 0.76, 0.62)
const INK: Color = Color(0.2, 0.15, 0.12)
const LABEL_BACK: Color = Color(0.03, 0.035, 0.045, 0.85)
const LABEL_COLOR: Color = Color(0.96, 0.92, 0.82)
const NEON: Color = Color(0.9, 0.14, 0.16)
const GLASS: Color = Color(0.1, 0.12, 0.16)

var mode: String = "floor":
	set(value):
		mode = value
		_hovered = -1
		queue_redraw()
# What's in your hand ("" for nothing): drawn following the mouse, and as a
# ghost on the spot it came from.
var held: String = "":
	set(value):
		held = value
		queue_redraw()
# Who is standing across the counter ("" for nobody), and how solid.
var person: String = "":
	set(value):
		person = value
		queue_redraw()
var person_alpha: float = 1.0:
	set(value):
		person_alpha = value
		queue_redraw()
# Nobody's in, and the bell would bring the next one (it shines).
var bell_ready: bool = false:
	set(value):
		bell_ready = value
		queue_redraw()
# Nobody's left today: the bell closes up.
var bell_closes: bool = false
# Highlight the counter top (something can be handed over).
var can_hand_over: bool = false:
	set(value):
		can_hand_over = value
		queue_redraw()

var _stock: ConfigFile
# item id -> pawn tag text, for the back shelf's tags.
var _tag_of: Callable
var _hovered: int = -1
var _hovering_counter: bool = false
var _hovering_arrow: String = ""
var _hovering_object: String = ""
var _mouse: Vector2 = Vector2.ZERO

func setup(stock: ConfigFile, tag_of: Callable) -> void:
	_stock = stock
	_tag_of = tag_of
	queue_redraw()

func _process(_delta: float) -> void:
	if bell_ready and mode == "counter":
		queue_redraw()

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	mouse_exited.connect(func() -> void:
		_hovered = -1
		_hovering_counter = false
		_hovering_arrow = ""
		_hovering_object = ""
		queue_redraw())

# --- Where things are ---

# The shelf most of the spots in this picture belong to.
func shelf_name() -> String:
	match mode:
		"counter": return "window"
		"back": return "back"
		_: return "floor"

# Every spot in this picture: {"shelf", "spot" (its index on that shelf),
# "rect" (in this control's coordinates)}.
func spots() -> Array[Dictionary]:
	var out: Array[Dictionary] = []
	match mode:
		"counter":
			var window: Rect2 = _window_rect()
			var w: float = window.size.x / 3.0
			for i in 3:
				out.append({"shelf": "window", "spot": i, "rect": Rect2(window.position + Vector2(w * i + w * 0.12, window.size.y * 0.3), Vector2(w * 0.76, window.size.y * 0.62))})
			for side in 2:
				var unit: Rect2 = _side_shelf_rect(side)
				for row in 2:
					out.append({"shelf": "floor", "spot": side * 2 + row, "rect": _cell(unit, 2, 1, row, 0)})
		"left", "right":
			var layout: Array = WALL_SPOTS[mode]
			var area: Rect2 = _wall_shelves_rect()
			for row in layout[1]:
				for col in layout[2]:
					out.append({"shelf": "floor", "spot": layout[0] + row * layout[2] + col, "rect": _cell(area, layout[1], layout[2], row, col)})
		_:
			var area: Rect2 = _inner_rect()
			for row in 3:
				for col in 4:
					out.append({"shelf": "back", "spot": row * 4 + col, "rect": _cell(area, 3, 4, row, col)})
	return out

# Each spot's box, in the same order as spots().
func spot_rects() -> Array[Rect2]:
	var rects: Array[Rect2] = []
	for s in spots():
		rects.append(s["rect"])
	return rects

# One cell of a grid laid over an area, with a little room around the thing.
func _cell(area: Rect2, rows: int, columns: int, row: int, col: int) -> Rect2:
	var cell: Vector2 = Vector2(area.size.x / columns, area.size.y / rows)
	return Rect2(area.position + Vector2(col * cell.x + cell.x * 0.1, row * cell.y + cell.y * 0.12), Vector2(cell.x * 0.8, cell.y * 0.72))

func counter_rect() -> Rect2:
	return Rect2(Vector2(size.x * 0.32, size.y * 0.85), Vector2(size.x * 0.36, size.y * 0.13))

# Where each thing on the counter is. Sized by the picture's height, so they
# keep their shape however wide the shop is.
func object_rect(object: String) -> Rect2:
	match object:
		"register":
			var h: float = size.y * 0.22
			return Rect2(Vector2(ARROW_WIDTH + 12, size.y * 0.76), Vector2(h * 1.2, h))
		"ledger":
			var h: float = size.y * 0.13
			return Rect2(Vector2(ARROW_WIDTH + 24 + size.y * 0.264, size.y * 0.84), Vector2(h * 1.6, h))
		_:
			var h: float = size.y * 0.15
			return Rect2(Vector2(size.x - ARROW_WIDTH - 24 - h, size.y * 0.82), Vector2(h, h))

func _object_at(at: Vector2) -> String:
	if mode != "counter":
		return ""
	for object in COUNTER_OBJECTS:
		if object_rect(object).has_point(at):
			return object
	return ""

func object_label(object: String) -> String:
	match object:
		"register": return "The register"
		"ledger": return "The ledger"
		_:
			if not bell_ready:
				return "The bell"
			return "Close up for the day" if bell_closes else "Ring: next customer"

func _window_rect() -> Rect2:
	return Rect2(Vector2(size.x * 0.26, size.y * 0.04), Vector2(size.x * 0.48, size.y * 0.64))

# The shelf left (0) or right (1) of the window, above the counter.
func _side_shelf_rect(side: int) -> Rect2:
	var w: float = size.x * 0.24 - ARROW_WIDTH - 10
	var x: float = ARROW_WIDTH + 6 if side == 0 else size.x * 0.76 + 4
	return Rect2(Vector2(x, size.y * 0.04), Vector2(w, size.y * 0.7))

# The picture between the two arrows.
func _inner_rect() -> Rect2:
	return Rect2(Vector2(ARROW_WIDTH + 6, 0), Vector2(size.x - (ARROW_WIDTH + 6) * 2, size.y))

# A side wall's shelves: the whole wall, less the door on the right one.
func _wall_shelves_rect() -> Rect2:
	var area: Rect2 = _inner_rect()
	if mode == "right":
		area.size.x *= 0.72
	return area

func _door_rect() -> Rect2:
	var area: Rect2 = _inner_rect()
	return Rect2(Vector2(area.position.x + area.size.x * 0.76, size.y * 0.08), Vector2(area.size.x * 0.2, size.y * 0.84))

func arrow_rect(direction: String) -> Rect2:
	if direction == "around":
		return Rect2(Vector2(size.x * 0.5 - 40, 0), Vector2(80, 18))
	var x: float = 0.0 if direction == "left" else size.x - ARROW_WIDTH
	return Rect2(Vector2(x, size.y * 0.5 - 32), Vector2(ARROW_WIDTH, 64))

func _arrow_at(at: Vector2) -> String:
	for direction in ["left", "right", "around"]:
		if arrow_rect(direction).has_point(at):
			return direction
	return ""

func _spot_at(at: Vector2) -> int:
	var rects: Array[Rect2] = spot_rects()
	for i in rects.size():
		if rects[i].has_point(at):
			return i
	return -1

# --- Input ---

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		_mouse = event.position
		_hovered = _spot_at(_mouse)
		_hovering_counter = mode == "counter" and counter_rect().has_point(_mouse)
		_hovering_arrow = _arrow_at(_mouse)
		_hovering_object = _object_at(_mouse)
		mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND if _hovered != -1 or _hovering_counter or _hovering_arrow != "" or _hovering_object != "" else Control.CURSOR_ARROW
		queue_redraw()
	elif event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			accept_event()
			put_back.emit()
		elif event.button_index == MOUSE_BUTTON_LEFT:
			accept_event()
			var at: int = _spot_at(event.position)
			var arrow: String = _arrow_at(event.position)
			var object: String = _object_at(event.position)
			if arrow != "":
				turned.emit(arrow)
			elif object != "":
				object_clicked.emit(object)
			elif at != -1:
				var s: Dictionary = spots()[at]
				spot_clicked.emit(s["shelf"], s["spot"])
			elif mode == "counter" and counter_rect().has_point(event.position):
				counter_clicked.emit()

# --- Drawing ---

func _shape(item_id: String) -> String:
	return str(_stock.get_value(item_id, "shape", "")) if _stock != null else ""

func _name(item_id: String) -> String:
	return str(_stock.get_value(item_id, "name", item_id)) if _stock != null else item_id

func _draw() -> void:
	if mode == "counter":
		_draw_counter()
	else:
		_draw_shelves()
	_draw_items()
	_draw_arrows()
	_draw_held()

func _draw_shelves() -> void:
	draw_rect(Rect2(Vector2.ZERO, size), BACK_WALL)
	_draw_panelling(_inner_rect())
	if mode == "back":
		_draw_case(_inner_rect(), 3)
	else:
		_draw_case(_wall_shelves_rect(), WALL_SPOTS[mode][1])
	if mode == "right":
		_draw_door(_door_rect())
	_draw_wall_dressing()

# Tongue-and-groove boards behind everything, darker at the floor.
func _draw_panelling(area: Rect2) -> void:
	var boards: int = int(area.size.x / 38.0)
	for k in boards:
		var x: float = area.position.x + k * area.size.x / boards
		draw_line(Vector2(x, area.position.y), Vector2(x, area.end.y), Color(0, 0, 0, 0.35), 1.0)
	draw_rect(Rect2(Vector2(area.position.x, area.end.y - size.y * 0.05), Vector2(area.size.x, size.y * 0.05)), Color(0.05, 0.04, 0.035))

# What's on the walls and the shelf ends: nothing to click, just the shop.
# The left wall has the antlers and the trap chain; the right wall, the
# calendar and the rules by the door; the back shelf, the gun rack and the
# PAWN TICKETS sign.
func _draw_wall_dressing() -> void:
	var area: Rect2 = _inner_rect()
	match mode:
		"left":
			# Antlers on a plaque, high on the upright between the rows.
			var top: Vector2 = Vector2(area.get_center().x, area.position.y + size.y * 0.035)
			_draw_antlers(top, size.y * 0.05)
			# A leg-hold trap on its chain, hung off the end of the shelf.
			var hook: Vector2 = Vector2(area.end.x - 10, area.position.y + area.size.y * 0.52)
			for k in 5:
				draw_arc(hook + Vector2(0, k * 7), 3.5, 0, TAU, 8, Color(0.35, 0.33, 0.3), 1.5)
			draw_arc(hook + Vector2(0, 52), 14, PI, TAU, 12, Color(0.4, 0.38, 0.35), 2.5)
			draw_line(hook + Vector2(-14, 52), hook + Vector2(14, 52), Color(0.4, 0.38, 0.35), 2.5)
		"right":
			var door: Rect2 = _door_rect()
			# The calendar from the feed store, this month, by the door.
			var cal: Rect2 = Rect2(Vector2(door.position.x - size.x * 0.005 - 54, size.y * 0.07), Vector2(50, 66))
			cal.position.x = maxf(cal.position.x, _wall_shelves_rect().end.x + 2)
			draw_rect(cal, Color(0.86, 0.84, 0.78))
			draw_rect(Rect2(cal.position, Vector2(cal.size.x, 24)), Color(0.55, 0.2, 0.15))
			draw_string(ThemeDB.fallback_font, cal.position + Vector2(4, 17), _month_name(), HORIZONTAL_ALIGNMENT_LEFT, cal.size.x - 6, 11, Color(0.95, 0.92, 0.85))
			for k in 12:
				draw_rect(Rect2(cal.position + Vector2(5 + (k % 4) * 11, 30 + (k / 4) * 11), Vector2(8, 7)), Color(0.4, 0.38, 0.35, 0.5))
			# The rules, typed and taped up: NO REFUNDS.
			var sign: Rect2 = Rect2(Vector2(door.position.x + door.size.x * 0.12, door.position.y + door.size.y * 0.56), Vector2(door.size.x * 0.76, door.size.y * 0.12))
			draw_rect(sign, Color(0.8, 0.78, 0.7))
			draw_string(ThemeDB.fallback_font, sign.position + Vector2(4, sign.size.y * 0.65), "NO REFUNDS", HORIZONTAL_ALIGNMENT_LEFT, sign.size.x - 6, 11, INK)
		_:
			# Behind the held things: PAWN TICKETS / 90 DAYS, painted on a board.
			var board: Rect2 = Rect2(Vector2(area.get_center().x - 90, 22), Vector2(180, 20))
			draw_rect(board, Color(0.16, 0.12, 0.08))
			draw_string(ThemeDB.fallback_font, board.position + Vector2(8, 15), "LOANS · 90 DAYS · NO EXTENSIONS", HORIZONTAL_ALIGNMENT_LEFT, board.size.x - 10, 10, Color(0.85, 0.78, 0.55))

func _draw_antlers(base: Vector2, s: float) -> void:
	var bone: Color = Color(0.7, 0.64, 0.52)
	draw_rect(Rect2(base + Vector2(-s * 0.5, -s * 0.2), Vector2(s, s * 0.7)), Color(0.25, 0.17, 0.1))
	for side in [-1.0, 1.0]:
		var root: Vector2 = base + Vector2(side * s * 0.15, 0)
		var tip: Vector2 = root + Vector2(side * s * 1.8, -s * 0.4)
		draw_line(root, tip, bone, 3.0)
		for k in 3:
			var at: Vector2 = root.lerp(tip, 0.35 + k * 0.25)
			draw_line(at, at + Vector2(side * s * 0.15, -s * 0.55), bone, 2.0)

func _month_name() -> String:
	var month: String = GameState.date_text().split(" ")[0]
	return month.to_upper().left(3) + (" '99" if month in ["Oct", "Nov", "Dec"] else " '00")

# A shelving unit: planks under each row, uprights at the ends.
func _draw_case(area: Rect2, rows: int) -> void:
	var cell_h: float = area.size.y / rows
	for row in rows:
		var y: float = area.position.y + (row + 1) * cell_h - cell_h * 0.12
		draw_rect(Rect2(Vector2(area.position.x, y), Vector2(area.size.x, cell_h * 0.07)), PLANK)
		draw_line(Vector2(area.position.x, y), Vector2(area.end.x, y), PLANK_EDGE, 2.0)
	draw_rect(Rect2(area.position, Vector2(6, area.size.y)), PLANK)
	draw_rect(Rect2(Vector2(area.end.x - 6, area.position.y), Vector2(6, area.size.y)), PLANK)

# The front door, with the bell over it.
func _draw_door(door: Rect2) -> void:
	draw_rect(door, Color(0.1, 0.08, 0.06))
	draw_rect(Rect2(door.position + Vector2(door.size.x * 0.15, door.size.y * 0.08), Vector2(door.size.x * 0.7, door.size.y * 0.4)), GLASS)
	draw_circle(door.position + Vector2(door.size.x * 0.5, -2), 6, Color(0.72, 0.58, 0.28))

func _draw_counter() -> void:
	draw_rect(Rect2(Vector2.ZERO, size), Color(0.05, 0.05, 0.06))
	# The floor, red from the neon.
	draw_rect(Rect2(Vector2(0, size.y * 0.5), Vector2(size.x, size.y * 0.5)), Color(0.07, 0.05, 0.05))
	# The front window: night (or day) outside, the snow, the neon at its edge.
	var window: Rect2 = _window_rect()
	draw_rect(window.grow(6), Color(0.12, 0.1, 0.08))
	_draw_street(window)
	draw_rect(Rect2(window.position, Vector2(window.size.x, 4)), Color(NEON, 0.5))
	# The three spots on the window ledge.
	var ledge_y: float = window.end.y - 4
	draw_rect(Rect2(Vector2(window.position.x - 6, ledge_y), Vector2(window.size.x + 12, 8)), PLANK)
	# A shelf either side of the window.
	for side in 2:
		_draw_case(_side_shelf_rect(side), 2)
	# Whoever's across the counter.
	if person != "":
		PersonArt.draw(self, person, Rect2(Vector2(size.x * 0.25, size.y * 0.12), Vector2(size.x * 0.5, size.y * 0.72)), person_alpha)
	# The counter top, close, under your hands.
	draw_rect(Rect2(Vector2(0, size.y * 0.82), Vector2(size.x, size.y * 0.18)), Color(0.06, 0.065, 0.075))
	draw_rect(Rect2(Vector2(0, size.y * 0.82), Vector2(size.x, 5)), Color(0.4, 0.45, 0.5, 0.35))
	_draw_counter_objects()
	var top: Rect2 = counter_rect()
	if can_hand_over:
		draw_rect(top, Color(HOVER, 0.12 if not _hovering_counter else 0.25))
		draw_rect(top, Color(HOVER, 0.4 if not _hovering_counter else 0.8), false, 1.5)
		_draw_label("Hand it over", top.get_center() - Vector2(0, top.size.y * 0.5 + 4))

# Out the front window: the road, the snowbank, the Gleaner's lit window
# across the way, the streetlight, the back of the neon. Light by the hour
# and the season (Alaska: a short winter day), snow from late October on.
func _draw_street(window: Rect2) -> void:
	var light: float = _daylight()
	var sky: Color = Color(0.03, 0.04, 0.07).lerp(Color(0.62, 0.68, 0.74), light)
	draw_rect(window, sky)
	var calendar_day: int = GameState.minutes / 1440
	var snow: bool = calendar_day >= 18 and calendar_day < 205
	var ground: Color = (Color(0.75, 0.78, 0.82) if snow else Color(0.3, 0.28, 0.24)).lerp(Color(0.05, 0.05, 0.07), 1.0 - light * 0.9)
	var horizon: float = window.position.y + window.size.y * 0.55
	# Across the road: the Gleaner, and a second roof.
	var bar: Rect2 = Rect2(Vector2(window.position.x + window.size.x * 0.08, horizon - window.size.y * 0.22), Vector2(window.size.x * 0.38, window.size.y * 0.22))
	draw_rect(bar, Color(0.1, 0.08, 0.07).lerp(Color(0.35, 0.28, 0.24), light))
	draw_colored_polygon(PackedVector2Array([bar.position + Vector2(-8, 0), bar.position + Vector2(bar.size.x * 0.5, -window.size.y * 0.08), Vector2(bar.end.x + 8, bar.position.y)]), Color(0.08, 0.07, 0.07).lerp(Color(0.25, 0.22, 0.2), light))
	draw_rect(Rect2(bar.position + Vector2(bar.size.x * 0.15, bar.size.y * 0.3), Vector2(bar.size.x * 0.25, bar.size.y * 0.35)), Color(0.95, 0.75, 0.4, 0.9 - light * 0.5))
	draw_rect(Rect2(bar.position + Vector2(bar.size.x * 0.6, bar.size.y * 0.3), Vector2(bar.size.x * 0.25, bar.size.y * 0.35)), Color(0.95, 0.75, 0.4, 0.9 - light * 0.5))
	draw_rect(Rect2(Vector2(window.position.x + window.size.x * 0.6, horizon - window.size.y * 0.14), Vector2(window.size.x * 0.3, window.size.y * 0.14)), Color(0.07, 0.07, 0.08).lerp(Color(0.3, 0.3, 0.3), light))
	# The road, and the bank the plough leaves.
	draw_rect(Rect2(Vector2(window.position.x, horizon), Vector2(window.size.x, window.end.y - horizon)), ground)
	draw_rect(Rect2(Vector2(window.position.x, horizon + window.size.y * 0.08), Vector2(window.size.x, window.size.y * 0.12)), ground.darkened(0.35))
	if snow:
		draw_colored_polygon(PackedVector2Array([Vector2(window.position.x, window.end.y), Vector2(window.position.x, window.end.y - window.size.y * 0.16), Vector2(window.position.x + window.size.x * 0.3, window.end.y - window.size.y * 0.1), Vector2(window.end.x * 0.7 + window.position.x * 0.3, window.end.y - window.size.y * 0.14), Vector2(window.end.x, window.end.y - window.size.y * 0.09), Vector2(window.end.x, window.end.y)]), ground.lightened(0.08))
	# The streetlight, on when it's dark.
	var pole_x: float = window.position.x + window.size.x * 0.52
	draw_line(Vector2(pole_x, horizon + 4), Vector2(pole_x, window.position.y + window.size.y * 0.12), Color(0.12, 0.12, 0.13), 3.0)
	draw_line(Vector2(pole_x, window.position.y + window.size.y * 0.12), Vector2(pole_x + 22, window.position.y + window.size.y * 0.12), Color(0.12, 0.12, 0.13), 3.0)
	if light < 0.5:
		draw_circle(Vector2(pole_x + 22, window.position.y + window.size.y * 0.13), 5, Color(1.0, 0.85, 0.55))
		draw_colored_polygon(PackedVector2Array([Vector2(pole_x + 18, window.position.y + window.size.y * 0.14), Vector2(pole_x + 26, window.position.y + window.size.y * 0.14), Vector2(pole_x + 60, horizon + window.size.y * 0.1), Vector2(pole_x - 16, horizon + window.size.y * 0.1)]), Color(1.0, 0.85, 0.55, 0.12))
	# The glass: a cold sheen, frost in the corners in winter.
	draw_rect(window, Color(0.6, 0.7, 0.8, 0.06))
	if snow:
		for corner in [window.position, Vector2(window.end.x, window.position.y), window.end, Vector2(window.position.x, window.end.y)]:
			draw_circle(corner, window.size.y * 0.06, Color(0.85, 0.9, 0.95, 0.08))
	# The neon from behind: PAWN, backwards, red on the glass.
	draw_string(ThemeDB.fallback_font, window.position + Vector2(window.size.x * 0.36, window.size.y * 0.11), "NWAP", HORIZONTAL_ALIGNMENT_LEFT, -1, int(window.size.y * 0.08), Color(NEON, 0.55))

# 0 in the dark, 1 in full day, by the clock and the date (a rough Alaskan
# day: about eighteen hours of light in June, under six at Christmas).
func _daylight() -> float:
	var calendar_day: int = GameState.minutes / 1440
	var hour: float = (GameState.minutes % 1440) / 60.0
	var day_of_year: int = (278 + calendar_day) % 365
	var length: float = 12.3 + 6.4 * cos(TAU * (day_of_year - 172) / 365.0)
	var noon: float = 13.5
	var from_noon: float = absf(hour - noon)
	return clampf((length / 2.0 - from_noon) / 1.2 + 0.5, 0.0, 1.0)

func _draw_items() -> void:
	var all: Array[Dictionary] = spots()
	for i in all.size():
		var r: Rect2 = all[i]["rect"]
		var item_id: String = _item_in(all[i])
		if i == _hovered:
			draw_rect(r.grow(2), HOVER, false, 1.5)
		if item_id == "":
			# Empty spots show faintly in the window, and anywhere while you're
			# holding something to put down.
			if all[i]["shelf"] == "window" or held != "":
				draw_rect(r, Color(HOVER, 0.18), false, 1.0)
			continue
		ItemArt.draw(self, _shape(item_id), r, item_id == held)
		if all[i]["shelf"] == "back" and _tag_of.is_valid():
			_draw_tag(r, str(_tag_of.call(item_id)))
		elif all[i]["shelf"] == "floor" and _stock != null and _stock.has_section_key(item_id, "price"):
			_draw_price(r, "$%d" % int(_stock.get_value(item_id, "price")))
	if _hovered != -1 and _hovered < all.size():
		var r: Rect2 = all[_hovered]["rect"]
		var under: String = _item_in(all[_hovered])
		var text: String = _name(under) if under != "" else ("Put it here" if held != "" else "")
		if text != "":
			_draw_label(text, r.get_center() - Vector2(0, r.size.y * 0.5 + 6))

# What's in a spot ("" for nothing, or a shelf not filled in yet).
func _item_in(s: Dictionary) -> String:
	var on: Array[String] = GameState.shelf(s["shelf"])
	return on[s["spot"]] if s["spot"] < on.size() else ""

# The register, the ledger and the bell, on the counter top.
func _draw_counter_objects() -> void:
	var reg: Rect2 = object_rect("register")
	draw_rect(Rect2(reg.position + Vector2(0, reg.size.y * 0.35), Vector2(reg.size.x, reg.size.y * 0.65)), Color(0.42, 0.33, 0.16))
	draw_rect(Rect2(reg.position + Vector2(reg.size.x * 0.1, 0), Vector2(reg.size.x * 0.8, reg.size.y * 0.4)), Color(0.5, 0.4, 0.2))
	for k in 4:
		draw_circle(reg.position + Vector2(reg.size.x * (0.2 + k * 0.2), reg.size.y * 0.55), reg.size.x * 0.05, Color(0.85, 0.8, 0.65))
	draw_rect(Rect2(reg.position + Vector2(reg.size.x * 0.15, reg.size.y * 0.1), Vector2(reg.size.x * 0.7, reg.size.y * 0.15)), Color(0.1, 0.09, 0.07))
	var book: Rect2 = object_rect("ledger")
	draw_rect(book, Color(0.3, 0.1, 0.07))
	draw_rect(book.grow(-3), Color(0.72, 0.68, 0.58))
	draw_line(Vector2(book.get_center().x, book.position.y + 3), Vector2(book.get_center().x, book.end.y - 3), Color(0.3, 0.1, 0.07), 2.0)
	for k in 4:
		var y: float = book.position.y + book.size.y * (0.25 + k * 0.17)
		draw_line(Vector2(book.position.x + 6, y), Vector2(book.get_center().x - 4, y), Color(0.3, 0.25, 0.2, 0.6), 1.0)
		draw_line(Vector2(book.get_center().x + 4, y), Vector2(book.end.x - 6, y), Color(0.3, 0.25, 0.2, 0.6), 1.0)
	# Not to click: a mug gone cold, and a cup of pens and a loupe.
	var mug: Vector2 = Vector2(counter_rect().position.x - size.y * 0.06, size.y * 0.93)
	draw_rect(Rect2(mug - Vector2(size.y * 0.025, size.y * 0.06), Vector2(size.y * 0.05, size.y * 0.06)), Color(0.55, 0.52, 0.48))
	draw_arc(mug + Vector2(size.y * 0.032, -size.y * 0.032), size.y * 0.014, -PI / 2, PI / 2, 8, Color(0.55, 0.52, 0.48), 2.0)
	var cup: Vector2 = Vector2(counter_rect().end.x + size.y * 0.06, size.y * 0.93)
	for k in 3:
		draw_line(cup + Vector2(-size.y * 0.01 + k * size.y * 0.01, -size.y * 0.05), cup + Vector2(-size.y * 0.016 + k * size.y * 0.016, -size.y * 0.1), [Color(0.15, 0.2, 0.5), Color(0.6, 0.15, 0.1), Color(0.1, 0.1, 0.1)][k], 2.0)
	draw_rect(Rect2(cup - Vector2(size.y * 0.022, size.y * 0.055), Vector2(size.y * 0.044, size.y * 0.055)), Color(0.3, 0.32, 0.28))
	var bell: Rect2 = object_rect("bell")
	var c: Vector2 = Vector2(bell.get_center().x, bell.end.y - bell.size.y * 0.2)
	var radius: float = bell.size.y * 0.38
	if bell_ready:
		draw_circle(c - Vector2(0, radius * 0.5), radius * 1.6, Color(0.95, 0.8, 0.45, 0.16 + 0.06 * sin(Time.get_ticks_msec() / 300.0)))
	draw_rect(Rect2(Vector2(bell.position.x, c.y), Vector2(bell.size.x, bell.size.y * 0.12)), Color(0.25, 0.2, 0.12))
	draw_arc(c, radius, PI, TAU, 16, Color(0.78, 0.62, 0.3), radius * 0.8)
	draw_circle(c - Vector2(0, radius * 1.45), 3, Color(0.85, 0.7, 0.35))
	for object in COUNTER_OBJECTS:
		var r: Rect2 = object_rect(object)
		if object == _hovering_object:
			draw_rect(r.grow(3), HOVER, false, 1.5)
			_draw_label(object_label(object), r.get_center() - Vector2(0, r.size.y * 0.5 + 6))

# The arrows at the edges: turn left, turn right.
func _draw_arrows() -> void:
	for direction in ["left", "right"]:
		var r: Rect2 = arrow_rect(direction)
		var lit: bool = _hovering_arrow == direction
		draw_rect(r, Color(LABEL_BACK, 0.9 if lit else 0.6))
		var tip: float = r.position.x + (6.0 if direction == "left" else r.size.x - 6.0)
		var base: float = r.position.x + (r.size.x - 6.0 if direction == "left" else 6.0)
		var mid: float = r.get_center().y
		draw_colored_polygon(PackedVector2Array([Vector2(tip, mid), Vector2(base, mid - 12), Vector2(base, mid + 12)]), Color(LABEL_COLOR, 1.0 if lit else 0.6))
	# The tab at the top: turn around.
	var tab: Rect2 = arrow_rect("around")
	var lit_tab: bool = _hovering_arrow == "around"
	draw_rect(tab, Color(LABEL_BACK, 0.9 if lit_tab else 0.6))
	draw_arc(tab.get_center() + Vector2(0, 2), 6, PI * 0.15, PI * 1.85, 12, Color(LABEL_COLOR, 1.0 if lit_tab else 0.6), 2.0)
	if lit_tab:
		_draw_label("Turn around", tab.get_center() + Vector2(0, tab.size.y + 26))

func _draw_tag(r: Rect2, tag: String) -> void:
	var tag_rect: Rect2 = Rect2(r.position + Vector2(r.size.x - 44, r.size.y - 18), Vector2(42, 16))
	draw_rect(tag_rect, TAG)
	draw_string(ThemeDB.fallback_font, tag_rect.position + Vector2(4, 13), tag, HORIZONTAL_ALIGNMENT_LEFT, -1, 12, INK)

# A price, on a string tag at the front of the shelf.
func _draw_price(r: Rect2, price: String) -> void:
	var tag_rect: Rect2 = Rect2(Vector2(r.get_center().x - 18, r.end.y + 2), Vector2(36, 15))
	draw_rect(tag_rect, Color(0.9, 0.86, 0.72))
	draw_string(ThemeDB.fallback_font, tag_rect.position + Vector2(4, 12), price, HORIZONTAL_ALIGNMENT_LEFT, 30, 11, INK)

# What's in your hand, following the mouse.
func _draw_held() -> void:
	if held == "" or not get_global_rect().has_point(get_global_mouse_position()):
		return
	var r: Rect2 = Rect2(_mouse + Vector2(6, 6), Vector2(54, 44))
	ItemArt.draw(self, _shape(held), r)

func _draw_label(text: String, bottom_center: Vector2) -> void:
	var font: Font = ThemeDB.fallback_font
	var text_size: Vector2 = font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, 15)
	var pad: Vector2 = Vector2(7, 3)
	var tag: Rect2 = Rect2(bottom_center - Vector2(text_size.x / 2 + pad.x, text_size.y + pad.y * 2), text_size + pad * 2)
	tag.position.x = clampf(tag.position.x, 0, size.x - tag.size.x)
	tag.position.y = maxf(tag.position.y, 0)
	draw_rect(tag, LABEL_BACK)
	draw_string(font, tag.position + Vector2(pad.x, pad.y + font.get_ascent(15)), text, HORIZONTAL_ALIGNMENT_LEFT, -1, 15, LABEL_COLOR)
