#include "compat.h"

#include "Log.h"

#include "SoundMixer.h"

#include "AcreSettings.h"

bool CSoundMixer::acquireChannel(CSoundChannelMono **returnChannel) { 
    return this->acquireChannel(returnChannel, 4800); 
}

bool CSoundMixer::acquireChannel(CSoundChannelMono **returnChannel, int bufferSize) { 
    return this->acquireChannel(returnChannel, bufferSize, true); 
}

bool CSoundMixer::acquireChannel(CSoundChannelMono **returnChannel, int bufferSize, bool singleShot) {
    this->lock();
    *returnChannel = new CSoundChannelMono(bufferSize, singleShot); 
    this->channelList.insert(*returnChannel); 
    this->unlock();
    return true; 
}


void CSoundMixer::mixDown(short* samples, int sampleCount, int channels, const unsigned int speakerMask) {
    short *monoSamples = new short[sampleCount];
    short *mixSamples = new short[sampleCount*channels];
    CSoundChannelMono *channel;
    CSoundMonoEffect *monoEffect;
    CSoundMixdownEffect *mixdownEffect;
    std::set<CSoundChannelMono *> cleanUp;
    this->lock();
    for(auto it = channelList.begin(); it != channelList.end(); ++it) {
        memset(monoSamples, 0x00, sampleCount*sizeof(short) );
        memset(mixSamples, 0x00, sampleCount*channels*sizeof(short) );
        channel = (CSoundChannelMono *)*it;
        channel->lock();
        if(channel->GetCurrentBufferSize() > 0) {
            
            channel->Out(monoSamples, sampleCount);
            for(int i = 0; i < 8; ++i) {
                monoEffect = channel->getEffectInsert(i);
                if(monoEffect) {
                    monoEffect->lock();
                    monoEffect->process(monoSamples, sampleCount);
                    monoEffect->unlock();
                }
            }
        
            int sourceSamplePos = 0;
            for(int x = 0; x < sampleCount * channels; x+=channels) {
                for(int i = 0; i < channels; i++) {
                    mixSamples[x+i] = monoSamples[sourceSamplePos];
                            
                }
                sourceSamplePos++;
            }
            
            for(int i = 0; i < 8; ++i) {
                mixdownEffect = channel->getMixdownEffectInsert(i);
                if(mixdownEffect) {
                    mixdownEffect->lock();
                    mixdownEffect->process(mixSamples, sampleCount, channels, speakerMask);
                    mixdownEffect->unlock();
                }
            }
            
            for(int i = 0; i < sampleCount*channels; ++i) {
                //mixSamples[i] = mixSamples[i]*1.75f;
                if(samples[i]+mixSamples[i] >= SHRT_MAX) {
                    samples[i] = SHRT_MAX;
                    //LOG("CLIPPING!");
                } else if(samples[i]+mixSamples[i] <= SHRT_MIN) {
                    samples[i] = SHRT_MIN;
                    //LOG("CLIPPING!");
                } else {
                    samples[i] += mixSamples[i];
                }                        
            }
        } else {
            if(channel->IsOneShot()) {
                cleanUp.insert(channel);
            }
        }
        channel->unlock();
    }
    if(cleanUp.size() > 0) {
        for(auto it = cleanUp.begin(); it != cleanUp.end(); ++it) {
            this->releaseChannel((CSoundChannelMono *)*it);
        }
    }
    delete monoSamples;
    delete mixSamples;
    this->unlock();
}

bool CSoundMixer::releaseChannel(CSoundChannelMono *releaseChannel) { 
    this->lock();
    if(this->channelList.find(releaseChannel) != this->channelList.end()) {
        this->channelList.unsafe_erase(releaseChannel); 
        if(releaseChannel)
            delete releaseChannel;
        releaseChannel = NULL;
    }
    this->unlock();
    return true; 
};