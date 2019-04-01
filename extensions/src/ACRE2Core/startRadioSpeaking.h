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

    CEngine::getInstance()->getClient()->localStartSpeaking(acre_speaking_radio, radioId);

    return acre_result_ok;
}
DECLARE_MEMBER(char *, Name);
};
