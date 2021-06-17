#pragma once

#include "IClient.h"
#include "TsFunctions.h"
#include <thread>
#include <string>
#include <vector>

class CTS3Client : public IClient {
public:

    //static TS3Functions ts3Functions;

    CTS3Client() {};
    ~CTS3Client() {};

    acre::Result initialize(void);

    acre::Result setMuted(const acre::id_t id_, const bool muted_);
    acre::Result setMuted(std::list<acre::id_t> idList_, const bool muted_);

    acre::Result getMuted(const acre::id_t id_);

    acre::Result stop();
    acre::Result start(const acre::id_t id_);

    acre::Result exPersistVersion(void);

    acre::Result enableMicrophone(const bool status_);

    bool getInputStatus();

    /*!
    * \brief Handles local player starting speaking.
    *
    * \param[in]    speakingType_    ACRE speaking type
    *
    * \return       acre::Result::ok if operation successful
    */
    acre::Result localStartSpeaking(const acre::Speaking speakingType_);

    /*!
    * \brief Handles local player starting speaking.
    *
    * \param[in]    speakingType_    ACRE speaking type
    * \param[in]    radioId_         Unique radio ideintifier
    *
    * \return       acre::Result::ok if operation successful
    */
    acre::Result localStartSpeaking(const acre::Speaking speakingType_, std::string radioId_);

    /*!
    * \brief Handles local player stopping speaking.
    *
    * \param[in]    speakingType_    ACRE speaking type
    *
    * \return       acre::Result::ok if operation successful
    */
    acre::Result localStopSpeaking(const acre::Speaking speakingType_);

    std::string getTempFilePath(void);
    std::string getConfigFilePath(void);

    acre::Result playSound(std::string path_, acre::vec3_fp32_t position_, const float32_t volume_, const int32_t looping_);

    std::string getUniqueId();

    bool getVAD();

    acre::Result microphoneOpen(const bool status_);

    acre::Result unMuteAll(void);

    acre::Result moveToServerTS3Channel();
    acre::Result moveToPreviousTS3Channel();
    uint64 findChannelByNames(std::vector<std::wstring> details_);
    uint32_t getWordMatches(const std::wstring& string1_, const std::wstring& string2_);
    uint32_t levenshteinDistance(const std::wstring& string1_, const std::wstring& string2_);
    std::wstring removeSubstrings(std::wstring string_, std::wstring substring_);
    acre::Result updateTs3ChannelDetails(std::vector<std::wstring> details_);
    acre::Result updateShouldSwitchTS3Channel(const bool state_);
    bool shouldSwitchTS3Channel();

    inline void setState(acre::State value) final { m_state = value; }
    inline acre::State getState() const final { return m_state; }

    DECLARE_MEMBER(bool, hadVAD);
    DECLARE_MEMBER(bool, InputActive);
    DECLARE_MEMBER(bool, OnRadio);
    DECLARE_MEMBER(int32_t, TsSpeakingState);
    DECLARE_MEMBER(bool, RadioPTTDown);
    DECLARE_MEMBER(bool, IntercomPTTDown);
    DECLARE_MEMBER(bool, MainPTTDown);
    DECLARE_MEMBER(bool, DirectFirst);
    DECLARE_MEMBER(bool, HitTSSpeakingEvent);
    DECLARE_MEMBER(bool, IsX3DInitialized);
    DECLARE_MEMBER(uint32_t, SpeakerMask);
    DECLARE_MEMBER(uint64, PreviousTSChannel);
    DECLARE_MEMBER(std::vector<std::wstring>, Ts3ChannelDetails);
    DECLARE_MEMBER(bool, ShouldSwitchTS3Channel)
protected:
    std::thread m_versionThreadHandle;
    char *m_vadLevel;
    acre::State m_state;
};
