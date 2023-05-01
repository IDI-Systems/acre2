#include "AcreSettings.h"
#include "Engine.h"
#include "Log.h"
#include "MumbleClient.h"
#include "MumbleFunctions.h"
#include "Shlwapi.h"
#include "Types.h"
#include "compat.h"
#include "shlobj.h"

#pragma comment(lib, "Shlwapi.lib")

static constexpr std::int32_t invalid_mumble_channel = -1;
constexpr char default_mumble_channel[]              = "ACRE";

extern MumbleAPI_v_1_0_x mumAPI;
extern mumble_connection_t activeConnection;
extern mumble_plugin_id_t pluginID;

acre::Result CMumbleClient::initialize() {
    setPreviousChannel(invalid_mumble_channel);
    return acre::Result::ok;
}

acre::Result CMumbleClient::setMuted(const acre::id_t id_, const bool muted_) {
    (void) id_;
    (void) muted_;
    return acre::Result::ok;
}

acre::Result CMumbleClient::setMuted(std::list<acre::id_t> idList_, bool muted_) {
    (void) idList_;
    (void) muted_;
    return acre::Result::ok;
}

acre::Result CMumbleClient::getMuted(acre::id_t id_) {
    (void) id_;
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

        mumAPI.log(pluginID, "stopped");
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
    this->setGodPTTDown(false);
    this->setZeusPTTDown(false);
    this->setHitTSSpeakingEvent(false);
    this->setOnRadio(false);
    this->setState(acre::State::running);
    this->setIsX3DInitialized(false);

    mumAPI.log(pluginID, "Started");
    mumAPI.log(pluginID, ACRE_VERSION_METADATA);

    return acre::Result::ok;
}

bool CMumbleClient::getVAD() {
    mumble_transmission_mode_t transmitMode;
    const mumble_error_t err = mumAPI.getLocalUserTransmissionMode(pluginID, &transmitMode);
    if (err != MUMBLE_STATUS_OK) {
        return false;
    }

    return transmitMode == MUMBLE_TM_VOICE_ACTIVATION;
}

acre::Result CMumbleClient::localStartSpeaking(const acre::Speaking speakingType_) {
    this->localStartSpeaking(speakingType_, "");
    return acre::Result::ok;
}

