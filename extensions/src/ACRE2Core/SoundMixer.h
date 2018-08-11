#pragma once

#include "compat.h"

#include "Lockable.h"
#include "SoundMonoChannel.h"

#include <set>
#include <concurrent_unordered_set.h>
#include "Types.h"

class CSoundMixer : public CLockable {
private:
    concurrency::concurrent_unordered_set<CSoundChannelMono *> channelList;
public:
    CSoundMixer() { };
    ~CSoundMixer() { };
    bool acquireChannel(CSoundChannelMono **returnChannel);
    bool acquireChannel(CSoundChannelMono **returnChannel, const int32_t bufferSize);
    bool acquireChannel(CSoundChannelMono **returnChannel, const int32_t bufferSize, const bool singleShot);

    bool releaseChannel(CSoundChannelMono *releaseChannel);
    void mixDown(int16_t *const samples, const int32_t sampleCount, const int32_t channels, const uint32_t speakerMask);

};
