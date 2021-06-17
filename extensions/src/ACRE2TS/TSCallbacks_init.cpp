#include "compat.h"

#include "Log.h"
#include "Engine.h"
#include "TS3Client.h"
#include "CommandServer.h"
#include "TS3Client.h"
#include "helpers.h"

#include "TsFunctions.h"

#define FROM_PIPENAME   "\\\\.\\pipe\\acre_comm_pipe_fromTS"
#define TO_PIPENAME     "\\\\.\\pipe\\acre_comm_pipe_toTS"

extern TS3Functions ts3Functions;

extern "C" {
    // API Compatibility
    // v23
    uint8_t onPluginCommandEvent_v23;
}

//
// TS3 API Intializers
//

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

char *pluginID = NULL;
//
// Register the command engine - Seems to be called before ts3plugin_init in 3.1
//
void ts3plugin_registerPluginID(const char* commandID) {

    pluginID = _strdup(commandID);
    //LOG("Registered: [%s]", str);
    if (CEngine::getInstance() != NULL) {
        if (((CCommandServer *)CEngine::getInstance()->getExternalServer()) != NULL) {
            ((CCommandServer *)CEngine::getInstance()->getExternalServer())->setCommandId(pluginID);
        }
    }
}


//
// Init
//
int ts3plugin_init() {
    CEngine::getInstance()->initialize(new CTS3Client(), new CCommandServer(), FROM_PIPENAME, TO_PIPENAME);

    // if PluginID was already loaded.
    if (pluginID != NULL) ((CCommandServer *)CEngine::getInstance()->getExternalServer())->setCommandId(pluginID);
    if (ts3Functions.getCurrentServerConnectionHandlerID()) {
        // we are activating while connected, call it
        // virtualize a connect event
        ts3plugin_onConnectStatusChangeEvent(ts3Functions.getCurrentServerConnectionHandlerID(), STATUS_CONNECTION_ESTABLISHED, NULL);
    }


    return 0;
}

//
// server connect/disconnect
//
void ts3plugin_currentServerConnectionChanged(uint64 serverConnectionHandlerID) {
    //TRACE("currentServerConnectionChanged %llu (%llu)", (long long unsigned int)serverConnectionHandlerID, (long long unsigned int)ts3Functions.getCurrentServerConnectionHandlerID());
}

void ts3plugin_onConnectStatusChangeEvent(uint64 serverConnectionHandlerID, int status, unsigned int err) {

    if (status == STATUS_CONNECTION_ESTABLISHED) {


        //
        // set ID on every new connection
        acre::id_t clientId = 0;
        ts3Functions.getClientID(serverConnectionHandlerID, (anyID *)&clientId);
        CEngine::getInstance()->getSelf()->setId(clientId);

        // subscribe to all channels to receive event
        ts3Functions.requestChannelSubscribeAll(serverConnectionHandlerID, NULL);
        if (CEngine::getInstance()->getClient()->getState() != acre::State::running) {
            CEngine::getInstance()->getClient()->start(static_cast<acre::id_t>(serverConnectionHandlerID));
        }
    } else if (status == STATUS_DISCONNECTED) {
        if (CEngine::getInstance()->getClient()->getState() != acre::State::stopped  && CEngine::getInstance()->getClient()->getState() != acre::State::stopping) {
            CEngine::getInstance()->getClient()->stop();
        }
    }
}

//
// Shutdown
//
void ts3plugin_onPlaybackShutdownCompleteEvent(uint64) {

}

void ts3plugin_shutdown() {
    if (CEngine::getInstance()->getClient()->getState() != acre::State::stopped && CEngine::getInstance()->getClient()->getState() != acre::State::stopping) {
        CEngine::getInstance()->getClient()->stop();
    }
    CEngine::getInstance()->stop();
}
