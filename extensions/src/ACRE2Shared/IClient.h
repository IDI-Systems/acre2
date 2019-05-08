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

    virtual AcreResult initialize( void ) = 0;

    virtual AcreResult setMuted(const acre_id_t id, bool muted) = 0;
    virtual AcreResult setMuted(std::list<acre_id_t> idList, const bool muted) = 0;

    virtual AcreResult getMuted(const acre_id_t id) = 0;

    virtual AcreResult stop() = 0;
    virtual AcreResult start(const acre_id_t id) = 0;

    virtual AcreResult enableMicrophone(const bool status) = 0;

    virtual AcreResult microphoneOpen(const bool status) = 0;

    virtual AcreResult localStartSpeaking(const AcreSpeaking speakingType) = 0;
    virtual AcreResult localStartSpeaking(const AcreSpeaking speakingType, std::string radioId) = 0;
    virtual AcreResult localStopSpeaking(const AcreSpeaking speakingType) = 0;

    virtual std::string getTempFilePath( void ) = 0;
    virtual std::string getConfigFilePath(void) = 0;

    virtual std::string getUniqueId() = 0;

    virtual AcreResult playSound(std::string path, ACRE_VECTOR position, const float32_t volume, const int32_t looping) = 0;

    virtual AcreResult unMuteAll( void ) = 0;

    virtual AcreResult moveToServerTS3Channel() = 0;
    virtual AcreResult moveToPreviousTS3Channel() = 0;
    virtual AcreResult updateTs3ChannelDetails(std::vector<std::string> details) = 0;
    virtual AcreResult updateShouldSwitchTS3Channel(const bool state) = 0;
    virtual BOOL shouldSwitchTS3Channel() = 0;

    DECLARE_INTERFACE_MEMBER(AcreState, State);

};
