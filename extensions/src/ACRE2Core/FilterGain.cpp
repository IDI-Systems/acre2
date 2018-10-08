#include "FilterGain.h"

#include "AcreDsp.h"
#include "Log.h"

#include <cmath>

ACRE_RESULT CFilterGain::process(int16_t *const samples, const int32_t sampleCount, const int32_t channels, const float32_t gain) {
    float32_t gainSampleValue;

    if (gain >= 0.0f) {
        for (int32_t i = 0; i < sampleCount * channels; i++) {
            gainSampleValue = (float32_t) samples[i] * gain;

            if (gainSampleValue > MAXSHORT) {
                gainSampleValue = MAXSHORT;
            } else if (gainSampleValue < -MINSHORT) {
                gainSampleValue = -MINSHORT;
            }
            samples[i] = (int16_t) gainSampleValue;
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
