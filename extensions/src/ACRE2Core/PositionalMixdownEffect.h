#pragma once

#include "compat.h"

#include "SoundMixdownEffect.h"
#include "FilterPosition.h"

#define POSITIONAL_EFFECT_ISLOCAL    0x00000000
#define POSITIONAL_EFFECT_ISWORLD    0x00000001

class CPositionalMixdownEffect : public CSoundMixdownEffect {
private:
    static CFilterPosition positionFilter;
public:
    CPositionalMixdownEffect() {
        this->setParam("isWorld", POSITIONAL_EFFECT_ISWORLD);
        this->setParam("isLoudSpeaker", 0.0f);
        this->setParam("speakerPosX", 0.0f);
        this->setParam("speakerPosY", 0.0f);
        this->setParam("speakerPosZ", 0.0f);
        this->setParam("headVectorX", 0.0f);
        this->setParam("headVectorY", 1.0f);
        this->setParam("headVectorZ", 0.0f);
        this->setParam("curveScale", 1.0f);
        this->setParam("speakingType", acre_speaking_direct);
    };
    void process(short* samples, int sampleCount, int channels, const unsigned int speakerMask) {
        this->positionFilter.process(samples, sampleCount, channels, speakerMask, this);
    };
};