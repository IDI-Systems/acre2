#pragma once

#include <vector>

#include "compat.h"

#include "SoundMonoEffect.h"
#include "AcreDsp.h"

// the CVSD rate must be a factor of the sample rate
#define TS_SAMPLE_RATE 48000
#define CVSD_RATE 16000

// this is chosen to match the volume of other radio effects
#define VOL_BOOST 3

class CRadioEffectCVSD : public CSoundMonoEffect {
private:
    class CVSDDecoder {
    private:
        std::vector<bool> lookback_register;
        const std::size_t lookback = 3;
        const short delta_min = 32;
        const short delta_max = delta_min * 16;
        const short delta_coef = 2;
        const float decay = 0.95;
        
        short reference = 0;
        short delta = delta_min;
        
    public:
        CVSDDecoder();
        
        short decode(bool sample);
    };

    class CVSDEncoder {
    private:
        CVSDDecoder decoder;

        short reference = 0;

    public:
        bool encode(short sample);
    };

    CVSDEncoder encoder;
    CVSDDecoder decoder;
    Dsp::SimpleFilter<Dsp::ChebyshevII::LowPass<4>, 1> filter;

public:
    CRadioEffectCVSD();

    static float quality_to_ber(float signalQuality);

    void process(short* samples, int sampleCount);
};
