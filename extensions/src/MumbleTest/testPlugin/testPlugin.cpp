// Copyright 2019-2020 The Mumble Developers. All rights reserved.
// Use of this source code is governed by a BSD-style license
// that can be found in the LICENSE file at the root of the
// Mumble source tree or at <https://www.mumble.info/LICENSE>.

// Include the definitions of the plugin functions
// Not that this will also include ../PluginComponents.h
#include "../MumblePlugin.h"
#include "../MumbleAPI.h"

#include <iostream>
#include <cstring>

// These are just some utility functions facilitating writing logs and the like
// The actual implementation of the plugin is further down
std::ostream& pLog() {
	std::cout << "TestPlugin: ";
	return std::cout;
}

template<typename T>
void pluginLog(T log) {
	pLog() << log << std::endl;
}

std::ostream& operator<<(std::ostream& stream, const version_t version) {
	stream << "v" << version.major << "." << version.minor << "." << version.patch;
	return stream;
}


//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////
//////////////////// PLUGIN IMPLEMENTATION ///////////////////
//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////

MumbleAPI mumAPI;
mumble_connection_t activeConnection;
plugin_id_t ownID;

//////////////////////////////////////////////////////////////
//////////////////// OBLIGATORY FUNCTIONS ////////////////////
//////////////////////////////////////////////////////////////
// All of the following function must be implemented in order for Mumble to load the plugin

mumble_error_t mumble_init(mumble_connection_t connection) {
	pluginLog("Initialized plugin");

	// Print the connection ID at initialization. If not connected to a server it should be -1.
	pLog() << "Connection ID at initialization: " << connection << std::endl;

	// STATUS_OK is a macro set to the appropriate status flag (ErrorCode)
	// If you need to return any other status have a look at the ErrorCode enum
	// inside PluginComponents.h and use one of its values
	return STATUS_OK;
}

void mumble_shutdown() {
	pluginLog("Shutdown plugin");

	mumAPI.log(ownID, "Shutdown");
}

const char* mumble_getName() {
	// The pointer returned by this functions has to remain valid forever and it must be able to return
	// one even if the plugin hasn't loaded (yet). Thus it may not require any variables that are only set
	// once the plugin is initialized
	// For most cases returning a hard-coded String-literal should be what you aim for
	return "TestPlugin";
}

version_t mumble_getAPIVersion() {
	// MUMBLE_PLUGIN_API_VERSION will always contain the API version of the used header file (the one used to build
	// this plugin against). Thus you should always return that here in order to no have to worry about it.
	return MUMBLE_PLUGIN_API_VERSION;
}

void mumble_registerAPIFunctions(MumbleAPI api) {
	// In this function the plugin is presented with a struct of function pointers that can be used
	// to interact with Mumble. Thus you should store it somewhere safe for later usage.
	mumAPI = api;

	pluginLog("Registered Mumble's API functions");

	mumAPI.log(ownID, "Received API functions");
}


//////////////////////////////////////////////////////////////
///////////////////// OPTIONAL FUNCTIONS /////////////////////
//////////////////////////////////////////////////////////////
// The implementation of below functions is optional. If you don't need them, don't include them in your
// plugin

void mumble_setMumbleInfo(version_t mumbleVersion, version_t mumbleAPIVersion, version_t minimalExpectedAPIVersion) {
	// this function will always be the first one to be called. Even before init()
	// In here you can get info about the Mumble version this plugin is about to run in.
	pLog() << "Mumble version: " << mumbleVersion << "; Mumble API-Version: " << mumbleAPIVersion << "; Minimal expected API-Version: "
		<< minimalExpectedAPIVersion << std::endl;
}

version_t mumble_getVersion() {
	// Mumble uses semantic versioning (see https://semver.org/)
	// { major, minor, patch }
	return { 1, 0, 0 };
}

const char* mumble_getAuthor() {
	// For the returned pointer the same rules as for getName() apply
	// In short: in the vast majority of cases you'll want to return a hard-coded String-literal
	return "MumbleDevelopers";
}

const char* mumble_getDescription() {
	// For the returned pointer the same rules as for getName() apply
	// In short: in the vast majority of cases you'll want to return a hard-coded String-literal
	return "This plugin is merely a reference implementation without any real functionality. It shouldn't be included in the release build of Mumble";
}

void mumble_registerPluginID(plugin_id_t id) {
	// This ID serves as an identifier for this plugin as far as Mumble is concerned
	// It might be a good idea to store it somewhere for later use
	pLog() << "Registered ID: " << id << std::endl;

	ownID = id;
}

