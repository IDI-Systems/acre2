#pragma once

#include "compat.h"

#include "SoundMixdownEffect.h"
#include "FilterPosition.h"

class CPositionalMixdownEffect : public CSoundMixdownEffect {
private:
    static CFilterPosition positionFilter;
public:
    CPositionalMixdownEffect() {
        this->setParam("isWorld", true);
        this->setParam("isLoudSpeaker", false);
        this->setParam("speakerPosX", 0.0f);
        this->setParam("speakerPosY", 0.0f);
        this->setParam("speakerPosZ", 0.0f);
        this->setParam("headVectorX", 0.0f);
        this->setParam("headVectorY", 1.0f);
        this->setParam("headVectorZ", 0.0f);
        this->setParam("curveScale", 1.0f);
        this->setParam("speakingType", acre::Speaking::direct);
    };
    void process(short* samples, int sampleCount, int channels, const unsigned int speakerMask) {
        this->positionFilter.process(samples, sampleCount, channels, speakerMask, this);
    };
};
