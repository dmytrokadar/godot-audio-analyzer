extends CharacterBody3D

@onready var head = $Head


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@export var FORWARD_STRING: float = 82.0 
@export var BACKWARD_STRING: float = 110.0
@export var LEFT_STRING: float = 146.0
@export var RIGHT_STRING: float = 196.0

@export var GRID_SIZE = 4
@export var TRAVEL_TIME = 1

@export var MOUSE_SENSITIVITY = 0.2
@export var LERP_SPEED = 10.0

@onready var ray_cast_3d: RayCast3D = $RayCast3D
@onready var gd_audio_analyzer: GdAudioAnalyzer = AudioAnalyzer
@onready var player_state: PlayerState = PlayerState
@onready var note_timer: Timer = $NoteTimer

@onready var forward_panel: Panel = $"../Control/Forward"
@onready var forward_label: Label = $"../Control/Forward/ForwardLabel"
@onready var backward_panel: Panel = $"../Control/Backward"
@onready var backward_label: Label = $"../Control/Backward/BackwardLabel"
@onready var left_panel: Panel = $"../Control/Left"
@onready var left_label: Label = $"../Control/Left/LeftLabel"
@onready var right_panel: Panel = $"../Control/Right"
@onready var right_label: Label = $"../Control/Right/RightLabel"


var is_mouse_visible = false
var just_pressed_note = 0.0


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	global_position = player_state.player_pos
	change_note_text()
	print(gd_audio_analyzer.hz_to_note_string_converter(146.83))


func is_note_just_pressed(note: float, expected: float) -> bool:
	if note < expected + 2 and note > expected - 2 and expected != just_pressed_note: 
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
		
	# unattaching cursor for debug purposes
	if Input.is_action_just_pressed("unattach_cursor"):
		if is_mouse_visible:
			is_mouse_visible = false
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			is_mouse_visible = true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	var move_dir = Vector2(0, 0)
	
	var is_moving = false
	
	#if just_pressed_note != 0.0:
		#pass
	if Input.is_action_just_pressed("move_forvard") or\
	 is_note_just_pressed(freq, FORWARD_STRING):
		move_dir.x = GRID_SIZE
		is_moving = try_move(move_dir)
	elif Input.is_action_just_pressed("move_backwards") or\
	 is_note_just_pressed(freq, BACKWARD_STRING):
		move_dir.x = -GRID_SIZE
		is_moving = try_move(move_dir)
	elif Input.is_action_just_pressed("move_left") or\
	 is_note_just_pressed(freq, LEFT_STRING):
		move_dir.x = 0
		move_dir.y = -GRID_SIZE
		is_moving = try_move(move_dir)
	elif Input.is_action_just_pressed("move_right") or\
	 is_note_just_pressed(freq, RIGHT_STRING):
		move_dir.x = 0
		move_dir.y = GRID_SIZE
		is_moving = try_move(move_dir)
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
		var tw = create_tween()
		var target_pos = round_to_center(Vector3(global_position.x + move_dir.x, global_position.y, global_position.z + move_dir.y))
		print(target_pos)
		
		tw.tween_property(self, "global_position", target_pos, TRAVEL_TIME).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		#velocity.x = move_toward(global_position.x + move_dir.x, 0, SPEED)
		#velocity.z = move_toward(global_position.z + move_dir.y, 0, SPEED)
		#global_position.x += move_dir.x
		#global_position.z += move_dir.y

	move_and_slide()


func round_to_center(inp: Vector3):
	#print("start")
	#print(inp)
	#print(floorf(inp.x / 4.0))
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


func change_note_text():
	forward_label.text = "E2"
	backward_label.text = "A2"
	left_label.text = "D3"
	right_label.text = "G3"


func _on_note_timer_timeout() -> void:
	print("player can move again")
	just_pressed_note = 0.0
