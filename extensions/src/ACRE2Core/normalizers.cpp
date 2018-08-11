#include "compat.h"
#include <cmath>
#include "Types.h"

namespace Dsp {
    
    void normalize(float32_t *const a_samples, const int32_t ac_count) {
        for (int32_t i = 0; i < ac_count; i ++) {
            a_samples[i] = a_samples[i] / 0x8000;
            if (a_samples[i] > 1.0f)
                a_samples[i] = 1.0f;
            if (a_samples[i] < -1.0f)
                a_samples[i] = -1.0f;
        }
    }
    void denormalize(float32_t *const a_samples, int32_t ac_count) {
        for (int32_t i = 0; i < ac_count; i ++) {
            if (a_samples[i] > 1.0f)
                a_samples[i] = 1.0f;
            if (a_samples[i] < -1.0f)
                a_samples[i] = -1.0f;

            a_samples[i] = a_samples[i] * 0x7FFF;
        }
    }

}

