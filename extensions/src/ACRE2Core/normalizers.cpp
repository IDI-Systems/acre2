#include "compat.h"
#include <cmath>
#include "Types.h"

namespace Dsp {

    void normalize(float32_t *const samples, const int32_t count) {
        for (int32_t i = 0; i < count; i ++) {
            samples[i] = samples[i] / 0x8000;
            if (samples[i] > 1.0f)
                samples[i] = 1.0f;
            if (samples[i] < -1.0f)
                samples[i] = -1.0f;
        }
    }
    void denormalize(float32_t *const samples, int32_t count) {
        for (int32_t i = 0; i < count; i ++) {
            if (samples[i] > 1.0f)
                samples[i] = 1.0f;
            if (samples[i] < -1.0f)
                samples[i] = -1.0f;

            samples[i] = samples[i] * 0x7FFF;
        }
    }

}

