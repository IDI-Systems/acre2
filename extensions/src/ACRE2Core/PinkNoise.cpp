#include <cstdlib>
#include <ctime>

#include "AcreDsp.h"

namespace Dsp {

    PinkNoise::PinkNoise() {
        
        srand((uint32_t)time(NULL)); // initialize random generator
        clear();
    }

    void PinkNoise::clear() {
        for (size_t i = 0; i < PINK_NOISE_NUM_STAGES; i++)
            state[i] = 0.0;
    }

    float PinkNoise::tick() {
        static const float RMI2 = 2.0f / float(RAND_MAX); // + 1.0; // change for range [0,1)
        static const float offset = A[0] + A[1] + A[2];

        // unrolled loop
        float temp = float(rand());
        state[0] = P[0] * (state[0] - temp) + temp;
        temp = float(rand());
        state[1] = P[1] * (state[1] - temp) + temp;
        temp = float(rand());
        state[2] = P[2] * (state[2] - temp) + temp;
        return (A[0] * state[0] + A[1] * state[1] + A[2] * state[2])*RMI2 - offset;
    }

    const float PinkNoise::A[PINK_NOISE_NUM_STAGES] = { 0.02109238f, 0.07113478f, 0.68873558f };
    const float PinkNoise::P[PINK_NOISE_NUM_STAGES] = { 0.3190f,  0.7756f,  0.9613f };
}