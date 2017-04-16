#pragma once

#include "compat.h"
#include "Types.h"
#include "Macros.h"
#include "IMessage.h"
#include "IServer.h"

#include "Engine.h"
#include "Lockable.h"

#include <concurrent_queue.h>

class CCommandServer : public IServer, public CLockable
{
public:
    CCommandServer(void);
    CCommandServer(ACRE_ID id);
    ~CCommandServer(void);

    ACRE_RESULT initialize(void);
    ACRE_RESULT shutdown(void);

    ACRE_RESULT sendMessage(IMessage *msg);
    ACRE_RESULT handleMessage(unsigned char *msg);

    ACRE_RESULT release(void);

    //DECLARE_MEMBER(bool, Connected);
    //DECLARE_MEMBER(ACRE_ID, Id);
    DECLARE_MEMBER(char *, CommandId);
    DECLARE_MEMBER(bool, Connected);
    DECLARE_MEMBER(ACRE_ID, Id);
private:
    concurrency::concurrent_queue<IMessage *> mInboundMessages;
};
