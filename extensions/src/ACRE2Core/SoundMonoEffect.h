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

class CSoundMonoEffect : public CLockable {
private:
    concurrency::concurrent_unordered_map<std::string, float> paramMap;
public:
    CSoundMonoEffect() { };
    ~CSoundMonoEffect() { };
    virtual void process(short *samples, int sampleCount) = 0;
    void setParam(std::string paramName, float value) { paramMap[paramName] = value; };
    float getParam(std::string paramName) {
        if (paramMap.find(paramName) != paramMap.end()) {
            return paramMap[paramName];
        } else {
            return 0.0f;
        }
    };
};
