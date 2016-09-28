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

    std::string speakingType;
    ACRE_ID playerId;
    CPlayer *speaker = NULL;

    speakingType = std::string((char *)vMessage->getParameter(0));
    playerId = (ACRE_ID)vMessage->getParameterAsInt(1);
    int32_t speaksBabbel = vMessage->getParameterAsInt(2);
    if(playerId == CEngine::getInstance()->getSelf()->getId() && speakingType == "r") {
        //speaker = CEngine::getInstance()->getSelf();
    } else {
        if(!speaker) {
            auto it = CEngine::getInstance()->speakingList.find(playerId);
            if(it != CEngine::getInstance()->speakingList.end()) {
                speaker = (CPlayer *)it->second;
            }
        }
    }
    TRACE("SPEAKING DATA: %s", vMessage->getData());
    CEngine::getInstance()->getSoundEngine()->getSoundMixer()->lock();
    if(speaker) {
        LOCK(speaker);
        if(speakingType == "d" || speakingType == "i") {
            if((speaker->getInitType() != "d" && speaker->getInitType() != "i") || speakingType != speaker->getInitType()) {
                speaker->setInitType(speakingType);
                if(speaker->channels[0]) {
                    CEngine::getInstance()->getSoundEngine()->getSoundMixer()->releaseChannel(speaker->channels[0]);
                    speaker->channels[0] = NULL;
                }
                CEngine::getInstance()->getSoundEngine()->getSoundMixer()->acquireChannel(&speaker->channels[0], 4800, false);
                if(speaksBabbel)
                        speaker->channels[0]->setEffectInsert(0, "acre_babbel");
                speaker->channels[0]->setMixdownEffectInsert(0, "acre_positional");
                speaker->channels[0]->getMixdownEffectInsert(0)->setParam("speakingType", ACRE_SPEAKING_DIRECT);
                speaker->setSpeakingType(ACRE_SPEAKING_DIRECT);
                if(speakingType == "i") {
                    speaker->channels[0]->setEffectInsert(2, "acre_radio");
                    speaker->channels[0]->getEffectInsert(2)->setParam("disableNoise", TRUE);
                    speaker->channels[0]->getEffectInsert(2)->setParam("signalQuality", 1.0f);
                    speaker->channels[0]->getMixdownEffectInsert(0)->setParam("speakingType", ACRE_SPEAKING_INTERCOM);
                    speaker->setSpeakingType(ACRE_SPEAKING_INTERCOM);
                }
                speaker->channels[0]->setEffectInsert(7, "acre_volume");
            }
            if(speaker->channels[0]) {
                speaker->channels[0]->getEffectInsert(7)->setParam("volume", vMessage->getParameterAsFloat(3));
            
                speaker->channels[0]->getMixdownEffectInsert(0)->setParam("speakerPosX", vMessage->getParameterAsFloat(4));
                speaker->channels[0]->getMixdownEffectInsert(0)->setParam("speakerPosZ", vMessage->getParameterAsFloat(5));
                speaker->channels[0]->getMixdownEffectInsert(0)->setParam("speakerPosY", vMessage->getParameterAsFloat(6));

                speaker->channels[0]->getMixdownEffectInsert(0)->setParam("headVectorX", vMessage->getParameterAsFloat(7));
                speaker->channels[0]->getMixdownEffectInsert(0)->setParam("headVectorZ", vMessage->getParameterAsFloat(8));
                speaker->channels[0]->getMixdownEffectInsert(0)->setParam("headVectorY", vMessage->getParameterAsFloat(9));

                speaker->channels[0]->getMixdownEffectInsert(0)->setParam("curveScale", speaker->getSelectableCurveScale());
            }
        } else if(speakingType == "r") {
            // Unmute them here. Dynamically muting and unmuting them when they transmit on a radio
            // cuts down on bandwidth and complexity. Now there is no more need to transmit lists of
            // radios or transfer radio ownerships around. Speakers just use whatever radio ID they
            // want.
            int count = vMessage->getParameterAsInt(3);
            speaker->setSpeakingType(ACRE_SPEAKING_RADIO);
            if(CEngine::getInstance()->getClient()->getMuted(playerId)) {
                CEngine::getInstance()->getClient()->setMuted(playerId, false);
            }
            for(int i = 0; i < count; ++i) {
                int channelId = i+1;
                if(!speaker->channels[channelId]) {
                    CEngine::getInstance()->getSoundEngine()->getSoundMixer()->acquireChannel(&speaker->channels[channelId], 4800, false);
                    if(speaksBabbel)
                        speaker->channels[channelId]->setEffectInsert(0, "acre_babbel");
                    speaker->channels[channelId]->setEffectInsert(7, "acre_volume");
                    speaker->channels[channelId]->getEffectInsert(7)->setParam("volume", vMessage->getParameterAsFloat(4));

                    speaker->channels[channelId]->setEffectInsert(2, "acre_radio");
                    speaker->channels[channelId]->getEffectInsert(2)->setParam("disableNoise", FALSE);
                    speaker->channels[channelId]->getEffectInsert(2)->setParam("signalQuality", vMessage->getParameterAsFloat(5));

                    speaker->channels[channelId]->setMixdownEffectInsert(0, "acre_positional");
                }
                
                if(speaker->channels[channelId]) {
                    speaker->channels[channelId]->getMixdownEffectInsert(0)->setParam("speakingType", ACRE_SPEAKING_RADIO);
            
                    speaker->channels[channelId]->getEffectInsert(7)->setParam("volume", vMessage->getParameterAsFloat(4+(i*7)));
                    
                    speaker->channels[channelId]->getEffectInsert(2)->setParam("disableNoise", FALSE);
                    speaker->channels[channelId]->getEffectInsert(2)->setParam("signalQuality", vMessage->getParameterAsFloat(5+(i*7)));
                    speaker->channels[channelId]->getEffectInsert(2)->setParam("signalModel", vMessage->getParameterAsFloat(6+(i*7)));
            
                    speaker->channels[channelId]->getMixdownEffectInsert(0)->setParam("isLoudSpeaker", vMessage->getParameterAsFloat(7+(i*7)));
                    if(vMessage->getParameterAsFloat(7+(i*7))) {
                        speaker->channels[channelId]->getMixdownEffectInsert(0)->setParam("isWorld", 0x00000001);
                    } else {
                        speaker->channels[channelId]->getMixdownEffectInsert(0)->setParam("isWorld", 0x00000000);
                    }



                    speaker->channels[channelId]->getMixdownEffectInsert(0)->setParam("speakerPosX", vMessage->getParameterAsFloat(8+(i*7)));
                    speaker->channels[channelId]->getMixdownEffectInsert(0)->setParam("speakerPosZ", vMessage->getParameterAsFloat(9+(i*7)));
                    speaker->channels[channelId]->getMixdownEffectInsert(0)->setParam("speakerPosY", vMessage->getParameterAsFloat(10+(i*7)));

                    speaker->channels[channelId]->getMixdownEffectInsert(0)->setParam("headVectorX", 0.0f);
                    speaker->channels[channelId]->getMixdownEffectInsert(0)->setParam("headVectorZ", 1.0f);
                    speaker->channels[channelId]->getMixdownEffectInsert(0)->setParam("headVectorY", 0.0f);
                    speaker->channels[channelId]->getMixdownEffectInsert(0)->setParam("curveScale", speaker->getSelectableCurveScale());
                }
            }

        } else if(speakingType == "s") {
            if(speaker->getInitType() != "s" || speakingType != speaker->getInitType()) {
                speaker->setInitType(speakingType);
                if(speaker->channels[0]) {
                    CEngine::getInstance()->getSoundEngine()->getSoundMixer()->releaseChannel(speaker->channels[0]);
                    speaker->channels[0] = NULL;
                }
                CEngine::getInstance()->getSoundEngine()->getSoundMixer()->acquireChannel(&speaker->channels[0], 4800, false);
                speaker->channels[0]->setEffectInsert(7, "acre_volume");
            }
            speaker->setSpeakingType(ACRE_SPEAKING_SPECTATE);
            if(CEngine::getInstance()->getClient()->getMuted(playerId)) {
                CEngine::getInstance()->getClient()->setMuted(playerId, false);
            }
            if(speaker->channels[0]) {
                speaker->channels[0]->getEffectInsert(7)->setParam("volume", vMessage->getParameterAsFloat(3));
            }
        } else {
            speaker->setSpeakingType(ACRE_SPEAKING_UNKNOWN);
        }
        UNLOCK(speaker);
    }
    CEngine::getInstance()->getSoundEngine()->getSoundMixer()->unlock();
    return ACRE_OK;
}
DECLARE_MEMBER(char *, Name);
};