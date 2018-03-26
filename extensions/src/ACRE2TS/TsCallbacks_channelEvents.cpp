#include "compat.h"

#include "public_errors.h"
#include "public_definitions.h"
#include "public_rare_definitions.h"
#include "ts3_functions.h"

#include "Log.h"

#include "TsCallbacks.h"

#include "Engine.h"
#include "Types.h"
#include "AcreSettings.h"

extern TS3Functions ts3Functions;

//
// Handle move events for silencing
//
void ts3plugin_onClientMoveEvent(const uint64_t serverConnectionHandlerID, anyID clientID, const uint64_t oldChannelID, const uint64_t newChannelID, int32_tvisibility, const int8_t* moveMessage) {
    
    // Only unmute if teamspeak is not linked to ARMA.
    if (!CAcreSettings::getInstance()->getDisableUnmuteClients() && !(CEngine::getInstance()->getGameServer()->getConnected())) {
        
        // Get local client ID
        anyID myID;
        
        if (ts3Functions.getClientID(serverConnectionHandlerID, &myID) != ERROR_ok) {
            return; // Exit if we don't
        }

        //Unmute all clients if local user moves.
        if (clientID == myID) {

            anyID* clientsInChannel;
            if (ts3Functions.getChannelClientList(serverConnectionHandlerID, newChannelID, &clientsInChannel) == ERROR_ok) {
                //Unmute clients in the current channel
                ts3Functions.requestUnmuteClients(serverConnectionHandlerID, clientsInChannel, NULL);
            }
            ts3Functions.freeMemory(clientsInChannel);
        } else {
            //Only unmute joining user when not current client.
            anyID clientIDArray[2]; // List of clients to unmute.
            clientIDArray[0] = clientID; // Client ID to unmute
            clientIDArray[1] = 0; // Mark end of array with a 0 value.
            ts3Functions.requestUnmuteClients(serverConnectionHandlerID, clientIDArray, NULL);
        }
    }

}

void ts3plugin_onClientMoveMovedEvent(const uint64_t serverConnectionHandlerID, anyID clientID, const uint64_t oldChannelID, const uint64_t newChannelID, int32_tvisibility, anyID moverID, const int8_t* moverName, const int8_t* moverUniqueIdentifier, const int8_t* moveMessage) {
    // Only unmute if teamspeak is not linked to ARMA.
    if (!CAcreSettings::getInstance()->getDisableUnmuteClients() && !(CEngine::getInstance()->getGameServer()->getConnected())) {

        // Get local client ID
        anyID myID;

        if (ts3Functions.getClientID(serverConnectionHandlerID, &myID) != ERROR_ok) {
            return; // Exit if we don't
        }

        //Unmute all clients if local user moves.
        if (clientID == myID) {

            anyID* clientsInChannel;
            if (ts3Functions.getChannelClientList(serverConnectionHandlerID, newChannelID, &clientsInChannel) == ERROR_ok) {
                //Unmute clients in the current channel
                ts3Functions.requestUnmuteClients(serverConnectionHandlerID, clientsInChannel, NULL);
            }
            ts3Functions.freeMemory(clientsInChannel);
        }
        else {
            //Only unmute joining user when not current client.
            anyID clientIDArray[2]; // List of clients to unmute.
            clientIDArray[0] = clientID; // Client ID to unmute
            clientIDArray[1] = 0; // Mark end of array with a 0 value.
            ts3Functions.requestUnmuteClients(serverConnectionHandlerID, clientIDArray, NULL);
        }
    }
}

void ts3plugin_onUpdateChannelEditedEvent(const uint64_t serverConnectionHandlerID, const uint64_t channelID, anyID invokerID, const int8_t* invokerName, const int8_t* invokerUniqueIdentifier) {
    CEngine::getInstance()->getClient()->updateShouldSwitchTS3Channel(true);
}
