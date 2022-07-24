#pragma once
#include "IRpcFunction.h"
#include "Engine.h"
#include "TextMessage.h"
#include "Log.h"

#include <Tracy.hpp>

RPC_FUNCTION(setVoiceCurveModel) {
    ZoneScopedN("RPC - setVoiceCurveModel");

    const acre::CurveModel voiceModel = static_cast<acre::CurveModel>(vMessage->getParameterAsInt(0));
    const float32_t voiceCurveScale = vMessage->getParameterAsFloat(1);

    if (!CEngine::getInstance()->getGameServer()->getConnected()) {
        return acre::Result::ok;
    }

    LOCK(CEngine::getInstance()->getSelf());
    CEngine::getInstance()->getSelf()->setCurveModel(voiceModel);
    CEngine::getInstance()->getSoundEngine()->setCurveModel(voiceModel);
    //CEngine::getInstance()->getSelf()->setSelectableCurveScale(voiceCurveScale);
    UNLOCK(CEngine::getInstance()->getSelf());

    return acre::Result::ok;
}
public:
    inline void setName(const char *const value) final { m_Name = value; }
    inline const char* getName() const final { return m_Name; }

protected:
    const char* m_Name;
};
