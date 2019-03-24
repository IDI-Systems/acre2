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

    acre_id_t id = (acre_id_t)vMessage->getParameterAsInt(0);
    int languageId = (acre_id_t)vMessage->getParameterAsInt(1);
    std::string netId = std::string((char *)vMessage->getParameter(2));
    
    acre_speaking_t speakingType = (acre_speaking_t)vMessage->getParameterAsInt(3);
    std::string radio_id = std::string((char *)vMessage->getParameter(4));
    acre_volume_t curveScale = vMessage->getParameterAsFloat(5);

    CEngine::getInstance()->remoteStartSpeaking(id, languageId, netId, speakingType, radio_id, curveScale);

    return acre_result_ok;
}
DECLARE_MEMBER(char *, Name);
};