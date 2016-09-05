#include "AcreSettings.h"
#include "FilterRadio.h"


#include "Log.h"

#include <ctime>

#define BASE_DISTORTION_LEVEL 0.43f

ACRE_RESULT CFilterRadio::process(short* samples, int sampleCount, int channels, ACRE_VOLUME value, bool noise) {
	float buffer[4096], *floatPointer[1];
	short *shortPointer[1];

	if (CAcreSettings::getInstance()->getDisableRadioFilter())
		return ACRE_OK;

	if (value > 0.0f) {
		floatPointer[0] = buffer;
		shortPointer[0] = samples;
		memset(floatPointer[0], 0x00, 4096 * sizeof(float));
		float mul = 1.0f / 32768.0f;
		for (int i = 0; i < sampleCount; ++i) {
			floatPointer[0][i] = static_cast<float>(samples[i]) * mul;
		}


		// Boost it
		for (int i = 0; i < sampleCount*channels; i++) {
			floatPointer[0][i] = floatPointer[0][i] * 3.0f;
		}
		if (noise) {
			this->mixPinkNoise(floatPointer[0], sampleCount*channels, value);
			this->mixWhiteNoise(floatPointer[0], sampleCount*channels, value);
		}

		// Mix noise
		this->m_RingModulate.mix(floatPointer[0], sampleCount*channels, value);

		// Fold back
		Dsp::foldback(floatPointer[0], sampleCount*channels, value);

		// shelf it
		this->m_LowPass.process(sampleCount*channels, floatPointer);
		this->m_HighPass.process(sampleCount*channels, floatPointer);

		// Convert it back to shorts
		for (int i = 0; i < sampleCount; ++i) {
			if (floatPointer[0][i] > 1.0f) {
				floatPointer[0][i] = 1.0f;
			}
			if (floatPointer[0][i] < -1.0f) {
				floatPointer[0][i] = -1.0f;
			}
			shortPointer[0][i] = static_cast<short>(std::floor(floatPointer[0][i] * 32767.0f));
		}

	} else {
		memset(samples, 0x00, (sampleCount*channels)*sizeof(short) );
	}

	return ACRE_OK;
}

ACRE_RESULT CFilterRadio::mixPinkNoise(float *buffer, int numSamples, ACRE_VOLUME value) {
	
	float inverse_value = 1.25f - value;
	for (int i = 0; i < numSamples; i++) {
		float noise = this->m_PinkNoise.tick() * (0.35f * inverse_value);
		buffer[i] = (buffer[i] + noise) - (noise * buffer[i]);
	}

	return ACRE_OK;
}

ACRE_RESULT CFilterRadio::mixWhiteNoise(float *buffer, int numSamples, ACRE_VOLUME value) {

	float inverse_value = 1.25f - value;
	for (int i = 0; i < numSamples; i++) {
		float noise = Dsp::whitenoise() * (0.001f *inverse_value);
		buffer[i] = buffer[i] + noise;
	}
	
	return ACRE_OK;
}

CFilterRadio::CFilterRadio(void)
{
	srand((unsigned int)time(0));
	this->m_HighPass.setup (TS_SAMPLE_RATE, 750, 0.97);
	this->m_LowPass.setup (TS_SAMPLE_RATE, 4000, 2.0);
	this->m_PinkNoise.clear();
}

CFilterRadio::~CFilterRadio(void)
{
}
