#pragma once

#include "IRpcFunction.h"
#include "Log.h"
#include "AcreSettings.h"

RPC_FUNCTION(setSetting) {
    const std::string name = std::string((char *)vMessage->getParameter(0));
    float32_t value = vMessage->getParameterAsFloat(1);
    value = round(value * 100.0f) / 100.0f;

    if (name == "globalVolume") {
        if (CAcreSettings::getInstance()->getGlobalVolume() != value) {
            CAcreSettings::getInstance()->setGlobalVolume(value);
        }
    } else if (name == "premixGlobalVolume") {
        if (CAcreSettings::getInstance()->getPremixGlobalVolume() != value) {
            CAcreSettings::getInstance()->setPremixGlobalVolume(value);
        }
    } else if (name == "disableUnmuteClients") {
        if (CAcreSettings::getInstance()->getDisableUnmuteClients() != (value != 1)) {
            CAcreSettings::getInstance()->setDisableUnmuteClients(value != 1);
        }
    } else if (name == "disableTS3ChannelSwitch") {
        if (CAcreSettings::getInstance()->getDisableTS3ChannelSwitch() != (value != 1)) {
            CAcreSettings::getInstance()->setDisableTS3ChannelSwitch(value != 1);
        }
    } else {
        LOG("Setting [%s] failed to change to [%f]", name.c_str(), value);
        return acre::Result::error;
    }

    LOG("Setting [%s] set to [%f]", name.c_str(), value);
    CAcreSettings::getInstance()->save();
    return acre::Result::ok;
}
public:
    __inline void setName(char *const value) final { m_Name = value; }
    __inline char* getName() const final { return m_Name; }

protected:
    char* m_Name;
};
