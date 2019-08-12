#pragma once

#include "compat.h"
#include "Types.h"
#include "Macros.h"
#include "Log.h"
#include "IRpcFunction.h"

#include "IServer.h"
#include "Engine.h"

#include "TextMessage.h"

RPC_FUNCTION(stopRadioSpeaking) {

    CEngine::getInstance()->getClient()->localStopSpeaking(acre::Speaking::radio);

    return acre::Result::ok;
}
public:
    inline void setName(char *const value) final { m_Name = value; }
    inline char* getName() const final { return m_Name; }

protected:
    char* m_Name;
};
