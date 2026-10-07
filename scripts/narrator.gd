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
	_show_line(start_index)
	if instant:
		_finish_line()

func get_line_index() -> int:
	return _line_index

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
	_section_done = true
	if _choices.is_empty():
		section_finished.emit(_section)
	else:
		_show_choices()

func _show_choices() -> void:
	for old in choice_box.get_children():
		old.queue_free()
	for choice in _choices:
		var button: Button = Button.new()
		button.text = choice["label"]
		button.pressed.connect(_on_choice_pressed.bind(choice))
		choice_box.add_child(button)
	choice_box.visible = true

func _hide_choices() -> void:
	choice_box.visible = false

func _on_choice_pressed(choice: Dictionary) -> void:
	_hide_choices()
	if choice.has("break"):
		GameState.break_rule(choice["break"])
	choice_made.emit(choice)
	# Targets starting with @ are events for the scene, not story sections.
	var target: String = choice["target"]
	if not target.begins_with("@"):
		play(target)

func _show_line(index: int) -> void:
	_line_index = index
	var line: Dictionary = _lines[index]
	var speaker: Dictionary = SPEAKERS[line["speaker"]]
	_speed = speaker.get("speed", CHARACTERS_PER_SECOND)
	speaker_label.text = speaker["name"]
	speaker_label.add_theme_color_override("font_color", speaker["color"])
	narration_label.add_theme_color_override("font_color", speaker["color"])
	narration_label.text = line["text"]
	_revealed = 0.0
	narration_label.visible_characters = 0
	line_shown.emit(line)

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
			sections[current] = {"lines": [], "choices": []}
			continue
		if current == "":
			push_warning("Skipping line outside a section: " + raw)
			continue
		if text.begins_with(">"):
			var choice: Dictionary = _parse_choice(text.trim_prefix(">"))
			if choice.is_empty():
				push_warning("Skipping choice, it needs 'Label -> target': " + raw)
				continue
			choice["from"] = current
			sections[current]["choices"].append(choice)
			continue
		var parts: PackedStringArray = text.split(":", true, 1)
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
		var option: PackedStringArray = parts[i].split("=")
		if option.size() == 2:
			into[option[0].strip_edges()] = option[1].strip_edges()

func _check_targets(path: String) -> void:
	for section in _story:
		for choice in _story[section]["choices"]:
			var target: String = choice["target"]
			if not target.begins_with("@") and not _story.has(target):
				push_warning("Choice '%s' in %s points to a missing section: %s" % [choice["label"], path, target])
