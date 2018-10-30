#pragma once

#include "IClient.h"
#include "TsFunctions.h"
#include <thread>
#include <string>
#include <vector>

class CTS3Client: public IClient {
public:

    //static TS3Functions ts3Functions;

    CTS3Client() { };
    ~CTS3Client() { };

    ACRE_RESULT initialize( void );

    ACRE_RESULT setMuted(const ACRE_ID id, const bool muted);
    ACRE_RESULT setMuted(const std::list<ACRE_ID> &idList, const bool muted);

    ACRE_RESULT getMuted(const ACRE_ID id);

    ACRE_RESULT stop();
    ACRE_RESULT start(const ACRE_ID id);

    ACRE_RESULT exPersistVersion( void );

    ACRE_RESULT enableMicrophone(const bool status);

    bool getInputStatus();

    ACRE_RESULT localStartSpeaking(const ACRE_SPEAKING_TYPE speakingType);
    ACRE_RESULT localStartSpeaking(const ACRE_SPEAKING_TYPE speakingType, const std::string &radioId);
    ACRE_RESULT localStopSpeaking(const ACRE_SPEAKING_TYPE speakingType );

    std::string getTempFilePath( void );
    std::string getConfigFilePath(void);

    ACRE_RESULT playSound(const std::string &path, const ACRE_VECTOR position, const float32_t volume, const int32_t looping);

    std::string getUniqueId( );

    bool getVAD();

    ACRE_RESULT microphoneOpen(const bool status);

    ACRE_RESULT unMuteAll( void );

    ACRE_RESULT moveToServerTS3Channel();
    ACRE_RESULT moveToPreviousTS3Channel();
    uint64 findChannelByNames(std::vector<std::string> &details);
    unsigned int getWordMatches(const std::string& string1, const std::string& string2);
    unsigned int levenshteinDistance(const std::string& string1, const std::string& string2);
    std::string removeSubstrings(std::string &string, const std::string &substring);
    ACRE_RESULT updateTs3ChannelDetails(const std::vector<std::string> details);
    ACRE_RESULT updateShouldSwitchTS3Channel(const bool state);
    bool shouldSwitchTS3Channel();

    virtual __inline void sethadVAD(const bool value) { this->m_hadVAD = value; }
    virtual __inline bool gethadVAD() const { return this->m_hadVAD; }

    virtual __inline void setInputActive(const bool value) { this->m_inputActive = value; }
    virtual __inline bool getInputActive() const { return this->m_inputActive; }

    virtual __inline void setState(const ACRE_STATE value) { this->m_state = value; }
    virtual __inline ACRE_STATE getState() const { return this->m_state; }

    virtual __inline void setOnRadio(const bool value) { this->m_onRadio = value; }
    virtual __inline bool getOnRadio() const { return this->m_onRadio; }

    virtual __inline void setTsSpeakingState(const int32_t value) { this->m_tsSpeakingState = value; }
    virtual __inline int32_t getTsSpeakingState() const { return this->m_tsSpeakingState; }

    virtual __inline void setRadioPTTDown(const bool value) { this->m_radioPTTDown = value; }
    virtual __inline bool getRadioPTTDown() const { return this->m_radioPTTDown; }

    virtual __inline void setMainPTTDown(const bool value) { this->m_mainPTTDown = value; }
    virtual __inline bool getMainPTTDown() const { return this->m_mainPTTDown; }

    virtual __inline void setDirectFirst(const bool value) { this->m_directFirst = value; }
    virtual __inline bool getDirectFirst() const { return this->m_directFirst; }

    virtual __inline void setHitTSSpeakingEvent(const bool value) { this->m_hitTSSpeakingEvent = value; }
    virtual __inline bool getHitTSSpeakingEvent() const { return this->m_hitTSSpeakingEvent; }

    virtual __inline void setIsX3DInitialized(const bool value) { this->m_isX3DInitialised = value; }
    virtual __inline bool getIsX3DInitialized() const { return this->m_isX3DInitialised; }

    virtual __inline void setSpeakerMask(const uint32_t value) { this->m_speakerMask = value; }
    virtual __inline uint32_t getSpeakerMask() const { return this->m_speakerMask; }

    virtual __inline void setPreviousTSChannel(const uint64_t value) { this->m_previousTSChannel = value; }
    virtual __inline uint64_t getPreviousTSChannel() const { return this->m_previousTSChannel; }

    virtual __inline void setTs3ChannelDetails(const std::vector<std::string> &value) { this->m_ts3ChannelDetails = value; }
    virtual __inline std::vector<std::string> getTs3ChannelDetails() const { return this->m_ts3ChannelDetails; }

    virtual __inline void setShouldSwitchTS3Channel(const bool value) { this->m_shouldSwitchTS3Channel = value; }
    virtual __inline bool getShouldSwitchTS3Channel() const { return this->m_shouldSwitchTS3Channel; }

protected:
    bool m_hadVAD;
    bool m_inputActive;
    ACRE_STATE m_state;
    bool m_onRadio;
    int32_t m_tsSpeakingState;
    bool m_radioPTTDown;
    bool m_mainPTTDown;
    bool m_directFirst;
    bool m_hitTSSpeakingEvent;
    bool m_isX3DInitialised;
    uint32_t m_speakerMask;
    uint64_t m_previousTSChannel;
    std::vector<std::string> m_ts3ChannelDetails;
    bool m_shouldSwitchTS3Channel;

    std::thread m_versionThreadHandle;
    char *m_vadLevel;
};
