#pragma once

#include "compat.h"
#include "Types.h"
#include "Macros.h"

#include "AcreDsp.h"

#define TS_SAMPLE_RATE 48000

class CFilterRadio
{
public:
	CFilterRadio(void);
	~CFilterRadio(void);

	ACRE_RESULT process(short* samples, int sampleCount, int channels, ACRE_VOLUME value, bool noise);

	Dsp::SimpleFilter<Dsp::RBJ::HighPass, 1> m_HighPass;
	Dsp::SimpleFilter<Dsp::RBJ::LowPass, 1> m_LowPass;
	Dsp::PinkNoise m_PinkNoise;
	Dsp::RingModulate m_RingModulate;
protected:
	ACRE_RESULT mixWhiteNoise(float *buffer, int numSamples, ACRE_VOLUME signal);
	ACRE_RESULT mixPinkNoise(float *buffer, int numSamples, ACRE_VOLUME signal);
};
