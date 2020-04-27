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

    acre::Result process(short* samples, int sampleCount, int channels, CPlayer *player);
    acre::Result reset(void);

    acre::Result processAmplitudes(void); 

};

