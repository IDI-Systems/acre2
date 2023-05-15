#include "SoundMonoChannel.h"

#include "RadioEffect.h"
#include "VolumeEffect.h"
#include "BabbelEffect.h"
#include "PositionalMixdownEffect.h"
#include "Log.h"

void CSoundChannelMono::init( int length, bool singleShot ) {
    for (int i = 0; i < 8; ++i) {
        this->effects[i] = NULL;
        this->mixdownEffects[i] = NULL;
    }
    this->bufferMaxSize = length;
    this->bufferLength = 0;
    this->buffer = new short[length];
    this->bufferPos = 0;
    this->oneShot = singleShot;
    memset(this->buffer, 0x00, length*sizeof(short) );
}

CSoundChannelMono::CSoundChannelMono() {
    this->init(4800, false);
}

CSoundChannelMono::CSoundChannelMono( int length ) {
    this->init(length, false);
}

CSoundChannelMono::CSoundChannelMono( int length, bool oneShot ) {
    this->init(length, oneShot);
}

CSoundChannelMono::~CSoundChannelMono() {
    if (this->buffer) {
        delete this->buffer;
        this->buffer = NULL;
    }
    for (int i = 0; i < 8; ++i) {
        if (effects[i])
            delete effects[i];
        if (mixdownEffects[i])
            delete mixdownEffects[i];
    }
}

int CSoundChannelMono::In(short *samples, int sampleCount, const int channels) {
    //memset(samples, 0x00, sampleCount*sizeof(short));
    if (this->bufferLength + sampleCount <= this->bufferMaxSize) {
        if (channels == 1) {
            memcpy(this->buffer + this->bufferLength, samples, sampleCount * sizeof(short));
        } else {
            // rare but for multi channel input just capture mono, samples[channels*sampleCount]={Left,Right,Left,...}
            for (int i = 0; i < sampleCount; i++) {
                this->buffer[this->bufferLength + i] = samples[channels * i];
            }
        }
        this->bufferLength += sampleCount;
    }
    return this->bufferLength;
}

int CSoundChannelMono::Out(short *samples, int sampleCount) {
    int outLength = 0;
    if (this->bufferLength > 0) {
        outLength = std::min(sampleCount, this->bufferLength);
        memcpy(samples, this->buffer, outLength*sizeof(short));
        this->bufferLength -= outLength;
        if (this->bufferLength > 0) {
            memmove(this->buffer, this->buffer+outLength, this->bufferLength*sizeof(short));
        }
        
    }
    return outLength;
}

CSoundMonoEffect * CSoundChannelMono::setEffectInsert(int index, std::string type) {
    if (index > 7)
        return NULL;
    if (this->effects[index])
        delete this->effects[index];
    if (type == "acre_volume") {
        this->effects[index] = new CVolumeEffect();
        return this->effects[index];
    } else if (type == "acre_radio") {
        this->effects[index] = new CRadioEffect();
        return this->effects[index];
    } else if (type == "acre_babbel") {
        this->effects[index] = new CBabbelEffect();
    }
    return NULL;
}

CSoundMonoEffect * CSoundChannelMono::getEffectInsert(int index) {
    if (index > 7)
        return NULL;
    return this->effects[index];
}

void CSoundChannelMono::clearEffectInsert(int index) {
    if (index > 7)
        return;
    if (this->effects[index])
        delete this->effects[index];
}

CSoundMixdownEffect * CSoundChannelMono::setMixdownEffectInsert(int index, std::string type) {
    if (index > 7)
        return NULL;
    if (this->mixdownEffects[index])
        delete this->mixdownEffects[index];
    if (type == "acre_positional") {
        this->mixdownEffects[index] = new CPositionalMixdownEffect();
        return this->mixdownEffects[index];
    }
    return NULL;
}

CSoundMixdownEffect * CSoundChannelMono::getMixdownEffectInsert(int index) {
    if (index > 7)
        return NULL;
    return this->mixdownEffects[index];
}
