#pragma once

#include "compat.h"
#include "Lockable.h"
#include <string>
#include <map>
#include <any>
#include <concurrent_unordered_map.h>

class CSoundMixdownEffect : public CLockable {
private:
    concurrency::concurrent_unordered_map<std::string, std::any> paramMap;
public:
    CSoundMixdownEffect() { };
    ~CSoundMixdownEffect()  { };
    virtual void process(short* samples, int sampleCount, int channels, const unsigned int speakerMask) = 0;
    void setParam(std::string paramName, std::any value) { paramMap[paramName] = value; };
    template <typename T>
    T getParam(std::string paramName) { return std::any_cast<T>(paramMap[paramName]); };
};
