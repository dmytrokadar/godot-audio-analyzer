extends Control

@onready var gd_audio_analyzer: GdAudioAnalyzer = AudioAnalyzer
@onready var hz: Label = $hz
@onready var settings: Control = $Settings
@onready var higher: Label = $Higher
@onready var lower: Label = $Lower
@onready var correct: Label = $Correct

@export var diviation: float = 5.0

# inspiration https://docs.godotengine.org/en/stable/classes/class_audiostreamgenerator.html
var playback # Will hold the AudioStreamGeneratorPlayback.
@onready var sample_hz = $AudioStreamPlayer.stream.mix_rate
var pulse_hz = 120.0 # The frequency of the sound wave. 440.0
var phase = 0.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var freq = gd_audio_analyzer.get_frequency()
	
	hz.text = str(freq)
	if(freq <= pulse_hz + diviation && freq >= pulse_hz - diviation):
		higher.visible = false
		lower.visible = false
		correct.visible = true
		
		gd_audio_analyzer.stop_analyzing()
	elif freq > pulse_hz + 4:
		higher.visible = true
		lower.visible = false
		correct.visible = false
	else:
		higher.visible = false
		lower.visible = true
		correct.visible = false


func fill_buffer():
	var increment = pulse_hz / sample_hz
	var frames_available = playback.get_frames_available()

	for i in range(frames_available):
		playback.push_frame(Vector2.ONE * sin(phase * TAU))
		phase = fmod(phase + increment, 1.0)


func _on_settings_button_down() -> void:
	settings.visible = true


func _on_play_sound_button_down() -> void:
	$AudioStreamPlayer.play()
	playback = $AudioStreamPlayer.get_stream_playback()
	fill_buffer()
