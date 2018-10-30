#pragma once

#include "compat.h"
#include "Types.h"
#include "Macros.h"
#include "Log.h"
#include "IRpcFunction.h"

#include "IServer.h"
#include "Engine.h"

#include "TextMessage.h"

RPC_FUNCTION(ext_remoteStartSpeaking) {

    /*CTextMessage::formatNewMessage("ext_remoteStartSpeaking", 
            "%d,%d,%s,%f,",
            this->getSelf()->getId(),
            this->getSelf()->getCurrentSpeakingType(),
            this->getSelf()->getCurrentRadioId().c_str(),
            this->getSelf()->getCurveScale()
        ) */

    ACRE_ID id = (ACRE_ID)vMessage->getParameterAsInt(0);
    int32_t languageId = (ACRE_ID)vMessage->getParameterAsInt(1);
    std::string netId = std::string((const char *)vMessage->getParameter(2));
    
    ACRE_SPEAKING_TYPE speakingType = (ACRE_SPEAKING_TYPE)vMessage->getParameterAsInt(3);
    std::string radio_id = std::string((const char *)vMessage->getParameter(4));
    ACRE_VOLUME curveScale = vMessage->getParameterAsFloat(5);

    CEngine::getInstance()->remoteStartSpeaking(id, languageId, netId, speakingType, radio_id, curveScale);

    return ACRE_OK;
}
DECLARE_MEMBER(char *, Name);
};
