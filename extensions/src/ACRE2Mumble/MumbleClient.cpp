#include "compat.h"

#include "MumbleClient.h"
#include "Engine.h"
#include "Types.h"
#include "MumbleFunctions.h"
#include "shlobj.h"
#include "Shlwapi.h"
#include "Log.h"

#include "AcreSettings.h"

#pragma comment(lib, "Shlwapi.lib")

#define INVALID_MUMBLE_CHANNEL -1
#define DEFAULT_MUMBLE_CHANNEL "ACRE"

extern MumbleAPI mumAPI;
extern mumble_connection_t activeConnection;
extern plugin_id_t pluginID;
//TS3Functions CMumbleClient::ts3Functions;

acre::Result CMumbleClient::initialize(void) {
    setPreviousChannel(INVALID_MUMBLE_CHANNEL);
    return acre::Result::ok;
}

acre::Result CMumbleClient::setMuted(const acre::id_t id_, const bool muted_) {
    (void)id_;
    (void)muted_;
    return acre::Result::ok;
}

acre::Result CMumbleClient::setMuted(std::list<acre::id_t> idList_, bool muted_) {
    (void)idList_;
    (void)muted_;
    return acre::Result::ok;
}

acre::Result CMumbleClient::getMuted(acre::id_t id_) {
    (void)id_;
    return acre::Result::ok;
}

acre::Result CMumbleClient::stop() {
    if (CEngine::getInstance() != nullptr) {
        CEngine::getInstance()->stop();
        this->setState(acre::State::stopping);
        if (this->m_versionThreadHandle.joinable()) {
            this->m_versionThreadHandle.join();
        }
        this->setState(acre::State::stopped);

    }
    return acre::Result::ok;
}

acre::Result CMumbleClient::start(const acre::id_t id_) {
    CEngine::getInstance()->start(id_);
    this->setInputActive(false);
    this->setDirectFirst(false);
    this->setMainPTTDown(false);
    this->setRadioPTTDown(false);
    this->setIntercomPTTDown(false);
    this->setHitTSSpeakingEvent(false);
    this->setOnRadio(false);
    this->setState(acre::State::running);
    this->setIsX3DInitialized(false);

    //this->m_versionThreadHandle = std::thread(&CMumbleClient::exPersistVersion, this);

    return acre::Result::ok;
}

/*
acre::Result CMumbleClient::exPersistVersion( void ) {

    CMumbleClient::setClientMetadata(ACRE_VERSION_METADATA);

    ts3Functions.printMessageToCurrentTab("ACRE2 loaded and initialized");
    ts3Functions.printMessageToCurrentTab(ACRE_VERSION_METADATA);

    clock_t run = clock() / CLOCKS_PER_SEC;
    clock_t delta = run;
    while (this->getState() == acre::State::running && CEngine::getInstance()->getExternalServer()) {

        delta = (clock() / CLOCKS_PER_SEC) - run;
        if (delta > (PERSIST_VERSION_TIMER / 1000) ) {
            char selfVariableBuffer[4096];
            if (CEngine::getInstance()->getGameServer()->getConnected()) {
                _snprintf_s(selfVariableBuffer, 4094, "%s\nArma Connected: Yes", ACRE_VERSION_METADATA);
            } else {
                _snprintf_s(selfVariableBuffer, 4094, "%s\nArma Connected: No", ACRE_VERSION_METADATA);
            }
            CMumbleClient::setClientMetadata(selfVariableBuffer);
            run = clock() / CLOCKS_PER_SEC;
        }

        Sleep(100);
    }

    return acre::Result::error;
}


acre::Result CMumbleClient::setClientMetadata(const char *const data) {
    char* clientInfo;
    anyID myID;
    ts3Functions.getClientID(ts3Functions.getCurrentServerConnectionHandlerID(), &myID);
    ts3Functions.getClientVariableAsString(ts3Functions.getCurrentServerConnectionHandlerID(), myID, CLIENT_META_DATA, &clientInfo);
    std::string to_set;
    std::string_view sharedMsg = clientInfo;
    const size_t start_pos = sharedMsg.find(START_DATA);
    const size_t end_pos = sharedMsg.find(END_DATA);
    if ((start_pos == std::string::npos) || (end_pos == std::string::npos)) {
        to_set = to_set + START_DATA + data + END_DATA;
    } else {
        const std::string before = (std::string)sharedMsg.substr(0, start_pos);
        const std::string after = (std::string)sharedMsg.substr(end_pos + strlen(END_DATA), std::string::npos);
        to_set = before + START_DATA + data + END_DATA + after;
    }
    ts3Functions.setClientSelfVariableAsString(ts3Functions.getCurrentServerConnectionHandlerID(), CLIENT_META_DATA, to_set.c_str());
    ts3Functions.freeMemory(clientInfo);
    ts3Functions.flushClientSelfUpdates(ts3Functions.getCurrentServerConnectionHandlerID(), nullptr);
    return acre::Result::ok;
}
*/

