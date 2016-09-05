#include "compat.h"
#include <cmath>

namespace Dsp {
    
    void normalize(float *samples, int count) {
        for (int i = 0; i < count; i ++) {
            samples[i] = samples[i] / 0x8000;
            if(samples[i] > 1.0f)
                samples[i] = 1.0f;
            if(samples[i] < -1.0f)
                samples[i] = -1.0f;
        }
    }
    void denormalize(float *samples, int count) {
        for (int i = 0; i < count; i ++) {
            if(samples[i] > 1.0f)
                samples[i] = 1.0f;
            if(samples[i] < -1.0f)
                samples[i] = -1.0f;

            samples[i] = samples[i] * 0x7FFF;
        }
    }

}