acre::Result CMumbleClient::localStartSpeaking(const acre::Speaking speakingType_, std::string radioId_) {
    bool stopDirectSpeaking = false;

    const bool VADactive = this->getVAD();
    const std::int32_t speakingState = this->getSpeakingState();

    /* Open or close the microphone. If the microphone is still active, stop direct speaking before
     * starting the new PTT method: radio/god speaking. In theory this would not be needed for intercom since
     * at the moment it is a direct speak with audio effect. However, it is planned to have intercoms converted
     * to components and unique IDs.
     */
    if ((speakingType_ == acre::Speaking::radio) || (speakingType_ == acre::Speaking::intercom) || (speakingType_ == acre::Speaking::god) || (speakingType_ == acre::Speaking::zeus)) {
        if (speakingType_ == acre::Speaking::radio) {
            this->setRadioPTTDown(true);
            this->setOnRadio(true);
        } else if (speakingType_ == acre::Speaking::intercom) {
            this->setIntercomPTTDown(true);
        } else if (speakingType_ == acre::Speaking::god) {
            this->setGodPTTDown(true);
            this->setOnRadio(true);
        } else if (speakingType_ == acre::Speaking::zeus) {
            this->setZeusPTTDown(true);
            this->setOnRadio(true);
        }

        if (!VADactive) {
            if (!this->getDirectFirst()) {
                this->microphoneOpen(true);
            } else {
                stopDirectSpeaking = true;
            }
        } else if (VADactive && (speakingState != MUMBLE_TS_PASSIVE) && (speakingState != MUMBLE_TS_INVALID)) {
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

    const bool VADactive = this->getVAD();
    switch (speakingType_) {
        case acre::Speaking::direct:
            break;
        case acre::Speaking::god:
            this->setGodPTTDown(false);
            break;
        case acre::Speaking::zeus:
            this->setZeusPTTDown(false);
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
            this->setGodPTTDown(false);
            this->setZeusPTTDown(false);
            break;
        default:
            break;
    }

    if (this->getOnRadio()) {
        if (!VADactive) {
            if (((speakingType_ == acre::Speaking::radio) || (speakingType_ == acre::Speaking::god) || (speakingType_ == acre::Speaking::zeus)) && this->getDirectFirst()) {
                this->setOnRadio(false);
                resendDirectSpeaking = true;
            } else {
                if ((!CEngine::getInstance()->getClient()->getMainPTTDown())
                      && (!CEngine::getInstance()->getClient()->getGodPTTDown())
                      && (!CEngine::getInstance()->getClient()->getZeusPTTDown())) {
                    this->microphoneOpen(false);
                } else {
                    resendDirectSpeaking = true;
                }
            }
        } else {
            this->setOnRadio(false);
            const std::int32_t speakingState = this->getSpeakingState();

            if ((speakingState != MUMBLE_TS_PASSIVE) && (speakingState != MUMBLE_TS_INVALID)) {
                resendDirectSpeaking = true;
            }
        }
    } else if (speakingType_ == acre::Speaking::intercom) {
        const std::int32_t speakingState = this->getSpeakingState();
        if (!VADactive) {
            if (!CEngine::getInstance()->getClient()->getIntercomPTTDown()) {
                this->microphoneOpen(false);
            } else {
                resendDirectSpeaking = true;
            }
        } else if ((speakingState != MUMBLE_TS_PASSIVE) && (speakingState != MUMBLE_TS_INVALID)) {
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
    (void) status_;
    return acre::Result::ok;
}

acre::Result CMumbleClient::playSound(std::string path_, acre::vec3_fp32_t position_, const float32_t volume_, const int32_t looping_) {
    return acre::Result::ok;
}

std::string CMumbleClient::getUniqueId() {
    return "not used";
}

std::string CMumbleClient::getConfigFilePath(void) {
    std::string tempFolder = ".\\acre";
    if (!PathFileExistsA(tempFolder.c_str()) && !CreateDirectoryA(tempFolder.c_str(), nullptr)) {
        LOG("ERROR: UNABLE TO CREATE TEMP DIR");
    }

    return tempFolder;
}

std::string CMumbleClient::getTempFilePath(void) {
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
    const mumble_error_t res = mumAPI.requestMicrophoneActivationOvewrite(pluginID, status_);
    if (res != MUMBLE_STATUS_OK) {
        if (status_) {
            LOG("Error toggling PTT Open: %s (%d)\n", mumble_errorMessage(res), res);
        } else {
            LOG("Error toggling PTT Closed: %s (%d)\n", mumble_errorMessage(res), res);
        }

        return acre::Result::error;
    }

    this->setInputActive(status_);
    return acre::Result::ok;
}

acre::Result CMumbleClient::unMuteAll(void) {
    return acre::Result::ok;
}

acre::Result CMumbleClient::moveToServerChannel() {
    TRACE("moveToServerChannel ENTER");
    if (!CAcreSettings::getInstance()->getDisableChannelSwitch()) {
        mumble_userid_t clientId;
        std::vector<std::string> details = getChannelDetails();

        if (mumAPI.getLocalUserID(pluginID, activeConnection, &clientId) == MUMBLE_STATUS_OK) {
            mumble_channelid_t currentChannelId = invalid_mumble_channel;

            if ((mumAPI.getChannelOfUser(pluginID, activeConnection, clientId, &currentChannelId) == MUMBLE_STATUS_OK) &&
                (getPreviousChannel() == invalid_mumble_channel)) {
                setPreviousChannel(currentChannelId);
            }

            const mumble_channelid_t channelId = static_cast<mumble_channelid_t>(findChannelByNames(details));
            if ((channelId != invalid_mumble_channel) && (channelId != currentChannelId)) {
                std::string password;
                if (!details.at(1).empty() && !details.at(0).empty()) {
                    password = details.at(1);
                }

                mumAPI.requestUserMove(pluginID, activeConnection, clientId, channelId, password.c_str());
            }
        }
    }
    setShouldSwitchChannel(false);

    return acre::Result::ok;
}

acre::Result CMumbleClient::moveToPreviousChannel() {
    TRACE("moveToPreviousChannel ENTER");
    if (!CAcreSettings::getInstance()->getDisableChannelSwitch()) {
        mumble_userid_t clientId = -1;

        if (mumAPI.getLocalUserID(pluginID, activeConnection, &clientId) == MUMBLE_STATUS_OK) {
            mumble_channelid_t currentChannelId = invalid_mumble_channel;

            if (mumAPI.getChannelOfUser(pluginID, activeConnection, clientId, &currentChannelId) == MUMBLE_STATUS_OK) {
                const mumble_channelid_t channelId = static_cast<mumble_channelid_t>(getPreviousChannel());
                if (channelId != invalid_mumble_channel && channelId != currentChannelId) {
                    mumAPI.requestUserMove(pluginID, activeConnection, clientId, channelId, "");
                }
            }
        }
        setPreviousChannel(invalid_mumble_channel);
    }

    return acre::Result::ok;
}

uint64_t CMumbleClient::findChannelByNames(std::vector<std::string> details_) {
    TRACE("findChannelByNames ENTER");
    mumble_channelid_t *channelList = nullptr;
    std::size_t channelCount        = 0U;

    if (mumAPI.getAllChannels(pluginID, activeConnection, &channelList, &channelCount) == MUMBLE_STATUS_OK) {
        mumble_channelid_t channelId        = invalid_mumble_channel;
        mumble_channelid_t defaultChannelId = invalid_mumble_channel;
        std::map<mumble_channelid_t, std::string> channelMap;
        std::string name = details_.at(2);
        if (!details_.at(0).empty()) {
            name = details_.at(0);
        }

        for (std::int32_t idx = 0U; idx < channelCount; idx++) {
            channelId         = *channelList + idx;
            const char *channelName = nullptr;

            if (mumAPI.getChannelName(pluginID, activeConnection, channelId, &channelName) == MUMBLE_STATUS_OK) {
                // Copy the channel name into a std::string and then get rid of the Mumble resource again
                std::string channelNameString(channelName);
                mumAPI.freeMemory(pluginID, (void *) channelName);

                if (channelNameString.find(default_mumble_channel) != -1 || (!details_.at(0).empty() && channelNameString == name)) {
                    if (channelNameString == default_mumble_channel) {
                        defaultChannelId = channelId;
                    }
                    channelMap.emplace(channelId, channelNameString);
                }
            }
        }

        mumAPI.freeMemory(pluginID, channelList);

        mumble_channelid_t bestChannelId = invalid_mumble_channel;
        int32_t bestMatches              = 0;
        int32_t bestDistance             = 10;
        for (auto &element : channelMap) {
            std::string fullChannelName = element.second;
            // Full comparison
            if (fullChannelName.compare(name) == 0) {
                bestChannelId = element.first;
                break;
            }
            const std::string cleanChannelName = removeSubstrings(fullChannelName, default_mumble_channel);
            // Word comparison
            const int32_t matches = getWordMatches(cleanChannelName, name);
            if (matches > bestMatches) {
                bestMatches   = matches;
                bestChannelId = element.first;
                continue;
            }
            // Char comparison
            const int32_t distance = levenshteinDistance(cleanChannelName, name);
            if (distance <= bestDistance) {
                bestDistance  = distance;
                bestChannelId = element.first;
            }
        }
        if (bestChannelId == invalid_mumble_channel) {
            if (!details_.at(0).empty()) {
                details_.at(0).clear();
                bestChannelId = static_cast<mumble_channelid_t>(findChannelByNames(details_));
            } else if (defaultChannelId != invalid_mumble_channel) {
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
