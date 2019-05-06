#pragma once
#include "IRpcFunction.h"
#include "Engine.h"
#include "TextMessage.h"
#include "Log.h"

RPC_FUNCTION(setVoiceCurveModel) {
    AcreCurveModel voiceModel;
    float voiceCurveScale;

    voiceModel = static_cast<AcreCurveModel>(vMessage->getParameterAsInt(0));
    voiceCurveScale = vMessage->getParameterAsFloat(1);

    if (!CEngine::getInstance()->getGameServer()->getConnected())
        return AcreResult::ok;

    LOCK(CEngine::getInstance()->getSelf());
    CEngine::getInstance()->getSelf()->setCurveModel(voiceModel);
    CEngine::getInstance()->getSoundEngine()->setCurveModel(voiceModel);
    //CEngine::getInstance()->getSelf()->setSelectableCurveScale(voiceCurveScale);
    UNLOCK(CEngine::getInstance()->getSelf());

    return AcreResult::ok;
}
DECLARE_MEMBER(char *, Name);
};
