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

    const acre::Vector3_t listenerPos(vMessage->getParameterAsFloat(0), vMessage->getParameterAsFloat(1), vMessage->getParameterAsFloat(2));
    const acre::Vector3_t listenerDir(vMessage->getParameterAsFloat(3), vMessage->getParameterAsFloat(4), vMessage->getParameterAsFloat(5));

    CEngine::getInstance()->getSelf()->setWorldPosition(listenerPos);
    CEngine::getInstance()->getSelf()->setHeadVector(listenerDir);
    CEngine::getInstance()->getSelf()->setCurrentLanguageId(vMessage->getParameterAsInt(6));

    UNLOCK(CEngine::getInstance()->getSelf());
    return acre::Result::ok;
}
public:
    __inline void setName(char *const value) final { m_Name = value; }
    __inline char* getName() const final { return m_Name; }

protected:
    char* m_Name;
};
