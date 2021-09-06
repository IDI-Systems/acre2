#pragma once

#include "compat.h"
#include "Lockable.h"
#include <string>
#include <map>
#include <any>
#include <concurrent_unordered_map.h>

class CSoundMonoEffect : public CLockable {
private:
    concurrency::concurrent_unordered_map<std::string, std::any> paramMap;
public:
    CSoundMonoEffect() { };
    ~CSoundMonoEffect() { };
    virtual void process(short *samples, int sampleCount) = 0;
    void setParam(std::string paramName, std::any value) { paramMap[paramName] = value; };
    template <typename T>
    T getParam(std::string paramName) {
        if (paramMap.find(paramName) != paramMap.end()) {
            return std::any_cast<T>(paramMap[paramName]);
        } else {
            return T();
        }
    };
};
