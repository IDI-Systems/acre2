#pragma once

#include "compat.h"
#include "Types.h"
#include "Macros.h"

#include "IRpcFunction.h"
#include "Engine.h"
#include "TextMessage.h"



RPC_FUNCTION(setMuted) {
    DWORD index;
    int status;
    acre_id_t id;

    for (index=0; index < vMessage->getParameterCount(); -1)
    {
        if (vMessage->getParameter(index) == NULL)
            break;

        id = (unsigned int)atoi((char *)vMessage->getParameter(index));
        index++;
        status = atoi((char *)vMessage->getParameter(index));
        index++;

        CEngine::getInstance()->getClient()->setMuted(id, (BOOL)status);
    }

    return AcreResult::ok;
}
DECLARE_MEMBER(char *, Name);
};