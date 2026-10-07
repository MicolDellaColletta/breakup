class_name Narrator
extends Control

signal line_shown(line: Dictionary)
signal section_finished(section: String)
# Sent when the player picks a choice, before its target section plays.
# The choice has "label", "target", "from" (its section) and any options.
signal choice_made(choice: Dictionary)

const CHARACTERS_PER_SECOND: float = 30.0

const SPEAKERS: Dictionary = {
	"narration": {"name": "", "color": Color(0.85, 0.87, 0.91), "speed": 30.0},
	"paranoia": {"name": "Paranoia", "color": Color(0.79, 0.71, 0.35), "speed": 45.0},
	"unknown": {"name": "???", "color": Color(0.78, 0.36, 0.43), "speed": 18.0},
}

@onready var speaker_label: Label = $TextBox/SpeakerLabel
@onready var narration_label: Label = $TextBox/NarrationLabel
@onready var advance_button: Button = $AdvanceButton
@onready var choice_box: HBoxContainer = $ChoiceBox

var _story: Dictionary = {}
var _section: String = ""
var _lines: Array = []
var _choices: Array = []
var _line_index: int = 0
var _revealed: float = 0.0
var _input_enabled: bool = true
var _section_done: bool = false
var _speed: float = CHARACTERS_PER_SECOND
var _sounds: Dictionary = {}

func _ready() -> void:
	advance_button.pressed.connect(_on_advance_pressed)
	choice_box.visible = false

func _process(delta: float) -> void:
	if _is_line_finished():
		return
	_revealed += _speed * delta
	narration_label.visible_characters = int(_revealed)

func _unhandled_input(event: InputEvent) -> void:
	if _input_enabled and event.is_action_pressed("ui_accept"):
		_on_advance_pressed()

# --- Public: what other scenes can use ---

func load_story(path: String) -> void:
	_story = _parse_story(path)
	_check_targets(path)

func play(section: String, start_index: int = 0, instant: bool = false) -> void:
	if not _story.has(section):
		push_error("No story section called: " + section)
		return
	_section = section
	_lines = _story[section]["lines"]
	_choices = _story[section]["choices"]
	_section_done = false
	_hide_choices()
	# A section with no lines only routes to another one.
	if _lines.is_empty():
		_end_section()
		return
	# An instant start resumes a line the player already saw, so its
	# sounds, time and items don't happen a second time.
	_show_line(start_index, not instant)
	if instant:
		_finish_line()

func get_line_index() -> int:
	return _line_index

# The scene's sounds, by the names story files use: sound=bell, stop=ring.
func use_sounds(sounds: Dictionary) -> void:
	_sounds = sounds

func play_sound(sound_name: String) -> void:
	if not _sounds.has(sound_name):
		push_warning("Unknown sound: " + sound_name)
		return
	_sounds[sound_name].play()

func stop_sound(sound_name: String) -> void:
	if sound_name == "all":
		for player in _sounds.values():
			player.stop()
		return
	if not _sounds.has(sound_name):
		push_warning("Unknown sound: " + sound_name)
		return
	_sounds[sound_name].stop()

func set_input_enabled(enabled: bool) -> void:
	_input_enabled = enabled
	advance_button.disabled = not enabled

# --- Private: the machinery ---

func _on_advance_pressed() -> void:
	if _is_line_finished():
		_advance()
	else:
		_finish_line()

func _advance() -> void:
	# A finished section stays on its last line until play() starts a new one.
	if _section_done:
		return
	var next_index: int = _line_index + 1
	if next_index < _lines.size():
		_show_line(next_index)
		return
	_end_section()

# What happens after the last line: choices if there are any, otherwise the
# first "->" whose condition holds. Only when neither applies does the
# scene get section_finished.
func _end_section() -> void:
	_section_done = true
	var choices: Array = _story[_section]["choices"].filter(_is_available)
	if not choices.is_empty():
		_show_choices(choices)
		return
	for next in _story[_section]["next"]:
		if _is_available(next):
			play(next["target"])
			return
	section_finished.emit(_section)

func _is_available(entry: Dictionary) -> bool:
	return not entry.has("if") or _condition_met(entry["if"])

# answered_phone, !answered_phone, rules_broken>=2, broke:window
func _condition_met(condition: String) -> bool:
	var text: String = condition.strip_edges()
	var negate: bool = text.begins_with("!")
	if negate:
		text = text.substr(1).strip_edges()
	var result: bool
	if text.begins_with("broke:"):
		result = GameState.rules_broken.has(text.trim_prefix("broke:"))
	elif text.begins_with("has:"):
		result = GameState.has_item(text.trim_prefix("has:"))
	else:
		result = _compare(text)
	return result != negate

func _compare(text: String) -> bool:
	for op in [">=", "<=", "==", "!=", ">", "<"]:
		var parts: PackedStringArray = text.split(op, true, 1)
		if parts.size() < 2:
			continue
		var value: float = _state_number(parts[0].strip_edges())
		var wanted: float = parts[1].strip_edges().to_float()
		match op:
			">=": return value >= wanted
			"<=": return value <= wanted
			"==": return value == wanted
			"!=": return value != wanted
			">": return value > wanted
			"<": return value < wanted
	var state: Variant = _state_value(text)
	return true if state else false

func _state_value(name: String) -> Variant:
	if not name in GameState:
		push_warning("Story condition uses unknown GameState value: " + name)
		return null
	return GameState.get(name)

# Lists count their items, true/false count as 1/0.
func _state_number(name: String) -> float:
	var state: Variant = _state_value(name)
	if state is Array:
		return state.size()
	if state is bool:
		return 1.0 if state else 0.0
	if state is int or state is float:
		return float(state)
	return 0.0

