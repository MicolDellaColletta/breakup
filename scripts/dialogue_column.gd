class_name DialogueColumn
extends Narrator

# Disco Elysium style: lines pile up in a scrolling column, the newest one
# types out and older ones fade. Choices are numbered at the bottom, and the
# one you pick is written into the log.
# The column slides in when a line starts and slides out when the story hands
# control back to the scene, so the world gets the whole screen in between.

const MAX_ENTRIES: int = 60
const OLD_LINE_ALPHA: float = 0.55
const FONT_SIZE: int = 18
const CHOICE_COLOR: Color = Color(0.86, 0.47, 0.29)
const SLIDE_DISTANCE: float = 48.0
const SLIDE_TIME: float = 0.25

@onready var scroll: ScrollContainer = %Scroll
@onready var log_box: VBoxContainer = %Log

var _current: RichTextLabel
var _shown: bool = false
var _slide_tween: Tween
var _home_left: float
var _home_right: float

func _ready() -> void:
	super()
	_home_left = offset_left
	_home_right = offset_right
	offset_left = _home_left + SLIDE_DISTANCE
	offset_right = _home_right + SLIDE_DISTANCE
	modulate.a = 0.0
	visible = false
	section_finished.connect(_on_own_section_finished)
	# Wrapped text only knows its height after layout, so follow the scrollbar
	# itself: whenever the log grows, jump to the bottom.
	scroll.get_v_scroll_bar().changed.connect(_scroll_to_end)

func _process(delta: float) -> void:
	super(delta)
	advance_button.visible = _input_enabled and _current != null and not _section_done

# --- Public: what other scenes can use ---

func has_section(section: String) -> bool:
	return _story.has(section)

# A fresh conversation (an object, a customer walking in): the log starts
# empty. play() on its own continues the conversation already on screen.
func start_conversation(section: String, start_index: int = 0, instant: bool = false) -> void:
	clear_log()
	play(section, start_index, instant)

func clear_log() -> void:
	for entry in log_box.get_children():
		entry.free()
	_current = null

func show_column() -> void:
	if _shown:
		return
	_shown = true
	visible = true
	_slide(0.0, 1.0)

func hide_column() -> void:
	if not _shown:
		return
	_shown = false
	await _slide(SLIDE_DISTANCE, 0.0)
	if not _shown:
		visible = false

# --- Private: the machinery ---

func _slide(distance: float, alpha: float) -> void:
	if _slide_tween:
		_slide_tween.kill()
	_slide_tween = create_tween().set_parallel()
	_slide_tween.tween_property(self, "offset_left", _home_left + distance, SLIDE_TIME)
	_slide_tween.tween_property(self, "offset_right", _home_right + distance, SLIDE_TIME)
	_slide_tween.tween_property(self, "modulate:a", alpha, SLIDE_TIME)
	await _slide_tween.finished

# Nothing more to say: the world gets the screen back.
func _on_own_section_finished(_section: String) -> void:
	hide_column()

func _display_line(line: Dictionary, speaker: Dictionary, resumed: bool) -> void:
	show_column()
	if not resumed:
		_add_entry(line["text"], speaker)
	elif log_box.get_child_count() == 0:
		# Picking up where we left off in a fresh log: show that line again,
		# already typed out.
		var entry: RichTextLabel = _add_entry(line["text"], speaker)
		entry.visible_characters = entry.get_total_character_count()

func _text_label() -> Variant:
	return _current

func _make_choice_button(choice: Dictionary, number: int) -> Button:
	var button: Button = Button.new()
	var color: Color = CHOICE_COLOR
	button.text = "%d. %s" % [number, choice["label"]]
	# voice=tongue: a choice that voice put in your head, shown in its color.
	if choice.has("voice"):
		var voice: Dictionary = speaker_info(choice["voice"])
		button.text = "%d. [%s] %s" % [number, voice["name"].to_upper(), choice["label"]]
		color = voice["color"]
	button.flat = true
	button.alignment = HORIZONTAL_ALIGNMENT_LEFT
	button.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	button.add_theme_font_size_override("font_size", FONT_SIZE)
	button.add_theme_color_override("font_color", color)
	return button

func _on_choice_pressed(choice: Dictionary) -> void:
	var entry: RichTextLabel = _add_entry(choice["label"], speaker_info("you"))
	entry.visible_characters = entry.get_total_character_count()
	super(choice)
	# @events hand control to the scene (a document, the shelves, a door).
	if choice["target"].begins_with("@"):
		hide_column()

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
	return entry

# "PARANOIA — Don't make a sound." Narration has no name in front.
func _format(text: String, speaker_name: String) -> String:
	var safe: String = text.replace("[", "[lb]")
	if speaker_name == "":
		return safe
	return "[b]%s[/b] — %s" % [speaker_name.to_upper(), safe]

func _scroll_to_end() -> void:
	scroll.scroll_vertical = int(scroll.get_v_scroll_bar().max_value)
