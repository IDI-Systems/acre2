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
    acre::Result process(short* samples, int sampleCount, int channels, acre::volume_t volume, Dsp::Filter *&filter);

    DECLARE_MEMBER(int, ChannelCount);
};
