extends Control

# The drive: the inside of the car, first person. Nothing can be clicked until
# the opening text is over; then click things in the car (story/spots.cfg,
# scene "drive") to look at them. Once you've looked at enough of them, the
# steering wheel takes you the rest of the way. Two things open into close-ups
# of their own: the glovebox (room "glovebox"), where each thing inside can be
# clicked and which counts as done once you've taken the pawn ticket; and the
# rearview mirror (room "mirror"), where the headlights behind you go out.

const STORY_PATH: String = "res://story/drive.txt"
const USE_PATH: String = "res://story/use.txt"
const SHOP_SCENE: String = "res://scenes/shop.tscn"
# How many of the car's things to look at before the wheel shows up.
const ENOUGH_LOOKED: int = 3
# Hotspot ids in spots.cfg are the section name with this in front.
const SPOT_PREFIX: String = "car_"
# Hotspots inside a close-up start with one of these.
const CLOSEUP_PREFIXES: Array[String] = ["glove_", "mirror_"]
const VIEW_FADE: float = 0.25

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
@onready var car_art: Control = %CarArt
@onready var glovebox_art: Control = %GloveboxArt
@onready var mirror_art: Control = %MirrorArt
@onready var exterior_art: Control = %ExteriorArt
@onready var radio_static: AudioStreamPlayer = $RadioStatic
@onready var car_interior: AudioStreamPlayer = $CarInterior
@onready var document_viewer: DocumentViewer = %DocumentViewer

@onready var sounds: Dictionary = {
	"paper": %Paper,
}

var _examining: bool = false
var _static_tween: Tween
var _examined: Array[String] = []
var _main_finished: bool = false
var _ending: bool = false
var _arriving: bool = false
# "car", "glovebox" or "mirror": which picture is on screen.
var _view: String = "car"
# Every hotspot already clicked, in any view, so it stays done when you come back.
var _used: Array[String] = []

func _ready() -> void:
	document_viewer.closed.connect(_on_document_closed)
	narrator.use_sounds(sounds)
	narrator.line_shown.connect(_on_line_shown)
	narrator.section_finished.connect(_on_section_finished)
	narrator.choice_made.connect(_on_choice_made)
	narrator.load_story(STORY_PATH)
	narrator.add_story(USE_PATH)
	hotspots.fill("drive", "car", narrator)
	hotspots.spot_clicked.connect(click)
	hotspots.aside.connect(play_aside)
	narrator.set_input_enabled(false)
	hotspots.interactive = false
	await Transition.fade_in(2.0)
	# The car wakes up once the opening text is over.
	narrator.set_input_enabled(true)
	narrator.play("main")

# --- Public: what tests can use ---

# Clicking a hotspot: car_radio, car_wheel, and so on.
func click(spot_id: String) -> void:
	if not _main_finished:
		return
	for prefix in CLOSEUP_PREFIXES:
		if spot_id.begins_with(prefix):
			_closeup_click(spot_id)
			return
	var object_id: String = spot_id.trim_prefix(SPOT_PREFIX)
	if object_id == "wheel":
		_on_wheel_pressed()
	else:
		_examine(object_id)

# A short scene that changes nothing: something from your pockets used on a
# hotspot, or a second look (story/use.txt).
# The hotspots only pass it on while they're awake, so nothing else is talking.
func play_aside(section: String) -> void:
	if not _main_finished or _ending:
		return
	_examining = true
	hotspots.interactive = false
	narrator.start_conversation(section)

func current_view() -> String:
	return _view

func _on_line_shown(line: Dictionary) -> void:
	if line.has("static"):
		_set_static(line["static"])
	# show=exterior: the shop from the road, behind the text.
	if line.get("show", "") == "exterior":
		exterior_art.visible = true
		create_tween().tween_property(exterior_art, "modulate:a", 1.0, 1.5)
	# show=mirror_empty: the headlights behind you go out.
	if line.get("show", "") == "mirror_empty":
		create_tween().tween_property(mirror_art, "lights", 0.0, 0.3)

