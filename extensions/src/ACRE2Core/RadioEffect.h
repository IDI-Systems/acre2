#pragma once

#include "compat.h"

#include "AcreSettings.h"
#include "SoundMonoEffect.h"
#include "FilterRadio.h"

class CRadioEffect : public CSoundMonoEffect {
private:
    CFilterRadio *radioFilter;
public:
    CRadioEffect();
    ~CRadioEffect();
    void process(int16_t *const samples, const int32_t sampleCount);
};
