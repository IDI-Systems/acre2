#pragma once

#include "compat.h"

#include "SoundMonoEffect.h"
#include "FilterVolume.h"

class CVolumeEffect : public CSoundMonoEffect {
private:
    static CFilterVolume m_volumeFilter;
public:
    CVolumeEffect() {
        this->setParam("previousVolume", 1.0f);
        this->setParam("volume", 1.0f);
    };

    void process(int16_t *const samples, const int32_t sampleCount) {
        this->m_volumeFilter.process(samples, sampleCount, 1, (ACRE_VOLUME)this->getParam("volume"), (ACRE_VOLUME)this->getParam("previousVolume"));
        this->setParam("previousVolume", this->getParam("volume"));
    };
};
