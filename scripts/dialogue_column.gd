class_name DialogueColumn
extends Narrator

# Disco Elysium style: lines pile up in a scrolling column, the newest one
# types out and older ones fade. Choices are numbered at the bottom, and the
# one you pick is written into the log.

const MAX_ENTRIES: int = 60
const OLD_LINE_ALPHA: float = 0.55
const FONT_SIZE: int = 18
const CHOICE_COLOR: Color = Color(0.86, 0.47, 0.29)

@onready var scroll: ScrollContainer = %Scroll
@onready var log_box: VBoxContainer = %Log

var _current: RichTextLabel

func _process(delta: float) -> void:
	super(delta)
	advance_button.visible = _input_enabled and _current != null and not _section_done

func has_section(section: String) -> bool:
	return _story.has(section)

func _display_line(line: Dictionary, speaker: Dictionary) -> void:
	_add_entry(line["text"], speaker)

func _text_label() -> Variant:
	return _current

func _make_choice_button(choice: Dictionary, number: int) -> Button:
	var button: Button = Button.new()
	button.text = "%d. %s" % [number, choice["label"]]
	button.flat = true
	button.alignment = HORIZONTAL_ALIGNMENT_LEFT
	button.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	button.add_theme_font_size_override("font_size", FONT_SIZE)
	button.add_theme_color_override("font_color", CHOICE_COLOR)
	return button

func _on_choice_pressed(choice: Dictionary) -> void:
	var entry: RichTextLabel = _add_entry(choice["label"], speaker_info("you"))
	entry.visible_characters = entry.get_total_character_count()
	super(choice)

func _add_entry(text: String, speaker: Dictionary) -> RichTextLabel:
	if _current:
		_current.modulate.a = OLD_LINE_ALPHA
	var entry: RichTextLabel = RichTextLabel.new()
	entry.bbcode_enabled = true
	entry.fit_content = true
	entry.scroll_active = false
	entry.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	entry.add_theme_font_size_override("normal_font_size", FONT_SIZE)
	entry.add_theme_font_size_override("bold_font_size", FONT_SIZE)
	entry.add_theme_color_override("default_color", speaker["color"])
	entry.text = _format(text, speaker["name"])
	log_box.add_child(entry)
	_current = entry
	while log_box.get_child_count() > MAX_ENTRIES:
		log_box.get_child(0).free()
	_scroll_to_end()
	return entry

# "PARANOIA — Don't make a sound." Narration has no name in front.
func _format(text: String, speaker_name: String) -> String:
	var safe: String = text.replace("[", "[lb]")
	if speaker_name == "":
		return safe
	return "[b]%s[/b] — %s" % [speaker_name.to_upper(), safe]

func _scroll_to_end() -> void:
	await get_tree().process_frame
	scroll.scroll_vertical = int(scroll.get_v_scroll_bar().max_value)
