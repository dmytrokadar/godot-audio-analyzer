extends GdAudioAnalyzer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#pass
	print(get_input_device_list())
	
	choose_input_device(0)
	start_analyzing()
	#choose_input_device(0)
	#start_analyzing()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	get
