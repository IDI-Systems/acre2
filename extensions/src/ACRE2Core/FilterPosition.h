#pragma once

#include "compat.h"
#include "Types.h"
#include "Macros.h"
#include "SoundMixdownEffect.h"

#ifdef WIN32
#include <x3daudio.h>
#else
#include <F3DAudio.h>
#define X3DAUDIO_CALCULATE_EMITTER_ANGLE F3DAUDIO_CALCULATE_EMITTER_ANGLE
#define X3DAUDIO_CALCULATE_MATRIX        F3DAUDIO_CALCULATE_MATRIX
#define X3DAUDIO_CONE                    F3DAUDIO_CONE
#define X3DAUDIO_DISTANCE_CURVE          F3DAUDIO_DISTANCE_CURVE
#define X3DAUDIO_DISTANCE_CURVE_POINT    F3DAUDIO_DISTANCE_CURVE_POINT
#define X3DAUDIO_DSP_SETTINGS            F3DAUDIO_DSP_SETTINGS
#define X3DAUDIO_EMITTER                 F3DAUDIO_EMITTER
#define X3DAUDIO_HANDLE                  F3DAUDIO_HANDLE
#define X3DAUDIO_LISTENER                F3DAUDIO_LISTENER
#define X3DAUDIO_PI                      F3DAUDIO_PI
#define X3DAUDIO_VECTOR                  F3DAUDIO_VECTOR
#define X3DAudioCalculate                F3DAudioCalculate
#define X3DAudioInitialize               F3DAudioInitialize
#define X3DAUDIO_SPEED_OF_SOUND          343.5
#endif

class CFilterPosition
{
public:
    CFilterPosition(void);
    ~CFilterPosition(void);

    acre::Result process(short* samples, int sampleCount, int channels, const unsigned int speakerMask, CSoundMixdownEffect *params);

    X3DAUDIO_VECTOR getUpVector(X3DAUDIO_VECTOR inVector);

    unsigned int getChannelMask(const unsigned int channelMask);

private:
    X3DAUDIO_HANDLE p_X3DInstance;
    BOOL p_IsInitialized;
};
