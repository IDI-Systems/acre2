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
    virtual void process(int16_t *const samples, const int32_t sampleCount) = 0;
    void setParam(const std::string &paramName, const float32_t value) { m_paramMap[paramName] = value; };
    float32_t getParam(const std::string &paramName) {
        if (m_paramMap.find(paramName) != m_paramMap.end()) {
            return m_paramMap[paramName];
        } else {
            return 0.0f;
        }
    };
};
