#pragma once

#include "compat.h"

#include "AcreSettings.h"
#include "SoundMonoEffect.h"
#include "FilterRadio.h"

class CRadioEffectAnalogue : public CSoundMonoEffect {
private:
    CFilterRadio *radioFilter;
public:
    CRadioEffectAnalogue();
    ~CRadioEffectAnalogue();
    void process(short *samples, int sampleCount);
};