func _on_section_finished(section: String) -> void:
	if section == "main":
		_main_finished = true
		hotspots.interactive = true
		_check_wheel()
	elif section == "wheel":
		_arrive()
	elif section == "glovebox":
		await _show_view("glovebox")
		hotspots.interactive = true
	elif section == "glovebox_papers":
		narrator.set_input_enabled(false)
		document_viewer.open("rental_agreement")
	elif section == "glovebox_close":
		await _show_view("car")
		_return_to_main()
	elif _view != "car":
		# Something in a close-up: back to it.
		if section == "glovebox_ticket" and not _examined.has("glovebox"):
			_examined.append("glovebox")
		hotspots.interactive = true
	else:
		_return_to_main()

func _on_choice_made(choice: Dictionary) -> void:
	var target: String = choice["target"]
	if target.begins_with("@read_"):
		narrator.set_input_enabled(false)
		document_viewer.open(target.trim_prefix("@read_"))

func _on_document_closed(doc_id: String) -> void:
	narrator.set_input_enabled(true)
	if _view != "car":
		hotspots.interactive = true
		return
	if AFTER_READING.has(doc_id):
		narrator.play(AFTER_READING[doc_id])
	else:
		_return_to_main()

func _return_to_main() -> void:
	_examining = false
	hotspots.interactive = true
	_check_wheel()

func _examine(object_id: String) -> void:
	if _examining or _ending or _examined.has(object_id):
		return
	_examining = true
	# Asleep while the story talks, so a stray click doesn't start another.
	hotspots.interactive = false
	# The glovebox can be opened again until you've taken what matters.
	if object_id == "glovebox":
		narrator.start_conversation("glovebox")
		return
	_use(SPOT_PREFIX + object_id)
	var sound: String = Spots.sound(SPOT_PREFIX + object_id)
	if sound != "":
		narrator.play_sound(sound)
	_examined.append(object_id)
	# The mirror: a close-up, and the lights in it.
	if object_id == "mirror":
		await _show_view("mirror")
	narrator.start_conversation(object_id)

# Something in a close-up (the open glovebox, the mirror), or leaving it.
func _closeup_click(spot_id: String) -> void:
	if _view == "car" or not hotspots.interactive or _used.has(spot_id):
		return
	hotspots.interactive = false
	var sound: String = Spots.sound(spot_id)
	if sound != "":
		narrator.play_sound(sound)
	# go=car: eyes back on the road.
	if Spots.go(spot_id) == "car":
		await _show_view("car")
		_return_to_main()
		return
	if spot_id != "glove_close":
		_use(spot_id)
	narrator.start_conversation(Spots.section(spot_id))

func _use(spot_id: String) -> void:
	_used.append(spot_id)
	hotspots.mark_used(spot_id)

# Swaps the picture and its hotspots, with a quick dip to black.
func _show_view(view: String) -> void:
	var fade: Tween = create_tween()
	fade.tween_property(self, "modulate", Color(0.2, 0.2, 0.2), VIEW_FADE)
	await fade.finished
	_view = view
	car_art.visible = view == "car"
	glovebox_art.visible = view == "glovebox"
	mirror_art.visible = view == "mirror"
	hotspots.fill("drive", view, narrator)
	for spot_id in _used:
		hotspots.mark_used(spot_id)
	if view == "car":
		_check_wheel()
	fade = create_tween()
	fade.tween_property(self, "modulate", Color.WHITE, VIEW_FADE)

func _on_wheel_pressed() -> void:
	if _examining:
		return
	_ending = true
	hotspots.interactive = false
	_use(SPOT_PREFIX + "wheel")
	narrator.start_conversation("wheel")

func _check_wheel() -> void:
	if _examined.has("glovebox"):
		hotspots.mark_used(SPOT_PREFIX + "glovebox")
	if _main_finished and _examined.size() >= ENOUGH_LOOKED:
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
	# The text slides away and the shop stays on screen a moment, alone.
	if exterior_art.visible:
		narrator.hide_column()
		await get_tree().create_timer(2.5).timeout
	var tween: Tween = create_tween().set_parallel()
	tween.tween_property(car_interior, "volume_db", -80.0, 2.0)
	tween.tween_property(radio_static, "volume_db", -80.0, 2.0)
	Transition.go_to(SHOP_SCENE, 2.0, 1.0)
