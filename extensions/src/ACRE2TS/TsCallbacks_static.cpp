#include "compat.h"
#include "Types.h"
#include "Macros.h"
#include "Engine.h"
#include "Player.h"


#include "TsFunctions.h"

#ifdef USE_ACRE2UI
    #include "UiEngine.hpp"
#endif

#include "Log.h"

extern TS3Functions ts3Functions;

const char* ts3plugin_commandKeyword() {
    return ACRE_COMMAND_KEYWORD;
}
int ts3plugin_requestAutoload() {
    return 1;
}

const char* ts3plugin_infoTitle() {
    return ACRE_NAME;
}

void ts3plugin_infoData(uint64 serverConnectionHandlerID, uint64 id, enum PluginItemType type, char** data) {
    /*serverConnectionHandlerID = serverConnectionHandlerID;
    data = data;
    type = type;
    id = id;*/

    BOOL noAcre = FALSE;
    char *metaData;
    std::string result;
    std::string sharedMsg;

    switch(type) {
        case PLUGIN_SERVER:
            break;
        case PLUGIN_CHANNEL:
            break;
        case PLUGIN_CLIENT:
            // Some code used from https://github.com/michail-nikolaev/task-force-arma-3-radio under APL-SA
            if (ts3Functions.getClientVariableAsString(ts3Functions.getCurrentServerConnectionHandlerID(), (anyID)id, CLIENT_META_DATA, &metaData) == ERROR_ok) {
                if (!metaData) {
                    noAcre = TRUE;
                } else {
                    sharedMsg = metaData;
                    if (sharedMsg.find(START_DATA) == std::string::npos || sharedMsg.find(END_DATA) == std::string::npos) {
                        noAcre = TRUE;
                    } else {
                        result = sharedMsg.substr(sharedMsg.find(START_DATA) + strlen(START_DATA), sharedMsg.find(END_DATA) - sharedMsg.find(START_DATA) - strlen(START_DATA));
                    }
                }
                *data = (char*)malloc(INFODATA_BUFSIZE * sizeof(char));
                if (!noAcre) {
                    _snprintf_s(*data, INFODATA_BUFSIZE, INFODATA_BUFSIZE, "%s\n", result.c_str());
                    ts3Functions.freeMemory(metaData);
                } else {
                    _snprintf_s(*data, INFODATA_BUFSIZE, INFODATA_BUFSIZE, "NO ACRE");
                    ts3Functions.freeMemory(metaData);
                }
            }
            break;
        default:
            break;
    }
}

void ts3plugin_freeMemory(void* data) {
    free(data);
}
// add plugin configuration crap
int ts3plugin_offersConfigure() {
    return PLUGIN_OFFERS_NO_CONFIGURE;
}
void ts3plugin_configure(void* handle, void* qParentWidget) {

}

int ts3plugin_onServerErrorEvent(uint64 serverConnectionHandlerID, const char* errorMessage, unsigned int error, const char* returnCode, const char* extraMessage) {

    return 0;  /* If no plugin return code was used, the return value of this function is ignored */
}
