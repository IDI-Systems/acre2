#pragma once

#include "compat.h"
#include "Types.h"
#include "Macros.h"

class CFilterGain
{
public:
    CFilterGain(void);
    ~CFilterGain(void);

    ACRE_RESULT process(int16_t *const a_samples, const int32_t ac_sampleCount, const int32_t ac_channels, const float32_t ac_gain);
    ACRE_RESULT reset(void) { return ACRE_NOT_IMPL; }
};
