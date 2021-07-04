#pragma once

#include "Engine.h"
#include "IMessage.h"
#include "IServer.h"
#include "Lockable.h"
#include "Macros.h"
#include "MumbleFunctions.h"
#include "Types.h"
#include "compat.h"

class CMumbleCommandServer : public IServer, public CLockable {
public:
    CMumbleCommandServer(void);
    CMumbleCommandServer(const acre::id_t id);
    ~CMumbleCommandServer(void) final = default;

    acre::Result initialize(void) final;
    acre::Result shutdown(void) final;

    acre::Result sendMessage(IMessage *msg) final;
    acre::Result handleMessage(unsigned char *msg) final;
    acre::Result handleMessage(unsigned char *msg, size_t length) final;

    acre::Result release(void) final;

    inline void setCommandId(mumble_plugin_id_t value) noexcept { m_commandId = value; }
    inline mumble_plugin_id_t getCommandId() const noexcept { return m_commandId; }

    inline void setConnected(const bool value) final { m_connected = value; }
    inline bool getConnected() const final { return m_connected; }

    inline void setId(const acre::id_t value) final { m_id = value; }
    inline acre::id_t getId() const final { return m_id; }

private:
    acre::id_t m_id;
    bool m_connected;
    mumble_plugin_id_t m_commandId;
};
