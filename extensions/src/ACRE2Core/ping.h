#pragma once
#include "IRpcFunction.h"
#include "Log.h"
#include <time.h>

#include "IServer.h"
#include "Engine.h"
#include "TextMessage.h"

volatile uint32_t g_pingTime;

RPC_FUNCTION(ping) {
    g_pingTime = clock() / CLOCKS_PER_SEC;
    vServer->sendMessage(CTextMessage::formatNewMessage("pong", "%f,", g_pingTime));
    return ACRE_OK;
}
DECLARE_MEMBER(char *, Name);
};