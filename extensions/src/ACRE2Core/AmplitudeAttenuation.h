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

    acre_result_t process(short* samples, int sampleCount, int channels, CPlayer *player);
    acre_result_t reset(void);

    acre_result_t processAmplitudes(void); 

};

