#pragma once

#include "compat.h"
#include "Types.h"
#include "Macros.h"
#include "Log.h"
#include "IRpcFunction.h"

#include "IServer.h"
#include "Engine.h"

#include "TextMessage.h"

#include <Tracy.hpp>

RPC_FUNCTION(ext_remoteStopSpeaking) {
    ZoneScopedN("RPC - ext_remoteStopSpeaking");

    /*CTextMessage::formatNewMessage("ext_remoteStartSpeaking",
            "%d,%d,%s,%f,",
            this->getSelf()->getId(),
            this->getSelf()->getCurrentSpeakingType(),
            this->getSelf()->getCurrentRadioId().c_str(),
            this->getSelf()->getCurveScale()
        ) */

    const acre::id_t id = static_cast<acre::id_t>(vMessage->getParameterAsInt(0));

    CEngine::getInstance()->remoteStopSpeaking(id);

    return acre::Result::ok;
}
public:
    inline void setName(const char *const value) final { m_Name = value; }
    inline const char* getName() const final { return m_Name; }

protected:
    const char* m_Name;
};
