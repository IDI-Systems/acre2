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

    const std::string id = std::string((char *)vMessage->getParameter(0));
    const acre::Vector3<float32_t> position(vMessage->getParameterAsFloat(1), vMessage->getParameterAsFloat(3), vMessage->getParameterAsFloat(2));
    const acre::Vector3<float32_t> direction(vMessage->getParameterAsFloat(4), vMessage->getParameterAsFloat(6), vMessage->getParameterAsFloat(5));
    const float32_t volume = vMessage->getParameterAsFloat(7);
    const bool isWorld = vMessage->getParameterAsInt(8) == 1;

    const acre::Result res = CEngine::getInstance()->getSoundPlayback()->playSound(id, position, direction, volume, isWorld);
    if (res == acre::Result::error) {
        vServer->sendMessage(CTextMessage::formatNewMessage("handleSoundError", "%s,", id.c_str()));
    }

    return acre::Result::ok;
}
public:
    __inline void setName(char *const value) final { m_Name = value; }
    __inline char* getName() const final { return m_Name; }

protected:
    char* m_Name;
};
