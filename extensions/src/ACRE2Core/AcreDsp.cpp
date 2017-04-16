#include <cstdlib>
#include "AcreDsp.h"

namespace Dsp {
    float whitenoise() {
        /* Setup constants */
        const static int q = 15;
        const static float c1 = (1 << q) - 1;
        const static float c2 = (float)((int)(c1 / 3)) + 1;
        const static float c3 = 1.f / c1;

        float random = ((float)rand() / (float)(RAND_MAX + 1.0f));
        float noise = (2.f * ((random * c2) + (random * c2) + (random * c2)) - 3.f * (c2 - 1.f)) * c3;

        return noise;
    }

    void foldback(float *samples, int count, float value) {
        float divFloat = 256.0f*powf(value, 4.0f) - 693.33f*powf(value, 3.0f) + 648.0f*powf(value, 2.0f) - 250.67f*value + 40.0f;
        int divisor = (int) divFloat;
        if (divisor < 5)
            divisor = 5;
        for (int i = 0; i < count; i += divisor) {
            for (int x = 1; x < divisor && i + value < count; x++) {
                samples[i + x] = samples[i];
            }
        }
    }
}
