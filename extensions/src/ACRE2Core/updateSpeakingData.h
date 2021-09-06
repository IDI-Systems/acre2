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
            CSoundChannelMono *channel = speaker->channels[0];
            if (speaker->getInitType() != speakingType) {
                speaker->setInitType(speakingType);
                reinitChannel(&(speaker->channels[0]));
                channel = speaker->channels[0];

                if (speaksBabbel) {
                    channel->setEffectInsert(0, "acre_babbel");
                }

                channel->setEffectInsert(channel->maxEffectInserts() - 1, "acre_volume");
                channel->setMixdownEffectInsert(0, "acre_positional");

                acre::Speaking speakingTypeEnum;
                if (speakingType == "i") {
                    channel->setEffectInsert(2, "acre_radio");
                    channel->getEffectInsert(2)->setParam("disableNoise", true);
                    channel->getEffectInsert(2)->setParam("signalQuality", 1.0f);
                    speakingTypeEnum = acre::Speaking::intercom;
                } else {
                    speakingTypeEnum = acre::Speaking::direct;
                }
                speaker->setSpeakingType(speakingTypeEnum);
                channel->getMixdownEffectInsert(0)->setParam("speakingType", speakingTypeEnum);
            }
            if (channel) {
                channel->getEffectInsert(channel->maxEffectInserts() - 1)->setParam("volume", vMessage->getParameterAsFloat(3));

                CSoundMixdownEffect *positionalEffect = channel->getMixdownEffectInsert(0);
                positionalEffect->setParam("speakerPosX", vMessage->getParameterAsFloat(4));
                positionalEffect->setParam("speakerPosZ", vMessage->getParameterAsFloat(5));
                positionalEffect->setParam("speakerPosY", vMessage->getParameterAsFloat(6));
                positionalEffect->setParam("vectorHeadX", vMessage->getParameterAsFloat(7));
                positionalEffect->setParam("vectorHeadZ", vMessage->getParameterAsFloat(8));
                positionalEffect->setParam("vectorHeadY", vMessage->getParameterAsFloat(9));
                positionalEffect->setParam("curveScale", speaker->getSelectableCurveScale());
            }
        } else if (speakingType == "r") {
            // Unmute them here. Dynamically muting and unmuting them when they transmit on a radio
            // cuts down on bandwidth and complexity. Now there is no more need to transmit lists of
            // radios or transfer radio ownerships around. Speakers just use whatever radio ID they
            // want.
            speaker->setSpeakingType(acre::Speaking::radio);
            if (CEngine::getInstance()->getClient()->getMuted(playerId) == acre::Result::ok) {
                CEngine::getInstance()->getClient()->setMuted(playerId, false);
            }

            const int32_t count = vMessage->getParameterAsInt(3);
            const float32_t volume = vMessage->getParameterAsFloat(4);
            const float32_t signalQuality = vMessage->getParameterAsFloat(5);

            for (int32_t i = 0; i < count; ++i) {
                const int32_t channelId = i + 1;
                CSoundChannelMono *channel = speaker->channels[channelId];

                if (!channel) {
                    CEngine::getInstance()->getSoundEngine()->getSoundMixer()->acquireChannel(&(speaker->channels[channelId]), 4800, false);
                    channel = speaker->channels[channelId];

                    if (speaksBabbel)
                        channel->setEffectInsert(0, "acre_babbel");

                    channel->setEffectInsert(channel->maxEffectInserts() - 1, "acre_volume");
                    channel->getEffectInsert(channel->maxEffectInserts() - 1)->setParam("volume", volume);

                    channel->setEffectInsert(2, "acre_radio");
                    channel->getEffectInsert(2)->setParam("disableNoise", false);
                    channel->getEffectInsert(2)->setParam("signalQuality", signalQuality);

                    channel->setMixdownEffectInsert(0, "acre_positional");
                    channel->getMixdownEffectInsert(0)->setParam("speakingType", acre::Speaking::radio);
                }

                if (channel) {
                    channel->getEffectInsert(channel->maxEffectInserts() - 1)->setParam("volume", vMessage->getParameterAsFloat(4 + (i * 8)));

                    channel->getEffectInsert(2)->setParam("disableNoise", false);
                    channel->getEffectInsert(2)->setParam("signalQuality", vMessage->getParameterAsFloat(5 + (i * 8)));
                    channel->getEffectInsert(2)->setParam("signalModel", vMessage->getParameterAsFloat(6 + (i * 8)));
                    channel->getEffectInsert(2)->setParam("modulation", vMessage->getParameter(11 + (i * 8)));

                    const bool isLoudSpeaker = vMessage->getParameterAsInt(7 + (i * 8));
                    channel->getMixdownEffectInsert(0)->setParam("isLoudSpeaker", isLoudSpeaker);
                    channel->getMixdownEffectInsert(0)->setParam("isWorld", isLoudSpeaker);

                    CSoundMixdownEffect *positionalEffect = channel->getMixdownEffectInsert(0);
                    positionalEffect->setParam("speakerPosX", vMessage->getParameterAsFloat(8 + (i * 8)));
                    positionalEffect->setParam("speakerPosZ", vMessage->getParameterAsFloat(9 + (i * 8)));
                    positionalEffect->setParam("speakerPosY", vMessage->getParameterAsFloat(10 + (i * 8)));
                    positionalEffect->setParam("vectorHeadX", 0.0f);
                    positionalEffect->setParam("vectorHeadZ", 1.0f);
                    positionalEffect->setParam("vectorHeadY", 0.0f);
                    positionalEffect->setParam("curveScale", speaker->getSelectableCurveScale());
                }
            }
        } else if (speakingType == "s" || speakingType == "g") {
            CSoundChannelMono *channel = speaker->channels[0];
            if (speakingType != speaker->getInitType()) {
                speaker->setInitType(speakingType);
                reinitChannel(&(speaker->channels[0]));
                channel = speaker->channels[0];
                channel->setEffectInsert(channel->maxEffectInserts() - 1, "acre_volume");
            }

            if (speakingType == "s") {
                speaker->setSpeakingType(acre::Speaking::spectate);
            } else {
                speaker->setSpeakingType(acre::Speaking::god);
            }

            if (CEngine::getInstance()->getClient()->getMuted(playerId) == acre::Result::ok) {
                CEngine::getInstance()->getClient()->setMuted(playerId, false);
            }

            if (channel) {
                channel->getEffectInsert(channel->maxEffectInserts() - 1)->setParam("volume", vMessage->getParameterAsFloat(3));
            }
        } else {
            speaker->setSpeakingType(acre::Speaking::unknown);
        }
        UNLOCK(speaker);
    }
    CEngine::getInstance()->getSoundEngine()->getSoundMixer()->unlock();
    return acre::Result::ok;
}
private:
    void reinitChannel(CSoundChannelMono **channel) {
        if (*channel) {
            CEngine::getInstance()->getSoundEngine()->getSoundMixer()->releaseChannel(channel);
        }
        CEngine::getInstance()->getSoundEngine()->getSoundMixer()->acquireChannel(channel, 4800, false);
    };

public:
    inline void setName(const char *const value) final { m_Name = value; }
    inline const char* getName() const final { return m_Name; }

protected:
    const char* m_Name;
};
