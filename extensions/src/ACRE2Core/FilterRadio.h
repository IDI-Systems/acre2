#pragma once

#include "compat.h"
#include "Types.h"
#include "Macros.h"

#include "AcreDsp.h"

#define TS_SAMPLE_RATE_Hz 48000

class CFilterRadio
{
public:
    CFilterRadio(void);
    ~CFilterRadio(void);

    ACRE_RESULT process(int16_t *const a_samples, const int32_t ac_sampleCount, const int32_t ac_channels, const ACRE_VOLUME ac_value, const bool ac_noise);

    Dsp::SimpleFilter<Dsp::RBJ::HighPass, 1> m_HighPass;
    Dsp::SimpleFilter<Dsp::RBJ::LowPass, 1> m_LowPass;
    Dsp::PinkNoise m_PinkNoise;
    Dsp::RingModulate m_RingModulate;
protected:
    ACRE_RESULT mixWhiteNoise(float32_t *const buffer, const int32_t ac_numSamples, const ACRE_VOLUME ac_signal);
    ACRE_RESULT mixPinkNoise(float32_t *const buffer, const int32_t ac_numSamples, const ACRE_VOLUME ac_signal);
};
