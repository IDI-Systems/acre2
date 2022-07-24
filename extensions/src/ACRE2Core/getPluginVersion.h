#pragma once
#include "IRpcFunction.h"
#include "IServer.h"
#include "TextMessage.h"

#include <Tracy.hpp>

RPC_FUNCTION(getPluginVersion) {
    ZoneScopedN("RPC - getPluginVersion");

    vServer->sendMessage(CTextMessage::formatNewMessage("handleGetPluginVersion", "%s", ACRE_VERSION));

    return acre::Result::ok;
}
public:
    inline void setName(const char *const value) final { m_Name = value; }
    inline const char* getName() const final { return m_Name; }

protected:
    const char* m_Name;
};
