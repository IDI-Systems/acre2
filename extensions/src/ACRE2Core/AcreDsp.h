#pragma once
#include "DspFilters\Dsp.h"
#include "Types.h"

#define PINK_NOISE_NUM_STAGES 3
#define PI_2                  1.57079632679489661923f

namespace Dsp {
    void normalize (float32_t *const samples, const int32_t count);
    void denormalize (float32_t *const  samples, const int32_t count);

    void foldback (float32_t *const samples, const int32_t count, const float32_t value);

    float32_t whitenoise ();

    class RingModulate {
    public:
        float32_t phase = 0;
        void mix (float32_t *const buffer, const int32_t numSamples, const float32_t value) {

            const float32_t val = (1.0f - value) * 0.20f;

            for (int32_t x = 0; x < numSamples; x++) {
                const float32_t multiple = buffer[x] * sinf(phase * PI_2);
                phase += (90.0f / 48000.0f);
                if (phase > 1.0f) phase = 0.0f;
                buffer[x] = buffer[x] * (1.0f - val) + multiple * val;
            }
        }
    };

    class PinkNoise {
    public:
        PinkNoise ();
        void clear ();

        float32_t m_tick ();

    protected:
        float32_t m_state[PINK_NOISE_NUM_STAGES];
        static const float32_t m_A[PINK_NOISE_NUM_STAGES];
        static const float32_t m_P[PINK_NOISE_NUM_STAGES];
    };
}
