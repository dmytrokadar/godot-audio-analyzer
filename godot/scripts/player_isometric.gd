extends CharacterBody3D

@onready var head = $Head


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@export_category("Notes")
@export var FORWARD_STRING: float = 82.0
@export var BACKWARD_STRING: float = 110.0
@export var LEFT_STRING: float = 146.0
@export var RIGHT_STRING: float = 196.0

@export var notes_scale = [87.0, 98.0, 110.0, 117.0, 131.0, 147.0, 165.0, 175.0, 196.0, 220.0, 233.0]

@export_category("Other")
@export var MOVES_TO_SWAP_NOTES: int = 2

@export var GRID_SIZE = 4
@export var TRAVEL_TIME = 1
@export var ROTATION_TIME = 0.1

@export var MOUSE_SENSITIVITY = 0.2
@export var LERP_SPEED = 10.0

@onready var ray_cast_3d: RayCast3D = $RayCast3D
@onready var camera_ray_cast_3d: RayCast3D = $Head/CameraRayCast3D

@onready var gd_audio_analyzer: GdAudioAnalyzer = AudioAnalyzer
@onready var player_state: PlayerState = PlayerState
@onready var note_timer: Timer = $NoteTimer
@onready var settings: Control = $"../Settings"
@onready var player_model: Node3D = $PlayerModel

@onready var forward_panel: Panel = $"../Control/Forward"
@onready var forward_label: Label = $"../Control/Forward/ForwardLabel"
@onready var backward_panel: Panel = $"../Control/Backward"
@onready var backward_label: Label = $"../Control/Backward/BackwardLabel"
@onready var left_panel: Panel = $"../Control/Left"
@onready var left_label: Label = $"../Control/Left/LeftLabel"
@onready var right_panel: Panel = $"../Control/Right"
@onready var right_label: Label = $"../Control/Right/RightLabel"

var just_pressed_note = 0.0
var moves_left = MOVES_TO_SWAP_NOTES
var ena = true
var tw: Tween
var rot: int

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#global_position = player_state.player_pos
	settings.notes_display_mode_changed.connect(change_note_text)
	change_note_text()
	#RenderingServer.global_shader_parameter_add("player_pos", RenderingServer.GLOBAL_VAR_TYPE_VEC3, Vector3.ZERO)
	#RenderingServer.global_shader_parameter_set("player_pos", Vector3(1, 1, 1))
	#print(RenderingServer.global_shader_parameter_get_list().has("player_pos"))
	#print(RenderingServer.global_shader_parameter_get_list().has("test_var_test"))
	print(ProjectSettings.get_setting("shader_globals/player_pos"))
	tw = create_tween()


func is_note_just_pressed(note: float, expected: float) -> bool:
	if note < expected + 2 and note > expected - 2 and expected != just_pressed_note and !note_timer.is_running():
		just_pressed_note = expected
		note_timer.start(TRAVEL_TIME)
		return true
	return false


