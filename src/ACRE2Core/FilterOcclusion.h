#pragma once

#include "compat.h"
#include "Types.h"
#include "Macros.h"

#include "AcreDsp.h"

class CFilterOcclusion
{
public:
	CFilterOcclusion(void);
	~CFilterOcclusion(void);
	ACRE_RESULT process(short* samples, int sampleCount, int channels, ACRE_VOLUME volume, Dsp::Filter *&filter);

	DECLARE_MEMBER(int, ChannelCount);
};
