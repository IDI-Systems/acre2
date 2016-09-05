#pragma once

#include "compat.h"
#include "Types.h"
#include "Macros.h"

#include "AcreDsp.h"

class CFilterVolume
{
public:
	CFilterVolume(void);
	~CFilterVolume(void);
	ACRE_RESULT process(short* samples, int sampleCount, int channels, ACRE_VOLUME volume, ACRE_VOLUME previousVolume);

	DECLARE_MEMBER(int, ChannelCount);
};