bool CMumbleClient::getVAD() {
    transmission_mode_t transmitMode;
    const mumble_error_t err = mumAPI.getLocalUserTransmissionMode(pluginID, &transmitMode);
    if (err != ErrorCode::EC_OK) {
        return false;
    }

    return transmitMode == TransmissionMode::TM_VOICE_ACTIVATION;
}

acre::Result CMumbleClient::localStartSpeaking(const acre::Speaking speakingType_) {
    this->localStartSpeaking(speakingType_, "");
    return acre::Result::ok;
}

acre::Result CMumbleClient::localStartSpeaking(const acre::Speaking speakingType_, std::string radioId_) {
    bool stopDirectSpeaking = false;

    /* Open or close the microphone. If the microphone is still active, stop direct speaking before
     * starting the new PTT method: radio speaking. In theory this would not be needed for intercom since
     * at the moment it is a direct speak with audio effect. However, it is planned to have intercoms converted
     * to components and unique IDs.
     */
    if ((speakingType_ == acre::Speaking::radio) || (speakingType_ == acre::Speaking::intercom)) {
        if (speakingType_ == acre::Speaking::radio) {
            this->setRadioPTTDown(true);
            this->setOnRadio(true);
        } else {
            this->setIntercomPTTDown(true);
        }

        if (!this->getVAD()) {
            if (!this->getDirectFirst()) {
                this->microphoneOpen(true);
            } else {
                stopDirectSpeaking = true;
            }
        } else if (this->getVAD() && (this->getSpeakingState() != TalkingState::PASSIVE && this->getSpeakingState() != TalkingState::INVALID)) {
            stopDirectSpeaking = true;
        }
    }

    if (stopDirectSpeaking) {
        CEngine::getInstance()->localStopSpeaking();
    }
    CEngine::getInstance()->localStartSpeaking(speakingType_, radioId_);
    return acre::Result::ok;
}

acre::Result CMumbleClient::localStopSpeaking(const acre::Speaking speakingType_) {
    bool resendDirectSpeaking = false;
    switch (speakingType_) {
        case acre::Speaking::direct:
            if (!this->getVAD()) {
                this->microphoneOpen(false);
            }
            break;
        case acre::Speaking::radio:
            this->setRadioPTTDown(false);
            break;
        case acre::Speaking::intercom:
            this->setIntercomPTTDown(false);
            break;
        case acre::Speaking::unknown:
            this->setRadioPTTDown(false);
            this->setIntercomPTTDown(false);
            break;
        default:
            break;
    }

    if (this->getOnRadio()) {
        if (!this->getVAD()) {
            if ((speakingType_ == acre::Speaking::radio) && this->getDirectFirst()) {
                this->setOnRadio(false);
                resendDirectSpeaking = true;
            } else {
                if (!CEngine::getInstance()->getClient()->getMainPTTDown()) {
                    this->microphoneOpen(false);
                } else {
                    resendDirectSpeaking = true;
                }
            }
        } else {
            this->setOnRadio(false);
            if (this->getSpeakingState() == 1) {
                resendDirectSpeaking = true;
            }
        }
    } else if (speakingType_ == acre::Speaking::intercom) {
        if (!this->getVAD()) {
            if (!CEngine::getInstance()->getClient()->getIntercomPTTDown()) {
                this->microphoneOpen(false);
            } else {
                resendDirectSpeaking = true;
            }
        } else if (this->getSpeakingState() == 1) {
             resendDirectSpeaking = true;
        }
    }

    CEngine::getInstance()->localStopSpeaking();
    if (resendDirectSpeaking) {
        CEngine::getInstance()->localStartSpeaking(acre::Speaking::direct);
    }

    return acre::Result::ok;
}

