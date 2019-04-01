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

    acre_result_t process(short* samples, int sampleCount, int channels, acre_id_t id);

    BabelStruct *getSpeaker(acre_id_t id);

protected:
    std::map<acre_id_t, BabelStruct *> babelSpeakers;
};