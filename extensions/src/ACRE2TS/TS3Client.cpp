#include "compat.h"

#include "TS3Client.h"
#include "Engine.h"
#include "Types.h"
#include "TsFunctions.h"
#include "shlobj.h"
#include "Shlwapi.h"
#include "Log.h"
#include <thread>
#include <exception>
#include <sstream>
#include <string>
#include <vector>
#include <numeric>

#include "AcreSettings.h"

#pragma comment(lib, "Shlwapi.lib")

#define INVALID_TS3_CHANNEL -1
#define DEFAULT_TS3_CHANNEL "ACRE"

extern TS3Functions ts3Functions;

//TS3Functions CTS3Client::ts3Functions;

acre::Result CTS3Client::initialize(void) {
    setPreviousTSChannel(INVALID_TS3_CHANNEL);
    return acre::Result::ok;
}

acre::Result CTS3Client::setMuted(const acre::id_t id_, const bool muted_) {
    anyID clientArray[2];

    clientArray[0] = static_cast<anyID>(id_);
    clientArray[1] = 0x0000;

    TRACE("MUTE: %d, %d", id_, muted_);

    if (muted_) {
        ts3Functions.requestMuteClients(ts3Functions.getCurrentServerConnectionHandlerID(), clientArray, NULL);
    } else {
        ts3Functions.requestUnmuteClients(ts3Functions.getCurrentServerConnectionHandlerID(), clientArray, NULL);
    }
    return acre::Result::ok;
}

acre::Result CTS3Client::setMuted(std::list<acre::id_t> idList_, bool muted_) {

    return acre::Result::ok;
}

acre::Result CTS3Client::getMuted(acre::id_t id_) {

    return acre::Result::ok;
}

acre::Result CTS3Client::stop() {
    if (CEngine::getInstance() != NULL) {
        CEngine::getInstance()->stop();
        this->setState(acre::State::stopping);
        if (this->m_versionThreadHandle.joinable()) {
            this->m_versionThreadHandle.join();
        }
        this->setState(acre::State::stopped);

    }
    return acre::Result::ok;
}

acre::Result CTS3Client::start(const acre::id_t id_) {
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

    this->m_versionThreadHandle = std::thread(&CTS3Client::exPersistVersion, this);

    return acre::Result::ok;
}

acre::Result CTS3Client::exPersistVersion( void ) {

    CTS3Client::setClientMetadata(ACRE_VERSION_METADATA);

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
            CTS3Client::setClientMetadata(selfVariableBuffer);
            run = clock() / CLOCKS_PER_SEC;
        }

        Sleep(100);
    }

    return acre::Result::error;
}

acre::Result CTS3Client::setClientMetadata(const char *const data) {
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
    ts3Functions.flushClientSelfUpdates(ts3Functions.getCurrentServerConnectionHandlerID(), NULL);
    return acre::Result::ok;
}

bool CTS3Client::getVAD() {
    char *data;
    bool returnValue = false;
    uint32_t res = ts3Functions.getPreProcessorConfigValue(ts3Functions.getCurrentServerConnectionHandlerID(), "vad", &data);
    if (!res) {
        if (!strcmp(data, "true")) {
            returnValue = true;
        }
        ts3Functions.freeMemory(data);
    }
    return returnValue;
}

acre::Result CTS3Client::localStartSpeaking(const acre::Speaking speakingType_) {
    this->localStartSpeaking(speakingType_, "");
    return acre::Result::ok;
}

acre::Result CTS3Client::localStartSpeaking(const acre::Speaking speakingType_, std::string radioId_) {
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
        } else if (this->getVAD() && (this->getTsSpeakingState() == STATUS_TALKING)) {
            stopDirectSpeaking = true;
        }
    }

    if (!this->getVAD() && speakingType_ == acre::Speaking::direct) {
        this->microphoneOpen(true);
    }

    if (stopDirectSpeaking) {
        CEngine::getInstance()->localStopSpeaking();
    }
    CEngine::getInstance()->localStartSpeaking(speakingType_, radioId_);
    return acre::Result::ok;
}

