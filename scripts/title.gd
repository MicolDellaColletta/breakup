extends Control

# The title screen: where the game opens and where "Quit to title" leads.

const FIRST_SCENE: String = "res://scenes/drive.tscn"

@onready var continue_button: Button = %ContinueButton
@onready var new_game_button: Button = %NewGameButton
@onready var load_button: Button = %LoadButton
@onready var settings_button: Button = %SettingsButton
@onready var quit_button: Button = %QuitButton
@onready var wind: AudioStreamPlayer = %Wind

func _ready() -> void:
	Hud.visible = false
	continue_button.pressed.connect(_continue)
	new_game_button.pressed.connect(_new_game)
	load_button.pressed.connect(Menu.open_slots.bind(false, true))
	settings_button.pressed.connect(Menu.open_settings.bind(true))
	quit_button.pressed.connect(get_tree().quit)
	var has_saves: bool = Saves.latest_slot() != -1
	continue_button.visible = has_saves
	load_button.disabled = not has_saves
	(continue_button if has_saves else new_game_button).grab_focus()
	await Transition.fade_in(1.5)

func _exit_tree() -> void:
	Hud.visible = true

# The most recent save, autosave or not.
func _continue() -> void:
	_leave()
	Saves.load_slot(Saves.latest_slot())

func _new_game() -> void:
	_leave()
	GameState.reset()
	Transition.go_to(FIRST_SCENE, 1.5, 0.5)

func _leave() -> void:
	for button in [continue_button, new_game_button, load_button, settings_button, quit_button]:
		button.disabled = true
	create_tween().tween_property(wind, "volume_db", -80.0, 1.5)
