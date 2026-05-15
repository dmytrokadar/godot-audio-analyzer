extends Node3D

@onready var gd_audio_analyzer: GdAudioAnalyzer = AudioAnalyzer
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D
@onready var game_controller: Node3D = $"../GameController"
@onready var area_3d: Area3D = $Area3D

@export var DOOR_NUM: int = 0
@export var NOTE_HZ: float = 100

var door_open_flag = false

var playback # Will hold the AudioStreamGeneratorPlayback.
@onready var sample_hz = audio_stream_player_3d.stream.mix_rate
var pulse_hz = 120.0
var phase = 0.0

var guessed = false
var current_door_guessing = false

signal display_dialogue(door_num: int, door_entity: Node3D)
signal guessed_signal


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	guessed_signal.connect(game_controller._on_gatedoor_guessed_signal)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print(gd_audio_analyzer.get_frequency())
	if game_controller.is_guessing_mode and current_door_guessing:
		if gd_audio_analyzer.get_frequency() == NOTE_HZ or Input.is_action_just_pressed("open_doors"):
			door_open_flag = !door_open_flag
			current_door_guessing = false
			$AnimationPlayer.play("open" if door_open_flag else "close")


func _on_area_3d_body_entered(body: Node3D) -> void:
	print("entered")
	if !guessed:
		if body.is_in_group("player"):
			print("yes")
			#play_sound()
			display_dialogue.emit(DOOR_NUM, self)
			current_door_guessing = true


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


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	#area_3d.free()
	guessed_signal.emit()
	guessed = true
