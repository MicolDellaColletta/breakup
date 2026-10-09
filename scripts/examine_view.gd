class_name ExamineView
extends Control

# A close-up of one thing from the shelves, filling the shop side of the
# screen: the object drawn big (ItemArt), with hotspots over it for its
# details (story/spots.cfg, scene "examine", room = the item id). What each
# detail tells you is in story/examine.txt.

# Where the object sits, in fractions of this control.
const ITEM_BOX: Rect2 = Rect2(0.2, 0.15, 0.6, 0.6)

var shape: String = "":
	set(value):
		shape = value
		queue_redraw()

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP

func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, size), Color(0.035, 0.03, 0.03))
	# A pool of lamplight on the counter glass.
	var c: Vector2 = Vector2(size.x * 0.5, size.y * 0.45)
	for i in range(6, 0, -1):
		draw_circle(c, size.y * 0.08 * i, Color(0.95, 0.75, 0.45, 0.025))
	var box: Rect2 = Rect2(ITEM_BOX.position * size, ITEM_BOX.size * size)
	ItemArt.draw(self, shape, box)