acre::Result CTS3Client::localStopSpeaking(const acre::Speaking speakingType_) {
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
                if (!((CTS3Client *) (CEngine::getInstance()->getClient()))->getMainPTTDown()) {
                    this->microphoneOpen(false);
                } else {
                    resendDirectSpeaking = true;
                }
            }
        } else {
            this->setOnRadio(false);
            if (this->getTsSpeakingState() == STATUS_TALKING) {
                resendDirectSpeaking = true;
            }
        }
    } else if (speakingType_ == acre::Speaking::intercom) {
        if (!this->getVAD()) {
            if (!((CTS3Client *) (CEngine::getInstance()->getClient()))->getIntercomPTTDown()) {
                this->microphoneOpen(false);
            } else {
                resendDirectSpeaking = true;
            }
        } else if (this->getTsSpeakingState() == STATUS_TALKING) {
             resendDirectSpeaking = true;
        }
    }

    CEngine::getInstance()->localStopSpeaking();
    if (resendDirectSpeaking) {
        CEngine::getInstance()->localStartSpeaking(acre::Speaking::direct);
    }

    return acre::Result::ok;
}

acre::Result CTS3Client::enableMicrophone(const bool status_) {
    bool currentStatus = this->getInputStatus();

    if (currentStatus != status_) {
        uint32_t res = 0u;
        if (status_) {
            res = ts3Functions.setClientSelfVariableAsInt(ts3Functions.getCurrentServerConnectionHandlerID(), CLIENT_INPUT_MUTED, MUTEINPUT_NONE);
            if (res != ERROR_ok) {
                char* errorMsg;
                if (ts3Functions.getErrorMessage(res, &errorMsg) == ERROR_ok) {
                    LOG("Error toggling microphone enabled: %s\n", errorMsg);
                    ts3Functions.freeMemory(errorMsg);
                }
                return acre::Result::ok;
            }
        } else {
            res = ts3Functions.setClientSelfVariableAsInt(ts3Functions.getCurrentServerConnectionHandlerID(), CLIENT_INPUT_MUTED, MUTEINPUT_MUTED);
            if (res != ERROR_ok) {
                char* errorMsg;
                if (ts3Functions.getErrorMessage(res, &errorMsg) == ERROR_ok) {
                    LOG("Error, failed to disable microphone input: %s\n", errorMsg);
                    ts3Functions.freeMemory(errorMsg);
                }
                return acre::Result::ok;
            }
        }
        res = ts3Functions.flushClientSelfUpdates(ts3Functions.getCurrentServerConnectionHandlerID(), NULL);
        if (!((res == ERROR_ok) || (res == ERROR_ok_no_update))) {
            char* errorMsg;
            if (ts3Functions.getErrorMessage(res, &errorMsg) == ERROR_ok) {
                LOG("STOP TALKING: Error flushing after toggling microphone muted: %s\n", errorMsg);
                ts3Functions.freeMemory(errorMsg);
            }
            return acre::Result::error;
        }
    }
    return acre::Result::ok;
}

bool CTS3Client::getInputStatus() {
    bool status = false;
    int32_t ret = 0u;
    uint32_t res = ts3Functions.getClientSelfVariableAsInt(ts3Functions.getCurrentServerConnectionHandlerID(), CLIENT_INPUT_MUTED, &ret);
    if (res != ERROR_ok) {
        char* errorMsg;
        if (ts3Functions.getErrorMessage(res, &errorMsg) == ERROR_ok) {
            LOG("Error querying microphone input status: %s\n", errorMsg);
            ts3Functions.freeMemory(errorMsg);
        }
        return false;
    }

    if (ret == MUTEINPUT_NONE) {
        status = true;
    }

    return status;
}

acre::Result CTS3Client::playSound(std::string path_, acre::vec3_fp32_t position_, const float32_t volume_, const int32_t looping_) {

    if (!PathFileExistsA(path_.c_str())) {
        return acre::Result::error;
    }

    char soundpackDb[32];
    uint32_t ret = 0u;
    uint32_t res = ts3Functions.getClientSelfVariableAsInt(ts3Functions.getCurrentServerConnectionHandlerID(), CLIENT_OUTPUT_MUTED, (int32_t *) &ret);
    if (res != ERROR_ok) {
        char* errorMsg;
        if (ts3Functions.getErrorMessage(res, &errorMsg) == ERROR_ok) {
            LOG("Error checking playback status: %s\n", errorMsg);
            ts3Functions.freeMemory(errorMsg);
        }
        return acre::Result::error;
    }

    if (ret > 0) {
        return acre::Result::ok;
    }

    // create a volume ranged from -40 to 0dB change
    _snprintf_s(soundpackDb, 32, "%f", (-40.0f + (40.0f * volume_) ) );
    // change the soundpack volume for this squawks volume
    ts3Functions.setPlaybackConfigValue(ts3Functions.getCurrentServerConnectionHandlerID(),
        "volume_factor_wave",
        soundpackDb);

    TS3_VECTOR vector = {position_.x, position_.z, position_.y};

    TRACE("HIT [%f,%f,%f]", vector.x, vector.z, vector.y);
    uint64_t playHandle;
    ret = ts3Functions.playWaveFileHandle(ts3Functions.getCurrentServerConnectionHandlerID(),
        path_.c_str(),
        looping_,
        &playHandle);
    ret = ts3Functions.set3DWaveAttributes(ts3Functions.getCurrentServerConnectionHandlerID(),
        playHandle,
        &vector);
    return acre::Result::ok;
}

