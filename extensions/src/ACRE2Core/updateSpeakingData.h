#pragma once

#include "compat.h"
#include "Types.h"
#include "Macros.h"
#include "Log.h"
#include "IRpcFunction.h"
#include "Player.h"

#include "IServer.h"
#include "Engine.h"

#include "TextMessage.h"

RPC_FUNCTION(updateSpeakingData) {

    CPlayer *speaker = nullptr;

    const std::string speakingType = std::string((char *)vMessage->getParameter(0));
    const acre::id_t playerId = static_cast<acre::id_t>(vMessage->getParameterAsInt(1));
    const bool speaksBabbel = vMessage->getParameterAsInt(2) == 1;
    if (playerId == CEngine::getInstance()->getSelf()->getId() && speakingType == "r") {
        //speaker = CEngine::getInstance()->getSelf();
    } else {
        if (!speaker) {
            auto it = CEngine::getInstance()->speakingList.find(playerId);
            if (it != CEngine::getInstance()->speakingList.end()) {
                speaker = (CPlayer *)it->second;
            }
        }
    }
    TRACE("SPEAKING DATA: %s", vMessage->getData());
    CEngine::getInstance()->getSoundEngine()->getSoundMixer()->lock();
    if (speaker) {
        LOCK(speaker);
        if ((speakingType == "d") || (speakingType == "i") || (speakingType == "z")) {
            if (((speaker->getInitType() != "d") && (speaker->getInitType() != "i") && (speaker->getInitType() != "z")) || speakingType != speaker->getInitType()) {
                speaker->setInitType(speakingType);
                if (speaker->channels[0]) {
                    CEngine::getInstance()->getSoundEngine()->getSoundMixer()->releaseChannel(speaker->channels[0]);
                    speaker->channels[0] = NULL;
                }
                CEngine::getInstance()->getSoundEngine()->getSoundMixer()->acquireChannel(&speaker->channels[0], 4800, false);
                if (speaksBabbel) {
                    speaker->channels[0]->setEffectInsert(0, "acre_babbel");
                }
                speaker->channels[0]->setMixdownEffectInsert(0, "acre_positional");
                speaker->channels[0]->getMixdownEffectInsert(0)->setParam("speakingType", static_cast<float32_t>(acre::Speaking::direct));
                speaker->setSpeakingType(acre::Speaking::direct);
                if (speakingType == "i") {
                    speaker->channels[0]->setEffectInsert(2, "acre_radio");
                    speaker->channels[0]->getEffectInsert(2)->setParam("disableNoise", true);
                    speaker->channels[0]->getEffectInsert(2)->setParam("signalQuality", 1.0f);
                    speaker->channels[0]->getMixdownEffectInsert(0)->setParam("speakingType", static_cast<float32_t>(acre::Speaking::intercom));
                    speaker->setSpeakingType(acre::Speaking::intercom);
                }
                speaker->channels[0]->setEffectInsert(7, "acre_volume");
            }
            if (speaker->channels[0]) {
                speaker->channels[0]->getEffectInsert(7)->setParam("volume", vMessage->getParameterAsFloat(3));

                speaker->channels[0]->getMixdownEffectInsert(0)->setParam("speakerPosX", vMessage->getParameterAsFloat(4));
                speaker->channels[0]->getMixdownEffectInsert(0)->setParam("speakerPosZ", vMessage->getParameterAsFloat(5));
                speaker->channels[0]->getMixdownEffectInsert(0)->setParam("speakerPosY", vMessage->getParameterAsFloat(6));

                speaker->channels[0]->getMixdownEffectInsert(0)->setParam("headVectorX", vMessage->getParameterAsFloat(7));
                speaker->channels[0]->getMixdownEffectInsert(0)->setParam("headVectorZ", vMessage->getParameterAsFloat(8));
                speaker->channels[0]->getMixdownEffectInsert(0)->setParam("headVectorY", vMessage->getParameterAsFloat(9));

                speaker->channels[0]->getMixdownEffectInsert(0)->setParam("curveScale", speaker->getSelectableCurveScale());
            }
        } else if (speakingType == "r") {
            // Unmute them here. Dynamically muting and unmuting them when they transmit on a radio
            // cuts down on bandwidth and complexity. Now there is no more need to transmit lists of
            // radios or transfer radio ownerships around. Speakers just use whatever radio ID they
            // want.
            const int32_t count = vMessage->getParameterAsInt(3);
            speaker->setSpeakingType(acre::Speaking::radio);
            if (CEngine::getInstance()->getClient()->getMuted(playerId) == acre::Result::ok) {
                CEngine::getInstance()->getClient()->setMuted(playerId, false);
            }
            for (int32_t i = 0; i < count; ++i) {
                const int32_t channelId = i + 1;
                if (!speaker->channels[channelId]) {
                    CEngine::getInstance()->getSoundEngine()->getSoundMixer()->acquireChannel(&speaker->channels[channelId], 4800, false);
                    if (speaksBabbel)
                        speaker->channels[channelId]->setEffectInsert(0, "acre_babbel");
                    speaker->channels[channelId]->setEffectInsert(7, "acre_volume");
                    speaker->channels[channelId]->getEffectInsert(7)->setParam("volume", vMessage->getParameterAsFloat(4));

                    speaker->channels[channelId]->setEffectInsert(2, "acre_radio");
                    speaker->channels[channelId]->getEffectInsert(2)->setParam("disableNoise", false);
                    speaker->channels[channelId]->getEffectInsert(2)->setParam("signalQuality", vMessage->getParameterAsFloat(5));
                    speaker->channels[channelId]->getEffectInsert(2)->setParam("isLoudSpeaker", vMessage->getParameterAsFloat(7));

                    speaker->channels[channelId]->setMixdownEffectInsert(0, "acre_positional");
                }

                if (speaker->channels[channelId]) {
                    speaker->channels[channelId]->getMixdownEffectInsert(0)->setParam("speakingType", static_cast<float32_t>(acre::Speaking::radio));

                    speaker->channels[channelId]->getEffectInsert(7)->setParam("volume", vMessage->getParameterAsFloat(4 + (i * 7)));

                    speaker->channels[channelId]->getEffectInsert(2)->setParam("disableNoise", FALSE);
                    speaker->channels[channelId]->getEffectInsert(2)->setParam("signalQuality", vMessage->getParameterAsFloat(5 + (i * 7)));
                    speaker->channels[channelId]->getEffectInsert(2)->setParam("signalModel", vMessage->getParameterAsFloat(6 + (i * 7)));

                    speaker->channels[channelId]->getMixdownEffectInsert(0)->setParam("isLoudSpeaker", vMessage->getParameterAsFloat(7 + (i * 7)));
                    if (vMessage->getParameterAsFloat(7 + (i * 7))) {
                        speaker->channels[channelId]->getMixdownEffectInsert(0)->setParam("isWorld", 0x00000001);
                    } else {
                        speaker->channels[channelId]->getMixdownEffectInsert(0)->setParam("isWorld", 0x00000000);
                    }

                    speaker->channels[channelId]->getMixdownEffectInsert(0)->setParam("speakerPosX", vMessage->getParameterAsFloat(8 + (i * 7)));
                    speaker->channels[channelId]->getMixdownEffectInsert(0)->setParam("speakerPosZ", vMessage->getParameterAsFloat(9 + (i * 7)));
                    speaker->channels[channelId]->getMixdownEffectInsert(0)->setParam("speakerPosY", vMessage->getParameterAsFloat(10 + (i * 7)));

                    speaker->channels[channelId]->getMixdownEffectInsert(0)->setParam("headVectorX", 0.0f);
                    speaker->channels[channelId]->getMixdownEffectInsert(0)->setParam("headVectorZ", 1.0f);
                    speaker->channels[channelId]->getMixdownEffectInsert(0)->setParam("headVectorY", 0.0f);
                    speaker->channels[channelId]->getMixdownEffectInsert(0)->setParam("curveScale", speaker->getSelectableCurveScale());
                }
            }
        } else if (speakingType == "s" || speakingType == "g") {
            if ((speaker->getInitType() != "s" && speaker->getInitType() != "g") || speakingType != speaker->getInitType()) {
                speaker->setInitType(speakingType);
                if (speaker->channels[0]) {
                    CEngine::getInstance()->getSoundEngine()->getSoundMixer()->releaseChannel(speaker->channels[0]);
                    speaker->channels[0] = NULL;
                }
                CEngine::getInstance()->getSoundEngine()->getSoundMixer()->acquireChannel(&speaker->channels[0], 4800, false);
                speaker->channels[0]->setEffectInsert(7, "acre_volume");
            }
            if (speakingType == "s") {
                speaker->setSpeakingType(acre::Speaking::spectate);
            } else {
                speaker->setSpeakingType(acre::Speaking::god);
            }
            if (CEngine::getInstance()->getClient()->getMuted(playerId) == acre::Result::ok) {
                CEngine::getInstance()->getClient()->setMuted(playerId, false);
            }
            if (speaker->channels[0]) {
                speaker->channels[0]->getEffectInsert(7)->setParam("volume", vMessage->getParameterAsFloat(3));
            }
        } else {
            speaker->setSpeakingType(acre::Speaking::unknown);
        }
        UNLOCK(speaker);
    }
    CEngine::getInstance()->getSoundEngine()->getSoundMixer()->unlock();
    return acre::Result::ok;
}
public:
    inline void setName(const char *const value) final { m_Name = value; }
    inline const char* getName() const final { return m_Name; }

protected:
    const char* m_Name;
};
