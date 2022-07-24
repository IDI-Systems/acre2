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

RPC_FUNCTION(localMute) {
    ZoneScopedN("RPC - localMute");

    const bool status = vMessage->getParameterAsInt(0) == 1;

    if (status) {
        CEngine::getInstance()->getClient()->enableMicrophone(false);
        if (CEngine::getInstance()->getSelf()->getSpeaking()) {
            CEngine::getInstance()->getClient()->localStopSpeaking(acre::Speaking::unknown);
        }
    } else {
        CEngine::getInstance()->getClient()->enableMicrophone(true);
    }


    return acre::Result::ok;
}
public:
    inline void setName(const char *const value) final { m_Name = value; }
    inline const char* getName() const final { return m_Name; }

protected:
    const char* m_Name;
};
