extends Control

# The title screen: where the game opens and where "Quit to title" leads.

const FIRST_SCENE: String = "res://scenes/drive.tscn"

@onready var continue_button: Button = %ContinueButton
@onready var new_game_button: Button = %NewGameButton
@onready var load_button: Button = %LoadButton
@onready var settings_button: Button = %SettingsButton
@onready var quit_button: Button = %QuitButton
@onready var wind: AudioStreamPlayer = %Wind

var _confirming: bool = false

func _ready() -> void:
	Hud.visible = false
	$Layout.add_child(Menu.keys_hint_label())
	continue_button.pressed.connect(_continue)
	new_game_button.pressed.connect(_new_game)
	load_button.pressed.connect(Menu.open_slots.bind(false, true))
	settings_button.pressed.connect(Menu.open_settings.bind(true))
	quit_button.pressed.connect(get_tree().quit)
	var has_saves: bool = Saves.latest_slot() != -1
	continue_button.visible = has_saves
	# The latest save is the last card of what's written: nothing to continue.
	var can_continue: bool = has_saves
	if has_saves and at_the_end(Saves.slot_info(Saves.latest_slot())):
		continue_button.text = "The end" if Saves.slot_info(Saves.latest_slot()).get("finished", false) else "To be continued"
		continue_button.disabled = true
		can_continue = false
	load_button.disabled = not has_saves
	(continue_button if can_continue else new_game_button).grab_focus()
	await Transition.fade_in(1.5)

func _exit_tree() -> void:
	Hud.visible = true

# The most recent save, autosave or not.
func _continue() -> void:
	_leave()
	Saves.load_slot(Saves.latest_slot())

# A save that stands at the end of what's written: the ending has played, or
# it's a last bridge with no day after it.
static func at_the_end(save: Dictionary) -> bool:
	if not save.is_empty() and save.get("finished", false):
		return true
	if save.is_empty() or save["scene"] != GameState.BRIDGE_SCENE:
		return false
	return GameState.day_scene(int(save["state"].get("day", 0))) == ""

# A new game replaces the autosave: with saves already there, it asks first.
func _new_game() -> void:
	if Saves.latest_slot() != -1 and not _confirming:
		_confirming = true
		new_game_button.text = "Start over? The autosave will be replaced."
		return
	_leave()
	GameState.reset()
	Transition.go_to(FIRST_SCENE, 1.5, 0.5)

func _leave() -> void:
	for button in [continue_button, new_game_button, load_button, settings_button, quit_button]:
		button.disabled = true
	create_tween().tween_property(wind, "volume_db", -80.0, 1.5)
