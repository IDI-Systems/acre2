#pragma once
#include "IRpcFunction.h"
#include "Engine.h"
#include "TextMessage.h"
#include "Log.h"
#include "Types.h"

RPC_FUNCTION(setVoiceCurveModel) {
    int32_t voiceModel;
    float32_t voiceCurveScale;

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
