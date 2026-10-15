extends "res://tests/test_base.gd"

# Every ending, reached by playing (docs/routes.md). Each route starts on the
# morning of February 5 (key day 31) with what October to January would have
# set on that route, then lets the game run: every counter day, map evening,
# walk-around, walked evening, night and bridge, in order, the way a player
# would go through them. When a choice comes up it takes the route's pick
# for that day (or the first choice); on visit days and nights it clicks the
# route's spots, then keeps the rules and goes to bed. It ends when breakup
# plays its ending and the title comes back, and checks the ending.

const FEB_5: int = 123 * 24 * 60 + 6 * 60
# Each night: the rules first, so none are broken by skipping them.
const RULES: Array = ["radio", "kitchen", "windows", "back_door"]
const ROUTE_TIME_LIMIT_MS: int = 15 * 60 * 1000

const ROUTES: Array = [
	{
		"ending": "fire",
		"why": "keep faith with four; Olstad looks away; the bear's paraffin; the town turns on him; burn it",
		"flags": ["walt_kind", "faith_hollis", "ezra_satisfied", "showed_olstad_ticket", "told_olstad_daniel", "met_sam", "door_sam_1"],
		"items": [],
		"picks": {
			31: ["Load the shells", "Go out to it"],
			33: ["Tell her the truth"],
			34: ["Step onto the scale", "I don't know whose lights", "Hide them in the bear"],
			35: ["Take her hand"],
			36: ["Take a notebook", "Close the box"],
			37: ["\"No.\""],
			38: ["It's all right"],
			40: ["Sign it"],
			41: ["anxious bench"],
			42: ["Watch from the step", "Burn it."],
		},
		"spots": {34: ["hall_scale_book", "hall_booth_sam"], 36: ["hall_to_gleaner", "room_files", "room_box", "room_leave"], 39: ["hall_to_line"]},
		"nights": {40: ["walk_bear"], 42: ["burn_it"]},
	},
	{
		"ending": "run_ruth",
		"why": "Ruth's three doors and the keys back; the town turns on him; she's at the car",
		"flags": ["door_ruth_1", "door_ruth_2", "ruth_has_keys", "car_forgotten"],
		"items": [],
		"picks": {
			32: ["It wasn't your fault"],
			36: ["Take a notebook"],
			40: ["Be at the car"],
			41: ["anxious bench"],
			42: ["Watch from the step", "Ruth is waiting"],
		},
		"spots": {34: ["hall_scale_book", "hall_booth_sam"], 36: ["hall_to_gleaner", "room_files", "room_leave"], 39: ["hall_to_line"]},
		"nights": {42: ["leave_now"]},
	},
	{
		"ending": "run_sam",
		"why": "keep Sam, forgive him at the tripod; John's gun, which he never loaded; Sam at the car",
		"flags": ["met_sam", "door_sam_1", "door_sam_2", "car_forgotten", "gun_pillow"],
		"items": ["revolver"],
		"picks": {
			34: ["I don't know whose lights", "Hide them in the bear"],
			37: ["\"No.\""],
			38: ["It's all right"],
			40: ["Be at the car"],
			41: ["John's gun"],
			42: ["Watch from the step", "Sam is waiting"],
		},
		"spots": {34: ["hall_scale_book", "hall_booth_sam"], 36: ["hall_to_gleaner", "room_leave"], 39: ["hall_to_line"]},
		"nights": {42: ["leave_now"]},
	},
	{
		"ending": "run_cody",
		"why": "gave Cody his picks back (he lives); no car; the truck to Fairbanks",
		"flags": ["gave_picks_back", "car_towed"],
		"items": [],
		"picks": {40: ["I'll be there"], 42: ["Watch from the step", "Get in."]},
		"spots": {34: ["hall_scale_book", "hall_booth_sam"], 36: ["hall_to_gleaner", "room_leave"], 39: ["hall_to_line"]},
		"nights": {42: ["cody_truck"]},
	},
	{
		"ending": "run_alone_him",
		"why": "a car and a clear line, but he isn't beaten: he's in the passenger seat",
		"flags": ["car_forgotten"],
		"items": [],
		"picks": {37: ["\"No.\""], 41: ["Do nothing"], 42: ["Watch from the step", "Drive."]},
		"spots": {34: ["hall_scale_book", "hall_booth_sam"], 36: ["hall_to_gleaner", "room_leave"], 39: ["hall_to_line"]},
		"nights": {42: ["leave_now"]},
	},
	{
		"ending": "run_alone",
		"why": "tell Olstad the John night, sign; she takes him on the steps; leave alone",
		"flags": ["showed_olstad_ticket", "told_olstad_daniel", "car_forgotten"],
		"items": [],
		"picks": {33: ["Tell her the truth"], 40: ["Sign it"], 41: ["Go out to the steps"], 42: ["Watch from the step", "Go alone"]},
		"spots": {34: ["hall_scale_book", "hall_booth_sam"], 36: ["hall_to_gleaner", "room_leave"], 39: ["hall_to_line"]},
		"nights": {42: ["leave_now"]},
	},
	{
		"ending": "daniel",
		"why": "his first two doors (November, Christmas Eve); say yes; don't run",
		"flags": ["door_daniel_1", "door_daniel_2"],
		"items": [],
		"picks": {37: ["\"Yes.\""], 41: ["Do nothing"], 42: ["Watch from the step"]},
		"spots": {34: ["hall_scale_book", "hall_booth_sam"], 36: ["hall_to_gleaner", "room_leave"], 39: ["hall_to_line"]},
		"nights": {},
	},
	{
		"ending": "season_ends",
		"why": "nothing in particular: the first choice every time",
		"flags": [],
		"items": [],
		"picks": {41: ["Do nothing"]},
		"spots": {34: ["hall_scale_book", "hall_booth_sam"], 36: ["hall_to_gleaner", "room_leave"], 39: ["hall_to_line"]},
		"nights": {},
	},
]

