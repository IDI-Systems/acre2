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

RPC_FUNCTION(stopRadioSpeaking) {
    
    CEngine::getInstance()->getClient()->localStopSpeaking(ACRE_SPEAKING_RADIO);

    return ACRE_OK;
}
DECLARE_MEMBER(char *, Name);
};