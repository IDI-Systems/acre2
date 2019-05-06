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

    AcreResult process(short* samples, int sampleCount, int channels, CPlayer *player);
    AcreResult reset(void);

    AcreResult processAmplitudes(void); 

};

