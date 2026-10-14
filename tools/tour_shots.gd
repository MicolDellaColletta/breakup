extends "res://tests/test_base.gd"
# Not a test: a screenshot tour of every placeholder (SHOTS=dir).
var out: String = OS.get_environment("SHOTS")
func _snap(name: String) -> void:
	await process_frame
	await process_frame
	root.get_texture().get_image().save_png(out + "/" + name + ".png")

func _bare(script_path: String, view: String, name: String) -> void:
	if current_scene:
		current_scene.queue_free()
		current_scene = null
	await process_frame
	var holder := Control.new()
	root.add_child(holder)
	holder.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var bg := ColorRect.new()
	bg.color = Color.BLACK
	holder.add_child(bg)
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var art := Control.new()
	art.set_script(load(script_path))
	if view != "":
		art.set("view", view)
	holder.add_child(art)
	art.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	await wait(0.4)
	await _snap(name)
	holder.queue_free()
	await process_frame

class Sheet extends Control:
	var kind: String
	var ids: Array
	func _draw() -> void:
		draw_rect(Rect2(Vector2.ZERO, size), Color(0.1, 0.1, 0.11))
		var cols: int = 7 if kind == "people" else 7
		var w: float = size.x / cols
		var h: float = size.y / ceili(ids.size() / float(cols))
		for i in ids.size():
			var r := Rect2((i % cols) * w + 8, (i / cols) * h + 8, w - 16, h - 36)
			draw_rect(r, Color(0.2, 0.2, 0.22))
			if kind == "people":
				PersonArt.draw(self, ids[i], r)
			else:
				ItemArt.draw(self, ids[i][1], r)
			var label: String = ids[i] if kind == "people" else ids[i][0]
			draw_string(ThemeDB.fallback_font, Vector2(r.position.x, r.end.y + 20), label, HORIZONTAL_ALIGNMENT_LEFT, -1, 16, Color.WHITE)

func _sheet(kind: String, ids: Array, name: String) -> void:
	if current_scene:
		current_scene.queue_free()
		current_scene = null
	await process_frame
	var s := Sheet.new()
	s.kind = kind
	s.ids = ids
	root.add_child(s)
	s.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	await wait(0.3)
	await _snap(name)
	s.queue_free()

func run() -> void:
	# The counter, day 1 and day 20, four ways.
	for d in [1, 20]:
		gs.reset()
		gs.day = d
		var counter: Node = await open_scene("res://scenes/counter.tscn", 2.0)
		var column: Node = counter.get_node("%DialogueColumn")
		await _snap("counter_d%d_open" % d)
		for i in 60:
			column._on_advance_pressed()
		await wait(1.5)
		await _snap("counter_d%d_front" % d)
		for dir in ["left", "around", "right"]:
			counter.turn(dir)
			await wait(0.5)
			await _snap("counter_d%d_%s" % [d, dir])
		counter.turn("around")
		await wait(0.3)
		counter.ring_bell()
		await wait(2.5)
		await _snap("counter_d%d_customer" % d)
	for v in ["floor", "counter", "hallway", "office", "backroom"]:
		await _bare("res://scripts/shop_art.gd", v, "shop_" + v)
	for v in ["main", "hall", "bathroom", "bedroom"]:
		await _bare("res://scripts/apartment_art.gd", v, "apt_" + v)
	for v in ["church", "vestry", "hollis_kitchen", "shore", "far_ice", "hall", "stage", "cabin", "cabin_road", "booth", "gleaner", "church_fire", "vestry_door", "ruins", "daniel_room", "lake_1988", "ice_tripod", "hall_cellar", "town_line", "highway", "shore_breakup", "tent"]:
		await _bare("res://scripts/place_art.gd", v, "place_" + v)
	for f in ["exterior", "car", "glovebox", "mirror"]:
		await _bare("res://scripts/%s_art.gd" % f, "", "misc_" + f)
	var cfg := ConfigFile.new()
	cfg.load("res://story/people.cfg")
	await _sheet("people", Array(cfg.get_sections()), "sheet_people")
	var stock := ConfigFile.new()
	stock.load("res://story/stock.cfg")
	var items: Array = []
	for s in stock.get_sections():
		items.append([s, stock.get_value(s, "shape", "")])
	await _sheet("items", items, "sheet_items")
	gs.reset(); gs.day = 2; gs.set_clock("19:00")
	var map: Node = await open_scene("res://scenes/map.tscn", 2.0)
	for i in 40:
		map.get_node("%DialogueColumn")._on_advance_pressed()
	await wait(1.5)
	await _snap("map")
	gs.reset(); gs.day = 3; gs.set_clock("22:10")
	await open_scene("res://scenes/night.tscn", 2.5)
	await _snap("night_d3")
	gs.reset(); gs.day = 20; gs.set_clock("22:10")
	await open_scene("res://scenes/night.tscn", 2.5)
	await _snap("night_d20")
	var night: Node = current_scene
	night._show_room("main")
	for room in ["hall", "bathroom", "bedroom", "shop_hall", "shop_counter", "shop_floor", "shop_office", "shop_back"]:
		night._show_room(room)
		var layer: Node = night.get_node("%Hotspots")
		layer.fill("night", room, night.get_node("%Narrator"))
		for spot in layer.spot_ids():
			layer.get_spot(spot).show_all = true
		await wait(0.4)
		await _snap("nightroom_" + room)
	check(true, "tour")
