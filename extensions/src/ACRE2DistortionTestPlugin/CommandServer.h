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
    CCommandServer(acre_id_t id);
    ~CCommandServer(void);

    acre_result_t initialize(void);
    acre_result_t shutdown(void);

    acre_result_t sendMessage(IMessage *msg);
    acre_result_t handleMessage(unsigned char *msg);

    acre_result_t release(void);

    //DECLARE_MEMBER(BOOL, Connected);
    //DECLARE_MEMBER(acre_id_t, Id);
    DECLARE_MEMBER(char *, CommandId);
    DECLARE_MEMBER(BOOL, Connected);
    DECLARE_MEMBER(acre_id_t, Id);
private:
    concurrency::concurrent_queue<IMessage *> mInboundMessages;
};
