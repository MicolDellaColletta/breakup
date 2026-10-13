extends "res://tests/test_base.gd"

# Daniel's light (docs/daniel_v7.md, section 10): the picture goes faintly
# red while he's in the room, deeper alone with MC, and sometimes, frayed,
# when he isn't there at all. Story lines: red=on, alone, phantom, off.

const STORY: String = "user://test_presence.txt"

var column: Node
var presence: Node

func run() -> void:
	presence = root.get_node("Presence")
	var file: FileAccess = FileAccess.open(STORY, FileAccess.WRITE)
	file.store_string("""=== he_speaks
narration: The bell.
daniel: Good morning.

=== alone
narration | red=alone: The door shuts. It's only the two of you.

=== gone
narration | red=off: He goes.

=== phone
daniel_line: Happy New Year.

=== radio
daniel | on=radio: Good evening, Kettle Lake.

=== silent
narration | red=on: He's in the chair. He doesn't say anything.
""")
	file.close()
	column = load("res://scenes/dialogue_column.tscn").instantiate()
	root.add_child(column)
	column.load_story(STORY)
	await _his_voice()
	await _alone_and_gone()
	await _the_phone()
	await _silent()
	_phantom()
	column.queue_free()
	DirAccess.remove_absolute(STORY)

func _play(section_name: String) -> void:
	column.play(section_name)
	await process_frame
	advance_all()
	await process_frame

func advance_all() -> void:
	for i in 10:
		column._advance()

func _his_voice() -> void:
	section("His voice brings the red")
	presence.leave(true)
	check(presence.state == "" and presence.tint() == Color.WHITE, "nothing at first: the picture as it is")
	await _play("he_speaks")
	check(presence.state == "present", "a line from daniel: he's in the room")
	await wait(2.3)
	var tint: Color = presence.tint()
	check(tint.r == 1.0 and tint.g < 0.85 and tint.b < 0.85, "after the fade, the picture is red, multiplied in")

func _alone_and_gone() -> void:
	section("Alone, deeper; gone, off")
	await _play("alone")
	check(presence.state == "alone", "red=alone: the door shut, the red deepens")
	await wait(2.3)
	var deep: Color = presence.tint()
	check(deep.g < 0.75, "alone it's deeper than in company")
	await wait(0.6)
	check(presence.tint() != deep, "and it breathes")
	await _play("gone")
	check(presence.state == "", "red=off: he goes")
	await wait(1.7)
	check(presence.tint() == Color.WHITE, "the picture comes back")

func _the_phone() -> void:
	section("On the phone he isn't in the room")
	await _play("phone")
	check(presence.state == "", "a daniel_line line leaves the light alone")
	await _play("radio")
	check(presence.state == "", "nor does his voice on the radio (on=radio): he's in every kitchen and none")

func _silent() -> void:
	section("There, and silent")
	await _play("silent")
	check(presence.state == "present", "red=on: present without a word")
	presence.leave(true)
	check(presence.state == "" and presence.tint() == Color.WHITE, "a scene change clears it at once")

func _phantom() -> void:
	section("Frayed: the red with nobody there")
	gs.reset()
	gs.day = 15
	check(not presence.phantom_tonight(), "not frayed: the light tells the truth")
	gs.fray = gs.FRAYED_AT
	check(presence.phantom_tonight(), "frayed, an odd night from his arrival: it comes anyway")
	gs.day = 16
	check(not presence.phantom_tonight(), "not every night")
	gs.day = 13
	check(not presence.phantom_tonight(), "not before he's in town")
	presence.arrive("phantom")
	check(presence.state == "phantom", "phantom is its own state, the faintest")
	presence.heard("daniel")
	check(presence.state == "present", "and if he really speaks, it's real")
	presence.leave(true)
