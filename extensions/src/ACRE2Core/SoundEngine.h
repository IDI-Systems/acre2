#pragma once

#include "compat.h"

#include "Macros.h"
#include "Types.h"
#include "Lockable.h"

#include "SoundMixer.h"


class CSoundEngine : public CLockable {
protected:
    CSoundMixer *soundMixer;
public:
    CSoundEngine( void );
    ~CSoundEngine();
    acre::Result onClientGameConnected( void ) { this->setIsRunning(true); return acre::Result::ok; };
    acre::Result onClientGameDisconnected( void ) { this->setIsRunning(false); return acre::Result::ok; };

    acre::Result onEditPlaybackVoiceDataEvent(acre::id_t id, short* samples, int sampleCount, int channels);
    acre::Result onEditPostProcessVoiceDataEvent(acre::id_t id, short* samples, int sampleCount, int channels, const unsigned int* channelSpeakerArray, unsigned int* channelFillMask);
    acre::Result onEditMixedPlaybackVoiceDataEvent(short* samples, int sampleCount, int channels, const unsigned int speakerMask);

    acre::Result onEditCapturedVoiceDataEvent(short* samples, int sampleCount, int channels);
    CSoundMixer * getSoundMixer() { return this->soundMixer; };
    DECLARE_MEMBER(BOOL, IsRunning);
    DECLARE_MEMBER(acre::CurveModel, CurveModel);
    DECLARE_MEMBER(float, CurveScale);
    DECLARE_MEMBER(int, ChannelCount);
};
