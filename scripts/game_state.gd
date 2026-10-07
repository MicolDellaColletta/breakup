extends Node

signal time_changed
signal item_added(item_id: String)

const ITEMS_PATH: String = "res://story/items.cfg"
const MINUTES_PER_DAY: int = 24 * 60

# 0 is the prologue night; day one starts the morning after.
var day: int = 0
var answered_phone: bool = false
var fed_dog: bool = false
var rules_broken: Array[String] = []

# Minutes since midnight on the first evening. Past midnight it keeps
# counting up, so 1:00 AM that night is 25 * 60.
var minutes: int = 22 * 60
var hour: int:
	get:
		return floori(minutes / 60.0)

var inventory: Array[String] = ["key", "job_offer"]
var _items: ConfigFile = ConfigFile.new()

func _ready() -> void:
	if _items.load(ITEMS_PATH) != OK:
		push_error("Could not load items: " + ITEMS_PATH)

func break_rule(rule: String) -> void:
	if not rules_broken.has(rule):
		rules_broken.append(rule)

# --- Time ---

func pass_time(amount: int) -> void:
	minutes += amount
	time_changed.emit()

# Moves the clock forward to the next time it reads "23:30". Never backwards.
func set_clock(clock: String) -> void:
	var parts: PackedStringArray = clock.split(":")
	if parts.size() != 2:
		push_warning("Clock time should look like 23:30, got: " + clock)
		return
	var day_start: int = floori(float(minutes) / MINUTES_PER_DAY) * MINUTES_PER_DAY
	var target: int = day_start + parts[0].to_int() * 60 + parts[1].to_int()
	while target < minutes:
		target += MINUTES_PER_DAY
	minutes = target
	time_changed.emit()

func clock_text() -> String:
	var of_day: int = minutes % MINUTES_PER_DAY
	var h: int = floori(of_day / 60.0)
	var suffix: String = "AM" if h < 12 else "PM"
	var shown: int = h % 12
	if shown == 0:
		shown = 12
	return "%d:%02d %s" % [shown, of_day % 60, suffix]

# --- Inventory ---

func add_item(item_id: String) -> void:
	if not _items.has_section(item_id):
		push_warning("Unknown item (add it to items.cfg): " + item_id)
		return
	if inventory.has(item_id):
		return
	inventory.append(item_id)
	item_added.emit(item_id)

func remove_item(item_id: String) -> void:
	inventory.erase(item_id)

func has_item(item_id: String) -> bool:
	return inventory.has(item_id)

func item_info(item_id: String, key: String) -> String:
	return _items.get_value(item_id, key, "")
