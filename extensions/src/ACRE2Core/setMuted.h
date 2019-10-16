#pragma once

#include "compat.h"
#include "Types.h"
#include "Macros.h"

#include "IRpcFunction.h"
#include "Engine.h"
#include "TextMessage.h"



RPC_FUNCTION(setMuted) {
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
    inline void setName(char *const value) final { m_Name = value; }
    inline char* getName() const final { return m_Name; }

protected:
    char* m_Name;
};
