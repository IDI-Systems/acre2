#include "compat.h"

#include "public_errors.h"
#include "public_definitions.h"
#include "public_rare_definitions.h"
#include "ts3_functions.h"

#include "Log.h"

#include "TsCallbacks.h"

//
// Handle move events for silencing
//
void ts3plugin_onClientMoveEvent(uint64 serverConnectionHandlerID, anyID clientID, uint64 oldChannelID, uint64 newChannelID, int visibility, const char* moveMessage) {

}
