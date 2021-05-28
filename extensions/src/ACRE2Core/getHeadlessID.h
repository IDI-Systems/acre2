#pragma once
#include "Engine.h"
#include "IRpcFunction.h"
#include "IServer.h"
#include "Log.h"
#include "TextMessage.h"

RPC_FUNCTION(getHeadlessID) {
    const std::string netId{reinterpret_cast<const char *const>(vMessage->getParameter(0))};
    const std::string targetName{reinterpret_cast<const char *const>(vMessage->getParameter(1))};

    // try to get ID from the displayName by searching the clientList (0 indicates not found)
    const acre::id_t targetID = CEngine::getInstance()->getClient()->getClientIDByName(targetName);

    vServer->sendMessage(CTextMessage::formatNewMessage("handleGetHeadlessID", "%s,%s,%d,", netId.c_str(), targetName.c_str(), targetID));
    return acre::Result::ok;
}

public:
inline void setName(const char *const value) final {
    m_Name = value;
}
inline const char *getName() const final {
    return m_Name;
}

protected:
const char *m_Name;
};
