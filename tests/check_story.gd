extends "res://tests/test_base.gd"

# Reads every story file and checks that everything it names exists: sounds
# in the scene that plays it, items, stock, voices, conditions, clock times,
# and the sections that choices and -> lines lead to.
# Run it after writing; it lists every typo it finds.

const STORY_SCENES: Dictionary = {
	"res://story/drive.txt": "res://scenes/drive.tscn",
	"res://story/shop.txt": "res://scenes/shop.tscn",
	"res://story/apartment.txt": "res://scenes/apartment.tscn",
	"res://story/day_one.txt": "res://scenes/counter.tscn",
	"res://story/town.txt": "res://scenes/map.tscn",
}

func run() -> void:
	var items: ConfigFile = ConfigFile.new()
	items.load("res://story/items.cfg")
	var stock: ConfigFile = ConfigFile.new()
	stock.load("res://story/stock.cfg")
	for path in STORY_SCENES:
		section(path.get_file())
		var scene: Node = load(STORY_SCENES[path]).instantiate()
		root.add_child(scene)
		await process_frame
		var sounds: Dictionary = scene.get("sounds") if scene.get("sounds") != null else {}
		var column: Node = load("res://scenes/dialogue_column.tscn").instantiate()
		root.add_child(column)
		column.load_story(path)
		var problems: Array = _check_speakers(path)
		for name in column._story:
			var part: Dictionary = column._story[name]
			for entry in part["lines"] + part["choices"] + part["next"]:
				_check_entry(entry, name, sounds, items, stock, column, problems)
		for problem in problems:
			print("  FAIL  ", problem)
		check(problems.is_empty(), "%d sections, everything they name exists" % column._story.size())
		failures += max(0, problems.size() - 1)
		column.queue_free()
		scene.queue_free()
		await process_frame

# The game quietly turns an unknown speaker into narration, so look for them here.
func _check_speakers(path: String) -> Array:
	var problems: Array = []
	var number: int = 0
	for raw in FileAccess.get_file_as_string(path).split("\n"):
		number += 1
		var text: String = raw.strip_edges()
		if text == "" or text.begins_with("#") or text.begins_with("===") or text.begins_with(">") or text.begins_with("->"):
			continue
		var speaker: String = text.split(": ", true, 1)[0].split("|")[0].strip_edges()
		if not load("res://scripts/narrator.gd").is_speaker(speaker):
			problems.append("line %d: no speaker '%s' in speakers.cfg" % [number, speaker])
	return problems

func _check_entry(entry: Dictionary, part: String, sounds: Dictionary, items: ConfigFile,
		stock: ConfigFile, column: Node, problems: Array) -> void:
	var where: String = "[%s] %s" % [part, entry.get("text", entry.get("label", "-> " + entry.get("target", ""))).left(50)]
	for key in ["sound", "stop", "after"]:
		if entry.has(key) and entry[key] != "all" and not sounds.has(entry[key]):
			problems.append("%s: this scene has no sound '%s'  %s" % [key, entry[key], where])
	for key in ["take", "lose"]:
		if entry.has(key) and not items.has_section(entry[key]):
			problems.append("%s: no item '%s' in items.cfg  %s" % [key, entry[key], where])
	for key in ["lean", "needs"]:
		if entry.has(key) and not gs.voices.has(entry[key]):
			problems.append("%s: no voice '%s'  %s" % [key, entry[key], where])
	if entry.has("sold") and not stock.has_section(entry["sold"]):
		problems.append("sold: no item '%s' in stock.cfg  %s" % [entry["sold"], where])
	if entry.has("set") and not (entry["set"] in gs and gs.get(entry["set"]) is bool):
		problems.append("set: GameState has no true/false '%s'  %s" % [entry["set"], where])
	if entry.has("cash") and not entry["cash"].trim_prefix("+").is_valid_int():
		problems.append("cash '%s' should look like +150 or -5  %s" % [entry["cash"], where])
	if entry.has("time") and not entry["time"].begins_with("+") and entry["time"].split(":").size() != 2:
		problems.append("time '%s' should look like +15 or 23:30  %s" % [entry["time"], where])
	if entry.has("target") and not entry["target"].begins_with("@") and not column._story.has(entry["target"]):
		problems.append("leads to a missing section '%s'  %s" % [entry["target"], where])
	if entry.has("if"):
		var condition: String = entry["if"].trim_prefix("!")
		if condition.begins_with("has:"):
			if not items.has_section(condition.trim_prefix("has:")):
				problems.append("if: no item '%s'  %s" % [condition, where])
		elif not condition.begins_with("broke:"):
			var value: String = condition
			for op in [">=", "<=", "==", "!=", ">", "<"]:
				value = value.split(op)[0]
			value = value.strip_edges()
			if not gs.voices.has(value) and not value in gs:
				problems.append("if: GameState has no '%s'  %s" % [value, where])
