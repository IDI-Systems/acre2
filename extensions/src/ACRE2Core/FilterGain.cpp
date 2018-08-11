#include "FilterGain.h"

#include "AcreDsp.h"
#include "Log.h"

#include <cmath>

ACRE_RESULT CFilterGain::process(int16_t *const a_samples, const int32_t ac_sampleCount, const int32_t ac_channels, const float32_t ac_gain) {
    float32_t gainSampleValue;

    if (ac_gain >= 0.0f) {
        for (int32_t i = 0; i < ac_sampleCount * ac_channels; i++) {
            gainSampleValue = (float32_t) a_samples[i] * ac_gain;

            if (gainSampleValue > MAXSHORT) {
                gainSampleValue = MAXSHORT;
            } else if (gainSampleValue < -MINSHORT) {
                gainSampleValue = -MINSHORT;
            }
            a_samples[i] = (int16_t) gainSampleValue;
        }
    }
    return ACRE_OK;
}

CFilterGain::CFilterGain(void)
{
}

CFilterGain::~CFilterGain(void)
{
}
