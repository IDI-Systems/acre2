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

    ACRE_RESULT setMuted(const ACRE_ID ac_id, const bool ac_muted);
    ACRE_RESULT setMuted(const std::list<ACRE_ID> &idList, const bool ac_muted);

    ACRE_RESULT getMuted(const ACRE_ID ac_id);

    ACRE_RESULT stop();
    ACRE_RESULT start(const ACRE_ID ac_id);

    ACRE_RESULT exPersistVersion( void );

    ACRE_RESULT enableMicrophone(const bool ac_status);

    bool getInputStatus();

    ACRE_RESULT localStartSpeaking(const ACRE_SPEAKING_TYPE ac_speakingType);
    ACRE_RESULT localStartSpeaking(const ACRE_SPEAKING_TYPE ac_speakingType, const std::string &ac_radioId);
    ACRE_RESULT localStopSpeaking(const ACRE_SPEAKING_TYPE ac_speakingType );

    std::string getTempFilePath( void );
    std::string getConfigFilePath(void);
    
    ACRE_RESULT playSound(const std::string &ac_path, const ACRE_VECTOR ac_position, const float32_t ac_volume, const int32_t ac_looping);

    std::string getUniqueId( );

    bool getVAD();

    ACRE_RESULT microphoneOpen(const bool ac_status);

    ACRE_RESULT unMuteAll( void );

    ACRE_RESULT moveToServerTS3Channel();
    ACRE_RESULT moveToPreviousTS3Channel();
    uint64 findChannelByNames(std::vector<std::string> &a_details);
    unsigned int getWordMatches(const std::string& ac_string1, const std::string& ac_string2);
    unsigned int levenshteinDistance(const std::string& ac_string1, const std::string& ac_string2);
    std::string removeSubstrings(std::string &ac_string, const std::string &ac_substring);
    ACRE_RESULT updateTs3ChannelDetails(const std::vector<std::string> ac_details);
    ACRE_RESULT updateShouldSwitchTS3Channel(const bool ac_state);
    bool shouldSwitchTS3Channel();

    virtual __inline void sethadVAD(const bool ac_value) { this->m_hadVAD = ac_value; }
    virtual __inline bool gethadVAD() const { return this->m_hadVAD; }

    virtual __inline void setInputActive(const bool ac_value) { this->m_inputActive = ac_value; }
    virtual __inline bool getInputActive() const { return this->m_inputActive; }

    virtual __inline void setState(const ACRE_STATE ac_value) { this->m_state = ac_value; }
    virtual __inline ACRE_STATE getState() const { return this->m_state; }

    virtual __inline void setOnRadio(const bool ac_value) { this->m_onRadio = ac_value; }
    virtual __inline bool getOnRadio() const { return this->m_onRadio; }

    virtual __inline void setTsSpeakingState(const int32_t ac_value) { this->m_tsSpeakingState = ac_value; }
    virtual __inline int32_t getTsSpeakingState() const { return this->m_tsSpeakingState; }

    virtual __inline void setRadioPTTDown(const bool ac_value) { this->m_radioPTTDown = ac_value; }
    virtual __inline bool getRadioPTTDown() const { return this->m_radioPTTDown; }

    virtual __inline void setMainPTTDown(const bool ac_value) { this->m_mainPTTDown = ac_value; }
    virtual __inline bool getMainPTTDown() const { return this->m_mainPTTDown; }

    virtual __inline void setDirectFirst(const bool ac_value) { this->m_directFirst = ac_value; }
    virtual __inline bool getDirectFirst() const { return this->m_directFirst; }

    virtual __inline void setHitTSSpeakingEvent(const bool ac_value) { this->m_hitTSSpeakingEvent = ac_value; }
    virtual __inline bool getHitTSSpeakingEvent() const { return this->m_hitTSSpeakingEvent; }

    virtual __inline void setIsX3DInitialized(const bool ac_value) { this->m_isX3DInitialised = ac_value; }
    virtual __inline bool getIsX3DInitialized() const { return this->m_isX3DInitialised; }

    virtual __inline void setSpeakerMask(const uint32_t ac_value) { this->m_speakerMask = ac_value; }
    virtual __inline uint32_t getSpeakerMask() const { return this->m_speakerMask; }

    virtual __inline void setPreviousTSChannel(const uint64_t ac_value) { this->m_previousTSChannel = ac_value; }
    virtual __inline uint64_t getPreviousTSChannel() const { return this->m_previousTSChannel; }

    virtual __inline void setTs3ChannelDetails(const std::vector<std::string> &ac_value) { this->m_ts3ChannelDetails = ac_value; }
    virtual __inline std::vector<std::string> getTs3ChannelDetails() const { return this->m_ts3ChannelDetails; }

    virtual __inline void setShouldSwitchTS3Channel(const bool ac_value) { this->m_shouldSwitchTS3Channel = ac_value; }
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
