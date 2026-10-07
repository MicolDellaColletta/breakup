extends CanvasLayer

# The pause menu (Esc in the game) and the save, load and settings screens,
# which the title screen uses too. The game freezes while it's open.

const TITLE_SCENE: String = "res://scenes/title.tscn"

@onready var dim: ColorRect = %Dim
@onready var pause_panel: Control = %PausePanel
@onready var slots_panel: Control = %SlotsPanel
@onready var settings_panel: Control = %SettingsPanel
@onready var slots_title: Label = %SlotsTitle
@onready var slots_note: Label = %SlotsNote
@onready var slot_list: VBoxContainer = %SlotList
@onready var volume_slider: HSlider = %VolumeSlider
@onready var speed_option: OptionButton = %SpeedOption
@onready var fullscreen_check: CheckButton = %FullscreenCheck

# Opened from the title screen: Back closes the menu instead of returning
# to the pause menu.
var _from_title: bool = false
var _saving: bool = false

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_close_all()
	%ResumeButton.pressed.connect(resume)
	%SaveButton.pressed.connect(open_slots.bind(true))
	%LoadButton.pressed.connect(open_slots.bind(false))
	%SettingsButton.pressed.connect(open_settings)
	%QuitButton.pressed.connect(_quit_to_title)
	%SlotsBack.pressed.connect(_back)
	%SettingsBack.pressed.connect(_back)
	for speed in Settings.TEXT_SPEEDS:
		speed_option.add_item(speed)
	volume_slider.value_changed.connect(_on_volume_changed)
	speed_option.item_selected.connect(_on_speed_selected)
	fullscreen_check.toggled.connect(_on_fullscreen_toggled)

func _unhandled_input(event: InputEvent) -> void:
	if not event.is_action_pressed("ui_cancel"):
		return
	get_viewport().set_input_as_handled()
	if slots_panel.visible or settings_panel.visible:
		_back()
	elif pause_panel.visible:
		resume()
	elif not _on_title():
		open_pause()

# --- Public: what other scenes can use ---

func is_open() -> bool:
	return dim.visible

func open_pause() -> void:
	_from_title = false
	get_tree().paused = true
	_close_all()
	dim.visible = true
	pause_panel.visible = true
	%SaveButton.disabled = not Saves.can_save()
	%ResumeButton.grab_focus()

func resume() -> void:
	_close_all()
	get_tree().paused = false

func open_slots(saving: bool, from_title: bool = false) -> void:
	_from_title = from_title
	_saving = saving
	_close_all()
	dim.visible = true
	slots_panel.visible = true
	slots_title.text = "Save" if saving else "Load"
	if saving:
		slots_note.text = "A save keeps your progress from the start of this part:\n%s." % Saves.checkpoint_label()
	else:
		slots_note.text = "Loading starts that part again."
	_fill_slots()

func open_settings(from_title: bool = false) -> void:
	_from_title = from_title
	_close_all()
	dim.visible = true
	settings_panel.visible = true
	volume_slider.value = Settings.volume
	speed_option.select(Settings.TEXT_SPEEDS.keys().find(Settings.text_speed))
	fullscreen_check.button_pressed = Settings.fullscreen
	%SettingsBack.grab_focus()

# --- Private: the machinery ---

func _fill_slots() -> void:
	for old in slot_list.get_children():
		old.queue_free()
	var first: int = 1 if _saving else 0
	for slot in range(first, Saves.MANUAL_SLOTS + 1):
		var data: Dictionary = Saves.slot_info(slot)
		var name: String = "Autosave" if slot == 0 else "Slot %d" % slot
		var button: Button = Button.new()
		button.text = "%s:  %s" % [name, data.get("label", "empty")]
		button.alignment = HORIZONTAL_ALIGNMENT_LEFT
		button.disabled = not _saving and data.is_empty()
		button.pressed.connect(_on_slot_pressed.bind(slot))
		slot_list.add_child(button)
	if slot_list.get_child_count() > 0:
		slot_list.get_child(0).grab_focus.call_deferred()

func _on_slot_pressed(slot: int) -> void:
	if _saving:
		Saves.save(slot)
		slots_note.text = "Saved."
		_fill_slots()
		return
	resume()
	Saves.load_slot(slot)

func _back() -> void:
	if _from_title:
		_close_all()
	else:
		open_pause()

func _close_all() -> void:
	dim.visible = false
	pause_panel.visible = false
	slots_panel.visible = false
	settings_panel.visible = false

func _quit_to_title() -> void:
	resume()
	Transition.go_to(TITLE_SCENE, 1.0)

func _on_title() -> bool:
	var scene: Node = get_tree().current_scene
	return scene != null and scene.scene_file_path == TITLE_SCENE

func _on_volume_changed(value: float) -> void:
	Settings.volume = value
	Settings.apply()
	Settings.save()

func _on_speed_selected(index: int) -> void:
	Settings.text_speed = Settings.TEXT_SPEEDS.keys()[index]
	Settings.save()

func _on_fullscreen_toggled(on: bool) -> void:
	Settings.fullscreen = on
	Settings.apply()
	Settings.save()
