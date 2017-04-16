#pragma once

#include "compat.h"

#include "Types.h"
#include "Macros.h"
#include "ACRE_VECTOR.h"
#include <list>
#include <string>
#include <vector>

class IClient {
public:

    virtual ACRE_RESULT initialize( void ) = 0;

    virtual ACRE_RESULT setMuted(ACRE_ID id, bool muted) = 0;
    virtual ACRE_RESULT setMuted(std::list<ACRE_ID> idList, bool muted) = 0;

    virtual ACRE_RESULT getMuted(ACRE_ID id) = 0;

    virtual ACRE_RESULT stop() = 0;
    virtual ACRE_RESULT start(ACRE_ID id) = 0;

    virtual ACRE_RESULT enableMicrophone(bool status) = 0;

    virtual ACRE_RESULT microphoneOpen(bool status) = 0;

    virtual ACRE_RESULT localStartSpeaking(ACRE_SPEAKING_TYPE speakingType) = 0;
    virtual ACRE_RESULT localStartSpeaking(ACRE_SPEAKING_TYPE speakingType, std::string radioId) = 0;
    virtual ACRE_RESULT localStopSpeaking(ACRE_SPEAKING_TYPE speakingType) = 0;

    virtual std::string getTempFilePath( void ) = 0;
    virtual std::string getConfigFilePath(void) = 0;

    virtual std::string getUniqueId() = 0;

    virtual ACRE_RESULT playSound(std::string path, ACRE_VECTOR position, float volume, int looping) = 0;

    virtual ACRE_RESULT unMuteAll( void ) = 0;

    virtual ACRE_RESULT moveToServerTS3Channel() = 0;
    virtual ACRE_RESULT moveToPreviousTS3Channel() = 0;
    virtual ACRE_RESULT updateTs3ChannelDetails(std::vector<std::string> details) = 0;
    virtual ACRE_RESULT updateShouldSwitchTS3Channel(bool state) = 0;
    virtual bool shouldSwitchTS3Channel() = 0;

    DECLARE_INTERFACE_MEMBER(ACRE_STATE, State);

};