std::string CTS3Client::getUniqueId( ) {
    char *uniqueId;
    std::string serverUniqueId = "";

    uint32_t res = ts3Functions.getServerVariableAsString(ts3Functions.getCurrentServerConnectionHandlerID(), VIRTUALSERVER_UNIQUE_IDENTIFIER, &uniqueId);
    if (res == ERROR_ok) {
        serverUniqueId = std::string(uniqueId);
        if (uniqueId) {
            ts3Functions.freeMemory(uniqueId);
        }
    }
    return serverUniqueId;
}

std::string CTS3Client::getConfigFilePath(void) {
    char tempPath[MAX_PATH - 14];

    ts3Functions.getConfigPath(tempPath, MAX_PATH - 14);

    std::string tempFolder = std::string(tempPath);
    tempFolder += "\\acre";
    if (!PathFileExistsA(tempFolder.c_str())) {
        if (!CreateDirectoryA(tempFolder.c_str(), NULL)) {
            LOG("ERROR: UNABLE TO CREATE TEMP DIR");
        }
    }

    return tempFolder;
}

std::string CTS3Client::getTempFilePath( void ) {
    char tempPath[MAX_PATH - 14];
    GetTempPathA(sizeof(tempPath), tempPath);
    std::string tempFolder = std::string(tempPath);
    tempFolder += "\\acre";
    if (!PathFileExistsA(tempFolder.c_str())) {
        if (!CreateDirectoryA(tempFolder.c_str(), NULL)) {
            LOG("ERROR: UNABLE TO CREATE TEMP DIR");
        }
    }

    return tempFolder;
}

acre::Result CTS3Client::microphoneOpen(bool status_) {
    int32_t micStatus = INPUT_DEACTIVATED;
    if (status_) {
        micStatus = INPUT_ACTIVE;
        this->setInputActive(true);
    } else {
        this->setInputActive(false);
    }

    uint32_t res = ts3Functions.setClientSelfVariableAsInt(ts3Functions.getCurrentServerConnectionHandlerID(), CLIENT_INPUT_DEACTIVATED, micStatus);
    if (res != ERROR_ok) {
        char* errorMsg;
        if (ts3Functions.getErrorMessage(res, &errorMsg) == ERROR_ok) {
            LOG("STOP TALKING: Error toggling push-to-talk: %s\n", errorMsg);
            ts3Functions.freeMemory(errorMsg);
        }
        return acre::Result::error;
    }

    res = ts3Functions.flushClientSelfUpdates(ts3Functions.getCurrentServerConnectionHandlerID(), NULL);
    if (!(res == ERROR_ok || res == ERROR_ok_no_update)) {
        char* errorMsg;
        if (ts3Functions.getErrorMessage(res, &errorMsg) == ERROR_ok) {
            LOG("STOP TALKING: Error flushing after toggling push-to-talk: %s\n", errorMsg);
            ts3Functions.freeMemory(errorMsg);
        }
        return acre::Result::error;
    }
    return acre::Result::ok;
}

