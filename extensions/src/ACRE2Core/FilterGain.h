#pragma once

#include "compat.h"
#include "Types.h"
#include "Macros.h"

class CFilterGain
{
public:
    CFilterGain(void);
    ~CFilterGain(void);

    acre::Result process(short* samples, int sampleCount, int channels, float gain);
    acre::Result reset(void) { return acre::Result::notImplemented; }
};
