#pragma once

#include "compat.h"
#include "Types.h"
#include "Macros.h"

class CFilterGain
{
public:
    CFilterGain(void);
    ~CFilterGain(void);

    ACRE_RESULT process(short* samples, int sampleCount, int channels, float gain);
    ACRE_RESULT reset(void) { return ACRE_NOT_IMPL; }
};
