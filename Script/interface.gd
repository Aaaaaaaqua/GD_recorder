extends PanelContainer
@onready var record: TextureButton = %Record
@onready var play: TextureButton = $VBox/HBox/HFlowContainer/Play
@onready var save: Button = $VBox/HBox/HFlowContainer/Save
@onready var specturm: PanelContainer = $VBox/HBox/Specturm
@onready var playback: AudioStreamPlayer = $Playback

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
	specturm.modulate.a = 0.7
	play.modulate.a = 0.7
	play.disabled = true
	save.modulate.a = 0.7
	save.disabled = true


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
		record.texture_normal = ICON_NOT_RECORDING

		# Audio stuff
		playback.stream = recording

		specturm.modulate.a = 0.7
		play.modulate.a = 1.0
		play.disabled = false
		save.modulate.a = 1.0
		save.disabled = false


	else:
		# $Mic.play()
		effect.set_recording_active(true)
		print("Recording started")
		record.texture_normal = ICON_RECORDING
		# print("Mic is playing: ", $Mic.playing)

		# Audio stuff
		playback.stop()
		
		specturm.modulate.a = 1.0
		play.modulate.a = 0.7
		play.disabled = true
		save.modulate.a = 0.7
		save.disabled = true

		


func _on_play_pressed() -> void:
	# playback and pause the audio
	if playback.stream_paused or !playback.playing:
		print("Playing audio")

		# Change icon
		# Change stream_paused
		play.texture_normal = ICON_PAUSE
		playback.stream_paused = false

		if !playback.playing:
			playback.play()
		
	else:
		print("No audio to play")
		play.texture_normal = ICON_PLAY
		playback.stream_paused = true

func _on_saved(a_file_path: String) -> void:
	# save wav file and path
	pass

func _on_save_pressed() -> void:
	# first open dialog
	# If file saved is pressed, run _on_saved()
	pass # Replace with function body.


func _on_playback_finished() -> void:
	print("Playback finished")
	play.texture_normal = ICON_PLAY