acre::Result CMumbleClient::enableMicrophone(const bool status_) {
    (void)status_;
    return acre::Result::ok;
}


acre::Result CMumbleClient::playSound(std::string path_, acre::vec3_fp32_t position_, const float32_t volume_, const int32_t looping_) {
    return acre::Result::ok;
}

std::string CMumbleClient::getUniqueId( ) {
    return "not used";
}

std::string CMumbleClient::getConfigFilePath(void) {
    std::string tempFolder = ".\\acre";
    if (!PathFileExistsA(tempFolder.c_str()) && !CreateDirectoryA(tempFolder.c_str(), nullptr)) {
        LOG("ERROR: UNABLE TO CREATE TEMP DIR");
    }

    return tempFolder;
}

std::string CMumbleClient::getTempFilePath( void ) {
    char tempPath[MAX_PATH - 14];
    GetTempPathA(sizeof(tempPath), tempPath);
    std::string tempFolder = std::string(tempPath);
    tempFolder.append("\\acre");
    if (!PathFileExistsA(tempFolder.c_str()) && !CreateDirectoryA(tempFolder.c_str(), nullptr)) {
        LOG("ERROR: UNABLE TO CREATE TEMP DIR");
    }

    return tempFolder;
}

acre::Result CMumbleClient::microphoneOpen(bool status_) {
    if (status_) {
        const mumble_error_t res = mumAPI.requestMicrophoneActivationOvewrite(pluginID, true);
        if (res != ErrorCode::EC_OK) {
            LOG("Error toggling PTT Open\n");
            return acre::Result::error;
        }
        this->setInputActive(true);
    } else {
        const mumble_error_t res = mumAPI.requestMicrophoneActivationOvewrite(pluginID, false);
        if (res != ErrorCode::EC_OK) {
            LOG("Error toggling PTT Closed\n");
            return acre::Result::error;
        }
        this->setInputActive(false);
    }
    return acre::Result::ok;
}

acre::Result CMumbleClient::unMuteAll( void ) {
    return acre::Result::ok;
}

acre::Result CMumbleClient::moveToServerChannel() {

    if (!CAcreSettings::getInstance()->getDisableChannelSwitch()) {
        mumble_userid_t clientId;
        std::vector<std::string> details = getChannelDetails();

        //if (ts3Functions.getClientID(ts3Functions.getCurrentServerConnectionHandlerID(), &clientId) == ERROR_ok) {
        if (mumAPI.getLocalUserID(pluginID, activeConnection, &clientId) == STATUS_OK) {
            mumble_channelid_t currentChannelId = INVALID_MUMBLE_CHANNEL;
            //if (ts3Functions.getChannelOfClient(ts3Functions.getCurrentServerConnectionHandlerID(), clientId, &currentChannelId) == ERROR_ok && getPreviousChannel() == INVALID_MUMBLE_CHANNEL) {
            if ((mumAPI.getChannelOfUser(pluginID, activeConnection, clientId, &currentChannelId) == STATUS_OK)  && (getPreviousChannel() == INVALID_MUMBLE_CHANNEL)) {
                setPreviousChannel(currentChannelId);
            }

            const mumble_channelid_t channelId = static_cast<mumble_channelid_t>(findChannelByNames(details));
            if ((channelId != INVALID_MUMBLE_CHANNEL) && (channelId != currentChannelId)) {
                std::string password;
                if (details.at(1) != "" && details.at(0) != "") {
                    password = details.at(1);
                }

                //ts3Functions.requestClientMove(ts3Functions.getCurrentServerConnectionHandlerID(), clientId, channelId, password.c_str(), nullptr);
                mumAPI.requestUserMove(pluginID, activeConnection, clientId, channelId, password.c_str());
                
            }
        }
    }
    setShouldSwitchChannel(false);
  
    return acre::Result::ok;
}

