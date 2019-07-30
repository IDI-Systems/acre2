#pragma once
#include "IRpcFunction.h"
#include "IServer.h"
#include "TextMessage.h"

RPC_FUNCTION(getPluginVersion) {

    vServer->sendMessage(CTextMessage::formatNewMessage("handleGetPluginVersion", "%s", ACRE_VERSION));

    return acre::Result::ok;
}
public:
    __inline void setName(char *const value) final { m_Name = value; }
    __inline char* getName() const final { return m_Name; }

protected:
    char* m_Name;
};
