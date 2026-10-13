extends CanvasLayer

# Daniel's light (docs/daniel_v7.md, section 10). While he's in the room the
# whole picture goes faintly red, multiplied in, not washed over; alone with
# MC it goes deeper and breathes; and when MC is frayed it sometimes comes
# when he isn't there at all, so the player stops trusting it.
#
# It comes on by itself on any line spoken by `daniel` (not `daniel_line`:
# on the phone he isn't in the room). Story lines can also say
# `| red=on`, `| red=alone`, `| red=phantom` or `| red=off`. It goes off
# when the scene changes and when a customer leaves the counter.

# Above the scenes and the HUD (50), under the pause menu (80) and the fades.
const DRAWN_ABOVE_SCENES: int = 75
const FADE_IN: float = 2.0
const FADE_OUT: float = 1.5
# Multiplied into the picture: white changes nothing, these redden it.
const TINTS: Dictionary = {
	"": Color.WHITE,
	"present": Color(1.0, 0.80, 0.77),
	"alone": Color(1.0, 0.66, 0.61),
	"phantom": Color(1.0, 0.87, 0.85),
}
# Alone, the red breathes: this far, this fast.
const PULSE_DEPTH: float = 0.05
const PULSE_SPEED: float = 1.3
# Frayed nights from this day on can bring the red with nobody there.
const PHANTOM_FROM_DAY: int = 15

# "" (off), "present", "alone" or "phantom".
var state: String = ""

var _rect: ColorRect
var _tween: Tween
var _time: float = 0.0

func _ready() -> void:
	layer = DRAWN_ABOVE_SCENES
	_rect = ColorRect.new()
	_rect.color = Color.WHITE
	_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	var multiply: CanvasItemMaterial = CanvasItemMaterial.new()
	multiply.blend_mode = CanvasItemMaterial.BLEND_MODE_MUL
	_rect.material = multiply
	add_child(_rect)

func _process(delta: float) -> void:
	if state != "alone" or (_tween and _tween.is_running()):
		return
	_time += delta
	var breath: float = sin(_time * PULSE_SPEED) * PULSE_DEPTH
	var tint: Color = TINTS["alone"]
	_rect.color = Color(1.0, clampf(tint.g + breath, 0.0, 1.0), clampf(tint.b + breath, 0.0, 1.0))

# --- Public: what other scenes can use ---

func arrive(how: String = "present") -> void:
	if not TINTS.has(how) or how == "":
		return
	state = how
	_fade_to(TINTS[how], FADE_IN)

func leave(instant: bool = false) -> void:
	if state == "":
		return
	state = ""
	if instant:
		if _tween:
			_tween.kill()
		_rect.color = Color.WHITE
	else:
		_fade_to(Color.WHITE, FADE_OUT)

# A story line's `red=` option: on, alone, phantom or off.
func apply(option: String) -> void:
	match option:
		"off":
			leave()
		"on":
			arrive("present")
		_:
			arrive(option)

# A line was shown: his voice in the room brings the red.
func heard(speaker: String) -> void:
	if speaker == "daniel" and state in ["", "phantom"]:
		arrive("present")

# At night, frayed, on odd days: the red with nobody in the room.
func phantom_tonight() -> bool:
	return GameState.frayed and GameState.day >= PHANTOM_FROM_DAY and GameState.day % 2 == 1

func tint() -> Color:
	return _rect.color

# --- Private: the machinery ---

func _fade_to(color: Color, duration: float) -> void:
	if _tween:
		_tween.kill()
	_tween = create_tween()
	_tween.tween_property(_rect, "color", color, duration)
