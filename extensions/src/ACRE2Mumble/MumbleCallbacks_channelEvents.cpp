#include "compat.h"



#include "Log.h"

#include "Engine.h"
#include "Types.h"
#include "AcreSettings.h"
#include "MumbleFunctions.h"

extern MumbleAPI mumAPI;
extern mumble_connection_t activeConnection;
extern plugin_id_t pluginID;
//extern TS3Functions ts3Functions;
/*
//
// Handle move events for silencing
//
//void ts3plugin_onClientMoveEvent(uint64 serverConnectionHandlerID, anyID clientID, uint64 oldChannelID, uint64 newChannelID, int visibility, const char* moveMessage) {
void mumble_onChannelEntered(mumble_connection_t connection, mumble_userid_t userID, mumble_channelid_t previousChannelID, mumble_channelid_t newChannelID) {
    // Only unmute if teamspeak is not linked to ARMA.
    if (!CAcreSettings::getInstance()->getDisableUnmuteClients() && !(CEngine::getInstance()->getGameServer()->getConnected())) {
        
        // Get local client ID
        mumble_userid_t myID;
        
        //if (ts3Functions.getClientID(serverConnectionHandlerID, &myID) != ERROR_ok) {
        if (mumAPI.getLocalUserID(pluginID, activeConnection, &myID) != STATUS_OK) {
            return; // Exit if we don't
        }

        //Unmute all clients if local user moves.
        if (userID == myID) {
            mumble_userid_t* clientsInChannel;
            std::size_t userCount = 0U;
            //if (ts3Functions.getChannelClientList(serverConnectionHandlerID, newChannelID, &clientsInChannel) == ERROR_ok) {
            if (mumAPI.getUsersInChannel(pluginID, activeConnection, newChannelID, &clientsInChannel, &userCount) {
                // Unmute clients in the current channel. Not Supported in mumble.
                // ts3Functions.requestUnmuteClients(serverConnectionHandlerID, clientsInChannel, NULL);
            }
            mumAPI.freeMemory(pluginID, (void *) &clientsInChannel);
        } else {
            //Only unmute joining user when not current client.
            mumble_userid_t clientIDArray[2]; // List of clients to unmute.
            clientIDArray[0] = userID; // Client ID to unmute
            clientIDArray[1] = 0; // Mark end of array with a 0 value.
            //ts3Functions.requestUnmuteClients(serverConnectionHandlerID, clientIDArray, NULL);
        }
    }

}

//void ts3plugin_onClientMoveMovedEvent(uint64 serverConnectionHandlerID, anyID clientID, uint64 oldChannelID, uint64 newChannelID, int visibility, anyID moverID, const char* moverName, const char* moverUniqueIdentifier, const char* moveMessage) {
void mumble_onChannelEntered(mumble_connection_t connection, mumble_userid_t userID, mumble_channelid_t previousChannelID, mumble_channelid_t newChannelID) {
    // Only unmute if teamspeak is not linked to ARMA.
    if (!CAcreSettings::getInstance()->getDisableUnmuteClients() && !(CEngine::getInstance()->getGameServer()->getConnected())) {

        // Get local client ID
        mumble_userid_t myID;

        //if (ts3Functions.getClientID(serverConnectionHandlerID, &myID) != ERROR_ok) {
        if(mumAPI.getLocalUserID(pluginID, activeConnection, &myID) != STATUS_OK) {
            return; // Exit if we don't
        }

        //Unmute all clients if local user moves.
        if (userID == myID) {
            mumble_userid_t* clientsInChannel;
            std::size_t userCount = 0U;
            // if (ts3Functions.getChannelClientList(serverConnectionHandlerID, newChannelID, &clientsInChannel) == ERROR_ok) {
            if (mumAPI.getUsersInChannel(pluginID, activeConnection, newChannelID, &clientsInChannel, &userCount) {
                // Unmute clients in the current channel. Not Supported in mumble.
                ts3Functions.requestUnmuteClients(serverConnectionHandlerID, clientsInChannel, NULL);
            }
            ts3Functions.freeMemory(clientsInChannel);
        } else {
            //Only unmute joining user when not current client.
            mumble_userid_t clientIDArray[2]; // List of clients to unmute.
            clientIDArray[0] = userID; // Client ID to unmute
            clientIDArray[1] = 0; // Mark end of array with a 0 value.
            //ts3Functions.requestUnmuteClients(serverConnectionHandlerID, clientIDArray, NULL);
        }
    }
}
*/

// void ts3plugin_onUpdateChannelEditedEvent(uint64 serverConnectionHandlerID, uint64 channelID, anyID invokerID, const char* invokerName, const char* invokerUniqueIdentifier) {
void mumble_onChannelRenamed(mumble_connection_t connection, mumble_channelid_t channelID) {
    (void)connection;
    (void)channelID;
    CEngine::getInstance()->getClient()->updateShouldSwitchChannel(true);
}
