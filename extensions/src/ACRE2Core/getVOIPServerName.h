#pragma once

#include "IRpcFunction.h"
#include "IServer.h"
#include "TextMessage.h"
#include "Engine.h"

#include <string>

RPC_FUNCTION(getVOIPServerName) {
    std::string id = CEngine::getInstance()->getClient()->getServerName();
    vServer->sendMessage(CTextMessage::formatNewMessage("handleGetVOIPServerName", "%s", id.c_str()));
    return acre::Result::ok;
}
public:
    inline void setName(const char *const value) final { m_Name = value; }
    inline const char* getName() const final { return m_Name; }

protected:
    const char* m_Name;
};
