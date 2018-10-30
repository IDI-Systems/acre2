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

    virtual ACRE_RESULT setMuted(const ACRE_ID id, const bool muted) = 0;
    virtual ACRE_RESULT setMuted(const std::list<ACRE_ID> &idList, const bool muted) = 0;

    virtual ACRE_RESULT getMuted(const ACRE_ID id) = 0;

    virtual ACRE_RESULT stop() = 0;
    virtual ACRE_RESULT start(const ACRE_ID id) = 0;

    virtual ACRE_RESULT enableMicrophone(const bool status) = 0;

    virtual ACRE_RESULT microphoneOpen(const bool status) = 0;

    virtual ACRE_RESULT localStartSpeaking(const ACRE_SPEAKING_TYPE speakingType) = 0;
    virtual ACRE_RESULT localStartSpeaking(const ACRE_SPEAKING_TYPE speakingType, const std::string &radioId) = 0;
    virtual ACRE_RESULT localStopSpeaking(const ACRE_SPEAKING_TYPE speakingType) = 0;

    virtual std::string getTempFilePath( void ) = 0;
    virtual std::string getConfigFilePath(void) = 0;

    virtual std::string getUniqueId() = 0;

    virtual ACRE_RESULT playSound(const std::string &path, const ACRE_VECTOR position, const float32_t volume, const int32_t looping) = 0;

    virtual ACRE_RESULT unMuteAll( void ) = 0;

    virtual ACRE_RESULT moveToServerTS3Channel() = 0;
    virtual ACRE_RESULT moveToPreviousTS3Channel() = 0;
    virtual ACRE_RESULT updateTs3ChannelDetails(const std::vector<std::string> details) = 0;
    virtual ACRE_RESULT updateShouldSwitchTS3Channel(const bool state) = 0;
    virtual bool shouldSwitchTS3Channel() = 0;

    virtual void setState(const ACRE_STATE value) = 0;
    virtual ACRE_STATE getState() const = 0;
};
