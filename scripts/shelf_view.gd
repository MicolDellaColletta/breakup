class_name ShelfView
extends Control

# The shop's shelves, drawn, with every object on its spot (placeholder art
# from ItemArt). Three pictures, one at a time:
#   "floor"   the shelves out front, for sale: three rows of four
#   "back"    the back shelf, held things with their pawn tags
#   "counter" from behind the counter: the front window with its three spots
#             (seen from the road), whoever is standing across the counter
#             (PersonArt), and the counter top, where things are handed over
# It only draws and reports clicks; the counter scene decides what they do.
# The arrangement lives in GameState (shelf_floor, shelf_back, shelf_window).

signal spot_clicked(shelf: String, spot: int)
# The counter top, in the "counter" picture: where you hand things over.
signal counter_clicked
# A right-click: put back whatever you're holding.
signal put_back

const ROWS: int = 3
const COLUMNS: int = 4
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
var _mouse: Vector2 = Vector2.ZERO

func setup(stock: ConfigFile, tag_of: Callable) -> void:
	_stock = stock
	_tag_of = tag_of
	queue_redraw()

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	mouse_exited.connect(func() -> void:
		_hovered = -1
		_hovering_counter = false
		queue_redraw())

# --- Where things are ---

# The shelf the spots in this picture belong to.
func shelf_name() -> String:
	return "window" if mode == "counter" else mode

# Each spot's box, in this control's coordinates.
func spot_rects() -> Array[Rect2]:
	var rects: Array[Rect2] = []
	if mode == "counter":
		var window: Rect2 = _window_rect()
		var w: float = window.size.x / 3.0
		for i in 3:
			rects.append(Rect2(window.position + Vector2(w * i + w * 0.12, window.size.y * 0.3), Vector2(w * 0.76, window.size.y * 0.62)))
		return rects
	var cell: Vector2 = Vector2(size.x / COLUMNS, size.y / ROWS)
	for row in ROWS:
		for col in COLUMNS:
			rects.append(Rect2(Vector2(col * cell.x + cell.x * 0.1, row * cell.y + cell.y * 0.12), Vector2(cell.x * 0.8, cell.y * 0.72)))
	return rects

func counter_rect() -> Rect2:
	return Rect2(Vector2(size.x * 0.3, size.y * 0.8), Vector2(size.x * 0.4, size.y * 0.17))

func _window_rect() -> Rect2:
	return Rect2(Vector2(size.x * 0.05, size.y * 0.06), Vector2(size.x * 0.62, size.y * 0.42))

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
		mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND if _hovered != -1 or _hovering_counter else Control.CURSOR_ARROW
		queue_redraw()
	elif event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			accept_event()
			put_back.emit()
		elif event.button_index == MOUSE_BUTTON_LEFT:
			accept_event()
			var spot: int = _spot_at(event.position)
			if spot != -1:
				spot_clicked.emit(shelf_name(), spot)
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
	_draw_held()

func _draw_shelves() -> void:
	draw_rect(Rect2(Vector2.ZERO, size), BACK_WALL)
	var cell_h: float = size.y / ROWS
	for row in ROWS:
		var y: float = (row + 1) * cell_h - cell_h * 0.12
		draw_rect(Rect2(Vector2(0, y), Vector2(size.x, cell_h * 0.07)), PLANK)
		draw_line(Vector2(0, y), Vector2(size.x, y), PLANK_EDGE, 2.0)
	# Uprights at the ends.
	draw_rect(Rect2(Vector2.ZERO, Vector2(6, size.y)), PLANK)
	draw_rect(Rect2(Vector2(size.x - 6, 0), Vector2(6, size.y)), PLANK)

