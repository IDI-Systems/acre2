#pragma once

#include "ACRE_VECTOR.h"
#include "Macros.h"
#include "Types.h"
#include "compat.h"

#include <algorithm>
#include <list>
#include <numeric>
#include <sstream>
#include <string>
#include <vector>

class IClient {
public:
    IClient() noexcept          = default;
    virtual ~IClient() noexcept = default;

    virtual acre::Result initialize(void) = 0;

    virtual acre::Result setMuted(const acre::id_t id, const bool muted)          = 0;
    virtual acre::Result setMuted(std::list<acre::id_t> idList, const bool muted) = 0;

    virtual acre::Result getMuted(const acre::id_t id) = 0;

    virtual acre::Result stop()                     = 0;
    virtual acre::Result start(const acre::id_t id) = 0;

    virtual acre::Result enableMicrophone(const bool status) = 0;

    virtual acre::Result microphoneOpen(const bool status) = 0;

    virtual acre::Result localStartSpeaking(const acre::Speaking speakingType)                            = 0;
    virtual acre::Result localStartSpeaking(const acre::Speaking speakingType, const std::string radioId) = 0;
    virtual acre::Result localStopSpeaking(const acre::Speaking speakingType)                             = 0;

    virtual std::string getTempFilePath(void)   = 0;
    virtual std::string getConfigFilePath(void) = 0;

    virtual std::string getUniqueId() = 0;

    virtual acre::Result playSound(std::string path, acre::vec3_fp32_t position, const float32_t volume, const int32_t looping) = 0;

    virtual acre::Result unMuteAll(void) = 0;

    virtual acre::Result moveToServerChannel()                                        = 0;
    virtual acre::Result moveToPreviousChannel()                                      = 0;
    virtual acre::Result updateChannelDetails(const std::vector<std::string> details) = 0;
    virtual acre::Result updateShouldSwitchChannel(const bool state)                  = 0;
    virtual bool shouldSwitchChannel()                                                = 0;
    virtual bool getVAD()                                                             = 0;

    virtual std::uint64_t findChannelByNames(std::vector<std::string> &details_) = 0;

    bool gethadVAD() const noexcept { return had_vad; }
    void sethadVAD(const bool value_) noexcept { had_vad = value_; }

    bool getInputActive() const noexcept { return input_active; }
    void setInputActive(const bool value_) noexcept { input_active = value_; }

    bool getOnRadio() const noexcept { return on_radio; }
    void setOnRadio(const bool value_) noexcept { on_radio = value_; }

    std::int32_t getSpeakingState() const noexcept { return speaking_state; }
    void setSpeakingState(const std::int32_t value_) noexcept { speaking_state = value_; }

    bool getRadioPTTDown() const noexcept { return radioPTTDown; }
    void setRadioPTTDown(const bool value_) noexcept { radioPTTDown = value_; }

    bool getIntercomPTTDown() const noexcept { return intercom_ptt_down; }
    void setIntercomPTTDown(const bool value_) noexcept { intercom_ptt_down = value_; }

    bool getMainPTTDown() const noexcept { return main_ptt_down; }
    void setMainPTTDown(const bool value_) noexcept { main_ptt_down = value_; }

    bool getDirectFirst() const noexcept { return direct_first; }
    void setDirectFirst(const bool value_) noexcept { direct_first = value_; }

    bool getHitTSSpeakingEvent() const noexcept { return hit_speaking_event; }
    void setHitTSSpeakingEvent(const bool value_) noexcept { hit_speaking_event = value_; }

    bool getIsX3DInitialized() const noexcept { return x3d_initialized; }

    void setIsX3DInitialized(const bool value_) noexcept { x3d_initialized = value_; }

    std::uint32_t getSpeakerMask() const noexcept { return speaker_mask; }
    void setSpeakerMask(const std::uint32_t value_) noexcept { speaker_mask = value_; }

    virtual std::uint64_t getPreviousChannel() const noexcept { return previous_channel; }
    virtual void setPreviousChannel(const std::uint64_t value_) noexcept { previous_channel = value_; }

    virtual const std::vector<std::string> &getChannelDetails() const noexcept { return channel_details; }
    virtual void setChannelDetails(const std::vector<std::string> &value_) noexcept { channel_details = value_; }

    virtual bool getShouldSwitchChannel() const noexcept { return should_switch_channel; }
    virtual void setShouldSwitchChannel(const bool value_) noexcept { should_switch_channel = value_; }

    acre::State getState() const noexcept { return state; }
    void setState(acre::State value) noexcept { state = value; }

protected:
    virtual std::uint32_t getWordMatches(const std::string &string1_, const std::string &string2_) noexcept {
        std::vector<std::string> words1;
        std::vector<std::string> words2;

        std::string temp;
        std::stringstream stringstream1(string1_);

        while (stringstream1 >> temp) {
            words1.push_back(temp);
        }
        std::stringstream stringstream2(string2_);
        while (stringstream2 >> temp) {
            words2.push_back(temp);
        }

        std::int32_t matches = 0;
        for (auto &word1 : words1) {
            for (auto &word2 : words2) {
                if (word1 == word2) {
                    matches++;
                }
            }
        }
        return matches;
    }

    virtual std::uint32_t levenshteinDistance(const std::string &string1_, const std::string &string2_) noexcept {
        std::int32_t length1       = string1_.size();
        const std::int32_t length2 = string2_.size();

        const decltype(length1) columnStart = decltype(length1)(1);

        decltype(length1) *const column = new decltype(length1)[length1 + 1];
        std::iota(column + columnStart, column + length1 + 1, columnStart);

        for (auto x = columnStart; x <= length2; x++) {
            column[0]                 = x;
            std::int32_t lastDiagonal = x - columnStart;
            for (auto y = columnStart; y <= length1; y++) {
                const int32_t oldDiagonal                          = column[y];
                const std::initializer_list<int32_t> possibilities = {
                  column[y] + 1, column[y - 1] + 1, lastDiagonal + (string1_[y - 1] == string2_[x - 1] ? 0 : 1)};
                column[y]    = min(possibilities);
                lastDiagonal = oldDiagonal;
            }
        }
        const std::int32_t result = column[length1];
        delete[] column;
        return result;
    }

    virtual std::string removeSubstrings(std::string string_, std::string substring_) noexcept {
        const std::string::size_type substringLength = substring_.length();
        for (auto iterator = string_.find(substring_); iterator != std::string::npos; iterator = string_.find(substring_))
            string_.erase(iterator, substringLength);
        return string_;
    }

private:
    bool had_vad      = false;
    bool input_active = false;
    bool on_radio     = false;

    std::int32_t speaking_state = 0;

    bool radioPTTDown       = false;
    bool intercom_ptt_down  = false;
    bool main_ptt_down      = false;
    bool direct_first       = false;
    bool hit_speaking_event = false;
    bool x3d_initialized    = false;

    std::uint32_t speaker_mask     = 0U;
    std::uint64_t previous_channel = 0LU;

    std::vector<std::string> channel_details;
    bool should_switch_channel = true;

    acre::State state = acre::State::stopped;
};
