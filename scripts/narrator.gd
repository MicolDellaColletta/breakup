class_name Narrator
extends Control

signal line_shown(line: Dictionary)
signal section_finished(section: String)

const CHARACTERS_PER_SECOND: float = 30.0

const SPEAKERS: Dictionary = {
	"narration": {"name": "", "color": Color(0.85, 0.87, 0.91)},
	"paranoia": {"name": "Paranoia", "color": Color(0.79, 0.71, 0.35)},
	"unknown": {"name": "???", "color": Color(0.78, 0.36, 0.43)},
}

@onready var speaker_label: Label = $TextBox/SpeakerLabel
@onready var narration_label: Label = $TextBox/NarrationLabel
@onready var advance_button: Button = $AdvanceButton

var _story: Dictionary = {}
var _section: String = ""
var _lines: Array = []
var _line_index: int = 0
var _revealed: float = 0.0
var _input_enabled: bool = true
var _section_done: bool = false

func _ready() -> void:
	advance_button.pressed.connect(_on_advance_pressed)

func _process(delta: float) -> void:
	if _is_line_finished():
		return
	_revealed += CHARACTERS_PER_SECOND * delta
	narration_label.visible_characters = int(_revealed)

func _unhandled_input(event: InputEvent) -> void:
	if _input_enabled and event.is_action_pressed("ui_accept"):
		_on_advance_pressed()

# --- Public: what other scenes can use ---

func load_story(path: String) -> void:
	_story = _parse_story(path)

func play(section: String, start_index: int = 0, instant: bool = false) -> void:
	if not _story.has(section):
		push_error("No story section called: " + section)
		return
	_section = section
	_lines = _story[section]
	_section_done = false
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
	section_finished.emit(_section)

func _show_line(index: int) -> void:
	_line_index = index
	var line: Dictionary = _lines[index]
	var speaker: Dictionary = SPEAKERS[line["speaker"]]
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
			sections[current] = []
			continue
		var parts: PackedStringArray = text.split(":", true, 1)
		if parts.size() < 2 or current == "":
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
		for i in range(1, header.size()):
			var option: PackedStringArray = header[i].split("=")
			if option.size() == 2:
				line[option[0].strip_edges()] = option[1].strip_edges()
		sections[current].append(line)
	return sections
