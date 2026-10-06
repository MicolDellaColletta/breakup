extends Control

const STORY_PATH: String = "res://story/apartment.txt"

@onready var narrator: Narrator = %Narrator
@onready var fade: ColorRect = %Fade

func _ready() -> void:
	narrator.section_finished.connect(_on_section_finished)
	narrator.load_story(STORY_PATH)
	narrator.set_input_enabled(false)
	fade.modulate.a = 1.0
	var tween: Tween = create_tween()
	tween.tween_property(fade, "modulate:a", 0.0, 1.5)
	await tween.finished
	narrator.set_input_enabled(true)
	narrator.play("arrival")

func _on_section_finished(section: String) -> void:
	match section:
		"arrival":
			var echo: String = "echo_answered" if GameState.answered_phone else "echo_ignored"
			narrator.play(echo)
		"echo_answered", "echo_ignored":
			print("Night 1: the window, the radio, the bed. (Next mission.)")
