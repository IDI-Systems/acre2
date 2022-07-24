#pragma once
#include "IRpcFunction.h"
#include "Engine.h"
#include "TextMessage.h"
#include "Log.h"

#include <Tracy.hpp>

RPC_FUNCTION(setPTTKeys) {
    ZoneScopedN("RPC - setPTTKeys");

    /*
    CEngine::getInstance()->getKeyHandlerEngine()->setKeyBind(
        std::string((char *)vMessage->getParameter(0)),
        vMessage->getParameterAsInt(1),
        vMessage->getParameterAsInt(2) ? 1 : 0,
        vMessage->getParameterAsInt(3) ? 1 : 0,
        vMessage->getParameterAsInt(4) ? 1 : 0
        );

        */

    return acre::Result::ok;
}
public:
    inline void setName(const char *const value) final { m_Name = value; }
    inline const char* getName() const final { return m_Name; }

protected:
    const char* m_Name;
};
