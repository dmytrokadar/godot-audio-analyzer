#include "godot_cpp/classes/node.hpp"
#include "audio_analyzer.h"

namespace godot {

class GdAudioAnalyzer : public Node {
	GDCLASS(GdAudioAnalyzer, Node);

protected:
	static void _bind_methods();

	// void _notification(int p_what);
	// bool _set(const StringName &p_name, const Variant &p_value);
	// bool _get(const StringName &p_name, Variant &r_ret) const;
	// void _get_property_list(List<PropertyInfo> *p_list) const;
	// bool _property_can_revert(const StringName &p_name) const;
	// bool _property_get_revert(const StringName &p_name, Variant &r_property) const;
	// void _validate_property(PropertyInfo &p_property) const;

	String _to_string() const;

private:
	std::unique_ptr<AudioAnalyzer> audioAnalyzer;
	AudioAnalyzer::DevicesList getDeviceList();
	

public:
	GdAudioAnalyzer();
	~GdAudioAnalyzer();

	void startAnalyzing();
	void stopAnalyzing();

	int chooseInputDevice(int deviceNum);
	int chooseOutputDevice(int deviceNum);
	Dictionary getInputDeviceList();
	Dictionary getOutputDeviceList();
	
	double getFrequency();
};

}
