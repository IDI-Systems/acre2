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

    AcreResult process(short* samples, int sampleCount, int channels, acre_volume_t value, bool noise);

    Dsp::SimpleFilter<Dsp::RBJ::HighPass, 1> m_HighPass;
    Dsp::SimpleFilter<Dsp::RBJ::LowPass, 1> m_LowPass;
    Dsp::PinkNoise m_PinkNoise;
    Dsp::RingModulate m_RingModulate;
protected:
    AcreResult mixWhiteNoise(float *buffer, int numSamples, acre_volume_t signal);
    AcreResult mixPinkNoise(float *buffer, int numSamples, acre_volume_t signal);
};
