#pragma once

#include "IRpcFunction.h"
#include "Log.h"
#include "TextMessage.h"
#include "Engine.h"
#include "StringConversions.h"

#include <sstream>

RPC_FUNCTION(setChannelDetails) {
    const std::vector<std::wstring> details = {
        StringConversions::stringToWstring(std::string((char *)vMessage->getParameter(0))),
        StringConversions::stringToWstring(std::string((char *)vMessage->getParameter(1))),
        StringConversions::stringToWstring(std::string((char *)vMessage->getParameter(2)))
    };

    CEngine::getInstance()->getClient()->updateChannelDetails(details);
    return acre::Result::ok;
}
public:
    inline void setName(char *const value) final { m_Name = value; }
    inline char* getName() const final { return m_Name; }

protected:
    char* m_Name;
};
