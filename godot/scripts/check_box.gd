extends TextureRect

@export var DEFAULT_TEXTURE: Texture2D
@export var CHECKED_TEXTURE: Texture2D

func _ready() -> void:
	change_texture(DEFAULT_TEXTURE)


func change_to_checked() -> void:
	change_texture(CHECKED_TEXTURE)


func change_texture(tex: Texture2D) -> void:
	texture = tex
