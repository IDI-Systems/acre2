#include <cstdlib>
#include "AcreDsp.h"

namespace Dsp {
    float32_t whitenoise () {
        /* Setup constants */
        const static int32_t q = 15;
        const static float32_t c1 = (1 << q) - 1;
        const static float32_t c2 = (float)((int)(c1 / 3)) + 1;
        const static float32_t c3 = 1.f / c1;

        const float32_t random = ((float32_t) rand() / (float32_t) (RAND_MAX + 1));
        const float32_t noise = (2.f * ((random * c2) + (random * c2) + (random * c2)) - 3.f * (c2 - 1.f)) * c3;

        return noise;
    }

    void foldback (float32_t *const samples, const int32_t count, const float32_t value) {

        const float32_t divFloat = 256.0f*powf(value, 4.0f) - 693.33f*powf(value, 3.0f) + 648.0f*powf(value, 2.0f) - 250.67f*value + 40.0f;
        int32_t divisor = (int32_t) divFloat;

        if (divisor < 5) {
            divisor = 5;
        }

        for (int32_t i = 0; i < count; i += divisor) {
            for (int32_t x = 1; x < divisor && i + value < count; x++) {
                samples[i + x] = samples[i];
            }
        }
    }
}
