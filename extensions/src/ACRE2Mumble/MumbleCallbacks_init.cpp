#include "Engine.h"
#include "Log.h"
#include "MumbleClient.h"
#include "MumbleCommandServer.h"
#include "MumbleFunctions.h"
#include "MumbleEventLoop.h"
#include "compat.h"
#include "helpers.h"

#include <Tracy.hpp>

#define FROM_PIPENAME "\\\\.\\pipe\\acre_comm_pipe_fromTS"
#define TO_PIPENAME   "\\\\.\\pipe\\acre_comm_pipe_toTS"

const char *mumbleThreadName = "Mumble main thread";

extern MumbleAPI_v_1_0_x mumAPI;
mumble_connection_t activeConnection = -1;
mumble_plugin_id_t pluginID          = -1;

uint32_t mumble_getFeatures() {
    return MUMBLE_FEATURE_AUDIO;
}

void mumble_registerAPIFunctions(void *apiStruct) {
    mumAPI = MUMBLE_API_CAST(apiStruct);
}

mumble_error_t mumble_init(mumble_plugin_id_t id) {
    ZoneScoped;

    tracy::SetThreadName(mumbleThreadName);

    pluginID = id;

    acre::MumbleEventLoop::getInstance().start();

    if (API_CALL(getActiveServerConnection, pluginID, &activeConnection) != MUMBLE_STATUS_OK) {
        activeConnection = -1;
    }

    CEngine::getInstance()->initialize(new CMumbleClient(), new CMumbleCommandServer(), FROM_PIPENAME, TO_PIPENAME);
    if (CEngine::getInstance() != NULL) {
        if (((CMumbleCommandServer *) CEngine::getInstance()->getExternalServer()) != NULL) {
            ((CMumbleCommandServer *) CEngine::getInstance()->getExternalServer())->setCommandId(pluginID);
        }
        if (pluginID != -1)
            ((CMumbleCommandServer *) CEngine::getInstance()->getExternalServer())->setCommandId(pluginID);
        if (activeConnection != -1) {
            // we are activating while connected, call it
            // virtualize a connect event
            mumble_onServerSynchronized(activeConnection);
        }
    }

    return MUMBLE_STATUS_OK;
}

void mumble_onServerSynchronized(mumble_connection_t connection) {
    ZoneScoped;

    tracy::SetThreadName(mumbleThreadName);

    acre::MumbleEventLoop::getInstance().queue([connection]() {
        ZoneScoped;

        activeConnection = connection;

        // set ID on every new connection
        acre::id_t clientId = 5;
        mumble_error_t retCode = API_CALL(getLocalUserID, pluginID, activeConnection, (mumble_userid_t*)&clientId);
        if (retCode != MUMBLE_STATUS_OK) {
            LOG("ERROR, FAILED TO FETCH LOCAL USER'S ID: %s (%d)", mumble_errorMessage(retCode), retCode);
        }
        TRACE("Local user's ID is %d", clientId);
        CEngine::getInstance()->getSelf()->setId(clientId);
        CEngine::getInstance()->getExternalServer()->setId(clientId);

        // subscribe to all channels to receive event
        if (CEngine::getInstance()->getClient()->getState() != acre::State::running) {
            CEngine::getInstance()->getClient()->start(static_cast<acre::id_t>(clientId));
        }
    });
}

void mumble_onServerDisconnected(mumble_connection_t connection) {
    ZoneScoped;

    acre::MumbleEventLoop::getInstance().queue([connection]() {
        ZoneScoped;

        activeConnection = -1;

        if ((CEngine::getInstance()->getClient()->getState() != acre::State::stopped) &&
            (CEngine::getInstance()->getClient()->getState() != acre::State::stopping)) {
            CEngine::getInstance()->getClient()->stop();
        }
    });
}

void mumble_shutdown() {
    ZoneScoped;

    acre::MumbleEventLoop::getInstance().queue([]() {
        ZoneScoped;

        if ((CEngine::getInstance()->getClient()->getState() != acre::State::stopped) &&
            (CEngine::getInstance()->getClient()->getState() != acre::State::stopping)) {
            CEngine::getInstance()->getClient()->stop();
        }
        CEngine::getInstance()->stop();
    });

    acre::MumbleEventLoop::getInstance().stop();
}

void mumble_releaseResource(const void *) {
    // Nothing to do here since we never pass allocated resourced to Mumble
    // that needed freeing
    LOG("ERROR: Unexpectedly called mumble_releaseResource");
}
