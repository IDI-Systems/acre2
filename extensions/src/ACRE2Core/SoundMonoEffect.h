#pragma once

#include "compat.h"
#include "Lockable.h"
#include <string>
#include <map>
#include <concurrent_unordered_map.h>
#include "Types.h"

class CSoundMonoEffect : public CLockable {
private:
    concurrency::concurrent_unordered_map<std::string, float32_t> m_paramMap;
public:
    CSoundMonoEffect() { };
    ~CSoundMonoEffect() { };
    virtual void process(int16_t *const a_samples, const int32_t ac_sampleCount) = 0;
    void setParam(const std::string &ac_paramName, const float32_t ac_value) { m_paramMap[ac_paramName] = ac_value; };
    float32_t getParam(const std::string &ac_paramName) {
        if (m_paramMap.find(ac_paramName) != m_paramMap.end()) {
            return m_paramMap[ac_paramName];
        } else {
            return 0.0f;
        }
    };
};
