#include <cstdlib>
#include <ctime>

#include "AcreDsp.h"
#include "Types.h"

namespace Dsp {

    PinkNoise::PinkNoise() {
        
        srand((uint32_t)time(NULL)); // initialize random generator
        clear();
    }

    void PinkNoise::clear() {
        for (size_t i = 0; i < PINK_NOISE_NUM_STAGES; i++)
            m_state[i] = 0.0;
    }

    float PinkNoise::m_tick() {
        static const float32_t RMI2 = 2.0f / (float32_t) RAND_MAX; // + 1.0; // change for range [0,1)
        static const float32_t offset = m_A[0] + m_A[1] + m_A[2];

        // unrolled loop
        float32_t temp = (float32_t) rand();
        m_state[0] = m_P[0] * (m_state[0] - temp) + temp;
        temp = (float32_t) rand();
        m_state[1] = m_P[1] * (m_state[1] - temp) + temp;
        temp = (float32_t)rand();
        m_state[2] = m_P[2] * (m_state[2] - temp) + temp;
        return (m_A[0] * m_state[0] + m_A[1] * m_state[1] + m_A[2] * m_state[2])*RMI2 - offset;
    }

    const float PinkNoise::m_A[PINK_NOISE_NUM_STAGES] = { 0.02109238f, 0.07113478f, 0.68873558f };
    const float PinkNoise::m_P[PINK_NOISE_NUM_STAGES] = { 0.3190f,  0.7756f,  0.9613f };
}
