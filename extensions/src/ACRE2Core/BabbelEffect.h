#pragma once

#include "compat.h"

#include "SoundMonoEffect.h"
#include "FilterRadio.h"
#include "Types.h"

#define _USE_MATH_DEFINES

#include <math.h>
#include <cmath>

#define VOLUME_MODIFIER 6.0f

class CBabbelEffect : public CSoundMonoEffect {
private:
    Dsp::SimpleFilter<Dsp::Butterworth::LowPass <4>, 1> lpFilter1;
    Dsp::SimpleFilter<Dsp::Butterworth::LowPass <4>, 1> lpFilter2;
    float32_t m_offset;
    float32_t m_sfreq;
    float32_t m_mfreq;
public:
    CBabbelEffect() {
        m_offset = 128.0f;
        m_sfreq = 48000.0f;
        m_mfreq = 5200.0f;
        lpFilter1.setup(4, (float64_t) m_sfreq, (float64_t) m_mfreq*0.3);
        lpFilter2.setup(4, (float64_t) m_sfreq, (float64_t) m_mfreq*0.5);
    };
    void process(int16_t *const a_samples, const int32_t ac_sampleCount) {
        float32_t *floatPointer[1], *buffer;
        buffer = new float32_t[ac_sampleCount];
        floatPointer[0] = buffer;
        int16_t *tempSamples = new int16_t[ac_sampleCount];
        memcpy(tempSamples, a_samples, sizeof(int16_t)*ac_sampleCount);
        int16_t maxAmp = 1;
        for (int32_t i = 0; i < ac_sampleCount; ++i) {
            a_samples[i] = (int16_t)(((float32_t)tempSamples[i]*1.0f)*cosf(((float32_t)i/(m_sfreq/m_mfreq))*1.4f*(float32_t) M_PI));
            //samples[i] += (short)(((float)tempSamples[i]*1.0f+offset)*cos(((float)i/(sfreq/500))*4*M_PI)+offset);
            if (abs(a_samples[i]) > maxAmp)
                maxAmp = a_samples[i];
            buffer[i] = (float32_t) a_samples[i]/(float32_t) SHRT_MAX;
            //samples[i] = samples[i-1] + (short)(alpha*(tempSamples[i] - samples[i-1]));
            //samples[i] = alpha * (samples[i-1] + tempSamples[i] - tempSamples[i-1]);
        }

        lpFilter1.process(ac_sampleCount, floatPointer);
        //lpFilter2.process(sampleCount, floatPointer);
    
        for (int32_t i = 0; i < ac_sampleCount; ++i) {
            a_samples[i] = (int16_t)(floatPointer[0][i]*SHRT_MAX);
            //if(abs(samples[i]) < 200) {
            //    samples[i] = samples[i]*0.01;
            //}

            buffer[i] = (float32_t)a_samples[i]/(float32_t)SHRT_MAX;
        }
        lpFilter2.process(ac_sampleCount, floatPointer);

        int16_t maxAmpPost = 1;

        for (int32_t i = 0; i < ac_sampleCount; ++i) {
            if (((floatPointer[0][i]*SHRT_MAX)*VOLUME_MODIFIER) > SHRT_MAX) {
                a_samples[i] = SHRT_MAX;
            } else if (((floatPointer[0][i]*SHRT_MAX)*VOLUME_MODIFIER) < SHRT_MIN) {
                a_samples[i] = SHRT_MIN;
            } else {
                a_samples[i] = (short)((floatPointer[0][i]*SHRT_MAX)*VOLUME_MODIFIER);
                //if(abs(samples[i]) < 50) {
                //    samples[i] = samples[i]*0.01;
                //}
            };
            if (abs(a_samples[i]) > maxAmpPost)
                maxAmpPost = a_samples[i];
        }

        //float difference = (float)(maxAmp/maxAmpPost);


        //for(int i = 0; i < sampleCount; i = i + 1) {
        //    samples[i] = samples[i]*difference;
        //}

        delete tempSamples;
        delete buffer;
    };
};
