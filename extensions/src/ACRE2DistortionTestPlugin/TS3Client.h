#pragma once

#include "IClient.h"
#include "TsFunctions.h"
#include <thread>
#include <string>
#include <vector>

class CTS3Client : public IClient {
public:

    //static TS3Functions ts3Functions;

    CTS3Client() { };
    ~CTS3Client() { };

    ACRE_RESULT initialize(void);

    ACRE_RESULT setMuted(const ACRE_ID id, const bool muted);
    ACRE_RESULT setMuted(std::list<ACRE_ID> idList, const bool muted);

    ACRE_RESULT getMuted(const ACRE_ID id);

    ACRE_RESULT stop();
    ACRE_RESULT start(const ACRE_ID id);

    ACRE_RESULT exPersistVersion(void);

    ACRE_RESULT enableMicrophone(const bool status);

    bool getInputStatus();

    ACRE_RESULT localStartSpeaking(const ACRE_SPEAKING_TYPE speakingType);
    ACRE_RESULT localStartSpeaking(const ACRE_SPEAKING_TYPE speakingType, std::string radioId);
    ACRE_RESULT localStopSpeaking(const ACRE_SPEAKING_TYPE speakingType);

    std::string getTempFilePath(void);
    std::string getConfigFilePath(void);

    ACRE_RESULT playSound(std::string path, ACRE_VECTOR position, const float32_t volume, const int32_t looping);

    std::string getUniqueId();

    bool getVAD();

    ACRE_RESULT microphoneOpen(const bool status);

    ACRE_RESULT unMuteAll(void);

    ACRE_RESULT moveToServerTS3Channel();
    ACRE_RESULT moveToPreviousTS3Channel();
    uint64 findChannelByNames(std::vector<std::string> details);
    uint32_t getWordMatches(const std::string& string1, const std::string& string2);
    uint32_t levenshteinDistance(const std::string& string1, const std::string& string2);
    std::string removeSubstrings(std::string string, std::string substring);
    ACRE_RESULT updateTs3ChannelDetails(std::vector<std::string> details);
    ACRE_RESULT updateShouldSwitchTS3Channel(const bool state);
    BOOL shouldSwitchTS3Channel();

    DECLARE_MEMBER(bool, hadVAD);
    DECLARE_MEMBER(bool, InputActive);
    DECLARE_MEMBER(ACRE_STATE, State);
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
    DECLARE_MEMBER(std::vector<std::string>, Ts3ChannelDetails);
    DECLARE_MEMBER(bool, ShouldSwitchTS3Channel)
protected:
    std::thread m_versionThreadHandle;
    char *m_vadLevel;
};
