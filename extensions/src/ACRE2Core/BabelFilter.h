#pragma once
#include "compat.h"

#include "Types.h"

#include "Macros.h"

#include "Lockable.h"
#include <map>

struct BabelStruct {
    uint32_t id;
    uint64_t period;
    int32_t attenCount;
    float32_t averageSum;
};

class CBabelFilter: CLockable {
public:
    CBabelFilter( void );
    ~CBabelFilter( void );

    ACRE_RESULT process(int16_t *const a_samples, const int32_t ac_sampleCount, const int32_t ac_channels, const ACRE_ID ac_id);

    BabelStruct *getSpeaker(const ACRE_ID ac_id);

protected:
    std::map<ACRE_ID, BabelStruct *> m_babelSpeakers;
};
