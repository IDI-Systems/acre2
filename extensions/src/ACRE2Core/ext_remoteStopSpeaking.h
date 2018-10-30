#pragma once

#include "compat.h"
#include "Types.h"
#include "Macros.h"
#include "Log.h"
#include "IRpcFunction.h"

#include "IServer.h"
#include "Engine.h"

#include "TextMessage.h"

RPC_FUNCTION(ext_remoteStopSpeaking) {

    /*CTextMessage::formatNewMessage("ext_remoteStartSpeaking", 
            "%d,%d,%s,%f,",
            this->getSelf()->getId(),
            this->getSelf()->getCurrentSpeakingType(),
            this->getSelf()->getCurrentRadioId().c_str(),
            this->getSelf()->getCurveScale()
        ) */

    ACRE_ID id = (ACRE_ID) vMessage->getParameterAsInt(0);

    CEngine::getInstance()->remoteStopSpeaking(id);

    return ACRE_OK;
}
DECLARE_MEMBER(char *, Name);
};
