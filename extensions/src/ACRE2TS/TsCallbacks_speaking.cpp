#include "compat.h"

#include "public_errors.h"
#include "public_definitions.h"
#include "public_rare_definitions.h"
#include "ts3_functions.h"

#include "Types.h"
#include "Macros.h"

#include "Engine.h"

#include "Log.h"

#include "TsCallbacks.h"
#include "TS3Client.h"

//
// TS3  Speaking callbacks
// 
void ts3plugin_onTalkStatusChangeEvent(uint64 serverConnectionHandlerID, int status, int isReceivedWhisper, anyID clientID) {

    if ((ACRE_ID)clientID == CEngine::getInstance()->getSelf()->getId()) {     
        if (CEngine::getInstance()->getClient()->getState() != ACRE_STATE_RUNNING)
            return;
        if (!CEngine::getInstance()->getGameServer())
            return;
        if (CEngine::getInstance()->getState() != ACRE_STATE_RUNNING)
            return;
        if (!CEngine::getInstance()->getGameServer()->getConnected())
            return;

        
        ((CTS3Client *)(CEngine::getInstance()->getClient()))->setTsSpeakingState(status);
        if (CEngine::getInstance()->getSoundSystemOverride())
            return;
        if (((CTS3Client *)(CEngine::getInstance()->getClient()))->getOnRadio()) {
            if (((CTS3Client *)(CEngine::getInstance()->getClient()))->getVAD()) {
                return;
            } else {
                if (status == STATUS_NOT_TALKING) {
                    if (!((CTS3Client *)(CEngine::getInstance()->getClient()))->getRadioPTTDown()) {
                        ((CTS3Client *)(CEngine::getInstance()->getClient()))->setOnRadio(false);
                    } else {
                        if (!((CTS3Client *)(CEngine::getInstance()->getClient()))->getDirectFirst()) {
                            ((CTS3Client *)(CEngine::getInstance()->getClient()))->microphoneOpen(true);
                        } else {
                            ((CTS3Client *)(CEngine::getInstance()->getClient()))->setDirectFirst(false);
                            if (((CTS3Client *)(CEngine::getInstance()->getClient()))->getRadioPTTDown()) {
                                ((CTS3Client *)(CEngine::getInstance()->getClient()))->microphoneOpen(true);
                            }
                        }
                    }
                }
                return;
            }
            return;
        }
        TRACE("enter: [%d],[%d]", clientID, status);

        
        if (status == STATUS_TALKING) {
            ((CTS3Client *)(CEngine::getInstance()->getClient()))->setDirectFirst(true);
            CEngine::getInstance()->getClient()->localStartSpeaking(ACRE_SPEAKING_DIRECT);
        } else if (status == STATUS_NOT_TALKING)  {
            ((CTS3Client *)(CEngine::getInstance()->getClient()))->setDirectFirst(false);
            CEngine::getInstance()->getClient()->localStopSpeaking(ACRE_SPEAKING_DIRECT);
            ((CTS3Client *)(CEngine::getInstance()->getClient()))->setMainPTTDown(false);
        }
    }


}