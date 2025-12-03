#pragma once
#include <iostream>
#include <algorithm>
#include <cmath>
#include <unordered_map>

#include <fftw3.h>
#include <vector>
#include <portaudio.h>
#include <godot_cpp/classes/node.hpp>

#define SAMPLE_RATE 44100.0
#define FRAMES_PER_BUFFER 8192

#define LOWEST_FREQUENCY 20
#define HIGHEST_FREQUENCY 20000
#define HIGHEST_GUITAR_PITCH 1400

class AudioAnalyzer {

private:
	PaError err;
	PaStream* stream;
	PaStreamParameters inputParameters;
	//double freq = -1;


	void checkForErrors(PaError err, std::string errorFunc);

	struct CallbackData
	{
		double* in;
		double* out;
		fftw_plan plan;
		int startIndex;
		int spectrumSize;

		double freq;
	};

	CallbackData* callbackData;

	static int analyzeFreqCallback(const void* inputBuffer, void* outputBuffer,
		unsigned long framesPerBuffer,
		const PaStreamCallbackTimeInfo* timeInfo,
		PaStreamCallbackFlags statusFlags,
		void* userData);

protected:

public:
	struct DevicesList
	{
		std::unordered_map<int, std::string> input_devices;
		std::unordered_map<int, std::string> output_devices;
	};
	
	AudioAnalyzer();
	~AudioAnalyzer();
	void startAnalyzing();
	void stopAnalyzing();

	int chooseInputDevice(int deviceNum);
	int chooseOutputDevice(int deviceNum);
	AudioAnalyzer::DevicesList getDeviceList();
	
	double getFrequency() {
		return callbackData->freq;
	}

};
