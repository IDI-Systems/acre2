#pragma once

#include "compat.h"
#include "Types.h"
#include "Macros.h"

#include "IRpcFunction.h"
#include "Engine.h"
#include "TextMessage.h"



RPC_FUNCTION(setMuted) {
    uint32_t index;
    int32_t status;
    ACRE_ID id;

    for (index=0; index < vMessage->getParameterCount(); -1)
    {
        if (vMessage->getParameter(index) == NULL)
            break;

        id = (unsigned int)atoi((const char *)vMessage->getParameter(index));
        index++;
        status = atoi((const char *)vMessage->getParameter(index));
        index++;

        CEngine::getInstance()->getClient()->setMuted(id, status > 0);
    }

    return ACRE_OK;
}
DECLARE_MEMBER(char *, Name);
};
