extends Node

# Player settings, remembered between sessions: volume, text speed and
# fullscreen. The game is laid out at 1152x648 and scales to the window
# (canvas_items), so it stays sharp at any size; windowed, it opens 16:9 and
# as large as fits comfortably on the screen.

const PATH: String = "user://settings.cfg"
const TEXT_SPEEDS: Dictionary = {
	"Slow": 0.6,
	"Normal": 1.0,
	"Fast": 1.7,
}

var volume: float = 0.8
var text_speed: String = "Normal"
var fullscreen: bool = false

# Sound is off for now, until it's redone with care (docs/todo.md): every
# sound still plays, silently, so nothing else changes. True turns it back on.
const SOUND_ON: bool = false

# How much of the screen the window takes when it isn't fullscreen.
const WINDOW_SHARE: float = 0.85
const ASPECT: float = 16.0 / 9.0

func _ready() -> void:
	var file: ConfigFile = ConfigFile.new()
	if file.load(PATH) == OK:
		volume = file.get_value("settings", "volume", volume)
		text_speed = file.get_value("settings", "text_speed", text_speed)
		fullscreen = file.get_value("settings", "fullscreen", fullscreen)
	apply()

# How much faster or slower than written the text types out.
func speed_multiplier() -> float:
	return TEXT_SPEEDS.get(text_speed, 1.0)

func apply() -> void:
	AudioServer.set_bus_volume_db(0, linear_to_db(maxf(volume, 0.0001)))
	AudioServer.set_bus_mute(0, not SOUND_ON)
	if DisplayServer.get_name() == "headless":
		return
	if fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		_size_window()

# A 16:9 window as big as WINDOW_SHARE of the screen it's on, centred.
func _size_window() -> void:
	var screen: int = DisplayServer.window_get_current_screen()
	var usable: Rect2i = DisplayServer.screen_get_usable_rect(screen)
	if usable.size.x <= 0 or usable.size.y <= 0:
		return
	var fit: Vector2 = Vector2(usable.size) * WINDOW_SHARE
	var size: Vector2i = Vector2i(int(minf(fit.x, fit.y * ASPECT)), int(minf(fit.y, fit.x / ASPECT)))
	DisplayServer.window_set_size(size)
	DisplayServer.window_set_position(usable.position + (usable.size - size) / 2)

func save() -> void:
	var file: ConfigFile = ConfigFile.new()
	file.set_value("settings", "volume", volume)
	file.set_value("settings", "text_speed", text_speed)
	file.set_value("settings", "fullscreen", fullscreen)
	file.save(PATH)
