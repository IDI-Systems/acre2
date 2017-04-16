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

    ACRE_RESULT process(short* samples, int sampleCount, int channels, const unsigned int speakerMask, CSoundMixdownEffect *params);

    X3DAUDIO_VECTOR getUpVector(X3DAUDIO_VECTOR inVector);

    unsigned int getChannelMask(const unsigned int channelMask);

private:
    X3DAUDIO_HANDLE p_X3DInstance;
    bool p_IsInitialized;
};
