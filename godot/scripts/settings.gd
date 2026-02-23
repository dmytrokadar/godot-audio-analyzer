extends Control

@onready var input_option: OptionButton = $Panel/InputOption
@onready var gd_audio_analyzer: GdAudioAnalyzer = AudioAnalyzer

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
