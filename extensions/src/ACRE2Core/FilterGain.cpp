#include "FilterGain.h"

#include "AcreDsp.h"
#include "Log.h"

#include <cmath>

acre::Result CFilterGain::process(short* samples, int sampleCount, int channels, float gain) {
    float gainSampleValue;
    if (gain >= 0.0f) {
        for (int i = 0; i < sampleCount * channels; i++) {
            gainSampleValue = ((float)samples[i] * gain);
            if (gainSampleValue > MAXSHORT) {
                gainSampleValue = MAXSHORT;
            }
            if (gainSampleValue < -MINSHORT) {
                gainSampleValue = -MINSHORT;
            }
            samples[i] = (short)gainSampleValue;
        }
    }
    return acre::Result::ok;
}

CFilterGain::CFilterGain(void)
{
}

CFilterGain::~CFilterGain(void)
{
}
