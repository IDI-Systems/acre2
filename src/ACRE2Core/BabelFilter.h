#pragma once
#include "compat.h"

#include "Types.h"

#include "Macros.h"

#include "Lockable.h"
#include <map>

struct BabelStruct {
    unsigned int id;
    long long unsigned int period;
    int attenCount;
    float averageSum;
};

class CBabelFilter: CLockable {
public:
    CBabelFilter( void );
    ~CBabelFilter( void );

    ACRE_RESULT process(short* samples, int sampleCount, int channels, ACRE_ID id);

    BabelStruct *getSpeaker(ACRE_ID id);

protected:
    std::map<ACRE_ID, BabelStruct *> babelSpeakers;
};