#pragma once

#include "compat.h"
#include "Types.h"
#include "Macros.h"

#include "AcreDsp.h"

class CFilterOcclusion
{
public:
    CFilterOcclusion(void);
    ~CFilterOcclusion(void);
    ACRE_RESULT process(int16_t *const samples, const int32_t sampleCount, const int32_t channels, const ACRE_VOLUME volume, Dsp::Filter *&filter);

    virtual __inline void setChannelCount(const int32_t value) { this->m_channelCount = value; }
    virtual __inline int32_t getChannelCount() const { return this->m_channelCount; }

protected:
    int32_t m_channelCount;
};
