#pragma once

#include "compat.h"
#include "IRpcFunction.h"
#include "Types.h"
#include "Engine.h"

#include <Tracy.hpp>

RPC_FUNCTION(ext_reset) {
    ZoneScopedN("RPC - ext_reset");

    const acre::id_t id = vMessage->getParameterAsInt(0);

    //
    // These checks were fucking up Because ext_reset is called on a named pipe disconnect, but this checked for a valid connection, and game, and that it was our valid ID.
    // This should just be calling unmute on EVERYONE - because it was a pipe disconnect. Pipe disconnect at the end of game, or when having issues.
    // We don't care if a person disconnects and they unmute all their shit, this doesn't break the "mute other people not in game" issue, because they mute this person.
    //
    //if(id == CEngine::getInstance()->getSelf()->getId())
    //    return acre::Result::ok;
    //if(!CEngine::getInstance()->getGameServer()->getConnected())
    //    return acre::Result::ok;
    //CEngine::getInstance()->getClient()->setMuted(id, FALSE);

    // We should be calling this, but the named pipe function already calls this too
    // We leave this here so SQF can force a full unmute, though.
    CEngine::getInstance()->getClient()->unMuteAll();

    return acre::Result::ok;
}
public:
    inline void setName(const char *const value) final { m_Name = value; }
    inline const char* getName() const final { return m_Name; }

protected:
    const char* m_Name;
};
