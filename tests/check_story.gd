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
	"res://story/day_two.txt": "res://scenes/counter.tscn",
	"res://story/shop_looks.txt": "res://scenes/counter.tscn",
	"res://story/town.txt": "res://scenes/map.tscn",
	"res://story/night_one.txt": "res://scenes/night.tscn",
	"res://story/night_two.txt": "res://scenes/night.tscn",
}

# Where each scene's spots must find their sections: every file listed.
const SPOT_STORIES: Dictionary = {
	"drive": ["res://story/drive.txt"],
	"shop_night": ["res://story/shop.txt"],
	"apartment_first": ["res://story/apartment.txt"],
	"shop": ["res://story/shop_looks.txt"],
	"night": ["res://story/night_one.txt", "res://story/night_two.txt"],
}

var places: ConfigFile = ConfigFile.new()

func run() -> void:
	_check_spots()
	var items: ConfigFile = ConfigFile.new()
	items.load("res://story/items.cfg")
	var stock: ConfigFile = ConfigFile.new()
	stock.load("res://story/stock.cfg")
	places.load("res://story/places.cfg")
	_check_places(items, stock)
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

# Every spot in spots.cfg must point at a section in its scene's story file.
func _check_spots() -> void:
	section("spots.cfg")
	var spots: ConfigFile = ConfigFile.new()
	spots.load("res://story/spots.cfg")
	var problems: Array = []
	for spot_id in spots.get_sections():
		var scene: String = spots.get_value(spot_id, "scene", "")
		if not SPOT_STORIES.has(scene):
			problems.append("[%s] unknown scene '%s'" % [spot_id, scene])
			continue
		if spots.has_section_key(spot_id, "rect") and str(spots.get_value(spot_id, "rect")).split(",").size() != 4:
			problems.append("[%s] rect= needs four numbers: x, y, width, height" % spot_id)
		var room_to: String = spots.get_value(spot_id, "go", "")
		if room_to != "":
			var rooms: Array = []
			for other in spots.get_sections():
				if spots.get_value(other, "scene", "") == scene:
					rooms.append(spots.get_value(other, "room", ""))
			if not rooms.has(room_to):
				problems.append("[%s] go='%s': no spot in that room, so you'd walk into nothing" % [spot_id, room_to])
			continue
		for path in SPOT_STORIES[scene]:
			var column: Node = load("res://scenes/dialogue_column.tscn").instantiate()
			var story: Dictionary = column._parse_story(path)
			column.free()
			var target: String = spots.get_value(spot_id, "section", "")
			if not story.has(target):
				problems.append("[%s] no section '%s' in %s" % [spot_id, target, path.get_file()])
	for problem in problems:
		print("  FAIL  ", problem)
	check(problems.is_empty(), "%d spots, every one leads to a section" % spots.get_sections().size())
	failures += max(0, problems.size() - 1)

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
	if entry.has("pawned"):
		if not stock.has_section(entry["pawned"]):
			problems.append("pawned: no item '%s' in stock.cfg  %s" % [entry["pawned"], where])
		elif not stock.get_value(entry["pawned"], "arrives", false):
			problems.append("pawned: '%s' needs arrives=true in stock.cfg  %s" % [entry["pawned"], where])
		if not entry.get("loan", "").is_valid_int():
			problems.append("pawned: needs a loan=amount  %s" % where)
	if entry.has("set") and not (entry["set"] in gs and gs.get(entry["set"]) is bool):
		problems.append("set: GameState has no true/false '%s'  %s" % [entry["set"], where])
	if entry.has("cash") and not entry["cash"].trim_prefix("+").is_valid_int():
		problems.append("cash '%s' should look like +150 or -5  %s" % [entry["cash"], where])
	if entry.has("time") and not entry["time"].begins_with("+") and entry["time"].split(":").size() != 2:
		problems.append("time '%s' should look like +15 or 23:30  %s" % [entry["time"], where])
	if entry.has("target") and not entry["target"].begins_with("@") and not column._story.has(entry["target"]):
		problems.append("leads to a missing section '%s'  %s" % [entry["target"], where])
	if entry.has("if"):
		for problem in _condition_problems(entry["if"], items, stock):
			problems.append("if: %s  %s" % [problem, where])

# What's wrong with a condition: "day>=2 or flag:x and !sold:ice_picks".
func _condition_problems(text: String, items: ConfigFile, stock: ConfigFile) -> Array:
	var problems: Array = []
	for either in text.split(" or "):
		for part in either.split(" and "):
			var condition: String = part.strip_edges().trim_prefix("!").strip_edges()
			if condition.begins_with("has:"):
				if not items.has_section(condition.trim_prefix("has:")):
					problems.append("no item '%s'" % condition)
			elif condition.begins_with("sold:"):
				if not stock.has_section(condition.trim_prefix("sold:")):
					problems.append("no stock item '%s'" % condition)
			elif condition.begins_with("visited:"):
				if not places.has_section(condition.trim_prefix("visited:")):
					problems.append("no place '%s' in places.cfg" % condition)
			elif condition.begins_with("background:"):
				if not gs.BACKGROUNDS.has(condition.trim_prefix("background:")):
					problems.append("no background '%s' (guilt, debt, witness, insanity)" % condition)
			elif condition.begins_with("flag:") or condition.begins_with("broke:"):
				pass
			else:
				var value: String = condition
				for op in [">=", "<=", "==", "!=", ">", "<"]:
					value = value.split(op)[0]
				value = value.strip_edges()
				if not gs.voices.has(value) and not value in gs:
					problems.append("GameState has no '%s'" % value)
	return problems

# The town map's own conditions, and the counter's visitors.
func _check_places(items: ConfigFile, stock: ConfigFile) -> void:
	section("places.cfg and the counter's visitors")
	var problems: Array = []
	for place_id in places.get_sections():
		for problem in _condition_problems(places.get_value(place_id, "if", "day>=0"), items, stock):
			problems.append("[%s] %s" % [place_id, problem])
	var visits: Dictionary = load("res://scripts/counter.gd").VISITS
	for day in visits:
		for visit in visits[day]:
			var parts: PackedStringArray = visit.split("| if=", true, 1)
			if parts.size() == 2:
				for problem in _condition_problems(parts[1], items, stock):
					problems.append("day %d, %s: %s" % [day, parts[0].strip_edges(), problem])
	for problem in problems:
		print("  FAIL  ", problem)
	check(problems.is_empty(), "every place and visitor condition makes sense")
	failures += max(0, problems.size() - 1)
