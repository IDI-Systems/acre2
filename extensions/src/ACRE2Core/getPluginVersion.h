#pragma once
#include "IRpcFunction.h"
#include "IServer.h"
#include "TextMessage.h"

RPC_FUNCTION(getPluginVersion) {

    vServer->sendMessage(CTextMessage::formatNewMessage("handleGetPluginVersion", "%s", ACRE_VERSION));

    return AcreResult::ok;
}
DECLARE_MEMBER(char *, Name);
};