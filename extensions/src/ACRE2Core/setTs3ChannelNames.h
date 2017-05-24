#pragma once

#include "IRpcFunction.h"
#include "Log.h"
#include "TextMessage.h"
#include "Engine.h"

#include <sstream>

RPC_FUNCTION(setTs3ChannelNames) {
    std::vector<std::string> names = {
        std::string((char *)vMessage->getParameter(0)),
        std::string((char *)vMessage->getParameter(1))
    };

    CEngine::getInstance()->getClient()->updateTs3ChannelNames(names);
    return ACRE_OK;
}
DECLARE_MEMBER(char *, Name);
};
