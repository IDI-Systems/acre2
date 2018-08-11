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

    ACRE_RESULT sendMessage(IMessage *const msg);
    ACRE_RESULT handleMessage(unsigned char *const msg);

    ACRE_RESULT release(void);

    //DECLARE_MEMBER(BOOL, Connected);
    //DECLARE_MEMBER(ACRE_ID, Id);

    virtual __inline void setCommandId(char *const ac_value) { this->m_commandId = ac_value; }
    virtual __inline char * getCommandId() const { return this->m_commandId; }

    virtual __inline void setConnected(const bool ac_value) { this->m_connected = ac_value; }
    virtual __inline bool getConnected() const { return this->m_connected; }

    virtual __inline void setId(const ACRE_ID ac_value) { this->m_id = ac_value; }
    virtual __inline ACRE_ID getId() const { return this->m_id; }

protected:
    char *m_commandId;
    bool m_connected;
    ACRE_ID m_id;

private:
    concurrency::concurrent_queue<IMessage *> mInboundMessages;
};
