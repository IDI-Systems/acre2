#pragma once

#include "compat.h"

#include "SoundMonoEffect.h"
#include "FilterVolume.h"

class CVolumeEffect : public CSoundMonoEffect {
private:
    static CFilterVolume volumeFilter;
public:
    CVolumeEffect() {
        this->setParam("previousVolume", 1.0f);
        this->setParam("volume", 1.0f);
    };

    void process(short *samples, int sampleCount) {
        this->volumeFilter.process(
            samples,
            sampleCount,
            1,
            this->getParam<acre::volume_t>("volume"),
            this->getParam<acre::volume_t>("previousVolume"));

        this->setParam("previousVolume", this->getParam<acre::volume_t>("volume"));
    };
};
