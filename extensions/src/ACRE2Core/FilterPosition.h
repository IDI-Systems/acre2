#pragma once

#include "compat.h"
#include "Types.h"
#include "Macros.h"
#include "SoundMixdownEffect.h"

#include <x3daudio.h>

class CFilterPosition
{
public:
    CFilterPosition(void);
    ~CFilterPosition(void);

    ACRE_RESULT process(int16_t *const a_samples, const int32_t ac_sampleCount, const int32_t ac_channels, const uint32_t ac_speakerMask, CSoundMixdownEffect *const params);

    X3DAUDIO_VECTOR getUpVector(X3DAUDIO_VECTOR inVector);

    uint32_t getChannelMask(const uint32_t ac_channelMask);

private:
    X3DAUDIO_HANDLE p_X3DInstance;
    bool p_IsInitialized;
};
