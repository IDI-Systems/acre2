#pragma once

#include "compat.h"
#include "Lockable.h"
#include <string>
#include <map>

#ifdef WIN32
#include <concurrent_unordered_map.h>
#else
#include <tbb/concurrent_unordered_map.h>
namespace concurrency = tbb;
#endif

class CSoundMixdownEffect : public CLockable {
private:
    concurrency::concurrent_unordered_map<std::string, float> paramMap;
public:
    CSoundMixdownEffect() { };
    ~CSoundMixdownEffect()  { };
    virtual void process(short* samples, int sampleCount, int channels, const unsigned int speakerMask) = 0;
    void setParam(std::string paramName, float value) { paramMap[paramName] = value; };
    float getParam(std::string paramName) { return paramMap[paramName]; };
};
