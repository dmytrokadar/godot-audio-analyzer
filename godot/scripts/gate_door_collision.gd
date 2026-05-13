extends Node3D

@onready var gd_audio_analyzer: GdAudioAnalyzer = AudioAnalyzer
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D

@export var DOOR_NUM: int = 0
@export var NOTE_HZ: float = 100

var door_open_flag = false

var playback # Will hold the AudioStreamGeneratorPlayback.
@onready var sample_hz = audio_stream_player_3d.stream.mix_rate
var pulse_hz = 120.0
var phase = 0.0
var round_ended = false

signal display_dialogue(door_num: int)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print(gd_audio_analyzer.get_frequency())
	if gd_audio_analyzer.get_frequency() == NOTE_HZ or Input.is_action_just_pressed("open_doors"):
		door_open_flag = !door_open_flag
		$AnimationPlayer.play("open" if door_open_flag else "close")


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		print("yes")
		play_sound()
		display_dialogue.emit(DOOR_NUM)


func fill_audio_buffer():
	var increment = pulse_hz / sample_hz
	var frames_available = playback.get_frames_available()

	for i in range(frames_available):
		playback.push_frame(Vector2.ONE * sin(phase * TAU))
		phase = fmod(phase + increment, 1.0)


func play_sound():
	audio_stream_player_3d.play()
	playback = audio_stream_player_3d.get_stream_playback()
	fill_audio_buffer()