uint32_t mumble_getFeatures() {
	// Tells Mumble whether this plugin delivers some known common functionality. See the PluginFeature enum in
	// PluginComponents.h for what is available.
	// If you want your plugin to deliver positional data, you'll want to return FEATURE_POSITIONAL
	return FEATURE_NONE;
}

uint32_t mumble_deactivateFeatures(uint32_t features) {
	pLog() << "Asked to deactivate feature set " << features << std::endl;

	// All features that can't be deactivated should be returned
	return features;
}

uint8_t mumble_initPositionalData(const char **programNames, const uint64_t *programPIDs, size_t programCount) {
	std::ostream& stream = pLog() << "Got " << programCount << " programs to init positional data.";

	if (programCount > 0) {
		stream << " The first name is " << programNames[0] << " and has PID " << programPIDs[0];
	}

	stream << std::endl;

	// As this plugin doesn't provide PD, we return PDEC_ERROR_PERM to indicate that even in the future we won't do so
	// If your plugin is indeed delivering positional data but is only temporarily unaible to do so, return PDEC_ERROR_TEMP
	// and if you deliver PD and succeeded initializing return PDEC_OK.
	return PDEC_ERROR_PERM;
}

#define SET_TO_ZERO(name) name[0] = 0.0f; name[1] = 0.0f; name[2] = 0.0f
bool mumble_fetchPositionalData(float *avatarPos, float *avatarDir, float *avatarAxis, float *cameraPos, float *cameraDir,
			float *cameraAxis, const char **context, const char **identity) {
	pluginLog("Has been asked to deliver positional data");

	// If unable to provide positional data, this function should return false and reset all given values to 0/empty Strings
	SET_TO_ZERO(avatarPos);
	SET_TO_ZERO(avatarDir);
	SET_TO_ZERO(avatarAxis);
	SET_TO_ZERO(cameraPos);
	SET_TO_ZERO(cameraDir);
	SET_TO_ZERO(cameraAxis);
	*context = "";
	*identity = "";

	// This function returns whether it can continue to deliver positional data
	return false;
}

void mumble_shutdownPositionalData() {
	pluginLog("Shutting down positional data");
}

void mumble_onServerConnected(mumble_connection_t connection) {
	activeConnection = connection;

	pLog() << "Established server-connection with ID " << connection << std::endl;
}

void mumble_onServerDisconnected(mumble_connection_t connection) {
	activeConnection = -1;

	pLog() << "Disconnected from server-connection with ID " << connection << std::endl;
}

void mumble_onServerSynchronized(mumble_connection_t connection) {
	// The client has finished synchronizing with the server. Thus we can now obtain a list of all users on this server
	pLog() << "Server has finished synchronizing (ServerConnection: " << connection << ")" << std::endl ;

	size_t userCount;
	mumble_userid_t *userIDs;

	if (mumAPI.getAllUsers(ownID, activeConnection, &userIDs, &userCount) != STATUS_OK) {
		pluginLog("[ERROR]: Can't obtain user list");
		return;
	}

	pLog() << "There are " << userCount << " users on this server. Their names are:" << std::endl;

	for(size_t i=0; i<userCount; i++) {
		char *userName;
		mumAPI.getUserName(ownID, connection, userIDs[i], &userName);
		
		pLog() << "\t" << userName << std::endl;

		mumAPI.freeMemory(ownID, userName);
	}

	mumAPI.freeMemory(ownID, userIDs);

	mumble_userid_t localUser;
	if (mumAPI.getLocalUserID(ownID, activeConnection, &localUser) != STATUS_OK) {
		pluginLog("Failed to retrieve local user ID");
		return;
	}

	if (mumAPI.sendData(ownID, activeConnection, &localUser, 1, "Just a test", 12, "testMsg") == STATUS_OK) {
		pluginLog("Successfully sent plugin message");
	} else {
		pluginLog("Failed at sending message");
	}
}

void mumble_onChannelEntered(mumble_connection_t connection, mumble_userid_t userID, mumble_channelid_t previousChannelID, mumble_channelid_t newChannelID) {
	std::ostream& stream = pLog() << "User with ID " << userID << " entered channel with ID " << newChannelID << ".";

	// negative ID means that there was no previous channel (e.g. because the user just connected)
	if (previousChannelID >= 0) {
		stream << " He came from channel with ID " << previousChannelID << ".";
	}

	stream << " (ServerConnection: " << connection << ")" << std::endl;
}

void mumble_onChannelExited(mumble_connection_t connection, mumble_userid_t userID, mumble_channelid_t channelID) {
	pLog() << "User with ID " << userID << " has left channel with ID " << channelID << ". (ServerConnection: " << connection << ")" << std::endl;
}

