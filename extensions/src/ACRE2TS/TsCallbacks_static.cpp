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

    switch(type) {
        case PLUGIN_SERVER:
            break;
        case PLUGIN_CHANNEL:
            break;
        case PLUGIN_CLIENT:
            if(ts3Functions.getClientVariableAsString(serverConnectionHandlerID, (anyID)id, CLIENT_META_DATA, &metaData) == ERROR_ok) {
                if(!metaData) { 
                    noAcre = TRUE;
                }
                if(strlen(metaData) < 3) {
                    noAcre = TRUE;
                }
                *data = (char*)malloc(INFODATA_BUFSIZE * sizeof(char)); 
                if(!noAcre) {
                    _snprintf_s(*data, INFODATA_BUFSIZE,INFODATA_BUFSIZE, "%s\n", metaData);
                    ts3Functions.freeMemory(metaData);
                } else {
                    _snprintf_s(*data, INFODATA_BUFSIZE,INFODATA_BUFSIZE, "NO ACRE");
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