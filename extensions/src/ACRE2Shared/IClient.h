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
    virtual acre::Result initialize( void ) = 0;

    virtual acre::Result setMuted(const acre::id_t id, const bool muted) = 0;
    virtual acre::Result setMuted(std::list<acre::id_t> idList, const bool muted) = 0;

    virtual acre::Result getMuted(const acre::id_t id) = 0;

    virtual acre::Result stop() = 0;
    virtual acre::Result start(const acre::id_t id) = 0;

    virtual acre::Result enableMicrophone(const bool status) = 0;

    virtual acre::Result microphoneOpen(const bool status) = 0;

    virtual acre::Result localStartSpeaking(const acre::Speaking speakingType) = 0;
    virtual acre::Result localStartSpeaking(const acre::Speaking speakingType, const std::string radioId) = 0;
    virtual acre::Result localStopSpeaking(const acre::Speaking speakingType) = 0;

    virtual std::string getTempFilePath( void ) = 0;
    virtual std::string getConfigFilePath(void) = 0;

    virtual std::string getUniqueId() = 0;

    virtual acre::Result playSound(std::string path, acre::Vector3_t position, const float32_t volume, const int32_t looping) = 0;

    virtual acre::Result unMuteAll( void ) = 0;

    virtual acre::Result moveToServerTS3Channel() = 0;
    virtual acre::Result moveToPreviousTS3Channel() = 0;
    virtual acre::Result updateTs3ChannelDetails(const std::vector<std::string> details) = 0;
    virtual acre::Result updateShouldSwitchTS3Channel(const bool state) = 0;
    virtual bool shouldSwitchTS3Channel() = 0;

    virtual void setState(const acre::State value) = 0;
    virtual acre::State getState() const = 0;
};
