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

    ACRE_RESULT process(int16_t *const samples, const int32_t sampleCount, const int32_t channels, const uint32_t speakerMask, CSoundMixdownEffect *const params);

    X3DAUDIO_VECTOR getUpVector(X3DAUDIO_VECTOR inVector);

    uint32_t getChannelMask(const uint32_t channelMask);

private:
    X3DAUDIO_HANDLE p_X3DInstance;
    bool p_IsInitialized;
};
