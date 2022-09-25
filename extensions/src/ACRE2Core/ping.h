#pragma once
#include "IRpcFunction.h"
#include "Log.h"
#include <time.h>

#include "IServer.h"
#include "Engine.h"
#include "TextMessage.h"

volatile DWORD g_pingTime;

RPC_FUNCTION(ping) {
#ifdef WIN32
    g_pingTime = clock() / CLOCKS_PER_SEC;
#else
    timespec t;
    clock_gettime(CLOCK_MONOTONIC_RAW, &t);
    g_pingTime = t.tv_sec;
#endif
    vServer->sendMessage(CTextMessage::formatNewMessage("pong", "%f,", (float) g_pingTime));
    return acre::Result::ok;
}
public:
    inline void setName(const char *const value) final { m_Name = value; }
    inline const char* getName() const final { return m_Name; }

protected:
    const char* m_Name;
};
