#pragma once

#include "compat.h"
#include "Types.h"
#include "Macros.h"
#include "Log.h"
#include "IRpcFunction.h"

#include "IServer.h"
#include "Engine.h"

#include "TextMessage.h"

#include <Tracy.hpp>

RPC_FUNCTION(ext_handleGetClientID) {
    ZoneScopedN("RPC - ext_handleGetClientID");

    CEngine::getInstance()->getGameServer()->sendMessage(
        CTextMessage::formatNewMessage("handleGetClientID",
            "%d,%s,",
            vMessage->getParameterAsInt(0),
            vMessage->getParameter(1)
        )
    );
    return acre::Result::ok;
}
public:
    inline void setName(const char *const value) final { m_Name = value; }
    inline const char* getName() const final { return m_Name; }

protected:
    const char* m_Name;
};
