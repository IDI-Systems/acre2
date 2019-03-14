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

    CEngine::getInstance()->getClient()->localStartSpeaking(acre_speaking_intercom);

    return acre_result_ok;
}
DECLARE_MEMBER(char *, Name);
};
