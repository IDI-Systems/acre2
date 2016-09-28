#pragma once

#include "IRpcFunction.h"
#include "Log.h"
#include "AcreSettings.h"

RPC_FUNCTION(setSetting) {
    std::string name;
    float value = 1.0f;

    name = std::string((char *)vMessage->getParameter(0));
    value = vMessage->getParameterAsFloat(1);
    value = round(value * 100) / 100;

    if (name == "globalVolume") {
        if (CAcreSettings::getInstance()->getGlobalVolume() != value) {
            CAcreSettings::getInstance()->setGlobalVolume(value);
        }
    }
    else if (name == "premixGlobalVolume") {
        if (CAcreSettings::getInstance()->getPremixGlobalVolume() != value) {
            CAcreSettings::getInstance()->setPremixGlobalVolume(value);
        }
    }
    else if (name == "disableUnmuteClients") {
        if (CAcreSettings::getInstance()->getDisableUnmuteClients() != (value != 1)) {
            CAcreSettings::getInstance()->setDisableUnmuteClients(value != 1);
        }
    }
    else {
        LOG("Setting [%s] failed to change to [%f]", name.c_str(), value);
        return ACRE_ERROR;
    }

    LOG("Setting [%s] set to [%f]", name.c_str(), value);
    CAcreSettings::getInstance()->save();
    return ACRE_OK;
}
DECLARE_MEMBER(char *, Name);
};
