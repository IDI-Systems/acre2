#pragma once

#include "compat.h"

#include "Lockable.h"
#include "SoundMonoChannel.h"

#include <set>
#ifdef WIN32
#include <concurrent_unordered_set.h>
#else
#include <tbb/concurrent_unordered_set.h>
namespace concurrency = tbb;
#endif

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
