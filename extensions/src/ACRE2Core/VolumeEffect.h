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

    void process(int16_t *const a_samples, const int32_t ac_sampleCount) {
        this->m_volumeFilter.process(a_samples, ac_sampleCount, 1, (ACRE_VOLUME)this->getParam("volume"), (ACRE_VOLUME)this->getParam("previousVolume"));
        this->setParam("previousVolume", this->getParam("volume"));
    };
};
