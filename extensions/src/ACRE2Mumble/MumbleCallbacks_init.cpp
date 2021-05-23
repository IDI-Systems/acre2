#include "Engine.h"
#include "Log.h"
#include "MumbleClient.h"
#include "MumbleCommandServer.h"
#include "MumbleFunctions.h"
#include "compat.h"
#include "helpers.h"

#define FROM_PIPENAME "\\\\.\\pipe\\acre_comm_pipe_fromTS"
#define TO_PIPENAME   "\\\\.\\pipe\\acre_comm_pipe_toTS"

extern MumbleAPI_v_1_0_x mumAPI;
// TODO: Should these special values be a named variable?
mumble_connection_t activeConnection = -1;
plugin_id_t pluginID                 = -1;

uint32_t mumble_getFeatures() {
    return FEATURE_AUDIO;
}

void mumble_registerAPIFunctions(void *apiStruct) {
    mumAPI = MUMBLE_API_CAST(apiStruct);
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
}

mumble_error_t mumble_init(mumble_plugin_id_t id) {
	pluginID = id;
	
	// TODO: Is initializing the active server connection required at this point?
	// If so it must be done via an API call

    return STATUS_OK;
}

void mumble_onServerSynchronized(mumble_connection_t connection) {
    activeConnection = connection;

    // set ID on every new connection
    acre::id_t clientId = 0;
	// TODO: Missing error handling of API call
    mumAPI.getLocalUserID(pluginID, activeConnection, (mumble_userid_t *) &clientId);
    CEngine::getInstance()->getSelf()->setId(clientId);
    CEngine::getInstance()->getExternalServer()->setId(clientId);

    // subscribe to all channels to receive event
    if (CEngine::getInstance()->getClient()->getState() != acre::State::running) {
        CEngine::getInstance()->getClient()->start(static_cast<acre::id_t>(clientId));
    }
}

void mumble_onServerDisconnected(mumble_connection_t connection) {
    activeConnection = -1;

    if ((CEngine::getInstance()->getClient()->getState() != acre::State::stopped) &&
        (CEngine::getInstance()->getClient()->getState() != acre::State::stopping)) {
        CEngine::getInstance()->getClient()->stop();
    }
}

void mumble_shutdown() {
    if ((CEngine::getInstance()->getClient()->getState() != acre::State::stopped) &&
        (CEngine::getInstance()->getClient()->getState() != acre::State::stopping)) {
        CEngine::getInstance()->getClient()->stop();
    }
    CEngine::getInstance()->stop();
}
