extends Node3D

@onready var attack_1: Button = $UI/MarginContainer/VBoxContainer/Attack1
@onready var attack_2: Button = $UI/MarginContainer/VBoxContainer/Attack2
@onready var attack_3: Button = $UI/MarginContainer/VBoxContainer/Attack3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("1"):
		attack_1.add_theme_color_override("font_color", Color())
	if Input.is_action_just_released("1"):
		attack_1.pressed.emit()
		


func _on_attack_1_pressed() -> void:
	print("enemie attacked pressed")
	attack_1.add_theme_color_override("font_color", Color(0.87, 0.87, 0.87))
