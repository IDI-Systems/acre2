#include "SoundMonoChannel.h"

#include "RadioEffect.h"
#include "VolumeEffect.h"
#include "BabbelEffect.h"
#include "PositionalMixdownEffect.h"
#include "Log.h"

void CSoundChannelMono::init(const int32_t ac_length, const bool ac_singleShot ) {
    for (int32_t i = 0; i < 8; ++i) {
        this->m_effects[i] = NULL;
        this->m_mixdownEffects[i] = NULL;
    }
    this->m_bufferMaxSize = ac_length;
    this->m_bufferLength = 0;
    this->m_buffer = new int16_t[ac_length];
    this->m_bufferPos = 0;
    this->m_oneShot = ac_singleShot;
    memset(this->m_buffer, 0x00, ac_length*sizeof(int16_t) );
}

CSoundChannelMono::CSoundChannelMono() {
    this->init(4800, false);
}

CSoundChannelMono::CSoundChannelMono(const int32_t ac_length ) {
    this->init(ac_length, false);
}

CSoundChannelMono::CSoundChannelMono(const int32_t ac_length, bool ac_oneShot ) {
    this->init(ac_length, ac_oneShot);
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

int CSoundChannelMono::In(int16_t *const a_samples, const int32_t ac_sampleCount) {
    //memset(samples, 0x00, sampleCount*sizeof(int16_t));
    if (this->m_bufferLength + ac_sampleCount <= this->m_bufferMaxSize) {
        memcpy(this->m_buffer+this->m_bufferLength, a_samples, ac_sampleCount*sizeof(int16_t));
        this->m_bufferLength += ac_sampleCount;
    }
    return this->m_bufferLength;
}

int CSoundChannelMono::Out(int16_t *const a_samples, const int32_t ac_sampleCount) {
    int32_t outLength = 0;
    if (this->m_bufferLength > 0) {
        outLength = std::min(ac_sampleCount, this->m_bufferLength);
        memcpy(a_samples, this->m_buffer, outLength*sizeof(int16_t));
        this->m_bufferLength -= outLength;
        if (this->m_bufferLength > 0) {
            memmove(this->m_buffer, this->m_buffer + outLength, this->m_bufferLength*sizeof(int16_t));
        }
        
    }
    return outLength;
}

CSoundMonoEffect * CSoundChannelMono::setEffectInsert(const int32_t ac_index, const std::string &ac_type) {
    if (ac_index > 7)
        return NULL;
    if (this->m_effects[ac_index])
        delete this->m_effects[ac_index];
    if (ac_type == "acre_volume") {
        this->m_effects[ac_index] = new CVolumeEffect();
        return this->m_effects[ac_index];
    } else if (ac_type == "acre_radio") {
        this->m_effects[ac_index] = new CRadioEffect();
        return this->m_effects[ac_index];
    } else if (ac_type == "acre_babbel") {
        this->m_effects[ac_index] = new CBabbelEffect();
    }
    return NULL;
}

CSoundMonoEffect * CSoundChannelMono::getEffectInsert(const int32_t ac_index) {
    if (ac_index > 7)
        return NULL;
    return this->m_effects[ac_index];
}

void CSoundChannelMono::clearEffectInsert(const int32_t ac_index) {
    if (ac_index > 7)
        return;
    if (this->m_effects[ac_index])
        delete this->m_effects[ac_index];
}

CSoundMixdownEffect * CSoundChannelMono::setMixdownEffectInsert(const int32_t ac_index, const std::string &ac_type) {
    if (ac_index > 7)
        return NULL;
    if (this->m_mixdownEffects[ac_index])
        delete this->m_mixdownEffects[ac_index];
    if (ac_type == "acre_positional") {
        this->m_mixdownEffects[ac_index] = new CPositionalMixdownEffect();
        return this->m_mixdownEffects[ac_index];
    }
    return NULL;
}

CSoundMixdownEffect * CSoundChannelMono::getMixdownEffectInsert(const int32_t ac_index) {
    if (ac_index > 7)
        return NULL;
    return this->m_mixdownEffects[ac_index];
}
