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

RPC_FUNCTION(loadSound) {
    ZoneScopedN("RPC - loadSound");

    const std::string id = std::string((char *)vMessage->getParameter(0));
    const int32_t currentCount = vMessage->getParameterAsInt(1);
    const int32_t totalCount = vMessage->getParameterAsInt(2);

    const std::string content = std::string((char *)vMessage->getParameter(3));
    //LOG("BUILDING SOUND %s PART %d of %d", id.c_str(), currentCount, totalCount);
    if (content != "") {
        CEngine::getInstance()->getSoundPlayback()->buildSound(id, content);
    } else {
        const acre::Result ret = CEngine::getInstance()->getSoundPlayback()->loadSound(id);
        if (ret == acre::Result::ok) {
            vServer->sendMessage(CTextMessage::formatNewMessage("handleLoadedSound", "%s,%s", id.c_str(), "1"));
        } else {
            vServer->sendMessage(CTextMessage::formatNewMessage("handleLoadedSound", "%s,%s", id.c_str(), "0"));
        }
    }

    return acre::Result::ok;
}
public:
    inline void setName(const char *const value) final { m_Name = value; }
    inline const char* getName() const final { return m_Name; }

protected:
    const char* m_Name;
};
