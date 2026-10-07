extends Node

signal time_changed
signal item_added(item_id: String)

const ITEMS_PATH: String = "res://story/items.cfg"
const MINUTES_PER_DAY: int = 24 * 60
# Day of October 1999 on the prologue night (see docs/story.md, Timeline).
const FIRST_NIGHT_DATE: int = 5

# A colored choice (needs=john) shows once its voice has this many points.
const COLORED_CHOICE_AT: int = 3

# Everything below is set in reset(), where a new game starts.

# 0 is the prologue night; day one starts the morning after.
var day: int
var answered_phone: bool
var fed_dog: bool
var invited_to_pub: bool
var locked_back_door: bool
var rules_broken: Array[String] = []

# Minutes since midnight on the first evening. Past midnight it keeps
# counting up, so 1:00 AM that night is 25 * 60.
var minutes: int
var hour: int:
	get:
		return floori(minutes / 60.0)

# The voices in MC's head and how strong each one is (see docs/voices.md).
# The player never sees the numbers. "unknown" is the ??? track: not a
# voice, MC slipping.
var voices: Dictionary = {}

var inventory: Array[String] = []
var _items: ConfigFile = ConfigFile.new()

# Two pots of money. Your pocket: what you came with, plus Management's
# envelopes. The till: the shop's money, from sales, written in the ledger.
# Taking from the till isn't written down, so the ledger stops adding up.
var cash: int
var till: int
var till_by_ledger: int
var till_short: int:
	get:
		return till_by_ledger - till

# Shop items that have been sold, and the lines written in the ledger this
# season ("Oct 6. Duck call, sold to Mrs. Hollis. $15").
var sold: Array[String] = []
var ledger_lines: Array[String] = []

func _ready() -> void:
	if _items.load(ITEMS_PATH) != OK:
		push_error("Could not load items: " + ITEMS_PATH)
	reset()

# How a new game starts.
func reset() -> void:
	day = 0
	answered_phone = false
	fed_dog = false
	invited_to_pub = false
	locked_back_door = false
	rules_broken.clear()
	minutes = 22 * 60
	# Paranoia starts high: in the prologue fear drowns everything else out.
	# The others wake up on day one.
	voices = {
		"paranoia": 3,
		"john": 0,
		"appraisal": 0,
		"warmth": 0,
		"animal": 0,
		"unknown": 0,
	}
	inventory.assign(["key", "job_offer"])
	# What MC came with (placeholder: why depends on the background).
	cash = 38
	till = 0
	till_by_ledger = 0
	sold.clear()
	ledger_lines.clear()
	time_changed.emit()

# --- Saving ---

# Everything a save file keeps. A new value that should survive saving and
# loading needs its name added here.
const SAVED: Array[String] = [
	"day", "answered_phone", "fed_dog", "invited_to_pub", "locked_back_door", "rules_broken",
	"minutes", "voices", "inventory", "cash", "till", "till_by_ledger",
	"sold", "ledger_lines",
]

func to_dict() -> Dictionary:
	var data: Dictionary = {}
	for key in SAVED:
		var value: Variant = get(key)
		data[key] = value.duplicate(true) if value is Array or value is Dictionary else value
	return data

# Save files store every number as a decimal, so each value is turned back
# into the kind GameState expects.
func from_dict(data: Dictionary) -> void:
	reset()
	for key in SAVED:
		if not data.has(key):
			continue
		var current: Variant = get(key)
		var value: Variant = data[key]
		if current is Array:
			current.assign(value)
		elif current is Dictionary:
			for name in value:
				current[name] = int(value[name])
		elif current is bool:
			set(key, bool(value))
		elif current is int:
			set(key, int(value))
		else:
			set(key, value)
	time_changed.emit()

func break_rule(rule: String) -> void:
	if not rules_broken.has(rule):
		rules_broken.append(rule)

func lean(voice: String, amount: int = 1) -> void:
	if not voices.has(voice):
		push_warning("Unknown voice: " + voice)
		return
	voices[voice] += amount

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

# The prologue night is October 5, 1999. The date turns over at midnight.
func date_text() -> String:
	return "Oct %d" % (FIRST_NIGHT_DATE + floori(float(minutes) / MINUTES_PER_DAY))

func clock_text() -> String:
	var of_day: int = minutes % MINUTES_PER_DAY
	var h: int = floori(of_day / 60.0)
	var suffix: String = "AM" if h < 12 else "PM"
	var shown: int = h % 12
	if shown == 0:
		shown = 12
	return "%d:%02d %s" % [shown, of_day % 60, suffix]

# --- Money and the ledger ---

func add_cash(amount: int) -> void:
	cash += amount

# A sale: the money goes in the till and the ledger writes it down.
func record_sale(item_name: String, item_id: String, price: int, buyer: String) -> void:
	sold.append(item_id)
	till += price
	till_by_ledger += price
	var to: String = (" to " + buyer) if buyer != "" else ""
	ledger_lines.append("%s. %s, sold%s. $%d" % [date_text(), item_name, to, price])

# Money taken from the till for yourself. The ledger doesn't know.
func take_from_till(amount: int) -> void:
	amount = mini(amount, till)
	till -= amount
	cash += amount

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
