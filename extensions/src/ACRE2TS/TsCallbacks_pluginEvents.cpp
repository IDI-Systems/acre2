#include "compat.h"

#include "teamspeak/public_errors.h"
#include "teamspeak/public_definitions.h"
#include "teamspeak/public_rare_definitions.h"
#include "ts3_functions.h"

#include "CommandServer.h"

#include "Log.h"

#include "TsCallbacks.h"



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
