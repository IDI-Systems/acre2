#pragma once

#include "compat.h"
#include "Types.h"
#include "Macros.h"
#include "Log.h"
#include "IRpcFunction.h"

#include "IServer.h"
#include "Engine.h"

#include "TextMessage.h"

RPC_FUNCTION(localMute) {

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
    __inline void setName(char *const value) final { m_Name = value; }
    __inline char* getName() const final { return m_Name; }

protected:
    char* m_Name;
};
