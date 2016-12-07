#include "compat.h"

#include "public_errors.h"
#include "public_definitions.h"
#include "public_rare_definitions.h"
#include "ts3_functions.h"

#include "CommandServer.h"

#include "Log.h"

#include "TsCallbacks.h"


//
// Register the command engine
//
void ts3plugin_registerPluginID(const char* commandID) {
    char *str;
    
    str = _strdup(commandID);
    //LOG("Registered: [%s]", str);
    ((CCommandServer *)CEngine::getInstance()->getExternalServer())->setCommandId(str);
}

//
// Handle a command event
//
void ts3plugin_onPluginCommandEvent(uint64 serverConnectionHandlerID, const char* pluginName, const char* pluginCommand) {
    //LOG("[%s], [%s]", pluginName, pluginCommand);

    if (pluginName && pluginCommand) {
        // this we pass to a custom TS3 IServer to handle the damn messages
        if (strstr(pluginName, "acre2") != NULL && CEngine::getInstance()->getExternalServer() ) {
            CEngine::getInstance()->getExternalServer()->handleMessage((unsigned char *)pluginCommand);
        }
    }
}