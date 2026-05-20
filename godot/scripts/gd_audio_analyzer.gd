extends GdAudioAnalyzer

enum notes_enum {C, Cs, D, Ds, E, F, Fs, G, Gs, A, As, B}
const notes_array = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]

const e_tuning = [40, 45, 50, 55, 59, 64]
const string_names = ["6S", "5S", "4S", "3S", "2S", "1S"]

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
	pass


func note_converter(hz: float) -> int:
	# formula origin: https://www.phys.unsw.edu.au/jw/notes.html
	return round(12 * (log(hz/440.0)/log(2.0)) + 69)


func hz_to_note_string_converter(hz: float) -> String:
	var n = note_converter(hz)
	
	return notes_array[n % 12] + str(n / 12 - 1)


func get_frequency_two() -> float:
	return get_frequency() * 2


func hz_to_tabulation_converter(hz: float) -> String:
	var n = note_converter(hz)
	var fret_n = 0
	var string_n = 0
	
	for i in range(e_tuning.size() - 1, -1, -1):
		if n < e_tuning[i]:
			continue
		fret_n = n - e_tuning[i]
		string_n = i
		break
	
	return str(string_names[string_n]) + "/" + str(fret_n) + "F"
