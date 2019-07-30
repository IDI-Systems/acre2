#pragma once

#include "compat.h"
#include "Types.h"
#include "Macros.h"
#include "IMessage.h"
#include "IServer.h"

#include "Engine.h"
#include "Lockable.h"

class CCommandServer : public IServer, public CLockable
{
public:
    CCommandServer(void);
    CCommandServer(const acre::id_t id);
    ~CCommandServer(void);

    acre::Result initialize(void);
    acre::Result shutdown(void);

    acre::Result sendMessage(IMessage *msg);
    acre::Result handleMessage(unsigned char *msg);

    acre::Result release(void);

    __inline void setCommandId(char *const value) { m_commandId = value; }
    __inline char* getCommandId() const { return m_commandId; }

    __inline void setConnected(const bool value) final { m_connected = value; }
    __inline bool getConnected() const final { return m_connected; }

    __inline void setId(const acre::id_t value) final { m_id = value; }
    __inline acre::id_t getId() const final { return m_id; }

protected:
    acre::id_t m_id;
    bool m_connected;
    char *m_commandId;
};
