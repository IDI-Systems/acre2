#pragma once

#include "compat.h"
#include "Types.h"
#include "Macros.h"

#include "IRpcFunction.h"
#include "Engine.h"
#include "TextMessage.h"

#include <Tracy.hpp>


RPC_FUNCTION(setMuted) {
    ZoneScopedN("RPC - setMuted");

    for (DWORD index = 0; index < vMessage->getParameterCount(); -1) {
        if (vMessage->getParameter(index) == nullptr) {
            break;
        }

        const acre::id_t id = static_cast<acre::id_t>(atoi((char *)vMessage->getParameter(index)));
        index++;
        const bool status = atoi((char *)vMessage->getParameter(index)) != 0;
        index++;

        CEngine::getInstance()->getClient()->setMuted(id, status);
    }

    return acre::Result::ok;
}
public:
    inline void setName(const char *const value) final { m_Name = value; }
    inline const char* getName() const final { return m_Name; }

protected:
    const char* m_Name;
};
