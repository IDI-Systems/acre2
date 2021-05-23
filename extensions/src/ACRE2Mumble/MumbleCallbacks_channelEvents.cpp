#include "AcreSettings.h"
#include "Engine.h"
#include "Log.h"
#include "MumbleFunctions.h"
#include "Types.h"
#include "compat.h"

extern MumbleAPI_v_1_0_x mumAPI;
extern mumble_connection_t activeConnection;
extern plugin_id_t pluginID;

void mumble_onChannelRenamed(mumble_connection_t connection, mumble_channelid_t channelID) {
    (void) connection;
    (void) channelID;
    CEngine::getInstance()->getClient()->updateShouldSwitchChannel(true);
}
