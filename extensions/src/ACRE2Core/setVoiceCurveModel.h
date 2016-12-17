#pragma once
#include "IRpcFunction.h"
#include "Engine.h"
#include "TextMessage.h"
#include "Log.h"

RPC_FUNCTION(setVoiceCurveModel) {
    int voiceModel;
    float voiceCurveScale;

    voiceModel = vMessage->getParameterAsInt(0);
    voiceCurveScale = vMessage->getParameterAsFloat(1);

    if (!CEngine::getInstance()->getGameServer()->getConnected())
        return ACRE_OK;

    LOCK(CEngine::getInstance()->getSelf());
    CEngine::getInstance()->getSelf()->setCurveModel(voiceModel);
    CEngine::getInstance()->getSoundEngine()->setCurveModel(voiceModel);
    //CEngine::getInstance()->getSelf()->setSelectableCurveScale(voiceCurveScale);
    UNLOCK(CEngine::getInstance()->getSelf());

    return ACRE_OK;
}
DECLARE_MEMBER(char *, Name);
};