acre::Result CTS3Client::unMuteAll( void ) {
    anyID clientId;
    anyID *clientList;

    uint32_t total_retries = 0;
    uint32_t total_intentional_runs = 0;

    //for (total_intentional_runs = 0; total_intentional_runs < 3; total_intentional_runs++) {
        uint32_t res = ts3Functions.getClientID(ts3Functions.getCurrentServerConnectionHandlerID(), &clientId);
        if (res == ERROR_ok) {

            res = ERROR_undefined;
            for (total_retries = 0; (total_retries < 5) && (res != ERROR_ok); total_retries++) {
                res = ts3Functions.getClientList(ts3Functions.getCurrentServerConnectionHandlerID(), &clientList);
                if (res == ERROR_ok) {
                    res = ts3Functions.requestUnmuteClients(ts3Functions.getCurrentServerConnectionHandlerID(), clientList, NULL);
                    //if (res != ERROR_ok) {
                    //    Sleep(500 * total_retries);
                    //}
                    ts3Functions.freeMemory(clientList);
                }
            }

            /*
            /*    - This was the alternative method originally, but it was hitting the spam threshold */
            /* Disable this method
            res = ts3Functions.getClientList(ts3Functions.getCurrentServerConnectionHandlerID(), &clientList);
            if (res == ERROR_ok) {
                for (x=0;clientList[x]!=0 && total_retries < 20;x++) {
                    anyID tempList[2];
                    uint32_t tries_on_client;

                    tempList[0] = (anyID)clientList[x];
                    tempList[1] = 0x0000;

                    res = ts3Functions.requestUnmuteClients(ts3Functions.getCurrentServerConnectionHandlerID(), clientList, NULL);
                    for (tries_on_client = 0; tries_on_client < 5 && total_retries < 20 && res != ERROR_ok; tries_on_client++, total_retries++) {
                            res = ts3Functions.requestUnmuteClients(ts3Functions.getCurrentServerConnectionHandlerID(), tempList, NULL);
                            if (res != ERROR_ok) {
                                Sleep(500 * tries_on_client);
                            }
                    }
                }
                ts3Functions.freeMemory(clientList);
            }
            */
        }
    //    Sleep(500);
    //}
    return acre::Result::ok;
}

acre::Result CTS3Client::moveToServerTS3Channel() {
    if (!CAcreSettings::getInstance()->getDisableTS3ChannelSwitch()) {
        anyID clientId;
        std::vector<std::string> details = getTs3ChannelDetails();

        if (ts3Functions.getClientID(ts3Functions.getCurrentServerConnectionHandlerID(), &clientId) == ERROR_ok) {
            uint64_t currentChannelId = INVALID_TS3_CHANNEL;
            if (ts3Functions.getChannelOfClient(ts3Functions.getCurrentServerConnectionHandlerID(), clientId, &currentChannelId) == ERROR_ok && getPreviousTSChannel() == INVALID_TS3_CHANNEL) {
                setPreviousTSChannel(currentChannelId);
            }

            const uint64_t channelId = findChannelByNames(details);
            if ((channelId != INVALID_TS3_CHANNEL) && (channelId != currentChannelId)) {
                std::string password = "";
                if (details.at(1) != "" && details.at(0) != "") {
                    password = details.at(1);
                }
                ts3Functions.requestClientMove(ts3Functions.getCurrentServerConnectionHandlerID(), clientId, channelId, password.c_str(), nullptr);
            }
        }
    }
    setShouldSwitchTS3Channel(false);
    return acre::Result::ok;
}

acre::Result CTS3Client::moveToPreviousTS3Channel() {
    if (!CAcreSettings::getInstance()->getDisableTS3ChannelSwitch()) {
        anyID clientId;
        if (ts3Functions.getClientID(ts3Functions.getCurrentServerConnectionHandlerID(), &clientId) == ERROR_ok) {
            uint64_t currentChannelId = INVALID_TS3_CHANNEL;
            if (ts3Functions.getChannelOfClient(ts3Functions.getCurrentServerConnectionHandlerID(), clientId, &currentChannelId) == ERROR_ok) {
                const uint64_t channelId = getPreviousTSChannel();
                if (channelId != INVALID_TS3_CHANNEL && channelId != currentChannelId) {
                    ts3Functions.requestClientMove(ts3Functions.getCurrentServerConnectionHandlerID(), clientId, channelId, "", nullptr);
                }
            }
        }
        setPreviousTSChannel(INVALID_TS3_CHANNEL);
    }
    return acre::Result::ok;
}

