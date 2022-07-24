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

RPC_FUNCTION(ext_remoteStartSpeaking) {
    ZoneScopedN("RPC - ext_remoteStartSpeaking");

    /*CTextMessage::formatNewMessage("ext_remoteStartSpeaking",
            "%d,%d,%s,%f,",
            this->getSelf()->getId(),
            this->getSelf()->getCurrentSpeakingType(),
            this->getSelf()->getCurrentRadioId().c_str(),
            this->getSelf()->getCurveScale()
        ) */

    const acre::id_t id = static_cast<acre::id_t>(vMessage->getParameterAsInt(0));
    const int32_t languageId = static_cast<acre::id_t>(vMessage->getParameterAsInt(1));
    const  std::string netId = std::string((char *)vMessage->getParameter(2));

    const  acre::Speaking speakingType = static_cast<acre::Speaking>(vMessage->getParameterAsInt(3));
    const std::string radio_id = std::string((char *)vMessage->getParameter(4));
    const acre::volume_t curveScale = vMessage->getParameterAsFloat(5);

    CEngine::getInstance()->remoteStartSpeaking(id, languageId, netId, speakingType, radio_id, curveScale);

    return acre::Result::ok;
}
public:
    inline void setName(const char *const value) final { m_Name = value; }
    inline const char* getName() const final { return m_Name; }

protected:
    const char* m_Name;
};
