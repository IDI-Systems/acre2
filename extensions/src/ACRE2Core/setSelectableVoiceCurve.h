#pragma once
#include "IRpcFunction.h"
#include "Engine.h"
#include "TextMessage.h"
#include "Log.h"
#include "Types.h"

RPC_FUNCTION(setSelectableVoiceCurve) {
    float32_t voiceCurveScale;

    voiceCurveScale = vMessage->getParameterAsFloat(0);
    //LOG("VOICE MODEL: %d VOICE CURVE: %f", voiceModel, voiceCurveScale);
    if (!CEngine::getInstance()->getGameServer()->getConnected())
        return ACRE_OK;

    if (CEngine::getInstance()->getSelf()) {
        LOCK(CEngine::getInstance()->getSelf());
        CEngine::getInstance()->getSelf()->setSelectableCurveScale(voiceCurveScale);
        if (CEngine::getInstance()->getSelf()->getSpeaking()) {
            CEngine::getInstance()->getExternalServer()->sendMessage(
                CTextMessage::formatNewMessage("ext_remoteStartSpeaking", 
                    "%d,%d,%s,%d,%s,%f,",
                    CEngine::getInstance()->getSelf()->getId(),
                    CEngine::getInstance()->getSelf()->getCurrentLanguageId(),
                    CEngine::getInstance()->getSelf()->getNetId().c_str(),
                    CEngine::getInstance()->getSelf()->getSpeakingType(),
                    CEngine::getInstance()->getSelf()->getCurrentRadioId().c_str(),
                    CEngine::getInstance()->getSelf()->getSelectableCurveScale()
                ) 
            );
        }
        UNLOCK(CEngine::getInstance()->getSelf());
    }

    return ACRE_OK;
}
DECLARE_MEMBER(char *, Name);
};
