#include "compat.h"

#include "Log.h"
#include "Engine.h"
#include "MumbleClient.h"
#include "CommandServer.h"
#include "helpers.h"

#include "MumbleFunctions.h"

#define FROM_PIPENAME   "\\\\.\\pipe\\acre_comm_pipe_fromTS"
#define TO_PIPENAME     "\\\\.\\pipe\\acre_comm_pipe_toTS"

extern MumbleAPI mumAPI;
mumble_connection_t activeConnection = -1;
plugin_id_t pluginID = -1;
/*
const char* ts3plugin_name() {
    return ACRE_NAME;
}
const char* ts3plugin_version() {
    return ACRE_VERSION;
}
int ts3plugin_apiVersion() {
    const int32_t api = getTSAPIVersion();

    // API Compatibility
    // v23
    onPluginCommandEvent_v23 = (api < 23) ? 0 : 1;

    return api;
}
const char* ts3plugin_author() {
    return ACRE_TEAM_URL;
}
const char* ts3plugin_description() {
    return ACRE_DESC;
}
void ts3plugin_setFunctionPointers(const struct TS3Functions funcs) {
    ts3Functions = funcs;
}
*/


void registerPluginID(plugin_id_t id) {
    pluginID = id;
    if (CEngine::getInstance() != NULL) {
        if (((CMumbleCommandServer*)CEngine::getInstance()->getExternalServer()) != NULL) {
            ((CMumbleCommandServer*)CEngine::getInstance()->getExternalServer())->setCommandId(pluginID);
        }
    }
}

uint32_t getFeatures() {
    return FEATURE_AUDIO;
}

//
// Init
//
int ts3plugin_init() {


    return 0;
}

mumble_error_t init() {
    CEngine::getInstance()->initialize(new CMumbleClient(), new CMumbleCommandServer(), FROM_PIPENAME, TO_PIPENAME);

    // if PluginID was already loaded.
    if (pluginID != -1) ((CMumbleCommandServer*)CEngine::getInstance()->getExternalServer())->setCommandId(pluginID);
    if (activeConnection != -1) {
        // we are activating while connected, call it
        // virtualize a connect event
        onServerConnected(activeConnection);
    }

    return STATUS_OK;
}


void onServerConnected(mumble_connection_t connection) {
    activeConnection = connection;

    //
    // set ID on every new connection
    acre::id_t clientId = 0;
    //ts3Functions.getClientID(ts3Functions.getCurrentServerConnectionHandlerID(), (anyID*)& clientId);
    mumAPI.getLocalUserID(pluginID, activeConnection, (mumble_userid_t*)& clientId);
    CEngine::getInstance()->getSelf()->setId(clientId);

    // subscribe to all channels to receive event
    //ts3Functions.requestChannelSubscribeAll(ts3Functions.getCurrentServerConnectionHandlerID(), NULL);
    if (CEngine::getInstance()->getClient()->getState() != acre::State::running) {
        CEngine::getInstance()->getClient()->start(static_cast<acre::id_t>(id));
    }
}

void onServerDisconnected(mumble_connection_t connection) {
    activeConnection = -1;

    if (CEngine::getInstance()->getClient()->getState() != acre::State::stopped && CEngine::getInstance()->getClient()->getState() != acre::State::stopping) {
        CEngine::getInstance()->getClient()->stop();
    }
}

void shutdown() {
    if (CEngine::getInstance()->getClient()->getState() != acre::State::stopped && CEngine::getInstance()->getClient()->getState() != acre::State::stopping) {
        CEngine::getInstance()->getClient()->stop();
    }
    CEngine::getInstance()->stop();
}
