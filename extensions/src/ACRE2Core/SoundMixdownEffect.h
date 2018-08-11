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
    virtual void process(int16_t *const a_samples, const int32_t ac_sampleCount, const int32_t ac_channels, const uint32_t ac_speakerMask) = 0;
    void setParam(const std::string &ac_paramName, const float32_t ac_value) { m_paramMap[ac_paramName] = ac_value; };
    float32_t getParam(const std::string &ac_paramName) { return m_paramMap[ac_paramName]; };
};
