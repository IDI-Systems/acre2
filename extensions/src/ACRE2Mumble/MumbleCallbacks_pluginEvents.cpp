#include "Engine.h"
#include "Log.h"
#include "MumbleFunctions.h"
#include "MumbleEventLoop.h"
#include "compat.h"

#include <Tracy.hpp>

//
// Handle a command event
//
bool mumble_onReceiveData(mumble_connection_t connection, mumble_userid_t sender, const uint8_t *data, size_t dataLength, const char *dataID) {
    ZoneScoped;

    if ((dataLength > 0U) && CEngine::getInstance()->getExternalServer()) {
        // Copy data to make sure it stays available in the async processing
        std::string dataString(reinterpret_cast<const char *>(data), dataLength);
        acre::MumbleEventLoop::getInstance().queue([dataString]() {
            ZoneScoped;

            CEngine::getInstance()->getExternalServer()->handleMessage((unsigned char *)dataString.data(), dataString.size());
        });
        return true;
    }
    return false;
}