uint64_t CTS3Client::findChannelByNames(std::vector<std::string> details_) {
    uint64_t *channelList;
    if (ts3Functions.getChannelList(ts3Functions.getCurrentServerConnectionHandlerID(), &channelList) == ERROR_ok) {
        uint64_t channelId = INVALID_TS3_CHANNEL;
        uint64_t defaultChannelId = INVALID_TS3_CHANNEL;
        std::map<uint64, std::string> channelMap;
        std::string name = details_.at(2);
        if (details_.at(0) != "") {
            name = details_.at(0);
        }
        while (*channelList) {
            channelId = *channelList;
            channelList++;
            char* channelName;
            if (ts3Functions.getChannelVariableAsString(ts3Functions.getCurrentServerConnectionHandlerID(), channelId, CHANNEL_NAME, &channelName) == ERROR_ok) {
                std::string channelNameString = std::string(channelName);
                if (channelNameString.find(DEFAULT_TS3_CHANNEL) != -1 || (details_.at(0) != "" && channelNameString == name)) {
                    if (channelNameString == DEFAULT_TS3_CHANNEL) {
                        defaultChannelId = channelId;
                    }
                    channelMap.emplace(channelId, channelNameString);
                }
            }
        }

        uint64_t bestChannelId = INVALID_TS3_CHANNEL;
        int32_t bestMatches = 0;
        int32_t bestDistance = 10;
        for (auto& element : channelMap) {
            std::string fullChannelName = element.second;
            // Full comparison
            if (fullChannelName.compare(name) == 0) {
                bestChannelId = element.first;
                break;
            }
            const std::string cleanChannelName = removeSubstrings(fullChannelName, DEFAULT_TS3_CHANNEL);
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
        if (bestChannelId == INVALID_TS3_CHANNEL) {
            if (details_.at(0) != "") {
                details_.at(0) = "";
                bestChannelId = findChannelByNames(details_);
            } else if (defaultChannelId != INVALID_TS3_CHANNEL) {
                bestChannelId = defaultChannelId;
            }
        }
        return bestChannelId;
    }
    return INVALID_TS3_CHANNEL;
}

unsigned int CTS3Client::getWordMatches(const std::string& string1_, const std::string& string2_) {
    std::vector<std::string> words1, words2;
    std::string temp;
    std::stringstream stringstream1(string1_);
    while (stringstream1 >> temp) {
        words1.push_back(temp);
    }
    std::stringstream stringstream2(string2_);
    while (stringstream2 >> temp) {
        words2.push_back(temp);
    }

    int32_t matches = 0;
    for (auto& word1 : words1) {
        for (auto& word2 : words2) {
            if (word1 == word2) {
                matches++;
            }
        }
    }
    return matches;
}

uint32_t CTS3Client::levenshteinDistance(const std::string& string1_, const std::string& string2_) {
    int32_t length1 = string1_.size();
    const int32_t length2 = string2_.size();

    const decltype(length1) columnStart = decltype(length1)(1);

    decltype(length1)*const column = new decltype(length1)[length1 + 1];
    std::iota(column + columnStart, column + length1 + 1, columnStart);

    for (auto x = columnStart; x <= length2; x++) {
        column[0] = x;
        int32_t lastDiagonal = x - columnStart;
        for (auto y = columnStart; y <= length1; y++) {
            const int32_t oldDiagonal = column[y];
            const std::initializer_list<int32_t> possibilities = {
                column[y] + 1,
                column[y - 1] + 1,
                lastDiagonal + (string1_[y - 1] == string2_[x - 1] ? 0 : 1)
            };
            column[y] = min(possibilities);
            lastDiagonal = oldDiagonal;
        }
    }
    const int32_t result = column[length1];
    delete[] column;
    return result;
}

std::string CTS3Client::removeSubstrings(std::string string_, std::string substring_) {
    const std::string::size_type substringLength = substring_.length();
    for (auto iterator = string_.find(substring_);
         iterator != std::string::npos;
         iterator = string_.find(substring_))
        string_.erase(iterator, substringLength);
    return string_;
}

acre::Result CTS3Client::updateTs3ChannelDetails(std::vector<std::string> details_) {
    setTs3ChannelDetails(details_);
    if (!details_.empty()) {
        updateShouldSwitchTS3Channel(true);
    }
    return acre::Result::ok;
}

acre::Result CTS3Client::updateShouldSwitchTS3Channel(const bool state_) {
    setShouldSwitchTS3Channel(state_);
    return acre::Result::ok;
}

bool CTS3Client::shouldSwitchTS3Channel() {
    return getShouldSwitchTS3Channel();
}
