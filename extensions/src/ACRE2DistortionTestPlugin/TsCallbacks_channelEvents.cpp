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
void ts3plugin_onClientMoveEvent(uint64 serverConnectionHandlerID, anyID clientID, uint64 oldChannelID, uint64 newChannelID, int visibility, const char* moveMessage) {
    
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

void ts3plugin_onClientMoveMovedEvent(uint64 serverConnectionHandlerID, anyID clientID, uint64 oldChannelID, uint64 newChannelID, int visibility, anyID moverID, const char* moverName, const char* moverUniqueIdentifier, const char* moveMessage) {
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

void ts3plugin_onUpdateChannelEditedEvent(uint64 serverConnectionHandlerID, uint64 channelID, anyID invokerID, const char* invokerName, const char* invokerUniqueIdentifier) {
    CEngine::getInstance()->getClient()->updateShouldSwitchTS3Channel(true);
}
