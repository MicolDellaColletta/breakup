class_name Spots
extends RefCounted

# The things you can look at in a room (story/spots.cfg). Scenes ask for the
# spots in a room and make a button (later, a clickable spot) for each.

const PATH: String = "res://story/spots.cfg"

static var _file: ConfigFile

# Spot ids in this scene and room whose condition holds, in file order.
# The narrator checks the conditions, the same way story files do.
static func in_room(scene: String, room: String, narrator: Narrator) -> Array[String]:
	var found: Array[String] = []
	for spot_id in _spots().get_sections():
		if _spots().get_value(spot_id, "scene", "") != scene or _spots().get_value(spot_id, "room", "") != room:
			continue
		var condition: String = _spots().get_value(spot_id, "if", "")
		if condition != "" and not narrator._condition_met(condition):
			continue
		found.append(spot_id)
	return found

static func label(spot_id: String) -> String:
	return _spots().get_value(spot_id, "label", spot_id)

static func section(spot_id: String) -> String:
	return _spots().get_value(spot_id, "section", spot_id)

static func _spots() -> ConfigFile:
	if _file == null:
		_file = ConfigFile.new()
		if _file.load(PATH) != OK:
			push_error("Could not load spots: " + PATH)
	return _file
