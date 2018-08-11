#pragma once

#include "compat.h"

#include "Macros.h"
#include "Types.h"
#include "Lockable.h"
#include "SoundMonoEffect.h"
#include "SoundMixdownEffect.h"
#include <string>
#include <algorithm>
#include <array>

class CSoundChannelMono : public CLockable {
protected:
    int32_t m_bufferMaxSize;
    int16_t *m_buffer;
    int32_t m_bufferLength;
    int32_t m_bufferPos;
    bool m_oneShot;
    std::array<CSoundMonoEffect *, 8> m_effects;
    std::array<CSoundMixdownEffect *, 8> m_mixdownEffects;
    void init( const int32_t ac_length, const bool ac_singleShot );
public:
    CSoundChannelMono();
    CSoundChannelMono(const int32_t ac_length );
    CSoundChannelMono(const int32_t ac_length, const bool ac_singleShot );

    ~CSoundChannelMono();
    int32_t In(int16_t *const a_samples, const int32_t ac_sampleCount);
    int32_t Out(int16_t *const a_samples, const int32_t ac_sampleCount);
    int32_t GetCurrentBufferSize() { return this->m_bufferLength-this->m_bufferPos; };
    bool IsOneShot() { return this->m_oneShot; };
    CSoundMonoEffect * setEffectInsert(const int32_t ac_index, const std::string &ac_type);
    CSoundMonoEffect * getEffectInsert(const int32_t ac_index);
    CSoundMixdownEffect * setMixdownEffectInsert(const int32_t ac_index, const std::string &ac_type);
    CSoundMixdownEffect * getMixdownEffectInsert(const int32_t ac_index);
    void clearEffectInsert(const int32_t ac_index);
};
