extends "res://tests/test_base.gd"

# The counts (docs/december.md): kept faith with six people and the doors
# of three romances, worked out from flags; the town's eye, stored, seeded
# once on December 1. Story files ask with faith:ruth>=1, faithless:sam,
# doors:daniel>=2, eye>=3, and change them with keep=, betray=, door=, eye=.

var column: Node

func run() -> void:
	column = load("res://scenes/dialogue_column.tscn").instantiate()
	root.add_child(column)
	_faith()
	_doors()
	_eye()
	_effects()
	_saved()
	await _repeated_flags()
	column.queue_free()

func _faith() -> void:
	section("Kept faith: worked out from the flags already written")
	gs.reset()
	check(not column._condition_met("faith:hollis") and not column._condition_met("faithless:hollis"), "nothing yet: neither kept nor broken")
	gs.set_flag("faith_hollis")
	check(column._condition_met("faith:hollis") and gs.faith_count("hollis") == 1, "the jacket given back: kept faith with the Hollises")
	gs.set_flag("ezra_satisfied")
	gs.set_flag("kept_ezra_shells")
	check(column._condition_met("faith:ezra>=2"), "Ezra: the shells in week one, and kept from the stranger at Thanksgiving")
	gs.set_flag("showed_olstad_ticket")
	gs.set_flag("tried_to_run")
	check(gs.faith_count("olstad") == 0 and not gs.is_faithless("olstad"), "trying to run costs Olstad's trust, but doesn't close her")
	gs.set_flag("told_olstad_daniel")
	check(column._condition_met("faith:olstad==1"), "telling her about him earns it back")
	gs.set_flag("door_ruth_1")
	gs.set_flag("broke_faith_ruth")
	check(column._condition_met("faithless:ruth") and gs.faith_count("ruth") == 0, "an open betrayal closes Ruth: no kept faith")

func _doors() -> void:
	section("The doors: door_<who>_<n>, closed by a betrayal")
	gs.reset()
	gs.set_flag("door_ruth_1")
	gs.set_flag("door_ruth_2")
	gs.set_flag("door_sam_1")
	gs.set_flag("door_daniel_1")
	check(column._condition_met("doors:ruth>=2") and column._condition_met("doors:sam==1") and column._condition_met("doors:daniel"), "Ruth two doors, Sam one, Daniel one")
	gs.set_flag("broke_faith_sam")
	check(gs.doors("sam") == 0 and not column._condition_met("doors:sam"), "Sam betrayed: his doors close")

func _eye() -> void:
	section("The town's eye: seeded once, on December 1")
	gs.reset()
	for flag in ["walked_out", "said_on_air", "sat_in_place", "refused_pie", "tried_to_run", "skated_over"]:
		gs.set_flag(flag)
	gs.day = 17
	gs.start_day()
	check(gs.eye == 0, "not before December")
	gs.day = 18
	gs.start_day()
	check(gs.eye == gs.EYE_SEED_CAP, "December 1: six strange things seen, capped at four")
	gs.add_eye(1)
	gs.start_day()
	check(gs.eye == gs.EYE_SEED_CAP + 1 and column._condition_met("eye>=5"), "seeded once only; eye>=5")

func _effects() -> void:
	section("keep=, betray=, door=, eye= from story lines")
	gs.reset()
	column._apply_effects({"keep": "ruth", "door": "sam", "eye": "+2"})
	column._apply_effects({"keep": "ruth"})
	check(gs.faith_count("ruth") == 2 and gs.flags.has("keep_ruth_2"), "keep=ruth twice: two kept moments")
	check(gs.doors("sam") == 1 and gs.eye == 2, "door=sam opens his first door; eye=+2")
	column._apply_effects({"door": "sam"})
	column._apply_effects({"door": "sam"})
	column._apply_effects({"door": "sam"})
	check(gs.doors("sam") == gs.DOORS_EACH, "three doors at most")
	column._apply_effects({"betray": "ruth"})
	column._apply_effects({"keep": "ruth", "door": "ruth"})
	check(gs.faith_count("ruth") == 0 and gs.doors("ruth") == 0, "betray=ruth: nothing more can be kept, no door opens")
	column._apply_effects({"eye": "-9"})
	check(gs.eye == 0, "the eye never goes below nothing")

func _saved() -> void:
	section("Saved")
	gs.reset()
	gs.add_eye(3)
	gs.keep_faith("sam")
	var saved: Dictionary = gs.to_dict()
	gs.reset()
	gs.from_dict(saved)
	check(gs.eye == 3 and gs.faith_count("sam") == 1, "the eye and kept faith survive a save")

func _repeated_flags() -> void:
	section("Two flag= on one line both count")
	gs.reset()
	var parsed: Dictionary = {}
	column._parse_options(PackedStringArray(["x", " flag=fed_fifteen ", " flag=bowl_door"]), parsed)
	column._apply_effects(parsed)
	check(gs.flags.has("fed_fifteen") and gs.flags.has("bowl_door"), "flag=fed_fifteen | flag=bowl_door sets both")
	await process_frame
