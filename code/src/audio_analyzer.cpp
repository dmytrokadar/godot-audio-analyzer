#include "audio_analyzer.h"

//AudioAnalyzer::callbackData_t* AudioAnalyzer::callbackData = nullptr;

void AudioAnalyzer::checkForErrors(PaError err, std::string errorFunc)
{
	if (err != paNoError)
		std::cout << "PortAudio error: " << err << "in function: " << errorFunc << std::endl;
}

int AudioAnalyzer::analyzeFreqCallback(const void* inputBuffer, void* outputBuffer,
	unsigned long framesPerBuffer,
	const PaStreamCallbackTimeInfo* timeInfo,
	PaStreamCallbackFlags statusFlags,
	void* userData)
{
	float* in = (float*)inputBuffer;
	(void)outputBuffer;
	CallbackData* data = (CallbackData*)userData;

	int dispSize = 100;

	// printf("\r");

	for (unsigned long i = 0; i < framesPerBuffer; i++)
	{
		data->in[i] = (double)in[i];
	}

	fftw_execute(data->plan);

	float volume = 0;

	for (unsigned long i = 0; i < framesPerBuffer; i++)
	{
		volume = std::max(abs(in[i]), volume);
	}

	// if (volume < 0.00001) {`
	// 	printf(" F: no %f", volume);
	// 	fflush(stdout);
	// 	return 0;
	// }

	int peak = -1;
	double peakValue = 0.0;
	double increment = (SAMPLE_RATE / FRAMES_PER_BUFFER);

	double max_reasonable_pitch = HIGHEST_GUITAR_PITCH / increment;

	for (int i = 0; i < max_reasonable_pitch; i++) {
		if (abs(data->out[i]) > peakValue) {
			peakValue = abs(data->out[i]);
			peak = i;
		}
	}

	double fundamentalFreq = peak * (SAMPLE_RATE / FRAMES_PER_BUFFER);

	/*printf(" F: %f %d", fundamentalFreq, peak);

	fflush(stdout);*/

	data->freq = fundamentalFreq;

	return 0;
}

AudioAnalyzer::AudioAnalyzer()
{
	err = Pa_Initialize();
	checkForErrors(err, "Constructor");

	// callback data setup
	callbackData = new CallbackData;
	callbackData->in = (double*)fftw_malloc(sizeof(double) * FRAMES_PER_BUFFER);
	callbackData->out = (double*)fftw_malloc(sizeof(double) * FRAMES_PER_BUFFER);
	callbackData->plan = fftw_plan_r2r_1d(FRAMES_PER_BUFFER, callbackData->in, callbackData->out, FFTW_R2HC, FFTW_ESTIMATE);

	// other data setup
	double sampleRatio = FRAMES_PER_BUFFER / SAMPLE_RATE;
	callbackData->startIndex = ceil(LOWEST_FREQUENCY * sampleRatio);
	callbackData->spectrumSize = std::min(ceil(HIGHEST_FREQUENCY * sampleRatio) - callbackData->startIndex, FRAMES_PER_BUFFER / 2.0);
}

/// <summary>
/// chooses the input device for audio analysis
/// </summary>
/// <param name="deviceNum">Number of device in system. -1 for default device</param>
/// <returns></returns>
int AudioAnalyzer::chooseInputDevice(int deviceNum)
{
	/*err = Pa_StopStream(stream);
	checkForErrors(err, "chooseInputDevice");*/

	if (deviceNum == -1) {
		deviceNum = Pa_GetDefaultInputDevice();
	}

	memset(&inputParameters, 0, sizeof(inputParameters));
	inputParameters.channelCount = Pa_GetDeviceInfo(deviceNum)->maxInputChannels;
	inputParameters.device = deviceNum;
	inputParameters.hostApiSpecificStreamInfo = NULL;
	inputParameters.sampleFormat = paFloat32;
	inputParameters.suggestedLatency = Pa_GetDeviceInfo(inputParameters.device)->defaultLowInputLatency;

	err = Pa_OpenStream(
		&stream,
		&inputParameters,
		NULL,
		SAMPLE_RATE,
		FRAMES_PER_BUFFER,
		paNoFlag,
		analyzeFreqCallback,
		callbackData
	);
	checkForErrors(err, "chooseInputDevice");

	return err;
}

int AudioAnalyzer::chooseOutputDevice(int deviceNum)
{
	return 0;
}

/// <summary>
///  TODO: currently just prints the device list, rework to return a list of devices
/// </summary>
AudioAnalyzer::DevicesList AudioAnalyzer::getDeviceList()
{
	int numDevices = Pa_GetDeviceCount();
	//std::cout << "Number of audio devices: " << numDevices << std::endl;

	DevicesList devicesList;

	for (int i = 0; i < numDevices; i++)
	{
		const PaDeviceInfo* deviceInfo = Pa_GetDeviceInfo(i);
		/*if (deviceInfo->maxInputChannels > 0)
		{
			std::cout << "Device " << i << ": " << deviceInfo->name << std::endl;
			std::cout << "  Max Input Channels: " << deviceInfo->maxInputChannels << std::endl;
			std::cout << "  Max Output Channels: " << deviceInfo->maxOutputChannels << std::endl;
			std::cout << "  Default Sample Rate: " << deviceInfo->defaultSampleRate << std::endl;
		}*/
		if (deviceInfo->maxInputChannels > 0)
		{
			devicesList.input_devices.insert({ i, deviceInfo->name });
		}
		else if (deviceInfo->maxOutputChannels > 0)
		{
			devicesList.output_devices.insert({ i, deviceInfo->name });
		}
	}

	return devicesList;
}

void AudioAnalyzer::startAnalyzing()
{
	err = Pa_StartStream(stream);
	checkForErrors(err, "startAnalyzing");

	//Pa_Sleep(300);
	//while (true) {
	//	//cin >> stop;
	//	if (std::cin.get() == '\n')
	//		break;
	//}
}

void AudioAnalyzer::stopAnalyzing()
{
	std::cout << "papuchi" << std::endl;
	if(stream == nullptr)
		return;

	err = Pa_StopStream(stream);
	checkForErrors(err, "stopAnalyzing");
}

AudioAnalyzer::~AudioAnalyzer()
{
	std::cout << "zalupa" << std::endl;

	if(stream != nullptr){
		err = Pa_StopStream(stream);
		checkForErrors(err, "Destructor");
	}

	err = Pa_CloseStream(stream);
	checkForErrors(err, "Destructor");

	err = Pa_Terminate();
	checkForErrors(err, "Destructor");

	fftw_destroy_plan(callbackData->plan);
	fftw_free(callbackData->in);
	fftw_free(callbackData->out);
	delete callbackData;
}
