extends PanelContainer

const BAR_COUNT: int = 16
const FREQ_MAX: float = 11050.0
const MIN_DB: float = 60.0

var specturm: AudioEffectSpectrumAnalyzerInstance
var max_heights: PackedFloat64Array = []
var min_heights: PackedFloat64Array = []
var heights: PackedFloat64Array = []

var bar_width: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_on_interface_is_audio_playing(false)


	for arr: PackedFloat64Array in [max_heights, min_heights, heights]:
		arr.resize(BAR_COUNT)
		arr.fill(0.0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var pre_hz: float = 0.0

	for i: int in BAR_COUNT:
		# get actuall height
		var hz: float = (i+1) * FREQ_MAX / BAR_COUNT
		var magnitude: float = specturm.get_magnitude_for_frequency_range(pre_hz, hz).length()
		var energy: float = clampf((MIN_DB + linear_to_db(magnitude)) / MIN_DB, 0, 1)
		var height: float = energy * size.y * 3.0
		# decide the max_height,min_height,height
		if height > max_heights[i]:
			max_heights[i] = height
		else:
			max_heights[i] = lerp(max_heights[i], height, 0.1)

		if height <= 0.0:
			min_heights[i] = lerp(min_heights[i], height, 0.1)

		heights[i] = lerp(max_heights[i], min_heights[i], 0.1) + 4
		# set pre_hz
		pre_hz = hz
	queue_redraw()

func _draw() -> void:
	for i: int in BAR_COUNT:
		if i == 0:
			continue # skip the first bar
		var color: Color = Color.from_hsv(
			(BAR_COUNT * 0.6 + i * 0.5) / BAR_COUNT, 0.5, 0.6)
		var rect: Rect2 = Rect2(
			(i-1) * bar_width,
			size.y - heights[i],
			bar_width - 2.0,
			heights[i]
		)
		draw_rect(rect,color)

func _on_interface_is_audio_playing(value: bool) -> void:
	if value: # audio playing
		specturm = AudioServer.get_bus_effect_instance(AudioServer.get_bus_index("Master"), 0)
	else:
		specturm = AudioServer.get_bus_effect_instance(AudioServer.get_bus_index("Record"), 1)

func _on_resized() -> void:
	bar_width = size.x / BAR_COUNT
	print("bar_width: ", bar_width)
	print("size: ", size)
	
