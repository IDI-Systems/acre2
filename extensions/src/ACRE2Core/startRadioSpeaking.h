#pragma once

#include "compat.h"
#include "Types.h"
#include "Macros.h"
#include "Log.h"
#include "IRpcFunction.h"

#include "IServer.h"
#include "Engine.h"

#include "TextMessage.h"

#include <string>

RPC_FUNCTION(startRadioSpeaking) {

    std::string radioId = std::string((char *)vMessage->getParameter(0));

    CEngine::getInstance()->getClient()->localStartSpeaking(AcreSpeaking::radio, radioId);

    return AcreResult::ok;
}
DECLARE_MEMBER(char *, Name);
};
