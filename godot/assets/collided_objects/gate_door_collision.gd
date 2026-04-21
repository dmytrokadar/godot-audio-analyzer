extends Node3D

@onready var gd_audio_analyzer: GdAudioAnalyzer = AudioAnalyzer

@export var NOTE_HZ:float = 100

var door_open_flag = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print(gd_audio_analyzer.get_frequency())
	if gd_audio_analyzer.get_frequency() == NOTE_HZ or Input.is_action_just_pressed("open_doors"):
		door_open_flag = !door_open_flag
		$AnimationPlayer.play("open" if door_open_flag else "close")
