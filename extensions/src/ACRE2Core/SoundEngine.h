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
    AcreResult onClientGameConnected( void ) { this->setIsRunning(true); return AcreResult::ok; };
    AcreResult onClientGameDisconnected( void ) { this->setIsRunning(false); return AcreResult::ok; };

    AcreResult onEditPlaybackVoiceDataEvent(acre_id_t id, short* samples, int sampleCount, int channels);
    AcreResult onEditPostProcessVoiceDataEvent(acre_id_t id, short* samples, int sampleCount, int channels, const unsigned int* channelSpeakerArray, unsigned int* channelFillMask);
    AcreResult onEditMixedPlaybackVoiceDataEvent(short* samples, int sampleCount, int channels, const unsigned int speakerMask);

    AcreResult onEditCapturedVoiceDataEvent(short* samples, int sampleCount, int channels);
    CSoundMixer * getSoundMixer() { return this->soundMixer; };
    DECLARE_MEMBER(BOOL, IsRunning);
    DECLARE_MEMBER(AcreCurveModel, CurveModel);
    DECLARE_MEMBER(float, CurveScale);
    DECLARE_MEMBER(int, ChannelCount);
};
