extends Node

@export var player_pos: Vector3 = Vector3(6.0, 2.0, -2.0)
@export var display_mode_notes: bool = true
@export var selected_microphone: int = 0

func _ready() -> void:
	print(RenderingServer.global_shader_parameter_get_list().has("player_pos"))
	print(RenderingServer.global_shader_parameter_get_list().has("test_var_test"))
