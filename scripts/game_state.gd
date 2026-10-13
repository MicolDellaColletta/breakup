extends Node

signal time_changed
signal item_added(item_id: String)

const ITEMS_PATH: String = "res://story/items.cfg"
const MINUTES_PER_DAY: int = 24 * 60
# Day of October 1999 on the prologue night (see docs/story.md, Timeline).
const FIRST_NIGHT_DATE: int = 5
# The season, October 1999 to breakup: each month and its length.
const MONTHS: Array = [["Oct", 31], ["Nov", 30], ["Dec", 31], ["Jan", 31], ["Feb", 29], ["Mar", 31], ["Apr", 30]]

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
	3: "res://story/day_three.txt",
	4: "res://story/day_four.txt",
	5: "res://story/day_five.txt",
	6: "res://story/day_six.txt",
	7: "res://story/day_seven.txt",
	8: "res://story/day_eight.txt",
	9: "res://story/day_nine.txt",
	10: "res://story/day_ten.txt",
	11: "res://story/day_eleven.txt",
	12: "res://story/day_twelve.txt",
	13: "res://story/day_thirteen.txt",
	14: "res://story/day_fourteen.txt",
	15: "res://story/day_fifteen.txt",
	16: "res://story/day_sixteen.txt",
	17: "res://story/day_seventeen.txt",
	18: "res://story/day_eighteen.txt",
	19: "res://story/day_nineteen.txt",
	20: "res://story/day_twenty.txt",
	21: "res://story/day_twentyone.txt",
	22: "res://story/day_twentytwo.txt",
	23: "res://story/day_twentythree.txt",
	24: "res://story/day_twentyfour.txt",
	25: "res://story/day_twentyfive.txt",
	26: "res://story/day_twentysix.txt",
}
# Evenings that are walked instead of picked from the town map (key day 10:
# the first-ice party on the lake). The story starts at "evening" and ends
# with end=night.
const EVENINGS: Dictionary = {
	10: "res://story/evening_ten.txt",
	19: "res://story/evening_nineteen.txt",
	25: "res://story/evening_twentyfive.txt",
}
# Where a walked evening starts (the first-ice party on the shore).
const EVENING_ROOMS: Dictionary = {
	10: "shore",
	19: "cabin_road",
	25: "shore",
}
const MAP_SCENE: String = "res://scenes/map.tscn"
const VISIT_SCENE: String = "res://scenes/visit.tscn"
# Days that aren't spent at the counter, and the scene they are (Sunday: the
# shop is closed; you walk to church and around town by day).
const DAY_SCENES: Dictionary = {
	5: "res://scenes/visit.tscn",
	9: "res://scenes/visit.tscn",
	12: "res://scenes/visit.tscn",
	14: "res://scenes/visit.tscn",
	17: "res://scenes/visit.tscn",
	20: "res://scenes/visit.tscn",
	22: "res://scenes/visit.tscn",
	23: "res://scenes/visit.tscn",
	26: "res://scenes/visit.tscn",
}
# After week one, the story days are key days, with days skipped between them.
# Which calendar day (counted from October 5, the drive) each one is. Days
# not listed fall on the day after the last (week one: day 3 is October 8).
const DAY_DATES: Dictionary = {
	8: 9,
	9: 12,
	10: 18,
	11: 25,
	12: 26,
	13: 31,
	14: 47,
	15: 49,
	16: 50,
	17: 51,
	18: 57,
	19: 60,
	20: 68,
	21: 77,
	22: 80,
	23: 87,
	24: 90,
	25: 102,
	26: 110,
	27: 123,
}
# A bridge before a key day covers the days skipped: a title card and a few
# lines (story/bridges.txt, the section named here), then the day itself.
const BRIDGES: Dictionary = {
	8: "bridge_wednesday",
	9: "bridge_weekend",
	10: "bridge_monday",
	11: "bridge_sunday",
	13: "bridge_november",
	14: "bridge_mid_november",
	15: "bridge_thanksgiving_week",
	18: "bridge_late_november",
	19: "bridge_early_december",
	20: "bridge_second_week",
	21: "bridge_mid_december",
	22: "bridge_christmas_week",
	23: "bridge_christmas",
	24: "bridge_into_january",
	25: "bridge_early_january",
	26: "bridge_late_january",
	27: "bridge_into_february",
}
const BRIDGE_SCENE: String = "res://scenes/bridge.tscn"
const COUNTER_SCENE: String = "res://scenes/counter.tscn"
const NIGHT_STORIES: Dictionary = {
	1: "res://story/night_one.txt",
	2: "res://story/night_two.txt",
	3: "res://story/night_three.txt",
	4: "res://story/night_four.txt",
	5: "res://story/night_five.txt",
	6: "res://story/night_six.txt",
	7: "res://story/night_seven.txt",
	8: "res://story/night_eight.txt",
	9: "res://story/night_nine.txt",
	10: "res://story/night_ten.txt",
	11: "res://story/night_eleven.txt",
	12: "res://story/night_twelve.txt",
	13: "res://story/night_thirteen.txt",
	14: "res://story/night_fourteen.txt",
	15: "res://story/night_fifteen.txt",
	16: "res://story/night_sixteen.txt",
	17: "res://story/night_seventeen.txt",
	18: "res://story/night_eighteen.txt",
	19: "res://story/night_nineteen.txt",
	20: "res://story/night_twenty.txt",
	21: "res://story/night_twentyone.txt",
	22: "res://story/night_twentytwo.txt",
	23: "res://story/night_twentythree.txt",
	24: "res://story/night_twentyfour.txt",
	25: "res://story/night_twentyfive.txt",
	26: "res://story/night_twentysix.txt",
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
# How many times each rule has been broken ("dog": 2): story files ask with
# broken:dog>=2, for what comes back days later (docs/nights.md).
var rule_tally: Dictionary = {}
# Tonight's stops, in the order you went to them (night.gd fills it; not
# saved: a night restarts from its beginning). Story files ask with
# order:back_door<windows.
var night_order: Array[String] = []
# Things that happened, for later story to remember: flag=ezra_satisfied in a
# story file, if=flag:ezra_satisfied to ask.
var flags: Array[String] = []
# The town's eye (docs/forks.md, docs/december.md): how much strangeness the
# town has seen MC do, through the people who watch. Never shown. Seeded once,
# on December 1, from what they'd already seen; then eye=+1 in story files.
var eye: int
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
# The last voice a choice leaned toward: it breaks a tie when the background
# settles (the John night's last choice).
var last_lean: String

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
# Properties of things in the shop you've found out, as "item_id/kind"
# (duck_call/marks): scripts/props.gd.
var known_props: Array[String] = []

const SHELF_SPOTS: Dictionary = {"floor": 16, "back": 12, "window": 3}
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
	rule_tally.clear()
	night_order.clear()
	flags.clear()
	eye = 0
	visited.clear()
	minutes = 22 * 60
	fray = 0
	broke_today = false
	background_settled = ""
	last_lean = ""
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
	known_props.clear()
	time_changed.emit()

# --- Saving ---

# Everything a save file keeps. A new value that should survive saving and
# loading needs its name added here.
const SAVED: Array[String] = [
	"day", "answered_phone", "fed_dog", "invited_to_pub", "locked_back_door", "rules_broken", "rule_tally",
	"minutes", "voices", "inventory", "cash", "till", "till_by_ledger",
	"sold", "acquired", "ledger_lines", "flags", "visited", "pawn_tags",
	"fray", "broke_today", "background_settled", "last_lean",
	"shelf_floor", "shelf_back", "shelf_window", "known_props", "eye",
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
	rule_tally[rule] = int(rule_tally.get(rule, 0)) + 1
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

# settle=background: from now on the background stays what it is. A tie (or
# no lead at all) goes to the last voice leaned toward, if it's one of the
# tied ones; otherwise the first of them.
func settle_background() -> void:
	var settled: String = background()
	if settled == "":
		var top: int = -1
		var tied: Array[String] = []
		for name in BACKGROUNDS:
			var score: int = voices.get(BACKGROUNDS[name], 0) + (2 if name == "insanity" and frayed else 0)
			if score > top:
				top = score
				tied = [name]
			elif score == top:
				tied.append(name)
		settled = tied[0]
		for name in tied:
			if BACKGROUNDS[name] == last_lean:
				settled = name
	background_settled = settled

# --- The counts: kept faith, the doors, the town's eye (docs/december.md) ---

# The six people MC can keep faith with, and the flags that already say so.
# Kept faith and doors are worked out from flags, never stored apart from
# them: keep=ruth adds keep_ruth_1, keep_ruth_2...; betray=ruth adds
# betrayed_ruth. A betrayal closes that person: no more kept faith, no doors.
const FAITH: Dictionary = {
	"walt": {"kept": ["walt_kind"], "broken": ["walt_hard"]},
	"hollis": {"kept": ["faith_hollis"], "broken": ["broke_faith_hollis"]},
	"ezra": {"kept": ["ezra_satisfied", "kept_ezra_shells"], "broken": []},
	"ruth": {"kept": ["door_ruth_1", "door_ruth_2"], "broken": ["broke_faith_ruth", "lied_to_ruth"]},
	"sam": {"kept": ["door_sam_1", "told_sam_daniel"], "broken": ["broke_faith_sam"]},
	"olstad": {"kept": ["showed_olstad_ticket", "told_olstad_daniel"], "broken": [], "costs": ["tried_to_run"]},
}
# Who has doors (closeness): door_ruth_1 to door_ruth_3.
const ROMANCES: Array[String] = ["ruth", "sam", "daniel"]
const DOORS_EACH: int = 3
# What the town had already seen by December, each +1 to the eye: walking out
# of church, the voice on the air, the empty place, the pie, running, the ice.
const EYE_SEEDS: Array[String] = ["walked_out", "walked_out_again", "said_on_air", "sat_in_place",
	"refused_pie", "tried_to_run", "skated_over", "showed_olstad_ice", "knelt_with_sam"]
const EYE_SEED_CAP: int = 4
const EYE_SEED_DAY: int = 18

# How many kept moments with this person (0 once betrayed).
func faith_count(person: String) -> int:
	if is_faithless(person):
		return 0
	var entry: Dictionary = FAITH.get(person, {})
	var count: int = 0
	for flag in entry.get("kept", []):
		if flags.has(flag):
			count += 1
	count += _numbered_flags("keep_%s_" % person)
	for flag in entry.get("costs", []):
		if flags.has(flag):
			count -= 1
	return maxi(count, 0)

func is_faithless(person: String) -> bool:
	if flags.has("betrayed_" + person):
		return true
	for flag in FAITH.get(person, {}).get("broken", []):
		if flags.has(flag):
			return true
	return false

# keep=ruth: one more kept moment (nothing, once betrayed).
func keep_faith(person: String) -> void:
	if is_faithless(person):
		return
	set_flag("keep_%s_%d" % [person, _numbered_flags("keep_%s_" % person) + 1])

# betray=ruth: closed for good.
func betray(person: String) -> void:
	set_flag("betrayed_" + person)

# How many of this person's doors are open (0 once betrayed).
func doors(person: String) -> int:
	if is_faithless(person):
		return 0
	return _numbered_flags("door_%s_" % person)

# door=sam: the next door opens (nothing once betrayed, or all three open).
func open_door(person: String) -> void:
	var open: int = doors(person)
	if is_faithless(person) or open >= DOORS_EACH:
		return
	set_flag("door_%s_%d" % [person, open + 1])

func add_eye(amount: int) -> void:
	eye = maxi(eye + amount, 0)

# December 1: the town remembers what it's already seen. Once.
func seed_eye() -> void:
	if flags.has("eye_seeded"):
		return
	set_flag("eye_seeded")
	var seen: int = 0
	for flag in EYE_SEEDS:
		if flags.has(flag):
			seen += 1
	eye += mini(seen, EYE_SEED_CAP)

# keep_ruth_1, keep_ruth_2... counted from 1 until one's missing.
func _numbered_flags(prefix: String) -> int:
	var n: int = 0
	while flags.has(prefix + str(n + 1)):
		n += 1
	return n

func set_flag(flag: String) -> void:
	if not flags.has(flag):
		flags.append(flag)

func lean(voice: String, amount: int = 1) -> void:
	if not voices.has(voice):
		push_warning("Unknown voice: " + voice)
		return
	voices[voice] += amount
	last_lean = voice
	# Following ??? is MC slipping.
	if voice == "unknown" and day >= 1:
		fray += amount

# --- Time ---

# rewind=60 in a story file: the clocks fall back (October 31, 2 a.m.: the
# one time in the game the clock moves backward, and an hour happens twice).
func rewind(amount: int) -> void:
	minutes -= amount
	time_changed.emit()

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
	var day_of: int = FIRST_NIGHT_DATE + floori(float(minutes) / MINUTES_PER_DAY)
	for month in MONTHS:
		if day_of <= month[1]:
			return "%s %d" % [month[0], day_of]
		day_of -= month[1]
	return "May %d" % day_of

# "Thu Oct 7", for the clock on screen.
func weekday_text() -> String:
	var days: int = floori(float(minutes) / MINUTES_PER_DAY)
	return "%s %s" % [WEEKDAYS[(FIRST_NIGHT_WEEKDAY + days) % 7], date_text()]

const WEEKDAY_NAMES: Array[String] = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]

# Moves the clock forward to the next day with this name ("Friday"), at the
# same time of day; nothing if it's already that day, or the name isn't one.
func advance_to_weekday(day_name: String) -> void:
	var target: int = WEEKDAY_NAMES.find(day_name)
	if target == -1:
		return
	var days: int = floori(float(minutes) / MINUTES_PER_DAY)
	var ahead: int = (target - (FIRST_NIGHT_WEEKDAY + days) % 7 + 7) % 7
	if ahead > 0:
		minutes += ahead * MINUTES_PER_DAY
		time_changed.emit()

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
# The calendar day (counted from October 5) a story day falls on.
func date_of(which_day: int) -> int:
	return DAY_DATES.get(which_day, which_day)

# A key day starts on its own date: the clock jumps ahead to that morning
# (never backwards). Each day's scene calls this as it opens.
func start_day() -> void:
	var morning: int = date_of(day) * MINUTES_PER_DAY + 6 * 60
	if minutes < morning:
		minutes = morning
		time_changed.emit()
	if day >= EYE_SEED_DAY:
		seed_eye()

# Where the day leads after closing: the town map, or a walked evening.
func evening_scene() -> String:
	return VISIT_SCENE if EVENINGS.has(day) else MAP_SCENE

# True when today's walk-around scene is the evening, not the day.
func is_walked_evening() -> bool:
	return EVENINGS.has(day) and not DAY_SCENES.has(day)

# Where the night leads in the morning: a bridge first if the days between
# need one, then the day itself; "" when nothing more is written.
func next_scene() -> String:
	if BRIDGES.has(day):
		return BRIDGE_SCENE
	return day_scene(day)

# Where a day starts: the counter, or another scene (DAY_SCENES); "" when
# that day isn't written yet.
func day_scene(which_day: int) -> String:
	if not DAY_STORIES.has(which_day):
		return ""
	return DAY_SCENES.get(which_day, COUNTER_SCENE)

func record_sale(item_name: String, item_id: String, price: int, buyer: String) -> void:
	sold.append(item_id)
	take_off_shelves(item_id)
	till += price
	till_by_ledger += price
	var to: String = (" to " + buyer) if buyer != "" else ""
	ledger_lines.append("%s. %s, sold%s. $%d" % [date_text(), item_name, to, price])

# A held thing given back without its ticket (redeemed= in a story file): it
# leaves the shop, and the ledger says so. No money changes hands.
func record_release(item_name: String, item_id: String, to: String) -> void:
	sold.append(item_id)
	take_off_shelves(item_id)
	var who: String = (" to " + to) if to != "" else ""
	ledger_lines.append("%s. %s, given back%s. No ticket." % [date_text(), item_name, who])

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
	# What the drawer can't cover comes out of your pocket, as far as it goes.
	cash = maxi(0, cash - (loan - from_till))
	till_by_ledger -= from_till
	var by: String = (" by " + seller) if seller != "" else ""
	var money: String = ("$%d loan" % loan) if loan > 0 else "No loan"
	ledger_lines.append("%s. %s, pawned%s, tag %s. %s" % [date_text(), item_name, by, tag, money])

# --- What you know about things ---

# Learns one property of an item; true if it wasn't known yet.
func learn_prop(item_id: String, kind: String) -> bool:
	var key: String = item_id + "/" + kind
	if known_props.has(key):
		return false
	known_props.append(key)
	return true

func knows_prop(item_id: String, kind: String) -> bool:
	return known_props.has(item_id + "/" + kind)

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
