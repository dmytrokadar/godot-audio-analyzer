#include "gd_audio_analyzer.h"

namespace godot {

void GdAudioAnalyzer::_bind_methods()
{
	ClassDB::bind_method(D_METHOD("start_analyzing"), &GdAudioAnalyzer::startAnalyzing);
	ClassDB::bind_method(D_METHOD("stop_analyzing"), &GdAudioAnalyzer::stopAnalyzing);
	ClassDB::bind_method(D_METHOD("choose_input_device", "device_name"), &GdAudioAnalyzer::chooseInputDevice);
	ClassDB::bind_method(D_METHOD("choose_output_device", "device_name"), &GdAudioAnalyzer::chooseOutputDevice);
	ClassDB::bind_method(D_METHOD("get_input_device_list"), &GdAudioAnalyzer::getInputDeviceList);
	ClassDB::bind_method(D_METHOD("get_output_device_list"), &GdAudioAnalyzer::getOutputDeviceList);
	ClassDB::bind_method(D_METHOD("get_frequency"), &GdAudioAnalyzer::getFrequency);
}

String GdAudioAnalyzer::_to_string() const
{
	return String();
}

AudioAnalyzer::DevicesList GdAudioAnalyzer::getDeviceList()
{
	return audioAnalyzer->getDeviceList();
}

GdAudioAnalyzer::GdAudioAnalyzer()
	: audioAnalyzer(std::make_unique<AudioAnalyzer>())
{
}

GdAudioAnalyzer::~GdAudioAnalyzer()
{
}

void GdAudioAnalyzer::startAnalyzing()
{
	audioAnalyzer->startAnalyzing();
}

void GdAudioAnalyzer::stopAnalyzing()
{
	audioAnalyzer->stopAnalyzing();
}

int GdAudioAnalyzer::chooseInputDevice(int deviceNum)
{
	return audioAnalyzer->chooseInputDevice(deviceNum);
}

int GdAudioAnalyzer::chooseOutputDevice(int deviceNum)
{
	return audioAnalyzer->chooseOutputDevice(deviceNum);
}

Dictionary GdAudioAnalyzer::getInputDeviceList()
{
	AudioAnalyzer::DevicesList list = getDeviceList();
	Dictionary d;
	for (const auto &p : list.input_devices) {
		d[p.first] = String(p.second.c_str());
	}
	return d;
}

Dictionary GdAudioAnalyzer::getOutputDeviceList()
{
	AudioAnalyzer::DevicesList list = getDeviceList();
	Dictionary d;
	for (const auto &p : list.output_devices) {
		d[p.first] = String(p.second.c_str());
	}
	return d;
}

double GdAudioAnalyzer::getFrequency()
{
	return audioAnalyzer->getFrequency();
}

}
