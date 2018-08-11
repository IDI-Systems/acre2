#include "compat.h"

#include "Log.h"

#include "SoundMixer.h"

#include "AcreSettings.h"

bool CSoundMixer::acquireChannel(CSoundChannelMono **a_returnChannel) { 
    return this->acquireChannel(a_returnChannel, 4800);
}

bool CSoundMixer::acquireChannel(CSoundChannelMono **a_returnChannel, const int32_t ac_bufferSize) {
    return this->acquireChannel(a_returnChannel, ac_bufferSize, true);
}

bool CSoundMixer::acquireChannel(CSoundChannelMono **a_returnChannel, const int32_t ac_bufferSize, const bool ac_singleShot) {
    this->lock();
    *a_returnChannel = new CSoundChannelMono(ac_bufferSize, ac_singleShot);
    this->channelList.insert(*a_returnChannel);
    this->unlock();
    return true; 
}


void CSoundMixer::mixDown(int16_t *const a_samples, const int32_t ac_sampleCount, const int32_t ac_channels, const uint32_t ac_speakerMask) {
    short *monoSamples = new short[ac_sampleCount];
    short *mixSamples = new short[ac_sampleCount*ac_channels];
    CSoundChannelMono *channel;
    CSoundMonoEffect *monoEffect;
    CSoundMixdownEffect *mixdownEffect;
    std::set<CSoundChannelMono *> cleanUp;
    this->lock();
    for (auto it = channelList.begin(); it != channelList.end(); ++it) {
        memset(monoSamples, 0x00, ac_sampleCount*sizeof(short) );
        memset(mixSamples, 0x00, ac_sampleCount*ac_channels*sizeof(short) );
        channel = (CSoundChannelMono *)*it;
        channel->lock();
        if (channel->GetCurrentBufferSize() > 0) {
            
            channel->Out(monoSamples, ac_sampleCount);
            for (int i = 0; i < 8; ++i) {
                monoEffect = channel->getEffectInsert(i);
                if (monoEffect) {
                    monoEffect->lock();
                    monoEffect->process(monoSamples, ac_sampleCount);
                    monoEffect->unlock();
                }
            }
        
            int sourceSamplePos = 0;
            for (int x = 0; x < ac_sampleCount * ac_channels; x += ac_channels) {
                for (int i = 0; i < ac_channels; i++) {
                    mixSamples[x+i] = monoSamples[sourceSamplePos];
                            
                }
                sourceSamplePos++;
            }
            
            for (int i = 0; i < 8; ++i) {
                mixdownEffect = channel->getMixdownEffectInsert(i);
                if (mixdownEffect) {
                    mixdownEffect->lock();
                    mixdownEffect->process(mixSamples, ac_sampleCount, ac_channels, ac_speakerMask);
                    mixdownEffect->unlock();
                }
            }
            
            for (int i = 0; i < ac_sampleCount*ac_channels; ++i) {
                //mixSamples[i] = mixSamples[i]*1.75f;
                if (a_samples[i]+mixSamples[i] >= SHRT_MAX) {
                    a_samples[i] = SHRT_MAX;
                    //LOG("CLIPPING!");
                } else if (a_samples[i] + mixSamples[i] <= SHRT_MIN) {
                    a_samples[i] = SHRT_MIN;
                    //LOG("CLIPPING!");
                } else {
                    a_samples[i] += mixSamples[i];
                }                        
            }
        } else {
            if (channel->IsOneShot()) {
                cleanUp.insert(channel);
            }
        }
        channel->unlock();
    }
    if (cleanUp.size() > 0) {
        for (auto it = cleanUp.begin(); it != cleanUp.end(); ++it) {
            this->releaseChannel((CSoundChannelMono *)*it);
        }
    }
    delete monoSamples;
    delete mixSamples;
    this->unlock();
}

bool CSoundMixer::releaseChannel(CSoundChannelMono *a_releaseChannel) { 
    this->lock();
    if (this->channelList.find(a_releaseChannel) != this->channelList.end()) {
        this->channelList.unsafe_erase(a_releaseChannel);
        if (a_releaseChannel)
            delete a_releaseChannel;
        a_releaseChannel = NULL;
    }
    this->unlock();
    return true; 
};
