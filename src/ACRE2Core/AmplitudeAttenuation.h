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

	ACRE_RESULT process(short* samples, int sampleCount, int channels, CPlayer *player);
	ACRE_RESULT reset(void);

	ACRE_RESULT processAmplitudes(void); 

};

