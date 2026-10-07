extends Node

# Saving and loading. A save keeps your progress from the start of the part
# you're in (the drive, the shop, the first night, the counter, the evening):
# loading starts that part again, with everything from before it.
# Slot 0 is the autosave, written every time a new part starts.

const MANUAL_SLOTS: int = 3
const VERSION: int = 1

# The parts of the game a save can start from, and how the menu names them.
const PARTS: Dictionary = {
	"res://scenes/drive.tscn": "The drive",
	"res://scenes/shop.tscn": "The shop",
	"res://scenes/apartment.tscn": "The first night",
	"res://scenes/counter.tscn": "The counter",
	"res://scenes/map.tscn": "The evening",
}

# Tests point this somewhere else, so they never touch the player's saves.
var save_dir: String = "user://saves/"
var _checkpoint: Dictionary = {}

# --- Public: what other scenes can use ---

# Called as each part starts (see Transition.go_to): remembers where you
# are, and writes the autosave.
func mark_checkpoint(scene_path: String) -> void:
	if not PARTS.has(scene_path):
		return
	_checkpoint = {
		"version": VERSION,
		"scene": scene_path,
		"label": "%s, %s, %s" % [PARTS[scene_path], GameState.date_text(), GameState.clock_text()],
		"state": GameState.to_dict(),
	}
	_write(0)

func can_save() -> bool:
	return not _checkpoint.is_empty()

# What a save made now would keep, for the menu to say.
func checkpoint_label() -> String:
	return _checkpoint.get("label", "")

func save(slot: int) -> void:
	if can_save():
		_write(slot)

# The slot's contents, or {} when it's empty or unreadable.
func slot_info(slot: int) -> Dictionary:
	var path: String = _path(slot)
	if not FileAccess.file_exists(path):
		return {}
	var data: Variant = JSON.parse_string(FileAccess.get_file_as_string(path))
	if not data is Dictionary or not data.has("scene") or not data.has("state"):
		push_warning("Unreadable save: " + path)
		return {}
	return data

func load_slot(slot: int) -> void:
	var data: Dictionary = slot_info(slot)
	if data.is_empty():
		return
	GameState.from_dict(data["state"])
	Transition.go_to(data["scene"], 1.0)

# The most recently written slot, or -1 when there are no saves.
func latest_slot() -> int:
	var best: int = -1
	var best_time: String = ""
	for slot in range(0, MANUAL_SLOTS + 1):
		var data: Dictionary = slot_info(slot)
		if not data.is_empty() and data.get("saved_at", "") > best_time:
			best = slot
			best_time = data.get("saved_at", "")
	return best

# --- Private: the machinery ---

func _write(slot: int) -> void:
	DirAccess.make_dir_recursive_absolute(save_dir)
	var data: Dictionary = _checkpoint.duplicate(true)
	data["saved_at"] = Time.get_datetime_string_from_system(false, true)
	var file: FileAccess = FileAccess.open(_path(slot), FileAccess.WRITE)
	if file == null:
		push_error("Could not write save: " + _path(slot))
		return
	file.store_string(JSON.stringify(data, "\t"))

func _path(slot: int) -> String:
	return save_dir + ("autosave.json" if slot == 0 else "slot_%d.json" % slot)
