#pragma once

#include "compat.h"
#include "Types.h"
#include "Macros.h"

class CFilterGain
{
public:
    CFilterGain(void);
    ~CFilterGain(void);

    ACRE_RESULT process(int16_t *const samples, const int32_t sampleCount, const int32_t channels, const float32_t gain);
    ACRE_RESULT reset(void) { return ACRE_NOT_IMPL; }
};
