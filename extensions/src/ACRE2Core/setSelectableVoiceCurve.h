#pragma once
#include "IRpcFunction.h"
#include "Engine.h"
#include "TextMessage.h"
#include "Log.h"

#include <Tracy.hpp>

RPC_FUNCTION(setSelectableVoiceCurve) {
    ZoneScopedN("RPC - setSelectableVoiceCurve");

    const float32_t voiceCurveScale = vMessage->getParameterAsFloat(0);
    //LOG("VOICE MODEL: %d VOICE CURVE: %f", voiceModel, voiceCurveScale);
    if (!CEngine::getInstance()->getGameServer()->getConnected()) {
        return acre::Result::ok;
    }

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

    return acre::Result::ok;
}
public:
    inline void setName(const char *const value) final { m_Name = value; }
    inline const char* getName() const final { return m_Name; }

protected:
    const char* m_Name;
};
