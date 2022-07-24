#include "Engine.h"
#include "Log.h"
#include "Macros.h"
#include "MumbleClient.h"
#include "MumbleEventLoop.h"
#include "Types.h"
#include "compat.h"

#include <Tracy.hpp>
//
// Mumble Speaking callbacks
//
void mumble_onUserTalkingStateChanged(mumble_connection_t connection, mumble_userid_t userID, mumble_talking_state_t status) {
    ZoneScoped;

    acre::MumbleEventLoop::getInstance().queue([connection, userID, status]() {
        ZoneScoped;

        TRACE("mumble_onUserTalkingStateChanged ENTER: %d", status);
        if (static_cast<acre::id_t>(userID) != CEngine::getInstance()->getSelf()->getId()) {
            return;
        }

        if (CEngine::getInstance()->getClient()->getState() != acre::State::running) {
            return;
        }

        if (!CEngine::getInstance()->getGameServer()) {
            return;
        }

        if (CEngine::getInstance()->getState() != acre::State::running) {
            return;
        }

        if (!CEngine::getInstance()->getGameServer()->getConnected()) {
            return;
        }

        CEngine::getInstance()->getClient()->setSpeakingState(status);
        if (CEngine::getInstance()->getSoundSystemOverride()) {
            return;
        }

        if (CEngine::getInstance()->getClient()->getOnRadio()) {
            if (CEngine::getInstance()->getClient()->getVAD()) {
                return;
            }

            if (status == MUMBLE_TS_PASSIVE || status == MUMBLE_TS_INVALID) {
                if ((!CEngine::getInstance()->getClient()->getRadioPTTDown())
                    && (!CEngine::getInstance()->getClient()->getGodPTTDown())
                    && (!CEngine::getInstance()->getClient()->getZeusPTTDown())) {
                    CEngine::getInstance()->getClient()->setOnRadio(false);
                }
                else {
                    if (!CEngine::getInstance()->getClient()->getDirectFirst()) {
                        CEngine::getInstance()->getClient()->microphoneOpen(true);
                    }
                    else {
                        CEngine::getInstance()->getClient()->setDirectFirst(false);
                        if ((CEngine::getInstance()->getClient()->getRadioPTTDown())
                            || (CEngine::getInstance()->getClient()->getGodPTTDown())
                            || (CEngine::getInstance()->getClient()->getZeusPTTDown())) {
                            CEngine::getInstance()->getClient()->microphoneOpen(true);
                        }
                    }
                }
            }

            return;
        }
        TRACE("enter: [%d],[%d]", userID, status);

        if ((status != MUMBLE_TS_PASSIVE) && (status != MUMBLE_TS_INVALID)) {
            CEngine::getInstance()->getClient()->setDirectFirst(true);
            CEngine::getInstance()->getClient()->localStartSpeaking(acre::Speaking::direct);
        }
        else {
            CEngine::getInstance()->getClient()->setDirectFirst(false);
            CEngine::getInstance()->getClient()->localStopSpeaking(acre::Speaking::direct);
            CEngine::getInstance()->getClient()->setMainPTTDown(false);
            CEngine::getInstance()->getClient()->setGodPTTDown(false);
            CEngine::getInstance()->getClient()->setZeusPTTDown(false);
        }
    });
}
