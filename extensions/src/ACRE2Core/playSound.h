#pragma once

#include "compat.h"
#include "Types.h"
#include "Macros.h"
#include "Log.h"
#include "IRpcFunction.h"

#include "IServer.h"
#include "Engine.h"

#include "TextMessage.h"

RPC_FUNCTION(playLoadedSound) {

    std::string id;
    ACRE_VECTOR position, direction;
    float volume;
    int32_t isWorld = 0;


    id = std::string((char *)vMessage->getParameter(0));
    position.x = vMessage->getParameterAsFloat(1);
    position.z = vMessage->getParameterAsFloat(2);
    position.y = vMessage->getParameterAsFloat(3);

    direction.x = vMessage->getParameterAsFloat(4);
    direction.z = vMessage->getParameterAsFloat(5);
    direction.y = vMessage->getParameterAsFloat(6);


    volume = vMessage->getParameterAsFloat(7);

    isWorld = vMessage->getParameterAsInt(8);

    ACRE_RESULT res = CEngine::getInstance()->getSoundPlayback()->playSound(id, position, direction, volume, isWorld == 1);
    if(res == ACRE_ERROR) {
        vServer->sendMessage(CTextMessage::formatNewMessage("handleSoundError", "%s,", id.c_str()));
    }

    return ACRE_OK;
}
DECLARE_MEMBER(char *, Name);
};