extends Control
# inspiration: https://www.youtube.com/watch?v=Ur9j3c5_of0
# https://www.youtube.com/watch?v=9UNLXwTxfQQ

@onready var json_loader: JsonLoader = JsonLoader
@onready var dialogue_timer: Timer = $DialogueTimer
@onready var label: Label = $Panel/Label

var text_to_show = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func start_dialogue(door_num: int):
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


func _on_gatedoor_display_dialogue(door_num: int) -> void:
	print("detected")
	start_dialogue(door_num)


func _on_dialogue_timer_timeout() -> void:
	if !text_to_show.is_empty():
		next_line()
	else:
		get_tree().paused = false
		$".".visible = false
