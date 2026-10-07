extends CanvasLayer

# Screen fades and scene changes, shared by every scene.
# The screen starts black, so each scene fades itself in when it's ready.

const DRAW_ON_TOP: int = 100

var _curtain: ColorRect
var _tween: Tween

func _ready() -> void:
	layer = DRAW_ON_TOP
	_curtain = ColorRect.new()
	_curtain.color = Color.BLACK
	_curtain.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_curtain.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(_curtain)

# --- Public: what other scenes can use ---

func fade_in(duration: float) -> void:
	await _fade_to(0.0, duration)

func fade_out(duration: float) -> void:
	await _fade_to(1.0, duration)

func go_to(scene_path: String, fade_duration: float, hold: float = 0.0) -> void:
	await fade_out(fade_duration)
	if hold > 0.0:
		await get_tree().create_timer(hold).timeout
	# A new part of the game starts here: the autosave remembers it.
	var saves: Node = get_node_or_null("/root/Saves")
	if saves:
		saves.mark_checkpoint(scene_path)
	get_tree().change_scene_to_file(scene_path)

# --- Private: the machinery ---

func _fade_to(alpha: float, duration: float) -> void:
	if _tween:
		_tween.kill()
	_tween = create_tween()
	_tween.tween_property(_curtain, "modulate:a", alpha, duration)
	await _tween.finished
