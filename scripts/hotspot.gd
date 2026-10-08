class_name Hotspot
extends Control

# Something in the room you can click: a door, the radio, a drawer. Shows
# its name and a faint outline when the mouse is over it (or while the
# player holds Tab to see everything clickable). Placed by HotspotLayer from
# story/spots.cfg.

signal clicked(spot_id: String)

const OUTLINE: Color = Color(0.95, 0.85, 0.6, 0.55)
const SHOW_ALL: Color = Color(0.95, 0.85, 0.6, 0.25)
const LABEL_COLOR: Color = Color(0.96, 0.92, 0.82, 1)
const LABEL_BACK: Color = Color(0.03, 0.035, 0.045, 0.85)
const FONT_SIZE: int = 16

var spot_id: String = ""
var label_text: String = ""
# Looked at already: still there, but no longer clickable.
var used: bool = false:
	set(value):
		used = value
		_refresh()
# The player is holding Tab: outline everything clickable.
var show_all: bool = false:
	set(value):
		if value != show_all:
			show_all = value
			queue_redraw()

var _hovered: bool = false

func _ready() -> void:
	mouse_entered.connect(_on_hover.bind(true))
	mouse_exited.connect(_on_hover.bind(false))
	_refresh()

func _gui_input(event: InputEvent) -> void:
	if used:
		return
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		accept_event()
		clicked.emit(spot_id)

func _on_hover(inside: bool) -> void:
	_hovered = inside
	queue_redraw()

func _refresh() -> void:
	mouse_default_cursor_shape = Control.CURSOR_ARROW if used else Control.CURSOR_POINTING_HAND
	queue_redraw()

func _draw() -> void:
	if used:
		return
	var rect: Rect2 = Rect2(Vector2.ZERO, size)
	if _hovered:
		draw_rect(rect, OUTLINE, false, 2.0)
	elif show_all:
		draw_rect(rect, SHOW_ALL, false, 1.0)
	if _hovered or show_all:
		_draw_label()

# The name, in a small dark tag just above the top edge (or inside it, when
# the hotspot touches the top of the screen).
func _draw_label() -> void:
	var font: Font = ThemeDB.fallback_font
	var text_size: Vector2 = font.get_string_size(label_text, HORIZONTAL_ALIGNMENT_LEFT, -1, FONT_SIZE)
	var pad: Vector2 = Vector2(8, 4)
	var top: float = -text_size.y - pad.y * 2 - 4
	if global_position.y + top < 0:
		top = 4
	var tag: Rect2 = Rect2(Vector2((size.x - text_size.x) / 2 - pad.x, top), text_size + pad * 2)
	draw_rect(tag, LABEL_BACK)
	draw_string(font, tag.position + Vector2(pad.x, pad.y + font.get_ascent(FONT_SIZE)), label_text,
		HORIZONTAL_ALIGNMENT_LEFT, -1, FONT_SIZE, LABEL_COLOR)
