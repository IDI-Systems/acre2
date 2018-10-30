#include "SoundMonoChannel.h"

#include "RadioEffect.h"
#include "VolumeEffect.h"
#include "BabbelEffect.h"
#include "PositionalMixdownEffect.h"
#include "Log.h"

void CSoundChannelMono::init(const int32_t length, const bool singleShot ) {
    for (int32_t i = 0; i < 8; ++i) {
        this->m_effects[i] = NULL;
        this->m_mixdownEffects[i] = NULL;
    }
    this->m_bufferMaxSize = length;
    this->m_bufferLength = 0;
    this->m_buffer = new int16_t[length];
    this->m_bufferPos = 0;
    this->m_oneShot = singleShot;
    memset(this->m_buffer, 0x00, length*sizeof(int16_t) );
}

CSoundChannelMono::CSoundChannelMono() {
    this->init(4800, false);
}

CSoundChannelMono::CSoundChannelMono(const int32_t length ) {
    this->init(length, false);
}

CSoundChannelMono::CSoundChannelMono(const int32_t length, bool oneShot ) {
    this->init(length, oneShot);
}

CSoundChannelMono::~CSoundChannelMono() {
    if (this->m_buffer) {
        delete this->m_buffer;
        this->m_buffer = NULL;
    }
    for (int32_t i = 0; i < 8; ++i) {
        if (m_effects[i])
            delete m_effects[i];
        if (m_mixdownEffects[i])
            delete m_mixdownEffects[i];
    }
}

int CSoundChannelMono::In(int16_t *const samples, const int32_t sampleCount) {
    //memset(samples, 0x00, sampleCount*sizeof(int16_t));
    if (this->m_bufferLength + sampleCount <= this->m_bufferMaxSize) {
        memcpy(this->m_buffer+this->m_bufferLength, samples, sampleCount*sizeof(int16_t));
        this->m_bufferLength += sampleCount;
    }
    return this->m_bufferLength;
}

int CSoundChannelMono::Out(int16_t *const samples, const int32_t sampleCount) {
    int32_t outLength = 0;
    if (this->m_bufferLength > 0) {
        outLength = std::min(sampleCount, this->m_bufferLength);
        memcpy(samples, this->m_buffer, outLength*sizeof(int16_t));
        this->m_bufferLength -= outLength;
        if (this->m_bufferLength > 0) {
            memmove(this->m_buffer, this->m_buffer + outLength, this->m_bufferLength*sizeof(int16_t));
        }

    }
    return outLength;
}

CSoundMonoEffect * CSoundChannelMono::setEffectInsert(const int32_t index, const std::string &type) {
    if (index > 7)
        return NULL;
    if (this->m_effects[index])
        delete this->m_effects[index];
    if (type == "acre_volume") {
        this->m_effects[index] = new CVolumeEffect();
        return this->m_effects[index];
    } else if (type == "acre_radio") {
        this->m_effects[index] = new CRadioEffect();
        return this->m_effects[index];
    } else if (type == "acre_babbel") {
        this->m_effects[index] = new CBabbelEffect();
    }
    return NULL;
}

CSoundMonoEffect * CSoundChannelMono::getEffectInsert(const int32_t index) {
    if (index > 7)
        return NULL;
    return this->m_effects[index];
}

void CSoundChannelMono::clearEffectInsert(const int32_t index) {
    if (index > 7)
        return;
    if (this->m_effects[index])
        delete this->m_effects[index];
}

CSoundMixdownEffect * CSoundChannelMono::setMixdownEffectInsert(const int32_t index, const std::string &type) {
    if (index > 7)
        return NULL;
    if (this->m_mixdownEffects[index])
        delete this->m_mixdownEffects[index];
    if (type == "acre_positional") {
        this->m_mixdownEffects[index] = new CPositionalMixdownEffect();
        return this->m_mixdownEffects[index];
    }
    return NULL;
}

CSoundMixdownEffect * CSoundChannelMono::getMixdownEffectInsert(const int32_t index) {
    if (index > 7)
        return NULL;
    return this->m_mixdownEffects[index];
}
