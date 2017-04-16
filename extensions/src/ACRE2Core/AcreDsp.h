#pragma once

#if WIN32
#include "DspFilters\Dsp.h"
#else
#include "DspFilters/Dsp.h"
#endif

#define PINK_NOISE_NUM_STAGES 3
#define PI_2     1.57079632679489661923f

namespace Dsp {
    void normalize(float *samples, int count);
    void denormalize(float *samples, int count);

    void foldback(float *samples, int count, float value);

    float whitenoise();

    class RingModulate {
    public:
        float phase = 0;
        void mix(float *buffer, int numSamples, float value) {

            value = (1.0f - value) * 0.20f;

            for (int x = 0; x < numSamples; x++) {
                float multiple = buffer[x] * sinf(phase * PI_2);
                phase += (90.0f * 1.0f / (float)48000);
                if (phase > 1.0f) phase = 0.0f;
                buffer[x] = buffer[x] * (1.0f - value) + multiple * value;
            }
        }
    };

    class PinkNoise {
    public:
        PinkNoise();
        void clear();

        float tick();

    protected:
        float state[PINK_NOISE_NUM_STAGES];
        static const float A[PINK_NOISE_NUM_STAGES];
        static const float P[PINK_NOISE_NUM_STAGES];

    };
}
