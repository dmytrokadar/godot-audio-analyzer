extends Area3D

@onready var end_screen: Control = $EndScreen


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().paused = true
		end_screen.visible = true