func _physics_process(delta: float) -> void:
	var freq
	freq = gd_audio_analyzer.get_frequency()
	#print(freq)
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	var move_dir = Vector2(0, 0)
	
	var is_moving = false
	
	#if tw.is_():
	if Input.is_action_just_pressed("move_forvard") or\
	 is_note_just_pressed(freq, FORWARD_STRING):
		move_dir.x = GRID_SIZE
		is_moving = try_move(move_dir)
		rot = 90
	elif Input.is_action_just_pressed("move_backwards") or\
	 is_note_just_pressed(freq, BACKWARD_STRING):
		move_dir.x = -GRID_SIZE
		is_moving = try_move(move_dir)
		rot = 270
	elif Input.is_action_just_pressed("move_left") or\
	 is_note_just_pressed(freq, LEFT_STRING):
		move_dir.x = 0
		move_dir.y = -GRID_SIZE
		is_moving = try_move(move_dir)
		rot = 180
	elif Input.is_action_just_pressed("move_right") or\
	 is_note_just_pressed(freq, RIGHT_STRING):
		move_dir.x = 0
		move_dir.y = GRID_SIZE
		is_moving = try_move(move_dir)
		rot = 0
	
	#if Input.is_action_just_pressed("enable_something"):
		##ProjectSettings.set_setting("shader_globals/ena", !ProjectSettings.get_setting("shader_globals/ena"))
		#ena = !ena
		#RenderingServer.global_shader_parameter_set("ena", ena)
		#print(RenderingServer.global_shader_parameter_get("ena"))
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#var input_dir := Input.get_vector("move_left", "move_right", "move_forvard", "move_backwards")
	#var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	#if direction:
		#velocity.x = direction.x * SPEED
		#velocity.z = direction.z * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
		#velocity.z = move_toward(velocity.z, 0, SPEED)
	
	if is_moving:
		print(freq)
		print(tw)
		
		#player_model.rotation = Vector3()
		
		tw = create_tween().set_parallel(true)
		var target_pos = round_to_center(Vector3(global_position.x + move_dir.x, global_position.y, global_position.z + move_dir.y))
		var target_rotation = Vector3(0.0, deg_to_rad(rot), 0.0)
		print(target_pos)
		
		player_model.play_run_anim()
		tw.tween_property(player_model, "rotation", target_rotation, ROTATION_TIME).set_ease(Tween.EASE_OUT)
		tw.tween_property(self, "global_position", target_pos, TRAVEL_TIME).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		
		moves_left -= 1
		
		if moves_left == 0:
			swap_move_notes()
			
			moves_left = MOVES_TO_SWAP_NOTES
			change_note_text()
		#velocity.x = move_toward(global_position.x + move_dir.x, 0, SPEED)
		#velocity.z = move_toward(global_position.z + move_dir.y, 0, SPEED)
		#global_position.x += move_dir.x
		#global_position.z += move_dir.y
	
	RenderingServer.global_shader_parameter_set("player_pos", global_position)
	#ProjectSettings.set_setting("shader_globals/player_pos", global_position)
	#print(ProjectSettings.get_setting("shader_globals/player_pos"))
	#print(RenderingServer.global_shader_parameter_get("player_pos"))
	move_and_slide()


func round_to_center(inp: Vector3):
	return Vector3(floorf(inp.x / 4.0) * 4.0 + 2.0, inp.y, floorf(inp.z / 4.0) * 4.0 + 2.0)


func try_move(dir: Vector2) -> bool:
	ray_cast_3d.target_position = Vector3(dir.x, 0, dir.y)
	
	ray_cast_3d.force_raycast_update()
	
	if(ray_cast_3d.is_colliding()):
		print("blocked")
		return false
	#else:
		#global_position.x += dir.x
		#global_position.z += dir.y
	
	return true


func swap_move_notes():
	var notes_array = notes_scale.duplicate_deep()
	notes_array.shuffle()
	FORWARD_STRING = notes_array[0]
	BACKWARD_STRING = notes_array[1]
	LEFT_STRING = notes_array[2]
	RIGHT_STRING = notes_array[3]
	
	print("Shufled, ", FORWARD_STRING, " ", BACKWARD_STRING, " ", LEFT_STRING, " ", RIGHT_STRING)


func change_note_text():
	if player_state.display_mode_notes:
		forward_label.text = gd_audio_analyzer.hz_to_note_string_converter(FORWARD_STRING)
		backward_label.text = gd_audio_analyzer.hz_to_note_string_converter(BACKWARD_STRING)
		left_label.text = gd_audio_analyzer.hz_to_note_string_converter(LEFT_STRING)
		right_label.text = gd_audio_analyzer.hz_to_note_string_converter(RIGHT_STRING)
	else:
		forward_label.text = gd_audio_analyzer.hz_to_tabulation_converter(FORWARD_STRING)
		backward_label.text = gd_audio_analyzer.hz_to_tabulation_converter(BACKWARD_STRING)
		left_label.text = gd_audio_analyzer.hz_to_tabulation_converter(LEFT_STRING)
		right_label.text = gd_audio_analyzer.hz_to_tabulation_converter(RIGHT_STRING)


func _on_note_timer_timeout() -> void:
	print("player can move again")
	just_pressed_note = 0.0
