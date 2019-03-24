#pragma once

#include "compat.h"
#include "Types.h"
#include "Macros.h"
#include "Log.h"
#include "IRpcFunction.h"

#include "IServer.h"
#include "Engine.h"

#include "TextMessage.h"

RPC_FUNCTION(loadSound) {

    std::string id;
    int currentCount, totalCount;
    std::string content;


    id = std::string((char *)vMessage->getParameter(0));
    currentCount = vMessage->getParameterAsInt(1);
    totalCount = vMessage->getParameterAsInt(2);

    content = std::string((char *)vMessage->getParameter(3));
    //LOG("BUILDING SOUND %s PART %d of %d", id.c_str(), currentCount, totalCount);
    if (content != "") {
        CEngine::getInstance()->getSoundPlayback()->buildSound(id, content);
    } else {
        acre_result_t ret = CEngine::getInstance()->getSoundPlayback()->loadSound(id);
        if (ret == acre_result_ok) {
            vServer->sendMessage(CTextMessage::formatNewMessage("handleLoadedSound", "%s,%s", id.c_str(), "1"));
        } else {
            vServer->sendMessage(CTextMessage::formatNewMessage("handleLoadedSound", "%s,%s", id.c_str(), "0"));
        }
    }

    return acre_result_ok;
}
DECLARE_MEMBER(char *, Name);
};