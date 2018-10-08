#pragma once

#include "compat.h"
#include "Lockable.h"
#include <string>
#include <map>
#include <concurrent_unordered_map.h>
#include "Types.h"

class CSoundMixdownEffect : public CLockable {
private:
    concurrency::concurrent_unordered_map<std::string, float32_t> m_paramMap;
public:
    CSoundMixdownEffect() { };
    ~CSoundMixdownEffect()  { };
    virtual void process(int16_t *const samples, const int32_t sampleCount, const int32_t channels, const uint32_t speakerMask) = 0;
    void setParam(const std::string &paramName, const float32_t value) { m_paramMap[paramName] = value; };
    float32_t getParam(const std::string &paramName) { return m_paramMap[paramName]; };
};
