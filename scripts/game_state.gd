extends Node

signal time_changed
signal item_added(item_id: String)

const ITEMS_PATH: String = "res://story/items.cfg"
const MINUTES_PER_DAY: int = 24 * 60
# Day of October 1999 on the prologue night (see docs/story.md, Timeline).
const FIRST_NIGHT_DATE: int = 5

# A colored choice (needs=john) shows once its voice has this many points.
const COLORED_CHOICE_AT: int = 3
# While MC is frayed, a ??? choice shows from this many points instead.
const FRAYED_UNKNOWN_CHOICE_AT: int = 1
# Paranoia talks over the other voices once it's this loud (it starts at 3,
# so it takes a few frightened choices), and only over a voice at least
# DROWN_MARGIN points weaker than it.
const PARANOIA_LOUD: int = 6
const DROWN_MARGIN: int = 3
# Fray points at which MC is frayed (see docs/voices.md, "Frayed").
const FRAYED_AT: int = 3
# The voices Paranoia can talk over: not itself, not ???.
const QUIET_VOICES: Array[String] = ["john", "appraisal", "warmth", "animal"]
# Each background and the voice it comes from. Insanity comes from the ???
# track, plus being frayed.
const BACKGROUNDS: Dictionary = {
	"guilt": "warmth",
	"debt": "john",
	"witness": "appraisal",
	"insanity": "unknown",
}

# Each day's story at the counter, and each night's. A day that isn't here
# yet ends the game on the title screen after the night before it.
const DAY_STORIES: Dictionary = {
	1: "res://story/day_one.txt",
	2: "res://story/day_two.txt",
}
const NIGHT_STORIES: Dictionary = {
	1: "res://story/night_one.txt",
	2: "res://story/night_two.txt",
}

# The last ticket number in the owner's hand (the rifle). New pawns count on
# from here. 0527 doesn't count: he skipped ahead to write that one.
const LAST_OWNER_TAG: int = 431
const WEEKDAYS: Array[String] = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
# October 5, 1999 was a Tuesday.
const FIRST_NIGHT_WEEKDAY: int = 2

# Everything below is set in reset(), where a new game starts.

# 0 is the prologue night; day one starts the morning after.
var day: int
var answered_phone: bool
var fed_dog: bool
var invited_to_pub: bool
var locked_back_door: bool
var rules_broken: Array[String] = []
# Things that happened, for later story to remember: flag=ezra_satisfied in a
# story file, if=flag:ezra_satisfied to ask.
var flags: Array[String] = []
# Places on the town map you've been to, any evening (if=visited:lake).
var visited: Array[String] = []
# Times something already looked at was clicked again: picks the reply.
var second_looks: int

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

# How frayed MC is. Every broken rule and every ??? choice adds a point (from
# day one; the prologue doesn't count). A day and night with no rule broken
# takes one away. The player never sees the number, only what it does.
var fray: int
var frayed: bool:
	get:
		return fray >= FRAYED_AT
var broke_today: bool
# Empty until a story moment settles it (settle=background).
var background_settled: String

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
# Items people brought in this season (pawned or sold to the shop).
var acquired: Array[String] = []
var ledger_lines: Array[String] = []
# The ticket written for each thing pawned this season, as "item_id=0433".
var pawn_tags: Array[String] = []

# How the shop is arranged: an item id per spot, "" for an empty one. The
# floor shelves (for sale), the back shelf (held), and the front window (three
# spots, seen from the road: for sale too). Empty until the counter first
# fills them from stock.cfg; the player rearranges them from there.
const SHELF_SPOTS: Dictionary = {"floor": 12, "back": 12, "window": 3}
var shelf_floor: Array[String] = []
var shelf_back: Array[String] = []
var shelf_window: Array[String] = []

func _ready() -> void:
	if _items.load(ITEMS_PATH) != OK:
		push_error("Could not load items: " + ITEMS_PATH)
	reset()

# How a new game starts.
func reset() -> void:
	day = 0
	second_looks = 0
	answered_phone = false
	fed_dog = false
	invited_to_pub = false
	locked_back_door = false
	rules_broken.clear()
	flags.clear()
	visited.clear()
	minutes = 22 * 60
	fray = 0
	broke_today = false
	background_settled = ""
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
	acquired.clear()
	ledger_lines.clear()
	pawn_tags.clear()
	shelf_floor.clear()
	shelf_back.clear()
	shelf_window.clear()
	time_changed.emit()

# --- Saving ---

