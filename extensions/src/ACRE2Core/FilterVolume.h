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
    acre_result_t process(short* samples, int sampleCount, int channels, acre_volume_t volume, acre_volume_t previousVolume);

    DECLARE_MEMBER(int, ChannelCount);
};
