#pragma once

#include "compat.h"
#include "Types.h"
#include "Macros.h"
#include "Log.h"
#include "IRpcFunction.h"

#include "IServer.h"
#include "Engine.h"

#include "TextMessage.h"

#include <string>

#include <Tracy.hpp>

RPC_FUNCTION(startRadioSpeaking) {
    ZoneScopedN("RPC - startRadioSpeaking");

    const std::string radioId = std::string((char *)vMessage->getParameter(0));

    CEngine::getInstance()->getClient()->localStartSpeaking(acre::Speaking::radio, radioId);

    return acre::Result::ok;
}
public:
    inline void setName(const char *const value) final { m_Name = value; }
    inline const char* getName() const final { return m_Name; }

protected:
    const char* m_Name;
};