func _show_choices(choices: Array) -> void:
	for old in choice_box.get_children():
		old.queue_free()
	for choice in choices:
		var button: Button = Button.new()
		button.text = choice["label"]
		button.pressed.connect(_on_choice_pressed.bind(choice))
		choice_box.add_child(button)
	choice_box.visible = true

func _hide_choices() -> void:
	choice_box.visible = false

func _on_choice_pressed(choice: Dictionary) -> void:
	_hide_choices()
	_apply_effects(choice)
	choice_made.emit(choice)
	# Targets starting with @ are events for the scene, not story sections.
	var target: String = choice["target"]
	if not target.begins_with("@"):
		play(target)

func _show_line(index: int, with_effects: bool = true) -> void:
	_line_index = index
	var line: Dictionary = _lines[index]
	if with_effects:
		_apply_effects(line)
	var speaker: Dictionary = SPEAKERS[line["speaker"]]
	_speed = speaker.get("speed", CHARACTERS_PER_SECOND)
	speaker_label.text = speaker["name"]
	speaker_label.add_theme_color_override("font_color", speaker["color"])
	narration_label.add_theme_color_override("font_color", speaker["color"])
	narration_label.text = line["text"]
	_revealed = 0.0
	narration_label.visible_characters = 0
	line_shown.emit(line)

# Options that change the world, on a line when it's shown or on a choice
# when it's picked: stop=, sound=, time=, take=, lose=, break=
func _apply_effects(entry: Dictionary) -> void:
	if entry.has("stop"):
		stop_sound(entry["stop"])
	if entry.has("sound"):
		if entry.has("after"):
			_play_after(entry["sound"], entry["after"])
		else:
			play_sound(entry["sound"])
	if entry.has("time"):
		var time: String = entry["time"]
		if time.begins_with("+"):
			GameState.pass_time(time.to_int())
		else:
			GameState.set_clock(time)
	if entry.has("take"):
		GameState.add_item(entry["take"])
	if entry.has("lose"):
		GameState.remove_item(entry["lose"])
	if entry.has("break"):
		GameState.break_rule(entry["break"])
	if entry.has("set"):
		_set_flag(entry["set"])

# set=fed_dog turns a true/false value in GameState on.
func _set_flag(name: String) -> void:
	if not name in GameState or not GameState.get(name) is bool:
		push_warning("set= needs a true/false value in GameState: " + name)
		return
	GameState.set(name, true)

# sound=door_shut | after=bell: wait for the bell to finish first.
func _play_after(sound_name: String, first: String) -> void:
	if _sounds.has(first) and _sounds[first].playing:
		await _sounds[first].finished
	play_sound(sound_name)

func _finish_line() -> void:
	_revealed = narration_label.get_total_character_count()
	narration_label.visible_characters = int(_revealed)

func _is_line_finished() -> bool:
	return narration_label.visible_characters >= narration_label.get_total_character_count()

func _parse_story(path: String) -> Dictionary:
	var sections: Dictionary = {}
	var current: String = ""
	var file: FileAccess = FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error("Could not open story file: " + path)
		return sections
	while not file.eof_reached():
		var raw: String = file.get_line()
		var text: String = raw.strip_edges()
		if text == "" or text.begins_with("#"):
			continue
		if text.begins_with("==="):
			current = text.trim_prefix("===").strip_edges()
			sections[current] = {"lines": [], "choices": [], "next": []}
			continue
		if current == "":
			push_warning("Skipping line outside a section: " + raw)
			continue
		if text.begins_with("->"):
			var parts: PackedStringArray = text.trim_prefix("->").split("|")
			var next: Dictionary = {"target": parts[0].strip_edges()}
			_parse_options(parts, next)
			sections[current]["next"].append(next)
			continue
		if text.begins_with(">"):
			var choice: Dictionary = _parse_choice(text.trim_prefix(">"))
			if choice.is_empty():
				push_warning("Skipping choice, it needs 'Label -> target': " + raw)
				continue
			choice["from"] = current
			sections[current]["choices"].append(choice)
			continue
		# Split at ": " so options like time=23:30 or if=has:key stay whole.
		var parts: PackedStringArray = text.split(": ", true, 1)
		if parts.size() < 2:
			push_warning("Skipping line: " + raw)
			continue
		var header: PackedStringArray = parts[0].split("|")
		var speaker: String = header[0].strip_edges()
		if not SPEAKERS.has(speaker):
			push_warning("Unknown speaker '%s' in %s, using narration: %s" % [speaker, path, raw])
			speaker = "narration"
		var line: Dictionary = {
			"speaker": speaker,
			"text": parts[1].strip_edges(),
		}
		_parse_options(header, line)
		sections[current]["lines"].append(line)
	return sections

# "Leave it open -> window_open | break=window"
func _parse_choice(body: String) -> Dictionary:
	var parts: PackedStringArray = body.split("|")
	var arrow: PackedStringArray = parts[0].split("->", true, 1)
	if arrow.size() < 2:
		return {}
	var choice: Dictionary = {
		"label": arrow[0].strip_edges(),
		"target": arrow[1].strip_edges(),
	}
	_parse_options(parts, choice)
	return choice

# Reads "name=value" options from every part after the first.
func _parse_options(parts: PackedStringArray, into: Dictionary) -> void:
	for i in range(1, parts.size()):
		var option: PackedStringArray = parts[i].split("=", true, 1)
		if option.size() == 2:
			into[option[0].strip_edges()] = option[1].strip_edges()

func _check_targets(path: String) -> void:
	for section in _story:
		for entry in _story[section]["choices"] + _story[section]["next"]:
			var target: String = entry["target"]
			if not target.begins_with("@") and not _story.has(target):
				push_warning("'%s' in %s points to a missing section: %s" % [section, path, target])
