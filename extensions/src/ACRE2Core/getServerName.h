#pragma once
#include "IRpcFunction.h"
#include "IServer.h"
#include "TextMessage.h"
#include "Engine.h"

RPC_FUNCTION(getServerName) {

    vServer->sendMessage(CTextMessage::formatNewMessage("getServerName",
        "%s,",
        CEngine::getInstance()->getClient()->getUniqueId()
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