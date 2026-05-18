extends Node3D


func _ready() -> void:
	play_idle_anim()


func play_idle_anim():
	$AnimationPlayer.play("CharacterArmature|Idle", 0.2)


func play_run_anim():
	$AnimationPlayer.play("CharacterArmature|Run", 0.1)


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	play_idle_anim()
