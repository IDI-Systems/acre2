#pragma once

#include "compat.h"
#include "Types.h"
#include "Macros.h"

class CFilterGain
{
public:
    CFilterGain(void);
    ~CFilterGain(void);

    AcreResult process(short* samples, int sampleCount, int channels, float gain);
    AcreResult reset(void) { return AcreResult::notImplemented; }
};
