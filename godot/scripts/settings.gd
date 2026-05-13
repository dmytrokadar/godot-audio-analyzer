extends Control

@onready var input_option: OptionButton = $Panel/InputOption
@onready var gd_audio_analyzer: GdAudioAnalyzer = AudioAnalyzer
@onready var player_state: PlayerState = PlayerState

signal notes_display_mode_changed
signal unpause_game

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var input_device_list: Dictionary = gd_audio_analyzer.get_input_device_list()
	
	for key in input_device_list:
		input_option.add_item(input_device_list[key], key)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_input_option_item_selected(index: int) -> void:
	gd_audio_analyzer.choose_input_device(index)


func _on_back_button_down() -> void:
	$".".visible = false
	get_tree().paused = false
	unpause_game.emit()


func _on_notes_display_mode_check_box_toggled(toggled_on: bool) -> void:
	player_state.display_mode_notes = !toggled_on
	notes_display_mode_changed.emit()
	print("display mode notes: ", player_state.display_mode_notes)
