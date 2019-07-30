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
    acre::Result process(short* samples, int sampleCount, int channels, acre::volume_t volume, acre::volume_t previousVolume);

    DECLARE_MEMBER(int, ChannelCount);
};
