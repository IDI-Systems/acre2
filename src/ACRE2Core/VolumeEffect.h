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
		this->volumeFilter.process(samples, sampleCount, 1, (ACRE_VOLUME)this->getParam("volume"), (ACRE_VOLUME)this->getParam("previousVolume"));
		this->setParam("previousVolume", this->getParam("volume"));
	};
};