#pragma once

#include "compat.h"
#include "Types.h"
#include "Macros.h"
#include "Log.h"
#include "IRpcFunction.h"
#include <sddl.h>

#include "IServer.h"
#include "Engine.h"

#include "TextMessage.h"

RPC_FUNCTION(getClientID) {

    TRACE("enter");

    LOCK(CEngine::getInstance()->getSelf());
    CEngine::getInstance()->getSelf()->setNetId(std::string((char *)vMessage->getParameter(0)));
    CEngine::getInstance()->getExternalServer()->sendMessage(
        CTextMessage::formatNewMessage("ext_handleGetClientID",
            "%d,%s,",
            CEngine::getInstance()->getSelf()->getId(),
            CEngine::getInstance()->getSelf()->getNetId().c_str()
        )
    );
    vServer->sendMessage(CTextMessage::formatNewMessage("handleGetClientID", "%d,%s,", CEngine::getInstance()->getSelf()->getId(), CEngine::getInstance()->getSelf()->getNetId().c_str()));

    UNLOCK(CEngine::getInstance()->getSelf());

    return ACRE_OK;
}
DECLARE_MEMBER(char *, Name);
};
