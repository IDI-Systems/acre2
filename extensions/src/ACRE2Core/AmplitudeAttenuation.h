#pragma once

#include "compat.h"
#include "Types.h"
#include "Macros.h"
#include "Player.h"
#include "Lockable.h"

class CAmplitudeAttenuation :  public CLockable
{
public:
    CAmplitudeAttenuation(void);
    ~CAmplitudeAttenuation(void);

    ACRE_RESULT process(int16_t  *const samples, const int32_t sampleCount, const int32_t channels, CPlayer *const player);
    ACRE_RESULT reset(void);

    ACRE_RESULT processAmplitudes(void);
};

