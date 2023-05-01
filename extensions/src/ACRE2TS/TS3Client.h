#pragma once

#include "IClient.h"
#include "TsFunctions.h"

#include <string>
#include <thread>
#include <vector>

class CTS3Client : public IClient {
public:
    // static TS3Functions ts3Functions;

    CTS3Client()        = default;
    ~CTS3Client() final = default;

    acre::Result initialize(void) final;

    acre::Result setMuted(const acre::id_t id_, const bool muted_) final;
    acre::Result setMuted(std::list<acre::id_t> idList_, const bool muted_) final;

    acre::Result getMuted(const acre::id_t id_) final;

    acre::Result stop() final;
    acre::Result start(const acre::id_t id_) final;

    acre::Result exPersistVersion(void);

    acre::Result setClientMetadata(const char *const data);

    acre::Result enableMicrophone(const bool status_) final;

    bool getInputStatus();

    bool getVAD();

    /*!
     * \brief Handles local player starting speaking.
     *
     * \param[in]    speakingType_    ACRE speaking type
     *
     * \return       acre::Result::ok if operation successful
     */
    acre::Result localStartSpeaking(const acre::Speaking speakingType_) final;

    /*!
     * \brief Handles local player starting speaking.
     *
     * \param[in]    speakingType_    ACRE speaking type
     * \param[in]    radioId_         Unique radio ideintifier
     *
     * \return       acre::Result::ok if operation successful
     */
    acre::Result localStartSpeaking(const acre::Speaking speakingType_, std::string radioId_) final;

    /*!
     * \brief Handles local player stopping speaking.
     *
     * \param[in]    speakingType_    ACRE speaking type
     *
     * \return       acre::Result::ok if operation successful
     */
    acre::Result localStopSpeaking(const acre::Speaking speakingType_) final;

    std::string getTempFilePath(void) final;
    std::string getConfigFilePath(void) final;

    acre::Result playSound(std::string path_, acre::vec3_fp32_t position_, const float32_t volume_, const int32_t looping_) final;

    std::string getUniqueId() final;

    acre::Result microphoneOpen(const bool status_) final;

    acre::Result unMuteAll(void) final;

    acre::Result moveToServerChannel() final;
    acre::Result moveToPreviousChannel() final;
    uint64 findChannelByNames(std::vector<std::string> details_) final;

    acre::Result updateChannelDetails(std::vector<std::string> details_) final;
    acre::Result updateShouldSwitchChannel(const bool state_) final;
    bool shouldSwitchChannel() final;

private:
    std::thread m_versionThreadHandle;
    char *m_vadLevel = nullptr;
};
