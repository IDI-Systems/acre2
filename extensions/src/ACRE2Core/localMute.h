#pragma once

#include "compat.h"
#include "Types.h"
#include "Macros.h"
#include "Log.h"
#include "IRpcFunction.h"

#include "IServer.h"
#include "Engine.h"

#include "TextMessage.h"

RPC_FUNCTION(localMute) {

    int status;

    status = vMessage->getParameterAsInt(0);

    if (status == 1) {
        CEngine::getInstance()->getClient()->enableMicrophone(false);
        if (CEngine::getInstance()->getSelf()->getSpeaking()) {
            CEngine::getInstance()->getClient()->localStopSpeaking(acre_speaking_unknown);
        }
    } else {
        CEngine::getInstance()->getClient()->enableMicrophone(true);
    }


    return acre_result_ok;
}
DECLARE_MEMBER(char *, Name);
};