void mumble_onUserTalkingStateChanged(mumble_connection_t connection, mumble_userid_t userID, talking_state_t talkingState) {
	std::ostream& stream = pLog() << "User with ID " << userID << " changed his talking state to ";

	// The possible values are contained in the TalkingState enum inside PluginComponent.h
	switch(talkingState) {
		case INVALID:
			stream << "Invalid";
			break;
		case PASSIVE:
			stream << "Passive";
			break;
		case TALKING:
			stream << "Talking";
			break;
		case WHISPERING:
			stream << "Whispering";
			break;
		case SHOUTING:
			stream << "Shouting";
			break;
		default:
			stream << "Unknown (" << talkingState << ")";
	}

	stream << ". (ServerConnection: " << connection << ")" << std::endl;
}

bool mumble_onAudioInput(short *inputPCM, uint32_t sampleCount, uint16_t channelCount, bool isSpeech) {
	pLog() << "Audio input with " << channelCount << " channels and " << sampleCount << " samples per channel encountered. IsSpeech: "
		<< isSpeech << std::endl;

	// mark inputPCM as unused
	(void) inputPCM;

	// This function returns whether it has modified the audio stream
	return false;
}

bool mumble_onAudioSourceFetched(float *outputPCM, uint32_t sampleCount, uint16_t channelCount, bool isSpeech, mumble_userid_t userID) {
	std::ostream& stream = pLog() << "Audio output source with " << channelCount << " channels and " << sampleCount << " samples per channel fetched.";

	if (isSpeech) {
		stream << " The output is speech from user with ID " << userID << ".";
	}

	stream << std::endl;

	// Mark ouputPCM as unused
	(void) outputPCM;

	// This function returns whether it has modified the audio stream
	return false;
}

bool mumble_onAudioOutputAboutToPlay(float *outputPCM, uint32_t sampleCount, uint16_t channelCount) {
	pLog() << "The resulting audio output has " << channelCount << " channels with " << sampleCount << " samples per channel" << std::endl;

	// mark outputPCM as unused
	(void) outputPCM;

	// This function returns whether it has modified the audio stream
	return false;
}

bool mumble_onReceiveData(mumble_connection_t connection, mumble_userid_t sender, const char *data, size_t dataLength, const char *dataID) {
	pLog() << "Received data with ID \"" << dataID << "\" from user with ID " << sender << ". Its length is " << dataLength
		<< ". (ServerConnection:" << connection << ")" << std::endl;

	if (std::strcmp(dataID, "testMsg") == 0) {
		pLog() << "The received data: " << data << std::endl;
	}

	// This function returns whether it has processed the data (preventing further plugins from seeing it)
	return false;
}

void mumble_onUserAdded(mumble_connection_t connection, mumble_userid_t userID) {
	pLog() << "Added user with ID " << userID << " (ServerConnection: " << connection << ")" << std::endl;
}

void mumble_onUserRemoved(mumble_connection_t connection, mumble_userid_t userID) {
	pLog() << "Removed user with ID " << userID << " (ServerConnection: " << connection << ")" << std::endl;
}

void mumble_onChannelAdded(mumble_connection_t connection, mumble_channelid_t channelID) {
	pLog() << "Added channel with ID " << channelID << " (ServerConnection: " << connection << ")" << std::endl;
}

void mumble_onChannelRemoved(mumble_connection_t connection, mumble_channelid_t channelID) {
	pLog() << "Removed channel with ID " << channelID << " (ServerConnection: " << connection << ")" << std::endl;
}

void mumble_onChannelRenamed(mumble_connection_t connection, mumble_channelid_t channelID) {
	pLog() << "Renamed channel with ID " << channelID << " (ServerConnection: " << connection << ")" << std::endl;
}

void mumble_onKeyEvent(uint32_t keyCode, bool wasPress) {
	pLog() << "Encountered key " << (wasPress ? "press" : "release") << " of key with code " << keyCode << std::endl;
}

bool mumble_hasUpdate() {
	// This plugin never has an update
	return false;
}

bool mumble_getUpdateDownloadURL(char *buffer, uint16_t bufferSize, uint16_t offset) {
	static std::string url = "https://i.dont.exist/testplugin.zip";

	size_t writtenChars = url.copy(buffer, bufferSize, offset);

	if (writtenChars < bufferSize) {
		// URL has fit into the buffer -> append null byte and be done with it
		buffer[writtenChars] = '\0';
		return true;
	} else {
		std::cout << "Overflow" << std::endl;
		return false;
	}
}
