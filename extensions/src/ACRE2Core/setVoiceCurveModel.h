#pragma once
#include "IRpcFunction.h"
#include "Engine.h"
#include "TextMessage.h"
#include "Log.h"

RPC_FUNCTION(setVoiceCurveModel) {
    acre_curveModel_t voiceModel;
    float voiceCurveScale;

    voiceModel = static_cast<acre_curveModel_t>(vMessage->getParameterAsInt(0));
    voiceCurveScale = vMessage->getParameterAsFloat(1);

    if (!CEngine::getInstance()->getGameServer()->getConnected())
        return acre_result_ok;

    LOCK(CEngine::getInstance()->getSelf());
    CEngine::getInstance()->getSelf()->setCurveModel(voiceModel);
    CEngine::getInstance()->getSoundEngine()->setCurveModel(voiceModel);
    //CEngine::getInstance()->getSelf()->setSelectableCurveScale(voiceCurveScale);
    UNLOCK(CEngine::getInstance()->getSelf());

    return acre_result_ok;
}
DECLARE_MEMBER(char *, Name);
};