# Everything a save file keeps. A new value that should survive saving and
# loading needs its name added here.
const SAVED: Array[String] = [
	"day", "answered_phone", "fed_dog", "invited_to_pub", "locked_back_door", "rules_broken",
	"minutes", "voices", "inventory", "cash", "till", "till_by_ledger",
	"sold", "acquired", "ledger_lines", "flags", "visited", "pawn_tags",
	"fray", "broke_today", "background_settled",
	"shelf_floor", "shelf_back", "shelf_window",
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
	if day >= 1:
		fray += 1
		broke_today = true

# fray=+1 or fray=-1 in a story file: a warm thing in your hands, a small
# comfort. Never below zero.
func add_fray(amount: int) -> void:
	fray = maxi(0, fray + amount)

# The end of a night: a whole day and night with no rule broken brings MC
# back a little.
func end_night() -> void:
	if not broke_today:
		add_fray(-1)
	broke_today = false

# True when Paranoia is loud enough to talk over this voice.
func drowned(voice: String) -> bool:
	var paranoia: int = voices.get("paranoia", 0)
	return QUIET_VOICES.has(voice) and paranoia >= PARANOIA_LOUD and paranoia - voices.get(voice, 0) >= DROWN_MARGIN

# The background MC's voices point to right now: the strongest of the four,
# if one leads outright. "" while nothing leads, or once settled, what it
# settled on.
func background() -> String:
	if background_settled != "":
		return background_settled
	var best: String = ""
	var best_score: int = 0
	var tied: bool = false
	for name in BACKGROUNDS:
		var score: int = voices.get(BACKGROUNDS[name], 0)
		if name == "insanity" and frayed:
			score += 2
		if score > best_score:
			best = name
			best_score = score
			tied = false
		elif score == best_score and score > 0:
			tied = true
	return "" if tied else best

# settle=background: from now on the background stays what it is.
func settle_background() -> void:
	background_settled = background()

func set_flag(flag: String) -> void:
	if not flags.has(flag):
		flags.append(flag)

func lean(voice: String, amount: int = 1) -> void:
	if not voices.has(voice):
		push_warning("Unknown voice: " + voice)
		return
	voices[voice] += amount
	# Following ??? is MC slipping.
	if voice == "unknown" and day >= 1:
		fray += amount

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

# "Thu Oct 7", for the clock on screen.
func weekday_text() -> String:
	var days: int = floori(float(minutes) / MINUTES_PER_DAY)
	return "%s %s" % [WEEKDAYS[(FIRST_NIGHT_WEEKDAY + days) % 7], date_text()]

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
	take_off_shelves(item_id)
	till += price
	till_by_ledger += price
	var to: String = (" to " + buyer) if buyer != "" else ""
	ledger_lines.append("%s. %s, sold%s. $%d" % [date_text(), item_name, to, price])

# Someone pawns an item: the loan comes out of the till, and out of your own
# pocket when the till runs short. The ledger writes down the whole loan; its
# drawer total only drops by what actually left the drawer. With no tag given
# (pawn_tag="new" in stock.cfg), it gets the next number in the book.
func record_pawn(item_name: String, item_id: String, loan: int, tag: String, seller: String) -> void:
	if tag == "" or tag == "new":
		tag = next_pawn_tag()
	acquired.append(item_id)
	pawn_tags.append("%s=%s" % [item_id, tag])
	var from_till: int = mini(loan, till)
	till -= from_till
	cash -= loan - from_till
	till_by_ledger -= from_till
	var by: String = (" by " + seller) if seller != "" else ""
	var money: String = ("$%d loan" % loan) if loan > 0 else "No loan"
	ledger_lines.append("%s. %s, pawned%s, tag %s. %s" % [date_text(), item_name, by, tag, money])

# --- The shelves ---

# The spots on one shelf ("floor", "back" or "window").
func shelf(name: String) -> Array[String]:
	match name:
		"floor": return shelf_floor
		"back": return shelf_back
		_: return shelf_window

# Makes sure every shelf has all its spots (empty ones are "").
func ready_shelves() -> void:
	for name in SHELF_SPOTS:
		var spots: Array[String] = shelf(name)
		while spots.size() < SHELF_SPOTS[name]:
			spots.append("")

# Where an item is: [shelf name, spot], or ["", -1] if it isn't on one.
func shelf_spot_of(item_id: String) -> Array:
	for name in SHELF_SPOTS:
		var at: int = shelf(name).find(item_id)
		if at != -1:
			return [name, at]
	return ["", -1]

# Takes an item off whatever shelf it's on (it was sold, or picked up).
func take_off_shelves(item_id: String) -> void:
	var where: Array = shelf_spot_of(item_id)
	if where[1] != -1:
		shelf(where[0])[where[1]] = ""

# Puts an item in a spot. Whatever was there goes where the item came from
# (a swap), or nowhere if it came from nowhere.
func place_on_shelf(item_id: String, name: String, spot: int) -> void:
	var from: Array = shelf_spot_of(item_id)
	var there: String = shelf(name)[spot]
	if from[1] != -1:
		shelf(from[0])[from[1]] = there
	shelf(name)[spot] = item_id

# The first empty spot on a shelf, or -1.
func empty_spot(name: String) -> int:
	return shelf(name).find("")

# The next ticket number: one past the highest written so far.
func next_pawn_tag() -> String:
	var highest: int = LAST_OWNER_TAG
	for entry in pawn_tags:
		highest = maxi(highest, entry.get_slice("=", 1).to_int())
	return "%04d" % (highest + 1)

# The ticket written for something pawned this season, or "" if it wasn't.
func pawn_tag_of(item_id: String) -> String:
	for entry in pawn_tags:
		if entry.get_slice("=", 0) == item_id:
			return entry.get_slice("=", 1)
	return ""

# A line in the ledger with no item and no money (write= in a story file).
func write_ledger(text: String) -> void:
	ledger_lines.append("%s. %s" % [date_text(), text])

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
