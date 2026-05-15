extends Control
# inspiration: https://www.youtube.com/watch?v=Ur9j3c5_of0
# https://www.youtube.com/watch?v=9UNLXwTxfQQ

@onready var json_loader: JsonLoader = JsonLoader
@onready var dialogue_timer: Timer = $DialogueTimer
@onready var label: Label = $Panel/Label
@onready var game_controller: Node3D = $"../GameController"
@onready var hint_label: Label = $Panel/HintLabel
@onready var replay_label: Label = $Panel/ReplayLabel

var text_to_show = []
var current_door: int = 0
var door_e: Node3D = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if game_controller.is_guessing_mode:
		if Input.is_action_just_pressed("guess"):
			game_controller.is_guessing_mode = false
			get_tree().paused = false
			$".".visible = false
			hint_label.visible = false
			replay_label.visible = false
		
		if Input.is_action_just_pressed("help"):
			show_hint()
		
		if Input.is_action_just_pressed("replay"):
			door_e.play_sound()


func start_dialogue(door_num: int):
	current_door = door_num
	print("dialogue started")
	text_to_show = json_loader.parsed_data["door"+str(door_num)].duplicate_deep()
	print(text_to_show)
	get_tree().paused = true
	$".".visible = true
	
	next_line()


func next_line():
	var t = text_to_show.pop_front()
	label.text = t
	dialogue_timer.start()


func show_hint():
	label.text = json_loader.parsed_data["hint"+str(current_door)][0]


func guessed():
	game_controller.is_guessing_mode = false
	get_tree().paused = false
	$".".visible = false
	hint_label.visible = false
	replay_label.visible = false
	door_e = null


func _on_gatedoor_display_dialogue(door_num: int, door_entity) -> void:
	print("detected")
	door_e = door_entity
	start_dialogue(door_num)


func _on_dialogue_timer_timeout() -> void:
	if !text_to_show.is_empty():
		next_line()
	else:
		door_e.play_sound()
		game_controller.is_guessing_mode = true
		hint_label.visible = true
		replay_label.visible = true
