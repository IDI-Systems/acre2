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

RPC_FUNCTION(startZeusSpeaking) {
    ZoneScopedN("RPC - startZeusSpeaking");

    CEngine::getInstance()->getClient()->localStartSpeaking(acre::Speaking::zeus);

    return acre::Result::ok;
}
public:
    inline void setName(const char *const value) final { m_Name = value; }
    inline const char* getName() const final { return m_Name; }

protected:
    const char* m_Name;
};
