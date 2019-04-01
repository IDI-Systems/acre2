#pragma once

#include "compat.h"
#include "Types.h"
#include "Macros.h"
#include "Log.h"
#include "IRpcFunction.h"
#include "Player.h"

#include "IServer.h"
#include "Engine.h"

#include "TextMessage.h"

RPC_FUNCTION(updateSelf) {

    LOCK(CEngine::getInstance()->getSelf());

    ACRE_VECTOR listenerPos;
    listenerPos.x = vMessage->getParameterAsFloat(0);
    listenerPos.z = vMessage->getParameterAsFloat(1);
    listenerPos.y = vMessage->getParameterAsFloat(2);

    CEngine::getInstance()->getSelf()->setWorldPosition(listenerPos);

    ACRE_VECTOR listenerDir;
    listenerDir.x = vMessage->getParameterAsFloat(3);
    listenerDir.z = vMessage->getParameterAsFloat(4);
    listenerDir.y = vMessage->getParameterAsFloat(5);

    CEngine::getInstance()->getSelf()->setHeadVector(listenerDir);

    CEngine::getInstance()->getSelf()->setCurrentLanguageId(vMessage->getParameterAsInt(6));

    UNLOCK(CEngine::getInstance()->getSelf());
    return AcreResult::ok;
}
DECLARE_MEMBER(char *, Name);
};