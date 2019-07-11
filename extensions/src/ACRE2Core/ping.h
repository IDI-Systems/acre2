#pragma once
#include "IRpcFunction.h"
#include "Log.h"
#include <time.h>

#include "IServer.h"
#include "Engine.h"
#include "TextMessage.h"

volatile DWORD g_pingTime;

RPC_FUNCTION(ping) {
    g_pingTime = clock() / CLOCKS_PER_SEC;
    vServer->sendMessage(CTextMessage::formatNewMessage("pong", "%f,", g_pingTime));
    return acre::Result::ok;
}
public:
    __inline void setName(char *const value) final { m_Name = value; }
    __inline char* getName() const final { return m_Name; }

protected:
    char* m_Name;
};
