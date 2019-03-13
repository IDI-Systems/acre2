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
    return acre_result_ok;
}
DECLARE_MEMBER(char *, Name);
};