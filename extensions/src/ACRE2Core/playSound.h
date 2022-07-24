#pragma once

#include "compat.h"
#include "Types.h"
#include "Macros.h"
#include "Log.h"
#include "IRpcFunction.h"

#include "IServer.h"
#include "Engine.h"

#include "TextMessage.h"

#include <Tracy.hpp>

RPC_FUNCTION(playLoadedSound) {
    ZoneScopedN("RPC - playLoadedSound");

    const std::string id = std::string((char *)vMessage->getParameter(0));
    const acre::vec3_fp32_t position(vMessage->getParameterAsFloat(1), vMessage->getParameterAsFloat(3), vMessage->getParameterAsFloat(2));
    const acre::vec3_fp32_t direction(vMessage->getParameterAsFloat(4), vMessage->getParameterAsFloat(6), vMessage->getParameterAsFloat(5));
    const float32_t volume = vMessage->getParameterAsFloat(7);
    const bool isWorld = vMessage->getParameterAsInt(8) == 1;

    const acre::Result res = CEngine::getInstance()->getSoundPlayback()->playSound(id, position, direction, volume, isWorld);
    if (res == acre::Result::error) {
        vServer->sendMessage(CTextMessage::formatNewMessage("handleSoundError", "%s,", id.c_str()));
    }

    return acre::Result::ok;
}
public:
    inline void setName(const char *const value) final { m_Name = value; }
    inline const char* getName() const final { return m_Name; }

protected:
    const char* m_Name;
};
