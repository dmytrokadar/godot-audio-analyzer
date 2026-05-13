extends Node
# inspiration: https://www.youtube.com/watch?v=dDe0x1S2y64

var parsed_data = {}
var file_path = "res://assets/dialogues/dialogues.json"

func _ready() -> void:
	parsed_data = load_data_from_file(file_path)


func load_data_from_file(path: String):
	if FileAccess.file_exists(path):
		var f = FileAccess.open(path, FileAccess.READ)
		
		return JSON.parse_string(f.get_as_text())
	print("file ", path, " does not exist")
	return null
