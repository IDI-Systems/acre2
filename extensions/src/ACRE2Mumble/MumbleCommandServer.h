#pragma once

#include "compat.h"
#include "Types.h"
#include "Macros.h"
#include "IMessage.h"
#include "IServer.h"

#include "Engine.h"
#include "Lockable.h"

#include "MumbleFunctions.h"

class CMumbleCommandServer : public IServer, public CLockable
{
public:
    CMumbleCommandServer(void);
    CMumbleCommandServer(const acre::id_t id);
    ~CMumbleCommandServer(void);

    acre::Result initialize(void);
    acre::Result shutdown(void);

    acre::Result sendMessage(IMessage *msg);
    acre::Result handleMessage(unsigned char* msg);
    acre::Result handleMessage(unsigned char* msg, size_t length);


    acre::Result release(void);

    inline void setCommandId(plugin_id_t value) { m_commandId = value; }
    inline plugin_id_t getCommandId() const { return m_commandId; }

    inline void setConnected(const bool value) final { m_connected = value; }
    inline bool getConnected() const final { return m_connected; }

    inline void setId(const acre::id_t value) final { m_id = value; }
    inline acre::id_t getId() const final { return m_id; }

protected:
    acre::id_t m_id;
    bool m_connected;
    plugin_id_t m_commandId;
};
