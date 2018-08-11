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

    ACRE_RESULT process(int16_t  *const a_samples, const int32_t ac_sampleCount, const int32_t ac_channels, CPlayer *const a_player);
    ACRE_RESULT reset(void);

    ACRE_RESULT processAmplitudes(void); 
};