var spots_cfg: ConfigFile = ConfigFile.new()

func run() -> void:
	spots_cfg.load("res://story/spots.cfg")
	# ROUTE=fire runs only that one (they take a few minutes each).
	var only: String = OS.get_environment("ROUTE")
	for route in ROUTES:
		if only == "" or only == route["ending"]:
			await _play(route)

# A spot is there only when its if= holds, the same as on screen.
func _available(spot_id: String, column: Node) -> bool:
	var condition: String = spots_cfg.get_value(spot_id, "if", "")
	return condition == "" or column._condition_met(condition)

func _column(scene: Node) -> Node:
	for path in ["%DialogueColumn", "%Narrator"]:
		if scene.has_node(path):
			return scene.get_node(path)
	return null

func _play(route: Dictionary) -> void:
	section("Route to %s: %s" % [route["ending"], route["why"]])
	gs.reset()
	gs.day = 31
	gs.minutes = FEB_5
	gs.voices["appraisal"] = 2
	gs.voices["warmth"] = 1
	for flag in route["flags"]:
		gs.flags.append(flag)
	for item in route["items"]:
		gs.add_item(item)
	var picks: Dictionary = route["picks"].duplicate(true)
	var spots: Dictionary = route["spots"].duplicate(true)
	var nights: Dictionary = route["nights"].duplicate(true)
	var done: Dictionary = {}
	var seen_breakup: bool = false
	var ending_at_breakup: String = ""
	var transition: Node = root.get_node("Transition")
	transition.go_to("res://scenes/counter.tscn", 0.1)
	await wait(1.0)
	var started: int = Time.get_ticks_msec()
	var last_where: String = ""
	var last_print: int = 0
	while Time.get_ticks_msec() - started < ROUTE_TIME_LIMIT_MS:
		await process_frame
		var scene: Node = current_scene
		if scene == null or transition.busy:
			continue
		if scene.name == "Title":
			break
		var column: Node = _column(scene)
		if column == null or column._section == "":
			continue
		if gs.day == 43 and not seen_breakup:
			seen_breakup = true
			ending_at_breakup = gs.ending()
		var day: int = gs.day
		var where: String = "%s %d %s" % [scene.name, day, column._section]
		if Time.get_ticks_msec() - last_print > 5000:
			last_print = Time.get_ticks_msec()
			last_where = ""
		if where != last_where:
			last_where = where
			print("    ... %s (done=%s, bell=%s)" % [where, column._section_done, scene.has_method("waiting_for_bell") and scene.waiting_for_bell()])
		# Old buttons stay in the box after a choice; only a shown box counts.
		var labels: Array = choices(column) if column.get_node("%ChoiceBox").visible else []
		if not labels.is_empty():
			await pick(column, _choose(picks, day, labels))
			await process_frame
			continue
		if not column._section_done:
			column._on_advance_pressed()
			continue
		var key: String = "%s_%d" % [scene.name, day]
		match scene.name:
			"Counter":
				if scene.waiting_for_bell():
					ring_bell()
				elif scene._exploring and not done.has(key):
					done[key] = true
					scene._leave_for_the_evening()
			"Map":
				if not done.has(key):
					done[key] = true
					scene._go_home()
			"Visit":
				if scene.hotspots.interactive and not spots.get(day, []).is_empty():
					var spot: String = spots[day].pop_front()
					if _available(spot, column):
						scene.click(spot)
					else:
						check(false, "day %d: %s isn't there" % [day, spot])
			"Night":
				if not done.has(key):
					var wanted: Array = nights.get(day, [])
					for spot in wanted:
						if not _available(spot, column):
							check(false, "night %d: %s isn't there" % [day, spot])
					done[key] = wanted.filter(func(s: String) -> bool: return _available(s, column)) + RULES.filter(func(s: String) -> bool: return _available(s, column)) + ["bed"]
				if scene.hotspots.interactive and not done[key].is_empty():
					scene.look(done[key].pop_front())
	check(seen_breakup, "the game ran on to breakup (day %d at the end)" % gs.day)
	check(ending_at_breakup == route["ending"], "breakup reads %s (got %s)" % [route["ending"], ending_at_breakup])
	check(current_scene != null and current_scene.name == "Title", "the ending played to the title")

# The route's next pick for today that's on screen; otherwise the first.
func _choose(picks: Dictionary, day: int, labels: Array) -> String:
	var todays: Array = picks.get(day, [])
	for i in todays.size():
		for label in labels:
			if label.contains(todays[i]):
				todays.remove_at(i)
				return label
	return labels[0]
