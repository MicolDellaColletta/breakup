extends SceneTree

# Shared helpers for the tests in this folder. A test extends this file and
# writes its checks in run(). Godot quits with code 1 if any check failed.
# How to run them: see tests/README.md.

var checks: int = 0
var failures: int = 0
var gs: Node

func _initialize() -> void:
	gs = root.get_node("GameState")
	_start.call_deferred()

func _start() -> void:
	await run()
	if checks == 0:
		failures += 1
		print("  FAIL  no checks ran: the test itself is broken")
	print("\n%d checks, %d failed" % [checks, failures])
	quit(1 if failures > 0 else 0)

# Filled in by each test.
func run() -> void:
	pass

func check(ok: bool, what: String) -> void:
	checks += 1
	if ok:
		print("  ok    ", what)
	else:
		failures += 1
		print("  FAIL  ", what)

func section(title: String) -> void:
	print("\n", title)

func wait(seconds: float) -> void:
	await create_timer(seconds).timeout

# Opens a scene the way the game does and waits for its fade-in.
func open_scene(path: String, fade: float = 2.2) -> Node:
	change_scene_to_file(path)
	await process_frame
	await process_frame
	await wait(fade)
	return current_scene

# Clicks Continue (or presses Space) as often as asked.
func advance(column: Node, times: int = 60) -> void:
	for i in times:
		column._on_advance_pressed()

# The choices on screen, without their "1. " numbers.
func choices(column: Node) -> Array:
	var out: Array = []
	for button in column.get_node("%ChoiceBox").get_children():
		if not button.is_queued_for_deletion():
			out.append(button.text.split(". ", true, 1)[1])
	return out

# Clicks the first choice whose text contains these words.
func pick(column: Node, words: String) -> bool:
	await process_frame
	for button in column.get_node("%ChoiceBox").get_children():
		if not button.is_queued_for_deletion() and button.text.contains(words):
			button.pressed.emit()
			return true
	print("  (no choice with '%s' among %s)" % [words, choices(column)])
	return false

# Presses a key, as the player would.
func press_key(keycode: Key) -> void:
	var event: InputEventKey = InputEventKey.new()
	event.keycode = keycode
	event.pressed = true
	root.push_input(event)
	await process_frame
