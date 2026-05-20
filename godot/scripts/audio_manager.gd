extends Node

@onready var background_music: AudioStreamPlayer = $BackgroundMusic



func _on_background_music_finished() -> void:
	background_music.play()