acre::Result CMumbleClient::moveToPreviousChannel() {
  
    if (!CAcreSettings::getInstance()->getDisableChannelSwitch()) {
        mumble_userid_t clientId = -1;
        //if (ts3Functions.getClientID(ts3Functions.getCurrentServerConnectionHandlerID(), &clientId) == ERROR_ok) {
        if (mumAPI.getLocalUserID(pluginID, activeConnection, &clientId) == STATUS_OK) {
            mumble_channelid_t currentChannelId = INVALID_MUMBLE_CHANNEL;
            //if (ts3Functions.getChannelOfClient(ts3Functions.getCurrentServerConnectionHandlerID(), clientId, &currentChannelId) == ERROR_ok) {
            if (mumAPI.getChannelOfUser(pluginID, activeConnection, clientId,  &currentChannelId) == STATUS_OK) {
                const mumble_channelid_t channelId = static_cast<mumble_channelid_t>(getPreviousChannel());
                if (channelId != INVALID_MUMBLE_CHANNEL && channelId != currentChannelId) {
                    //ts3Functions.requestClientMove(ts3Functions.getCurrentServerConnectionHandlerID(), clientId, channelId, "", nullptr);
                    mumAPI.requestUserMove(pluginID, activeConnection, clientId, channelId, "");
                }
            }
        }
        setPreviousChannel(INVALID_MUMBLE_CHANNEL);
    }

    return acre::Result::ok;
}

uint64_t CMumbleClient::findChannelByNames(std::vector<std::string> details_) {
    
    mumble_channelid_t*channelList = nullptr;
    std::size_t channelCount = 0U;
    //if (ts3Functions.getChannelList(ts3Functions.getCurrentServerConnectionHandlerID(), &channelList) == ERROR_ok) {
    if (mumAPI.getAllChannels(pluginID, activeConnection, &channelList, &channelCount) == STATUS_OK) {
        mumble_channelid_t channelId = INVALID_MUMBLE_CHANNEL;
        mumble_channelid_t defaultChannelId = INVALID_MUMBLE_CHANNEL;
        std::map<mumble_channelid_t, std::string> channelMap;
        std::string name = details_.at(2);
        if (details_.at(0) != "") {
            name = details_.at(0);
        }
        while (*channelList) {
            channelId = *channelList;
            channelList++;
            char* channelName = nullptr;
            //if (ts3Functions.getChannelVariableAsString(ts3Functions.getCurrentServerConnectionHandlerID(), channelId, CHANNEL_NAME, &channelName) == ERROR_ok) {
            if (mumAPI.getChannelName(pluginID, activeConnection, channelId, &channelName) == STATUS_OK) {
                std::string channelNameString(channelName);
                if (channelNameString.find(DEFAULT_MUMBLE_CHANNEL) != -1 || (!details_.at(0).empty() && channelNameString == name)) {
                    if (channelNameString == DEFAULT_MUMBLE_CHANNEL) {
                        defaultChannelId = channelId;
                    }
                    channelMap.emplace(channelId, channelNameString);
                }
            }
        }

        mumAPI.freeMemory(pluginID, (void *) &channelList);

        mumble_channelid_t bestChannelId = INVALID_MUMBLE_CHANNEL;
        int32_t bestMatches = 0;
        int32_t bestDistance = 10;
        for (auto& element : channelMap) {
            std::string fullChannelName = element.second;
            // Full comparison
            if (fullChannelName.compare(name) == 0) {
                bestChannelId = element.first;
                break;
            }
            const std::string cleanChannelName = removeSubstrings(fullChannelName, DEFAULT_MUMBLE_CHANNEL);
            // Word comparison
            const int32_t matches = getWordMatches(cleanChannelName, name);
            if (matches > bestMatches) {
                bestMatches = matches;
                bestChannelId = element.first;
                continue;
            }
            // Char comparison
            const int32_t distance = levenshteinDistance(cleanChannelName, name);
            if (distance <= bestDistance) {
                bestDistance = distance;
                bestChannelId = element.first;
            }
        }
        if (bestChannelId == INVALID_MUMBLE_CHANNEL) {
            if (!details_.at(0).empty()) {
                details_.at(0) = "";
                bestChannelId = static_cast<mumble_channelid_t>(findChannelByNames(details_));
            } else if (defaultChannelId != INVALID_MUMBLE_CHANNEL) {
                bestChannelId = defaultChannelId;
            }
        }
        return bestChannelId;
    }
    
    return 0;
}

acre::Result CMumbleClient::updateChannelDetails(std::vector<std::string> details_) {
    setChannelDetails(details_);
    if (!details_.empty()) {
        updateShouldSwitchChannel(true);
    }
    return acre::Result::ok;
}

acre::Result CMumbleClient::updateShouldSwitchChannel(const bool state_) {
    setShouldSwitchChannel(state_);
    return acre::Result::ok;
}

bool CMumbleClient::shouldSwitchChannel() {
    return getShouldSwitchChannel();
}
