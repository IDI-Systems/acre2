#pragma once

#include "IRpcFunction.h"
#include "Log.h"
#include "TextMessage.h"
#include "Engine.h"

#include <sstream>

RPC_FUNCTION(setTs3ChannelDetails) {
    std::vector<std::string> details = {
        std::string((char *)vMessage->getParameter(0)),
        std::string((char *)vMessage->getParameter(1)),
        std::string((char *)vMessage->getParameter(2))
    };

    CEngine::getInstance()->getClient()->updateTs3ChannelDetails(details);
    return acre_result_ok;
}
DECLARE_MEMBER(char *, Name);
};
