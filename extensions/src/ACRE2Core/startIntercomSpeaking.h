#pragma once

#include "compat.h"
#include "Types.h"
#include "Macros.h"
#include "Log.h"
#include "IRpcFunction.h"

#include "IServer.h"
#include "Engine.h"

#include "TextMessage.h"

RPC_FUNCTION(startIntercomSpeaking) {

    CEngine::getInstance()->getClient()->localStartSpeaking(AcreSpeaking::intercom);

    return AcreResult::ok;
}
DECLARE_MEMBER(char *, Name);
};
