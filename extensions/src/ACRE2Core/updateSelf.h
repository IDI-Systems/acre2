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

#include <Tracy.hpp>

RPC_FUNCTION(updateSelf) {
    ZoneScopedN("RPC - updateSelf");

    LOCK(CEngine::getInstance()->getSelf());

    const acre::vec3_fp32_t listenerPos(vMessage->getParameterAsFloat(0), vMessage->getParameterAsFloat(2), vMessage->getParameterAsFloat(1));
    const acre::vec3_fp32_t listenerDir(vMessage->getParameterAsFloat(3), vMessage->getParameterAsFloat(5), vMessage->getParameterAsFloat(4));

    CEngine::getInstance()->getSelf()->setWorldPosition(listenerPos);
    CEngine::getInstance()->getSelf()->setHeadVector(listenerDir);
    CEngine::getInstance()->getSelf()->setCurrentLanguageId(vMessage->getParameterAsInt(6));

    UNLOCK(CEngine::getInstance()->getSelf());
    return acre::Result::ok;
}
public:
    inline void setName(const char *const value) final { m_Name = value; }
    inline const char* getName() const final { return m_Name; }

protected:
    const char* m_Name;
};
