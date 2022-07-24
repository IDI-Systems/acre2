#pragma once
#include "IRpcFunction.h"
#include "Log.h"
#include <time.h>

#include "IServer.h"
#include "Engine.h"
#include "TextMessage.h"

#include <Tracy.hpp>

volatile DWORD g_pingTime;

RPC_FUNCTION(ping) {
    ZoneScopedN("RPC - ping");

    g_pingTime = clock() / CLOCKS_PER_SEC;
    vServer->sendMessage(CTextMessage::formatNewMessage("pong", "%f,", g_pingTime));
    return acre::Result::ok;
}
public:
    inline void setName(const char *const value) final { m_Name = value; }
    inline const char* getName() const final { return m_Name; }

protected:
    const char* m_Name;
};