func _draw_counter() -> void:
	draw_rect(Rect2(Vector2.ZERO, size), Color(0.05, 0.05, 0.06))
	# The floor, red from the neon.
	draw_rect(Rect2(Vector2(0, size.y * 0.5), Vector2(size.x, size.y * 0.5)), Color(0.07, 0.05, 0.05))
	# The front window: night (or day) outside, the snow, the neon at its edge.
	var window: Rect2 = _window_rect()
	draw_rect(window.grow(6), Color(0.12, 0.1, 0.08))
	draw_rect(window, GLASS)
	draw_rect(Rect2(window.position + Vector2(0, window.size.y * 0.8), Vector2(window.size.x, window.size.y * 0.2)), Color(0.6, 0.62, 0.66, 0.25))
	draw_rect(Rect2(window.position, Vector2(window.size.x, 4)), Color(NEON, 0.5))
	# The three spots on the window ledge.
	var ledge_y: float = window.end.y - 4
	draw_rect(Rect2(Vector2(window.position.x - 6, ledge_y), Vector2(window.size.x + 12, 8)), PLANK)
	# The door, with its bell.
	var door: Rect2 = Rect2(Vector2(size.x * 0.75, size.y * 0.06), Vector2(size.x * 0.18, size.y * 0.5))
	draw_rect(door, Color(0.1, 0.08, 0.06))
	draw_rect(Rect2(door.position + Vector2(door.size.x * 0.15, door.size.y * 0.08), Vector2(door.size.x * 0.7, door.size.y * 0.4)), GLASS)
	draw_circle(door.position + Vector2(door.size.x * 0.5, -2), 5, Color(0.72, 0.58, 0.28))
	# Whoever's across the counter.
	if person != "":
		PersonArt.draw(self, person, Rect2(Vector2(size.x * 0.25, size.y * 0.12), Vector2(size.x * 0.5, size.y * 0.72)), person_alpha)
	# The counter top, close, under your hands.
	draw_rect(Rect2(Vector2(0, size.y * 0.78), Vector2(size.x, size.y * 0.22)), Color(0.06, 0.065, 0.075))
	draw_rect(Rect2(Vector2(0, size.y * 0.78), Vector2(size.x, 5)), Color(0.4, 0.45, 0.5, 0.35))
	var top: Rect2 = counter_rect()
	if can_hand_over:
		draw_rect(top, Color(HOVER, 0.12 if not _hovering_counter else 0.25))
		draw_rect(top, Color(HOVER, 0.4 if not _hovering_counter else 0.8), false, 1.5)
		_draw_label("Hand it over", top.get_center() - Vector2(0, top.size.y * 0.5 + 4))

func _draw_items() -> void:
	var spots: Array[String] = GameState.shelf(shelf_name())
	var rects: Array[Rect2] = spot_rects()
	for i in mini(spots.size(), rects.size()):
		var item_id: String = spots[i]
		if i == _hovered:
			draw_rect(rects[i].grow(2), HOVER, false, 1.5)
		if item_id == "":
			# Empty spots show faintly in the window, and anywhere while you're
			# holding something to put down.
			if mode == "counter" or held != "":
				draw_rect(rects[i], Color(HOVER, 0.18), false, 1.0)
			continue
		ItemArt.draw(self, _shape(item_id), rects[i], item_id == held)
		if mode == "back" and _tag_of.is_valid():
			_draw_tag(rects[i], str(_tag_of.call(item_id)))
	if _hovered != -1 and _hovered < spots.size():
		var under: String = spots[_hovered]
		var text: String = _name(under) if under != "" else ("Put it here" if held != "" else "")
		if text != "":
			_draw_label(text, rects[_hovered].get_center() - Vector2(0, rects[_hovered].size.y * 0.5 + 6))

func _draw_tag(r: Rect2, tag: String) -> void:
	var tag_rect: Rect2 = Rect2(r.position + Vector2(r.size.x - 44, r.size.y - 18), Vector2(42, 16))
	draw_rect(tag_rect, TAG)
	draw_string(ThemeDB.fallback_font, tag_rect.position + Vector2(4, 13), tag, HORIZONTAL_ALIGNMENT_LEFT, -1, 12, INK)

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
