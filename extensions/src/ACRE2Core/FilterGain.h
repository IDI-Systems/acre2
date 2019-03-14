#pragma once

#include "compat.h"
#include "Types.h"
#include "Macros.h"

class CFilterGain
{
public:
    CFilterGain(void);
    ~CFilterGain(void);

    acre_result_t process(short* samples, int sampleCount, int channels, float gain);
    acre_result_t reset(void) { return acre_result_notImplemented; }
};
