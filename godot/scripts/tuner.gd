extends Control

@onready var gd_audio_analyzer: GdAudioAnalyzer = AudioAnalyzer
@onready var current_note: Label = $"Panel/Current note"


func _process(delta: float) -> void:
	var hz = gd_audio_analyzer.get_frequency()
	if hz > 70 and hz < 1000:
		current_note.text = gd_audio_analyzer.hz_to_note_string_converter(gd_audio_analyzer.get_frequency())


func _on_back_button_button_down() -> void:
	$".".visible = false
