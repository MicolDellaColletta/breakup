class_name Sfx
extends RefCounted

# Small sounds made in code, there in every scene without a file: a switch
# clicking, a latch, a drawer sliding, keys. Placeholders until there are
# recordings: put a file in audio/ and add a player to the scene under the
# same name, and the scene's own sound wins. Story files and spots.cfg use
# them like any other sound: sound=latch.

const RATE: int = 22050
const NAMES: Array[String] = ["click", "latch", "drawer", "keys"]

static var _made: Dictionary = {}

static func has(sound_name: String) -> bool:
	return NAMES.has(sound_name)

static func stream(sound_name: String) -> AudioStreamWAV:
	if not _made.has(sound_name):
		var rng: RandomNumberGenerator = RandomNumberGenerator.new()
		rng.seed = hash(sound_name)
		var samples: PackedFloat32Array
		match sound_name:
			"click": samples = _click(rng)
			"latch": samples = _latch(rng)
			"drawer": samples = _drawer(rng)
			"keys": samples = _keys(rng)
		_made[sound_name] = _to_wav(samples)
	return _made[sound_name]

# A switch: two tiny ticks, close together.
static func _click(rng: RandomNumberGenerator) -> PackedFloat32Array:
	var out: PackedFloat32Array = _silence(0.09)
	_tick(out, rng, 0.0, 2200.0, 0.8)
	_tick(out, rng, 0.028, 1600.0, 0.5)
	return out

# A latch: a light tick, then the heavier clunk of it catching.
static func _latch(rng: RandomNumberGenerator) -> PackedFloat32Array:
	var out: PackedFloat32Array = _silence(0.25)
	_tick(out, rng, 0.0, 2600.0, 0.5)
	_tick(out, rng, 0.07, 900.0, 0.6)
	_thump(out, 0.07, 180.0, 0.08, 0.4)
	return out

# A wooden drawer: a rough slide, then a soft knock as it stops.
static func _drawer(rng: RandomNumberGenerator) -> PackedFloat32Array:
	var length: float = 0.42
	var out: PackedFloat32Array = _silence(length + 0.12)
	var low: float = 0.0
	var grain: float = 1.0
	for i in int(length * RATE):
		var t: float = float(i) / RATE
		if i % 220 == 0:
			grain = rng.randf_range(0.4, 1.0)
		# Noise, smoothed down to a wooden rumble.
		low += (rng.randf_range(-1.0, 1.0) - low) * 0.12
		var envelope: float = sin(PI * t / length)
		out[i] += low * 1.6 * envelope * grain
	_thump(out, length, 90.0, 0.09, 0.7)
	_tick(out, rng, length, 700.0, 0.4)
	return out

# Keys: little bright bells, jostling.
static func _keys(rng: RandomNumberGenerator) -> PackedFloat32Array:
	var out: PackedFloat32Array = _silence(0.4)
	for k in 7:
		var start: int = int(rng.randf_range(0.0, 0.25) * RATE)
		var freq: float = rng.randf_range(3200.0, 5600.0)
		var loud: float = rng.randf_range(0.15, 0.35)
		for i in int(0.08 * RATE):
			if start + i >= out.size():
				break
			var t: float = float(i) / RATE
			out[start + i] += sin(TAU * freq * t) * loud * exp(-t * 55.0)
	return out

# --- The pieces ---

static func _silence(seconds: float) -> PackedFloat32Array:
	var out: PackedFloat32Array = PackedFloat32Array()
	out.resize(int(seconds * RATE))
	return out

# A short snap: a burst of noise and a ping, both gone in a few milliseconds.
static func _tick(out: PackedFloat32Array, rng: RandomNumberGenerator, at: float, freq: float, loud: float) -> void:
	var start: int = int(at * RATE)
	for i in int(0.03 * RATE):
		if start + i >= out.size():
			return
		var t: float = float(i) / RATE
		var noise: float = rng.randf_range(-1.0, 1.0) * exp(-t * 900.0)
		var ping: float = sin(TAU * freq * t) * exp(-t * 160.0) * 0.5
		out[start + i] += (noise + ping) * loud

# A low knock that dies away.
static func _thump(out: PackedFloat32Array, at: float, freq: float, seconds: float, loud: float) -> void:
	var start: int = int(at * RATE)
	for i in int(seconds * RATE):
		if start + i >= out.size():
			return
		var t: float = float(i) / RATE
		out[start + i] += sin(TAU * freq * t) * exp(-t * 40.0) * loud

static func _to_wav(samples: PackedFloat32Array) -> AudioStreamWAV:
	var data: PackedByteArray = PackedByteArray()
	data.resize(samples.size() * 2)
	for i in samples.size():
		data.encode_s16(i * 2, int(clampf(samples[i], -1.0, 1.0) * 30000.0))
	var wav: AudioStreamWAV = AudioStreamWAV.new()
	wav.format = AudioStreamWAV.FORMAT_16_BITS
	wav.mix_rate = RATE
	wav.stereo = false
	wav.data = data
	return wav
