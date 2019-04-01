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

    acre_id_t id = (acre_id_t)vMessage->getParameterAsInt(0);

    CEngine::getInstance()->remoteStopSpeaking(id);

    return AcreResult::ok;
}
DECLARE_MEMBER(char *, Name);
};