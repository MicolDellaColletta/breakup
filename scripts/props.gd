class_name Props
extends RefCounted

# The hidden properties of things in the shop (docs/shop.md, "Objects"):
# prop_<kind>="..." in stock.cfg, found with a tool (the loupe, your hands) or
# in a story (learn=item/kind). What's been found is in GameState.known_props;
# the owner's catalogue shows it, and blanks for the rest.

# Every kind, in the order the catalogue lists them, with its label.
const KINDS: Array[String] = ["marks", "material", "warmth", "sound", "smell",
	"mechanism", "story", "folk", "plain"]
const LABELS: Dictionary = {
	"marks": "Marks", "material": "Made of", "warmth": "To the touch",
	"sound": "Sound", "smell": "Smell", "mechanism": "Inside",
	"story": "Whose", "folk": "What they say", "plain": "What it does",
}
# What each tool finds. The rest are found by examining, and from people.
const TOOLS: Dictionary = {
	"loupe": ["marks", "material"],
	"handle": ["warmth", "sound", "smell"],
}

# The kinds this item has, in catalogue order.
static func kinds_of(stock: ConfigFile, item_id: String) -> Array[String]:
	var out: Array[String] = []
	for kind in KINDS:
		if stock.has_section_key(item_id, "prop_" + kind):
			out.append(kind)
	return out

static func text(stock: ConfigFile, item_id: String, kind: String) -> String:
	return str(stock.get_value(item_id, "prop_" + kind, ""))

# Uses a tool on an item: learns whatever that tool finds on it. Returns the
# kinds newly found (empty if there was nothing, or nothing new).
static func use_tool(stock: ConfigFile, item_id: String, tool: String) -> Array[String]:
	var found: Array[String] = []
	for kind in TOOLS[tool]:
		if stock.has_section_key(item_id, "prop_" + kind) and GameState.learn_prop(item_id, kind):
			found.append(kind)
	return found
