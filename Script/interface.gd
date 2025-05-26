extends PanelContainer
@onready var record: TextureButton = %Record
@onready var play: TextureButton = $VBox/HBox/HFlowContainer/Play
@onready var save: Button = $VBox/HBox/HFlowContainer/Save

const PATH_ICON: String = "res://Icon/%s"
const ICON_RECORDING: Texture2D = preload(PATH_ICON % "recording.svg")
const ICON_NOT_RECORDING: Texture2D = preload(PATH_ICON % "not_recording.svg")
const ICON_PLAY: Texture2D = preload(PATH_ICON % "play.svg")
const ICON_PAUSE: Texture2D = preload(PATH_ICON % "pause.svg")

var effect: AudioEffectRecord
var recording: AudioStreamWAV 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	effect = AudioServer.get_bus_effect(AudioServer.get_bus_index("Record"), 0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_exit_button_pressed() -> void:
	get_tree().quit()


func _on_record_pressed() -> void:
	if effect.is_recording_active():
		recording = effect.get_recording()
		effect.set_recording_active(false)
		# $Mic.stop()
		print("Recording stopped")
		print("Recording data length: ", recording.data.size())
		print("First few bytes: ", recording.data.slice(0, 10))
	else:
		# $Mic.play()
		effect.set_recording_active(true)
		print("Recording started")
		# print("Mic is playing: ", $Mic.playing)


func _on_play_pressed() -> void:
	# playback and pause the audio
	pass # Replace with function body.

func _on_saved(a_file_path: String) -> void:
	# save wav file and path
	pass

func _on_save_pressed() -> void:
	# first open dialog
	# If file saved is pressed, run _on_saved()
	pass # Replace with function body.
