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
    acre_result_t process(short* samples, int sampleCount, int channels, acre_volume_t volume, Dsp::Filter *&filter);

    DECLARE_MEMBER(int, ChannelCount);
};
