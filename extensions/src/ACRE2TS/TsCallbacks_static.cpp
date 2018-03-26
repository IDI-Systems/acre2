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

const int8_t* ts3plugin_commandKeyword() {
    return ACRE_COMMAND_KEYWORD;
}
int32_t ts3plugin_requestAutoload() {
    return 1; 
}

const int8_t* ts3plugin_infoTitle() {
    return ACRE_NAME;
}

void ts3plugin_infoData(uint64_t serverConnectionHandlerID, uint64_t id, enum PluginItemType type, int8_t** data) {
    /*serverConnectionHandlerID = serverConnectionHandlerID;
    data = data;
    type = type;
    id = id;*/

    bool noAcre = false;
    int8_t *metaData;

    switch(type) {
        case PLUGIN_SERVER:
            break;
        case PLUGIN_CHANNEL:
            break;
        case PLUGIN_CLIENT:
            if (ts3Functions.getClientVariableAsString(serverConnectionHandlerID, (anyID)id, CLIENT_META_DATA, &metaData) == ERROR_ok) {
                if (!metaData) { 
                    noAcre = true;
                }
                int metaDataLength = strlen(metaData);
                if (metaDataLength < 3 || metaDataLength > (INFODATA_BUFSIZE - 2)) {
                    noAcre = true;
                }
                *data = (int8_t*)malloc(INFODATA_BUFSIZE * sizeof(int8_t)); 
                if (!noAcre) {
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

int ts3plugin_onServerErrorEvent(uint64_t serverConnectionHandlerID, const int8_t* errorMessage, unsigned int error, const int8_t* returnCode, const int8_t* extraMessage) {

    return 0;  /* If no plugin return code was used, the return value of this function is ignored */
}
