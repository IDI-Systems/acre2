#pragma once

#include "compat.h"

#include "Lockable.h"
#include "SoundMonoChannel.h"

#include <set>
#include <concurrent_unordered_set.h>

class CSoundMixer : public CLockable {
private:
    concurrency::concurrent_unordered_set<CSoundChannelMono *> channelList;
public:
    CSoundMixer() { };
    ~CSoundMixer() { };
    bool acquireChannel(CSoundChannelMono **returnChannel);
    bool acquireChannel(CSoundChannelMono **returnChannel, int bufferSize);
    bool acquireChannel(CSoundChannelMono **returnChannel, int bufferSize, bool singleShot);

    bool releaseChannel(CSoundChannelMono *releaseChannel);
    void mixDown(short* samples, int sampleCount, int channels, const unsigned int speakerMask);

};