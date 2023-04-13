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

    acre::Result process(short* samples, int sampleCount, int channels, acre::volume_t value, bool noise, const bool isLoudSpeaker);

    Dsp::SimpleFilter<Dsp::RBJ::HighPass, 1> m_HighPass;
    Dsp::SimpleFilter<Dsp::RBJ::LowPass, 1> m_LowPass;
    Dsp::SimpleFilter<Dsp::RBJ::LowShelf, 1> m_lowShelf;
    Dsp::PinkNoise m_PinkNoise;
    Dsp::RingModulate m_RingModulate;
protected:
    acre::Result mixWhiteNoise(float *buffer, int numSamples, acre::volume_t signal);
    acre::Result mixPinkNoise(float *buffer, int numSamples, acre::volume_t signal);
};
