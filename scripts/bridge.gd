extends Control

# Between key days (from week two on): the days skipped, told in under a
# minute. A title card in the town's voice, white on black like a silent film,
# and a few lines under it (story/bridges.txt, the section GameState.BRIDGES
# names for today). A line with card=... puts up a new card. Then on to the
# day itself, or the title screen if it isn't written yet.

const STORY_PATH: String = "res://story/bridges.txt"
const TITLE_SCENE: String = "res://scenes/title.tscn"
const CARD_FADE: float = 0.8

@onready var narrator: DialogueColumn = %Narrator
@onready var card: Label = %Card

var _leaving: bool = false

func _ready() -> void:
	card.text = ""
	card.modulate.a = 0.0
	narrator.line_shown.connect(_on_line_shown)
	narrator.section_finished.connect(_on_section_finished)
	narrator.load_story(STORY_PATH)
	narrator.set_input_enabled(false)
	await Transition.fade_in(1.2)
	narrator.set_input_enabled(true)
	narrator.play(GameState.BRIDGES.get(GameState.day, "bridge_wednesday"))

# --- Public: what tests can use ---

func card_text() -> String:
	return card.text

# --- Private: the machinery ---

func _on_line_shown(line: Dictionary) -> void:
	if not line.has("card"):
		return
	card.text = line["card"]
	# A card that names a day ("Friday. The Keeper dresses the window.") moves
	# the clock on to that day, so the clock and the card agree.
	GameState.advance_to_weekday(line["card"].get_slice(".", 0).strip_edges())
	card.modulate.a = 0.0
	create_tween().tween_property(card, "modulate:a", 1.0, CARD_FADE)

func _on_section_finished(_section: String) -> void:
	if _leaving:
		return
	_leaving = true
	narrator.set_input_enabled(false)
	var next: String = GameState.day_scene(GameState.day)
	Transition.go_to(next if next != "" else TITLE_SCENE, 2.0, 1.0)
