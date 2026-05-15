extends Node3D

@onready var player_isometric: CharacterBody3D = $"../Player_isometric"
@onready var settings: Control = $"../Settings"
@onready var dialogue_box: Control = $"../DialogueBox"

var is_mouse_visible = false
var is_guessing_mode = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	settings.unpause_game.connect(unpause_game)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# unattaching cursor for debug purposes
	if Input.is_action_just_pressed("unattach_cursor"):
		if is_mouse_visible:
			is_mouse_visible = false
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			is_mouse_visible = true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	# toggle esc menu
	if Input.is_action_just_released("menu"):
		#settings.visible = !settings.visible
		settings.visible = !settings.visible
		is_mouse_visible = !is_mouse_visible
		get_tree().paused = !get_tree().paused
		if is_mouse_visible:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func unpause_game():
	print("test")
	is_mouse_visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _on_gatedoor_guessed_signal() -> void:
	is_guessing_mode = false
	dialogue_box.guessed()
