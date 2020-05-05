#include "compat.h"

#include "Engine.h"

#include "Log.h"

#include "MumbleFunctions.h"



//
// Handle a command event
//
bool mumble_onReceiveData(mumble_connection_t connection, mumble_userid_t sender, const char* data, size_t dataLength,
    const char* dataID) {
    //LOG("[%s], [%s]", pluginName, pluginCommand);

    if ((dataLength > 0U) &&  CEngine::getInstance()->getExternalServer()) {
        CEngine::getInstance()->getExternalServer()->handleMessage((unsigned char *)data, dataLength);
        return true;
    }
    return false;
}
