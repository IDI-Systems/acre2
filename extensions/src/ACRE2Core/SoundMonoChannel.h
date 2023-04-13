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
    int bufferMaxSize;
    short *buffer;
    int bufferLength;
    int bufferPos;
    bool oneShot;
    std::array<CSoundMonoEffect *, 8> effects;
    std::array<CSoundMixdownEffect *, 8> mixdownEffects;
    void init( int length, bool singleShot );
public:
    CSoundChannelMono();
    CSoundChannelMono( int length );
    CSoundChannelMono( int length, bool singleShot );

    ~CSoundChannelMono();
    int In(short *samples, int sampleCount, const int channels);
    int Out(short *samples, int sampleCount);
    int GetCurrentBufferSize() { return this->bufferLength-this->bufferPos; };
    bool IsOneShot() { return this->oneShot; };
    CSoundMonoEffect * setEffectInsert(int index, std::string type);
    CSoundMonoEffect * getEffectInsert(int index);
    CSoundMixdownEffect * setMixdownEffectInsert(int index, std::string type);
    CSoundMixdownEffect * getMixdownEffectInsert(int index);
    void clearEffectInsert(int index);
};
