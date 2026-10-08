extends Control

# The drive: the inside of the car, first person. Click things in the car
# (story/spots.cfg, scene "drive") to look at them; once the radio, glovebox,
# mirror and coat are done, the steering wheel takes you the rest of the way.

const STORY_PATH: String = "res://story/drive.txt"
const SHOP_SCENE: String = "res://scenes/shop.tscn"
const MANDATORY: Array[String] = ["radio", "glovebox", "mirror", "coat"]
# Hotspot ids in spots.cfg are the section name with this in front.
const SPOT_PREFIX: String = "car_"

# Story section that plays after a document is put away.
const AFTER_READING: Dictionary = {
	"job_offer": "job_offer_read",
}

const STATIC_LEVELS: Dictionary = {
	"silent": -80.0,
	"normal": -18.0,
	"loud": -6.0,
}

@onready var narrator: DialogueColumn = $Narrator
@onready var hotspots: HotspotLayer = %Hotspots
@onready var radio_static: AudioStreamPlayer = $RadioStatic
@onready var car_interior: AudioStreamPlayer = $CarInterior
@onready var document_viewer: DocumentViewer = %DocumentViewer

@onready var sounds: Dictionary = {
	"paper": %Paper,
}

var _examining: bool = false
var _main_index: int = 0
var _static_tween: Tween
var _examined: Array[String] = []
var _main_finished: bool = false
var _ending: bool = false
var _arriving: bool = false

func _ready() -> void:
	document_viewer.closed.connect(_on_document_closed)
	narrator.use_sounds(sounds)
	narrator.line_shown.connect(_on_line_shown)
	narrator.section_finished.connect(_on_section_finished)
	narrator.choice_made.connect(_on_choice_made)
	narrator.load_story(STORY_PATH)
	hotspots.fill("drive", "car", narrator)
	hotspots.spot_clicked.connect(click)
	narrator.set_input_enabled(false)
	hotspots.interactive = false
	await Transition.fade_in(2.0)
	hotspots.interactive = true
	narrator.set_input_enabled(true)
	narrator.play("main")

# --- Public: what tests can use ---

# Clicking a hotspot: car_radio, car_wheel, and so on.
func click(spot_id: String) -> void:
	var object_id: String = spot_id.trim_prefix(SPOT_PREFIX)
	if object_id == "wheel":
		_on_wheel_pressed()
	else:
		_examine(object_id)

func _on_line_shown(line: Dictionary) -> void:
	if line.has("static"):
		_set_static(line["static"])

func _on_section_finished(section: String) -> void:
	if section == "main":
		_main_finished = true
		_check_wheel()
	elif section == "wheel":
		_arrive()
	elif section == "glovebox":
		narrator.set_input_enabled(false)
		document_viewer.open("rental_agreement")
	else:
		_return_to_main()

func _on_choice_made(choice: Dictionary) -> void:
	var target: String = choice["target"]
	if target.begins_with("@read_"):
		narrator.set_input_enabled(false)
		document_viewer.open(target.trim_prefix("@read_"))

func _on_document_closed(doc_id: String) -> void:
	narrator.set_input_enabled(true)
	if AFTER_READING.has(doc_id):
		narrator.play(AFTER_READING[doc_id])
	else:
		_return_to_main()

func _return_to_main() -> void:
	_examining = false
	hotspots.interactive = true
	# Once the main text is over there's nothing to pick back up.
	if not _main_finished:
		narrator.start_conversation("main", _main_index, true)
	_check_wheel()

func _examine(object_id: String) -> void:
	if _examining or _ending or _examined.has(object_id):
		return
	_examining = true
	# Asleep while the story talks, so a stray click doesn't start another.
	hotspots.interactive = false
	hotspots.mark_used(SPOT_PREFIX + object_id)
	var sound: String = Spots.sound(SPOT_PREFIX + object_id)
	if sound != "":
		narrator.play_sound(sound)
	_examined.append(object_id)
	_main_index = narrator.get_line_index()
	narrator.start_conversation(object_id)

func _on_wheel_pressed() -> void:
	if _examining:
		return
	_ending = true
	hotspots.interactive = false
	hotspots.mark_used(SPOT_PREFIX + "wheel")
	narrator.start_conversation("wheel")

func _check_wheel() -> void:
	if not _main_finished:
		return
	for object_id in MANDATORY:
		if not _examined.has(object_id):
			return
	hotspots.set_shown(SPOT_PREFIX + "wheel", true)

func _set_static(level: String) -> void:
	var target_db: float = STATIC_LEVELS[level]
	var duration: float = 0.05 if level == "silent" else 0.6
	if _static_tween:
		_static_tween.kill()
	_static_tween = create_tween()
	_static_tween.tween_property(radio_static, "volume_db", target_db, duration)

func _arrive() -> void:
	if _arriving:
		return
	_arriving = true
	narrator.set_input_enabled(false)
	if _static_tween:
		_static_tween.kill()
	var tween: Tween = create_tween().set_parallel()
	tween.tween_property(car_interior, "volume_db", -80.0, 2.0)
	tween.tween_property(radio_static, "volume_db", -80.0, 2.0)
	Transition.go_to(SHOP_SCENE, 2.0, 1.0)
