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

    virtual acre_result_t initialize( void ) = 0;

    virtual acre_result_t setMuted(const acre_id_t id, bool muted) = 0;
    virtual acre_result_t setMuted(std::list<acre_id_t> idList, const bool muted) = 0;

    virtual acre_result_t getMuted(const acre_id_t id) = 0;

    virtual acre_result_t stop() = 0;
    virtual acre_result_t start(const acre_id_t id) = 0;

    virtual acre_result_t enableMicrophone(const bool status) = 0;

    virtual acre_result_t microphoneOpen(const bool status) = 0;

    virtual acre_result_t localStartSpeaking(const acre_speaking_t speakingType) = 0;
    virtual acre_result_t localStartSpeaking(const acre_speaking_t speakingType, std::string radioId) = 0;
    virtual acre_result_t localStopSpeaking(const acre_speaking_t speakingType) = 0;

    virtual std::string getTempFilePath( void ) = 0;
    virtual std::string getConfigFilePath(void) = 0;

    virtual std::string getUniqueId() = 0;

    virtual acre_result_t playSound(std::string path, ACRE_VECTOR position, const float32_t volume, const int32_t looping) = 0;

    virtual acre_result_t unMuteAll( void ) = 0;

    virtual acre_result_t moveToServerTS3Channel() = 0;
    virtual acre_result_t moveToPreviousTS3Channel() = 0;
    virtual acre_result_t updateTs3ChannelDetails(std::vector<std::string> details) = 0;
    virtual acre_result_t updateShouldSwitchTS3Channel(const bool state) = 0;
    virtual BOOL shouldSwitchTS3Channel() = 0;

    DECLARE_INTERFACE_MEMBER(acre_state_t, State);

};
