#pragma once

#include "IRpcFunction.h"
#include "Log.h"
#include "TextMessage.h"
#include "Engine.h"

#include <sstream>

#include <Tracy.hpp>

RPC_FUNCTION(setChannelDetails) {
    ZoneScopedN("RPC - setChannelDetails");

    const  std::vector<std::string> details = {
        std::string((char *)vMessage->getParameter(0)),
        std::string((char *)vMessage->getParameter(1)),
        std::string((char *)vMessage->getParameter(2))
    };

    CEngine::getInstance()->getClient()->updateChannelDetails(details);
    return acre::Result::ok;
}
public:
    inline void setName(const char *const value) final { m_Name = value; }
    inline const char* getName() const final { return m_Name; }

protected:
    const char* m_Name;
};
