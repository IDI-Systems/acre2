#pragma once

#include "compat.h"
#include "Types.h"
#include "Macros.h"
#include "Log.h"
#include "IRpcFunction.h"

#include "IServer.h"
#include "Engine.h"

#include "TextMessage.h"

RPC_FUNCTION(ext_handleGetClientID) {
    CEngine::getInstance()->getGameServer()->sendMessage(
        CTextMessage::formatNewMessage("handleGetClientID", 
            "%d,%s,", 
            vMessage->getParameterAsInt(0), 
            vMessage->getParameter(1)
        )
    );
    return AcreResult::ok;
}
DECLARE_MEMBER(char *, Name);
};