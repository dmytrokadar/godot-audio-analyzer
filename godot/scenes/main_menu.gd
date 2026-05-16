extends Control

@onready var settings: Control = $Settings


func _on_play_button_down() -> void:
	get_tree().change_scene_to_file("res://scenes/gridmap_level_isometric.tscn")


func _on_tuner_button_down() -> void:
	pass # Replace with function body.


func _on_settings_button_button_down() -> void:
	settings.visible = true


func _on_exit_button_down() -> void:
	get_tree().quit()
