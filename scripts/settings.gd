extends Node

# Player settings, remembered between sessions: volume, text speed and
# fullscreen.

const PATH: String = "user://settings.cfg"
const TEXT_SPEEDS: Dictionary = {
	"Slow": 0.6,
	"Normal": 1.0,
	"Fast": 1.7,
}

var volume: float = 0.8
var text_speed: String = "Normal"
var fullscreen: bool = false

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
	if DisplayServer.get_name() != "headless":
		DisplayServer.window_set_mode(
			DisplayServer.WINDOW_MODE_FULLSCREEN if fullscreen else DisplayServer.WINDOW_MODE_WINDOWED)

func save() -> void:
	var file: ConfigFile = ConfigFile.new()
	file.set_value("settings", "volume", volume)
	file.set_value("settings", "text_speed", text_speed)
	file.set_value("settings", "fullscreen", fullscreen)
	file.save(PATH)
