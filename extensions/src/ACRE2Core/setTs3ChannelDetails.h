#pragma once

#include "IRpcFunction.h"
#include "Log.h"
#include "TextMessage.h"
#include "Engine.h"

#include <sstream>

RPC_FUNCTION(setTs3ChannelDetails) {
    const  std::vector<std::string> details = {
        std::string((char *)vMessage->getParameter(0)),
        std::string((char *)vMessage->getParameter(1)),
        std::string((char *)vMessage->getParameter(2))
    };

    CEngine::getInstance()->getClient()->updateTs3ChannelDetails(details);
    return acre::Result::ok;
}
public:
    inline void setName(char *const value) final { m_Name = value; }
    inline char* getName() const final { return m_Name; }

protected:
    char* m_Name;
};
