@tool
extends Node3D

@export var enemy_model: PackedScene:
	set(value):
		enemy_model = value
		update_model()

@onready var player_state: PlayerState = PlayerState
@onready var player_isometric: CharacterBody3D = $"../Player_isometric"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_model():
	# TODO: add model swap
	pass

func open_fight_scene():
	player_state.player_pos = player_isometric.global_position
	# TODO: add transition to fight scene

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		open_fight_scene()
