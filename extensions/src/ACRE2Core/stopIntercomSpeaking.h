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

RPC_FUNCTION(stopIntercomSpeaking) {

    CEngine::getInstance()->getClient()->localStopSpeaking(AcreSpeaking::intercom);

    return AcreResult::ok;
}
DECLARE_MEMBER(char *, Name);
};
