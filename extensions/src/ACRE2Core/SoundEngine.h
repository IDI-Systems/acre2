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
    acre_result_t onClientGameConnected( void ) { this->setIsRunning(true); return acre_result_ok; };
    acre_result_t onClientGameDisconnected( void ) { this->setIsRunning(false); return acre_result_ok; };

    acre_result_t onEditPlaybackVoiceDataEvent(acre_id_t id, short* samples, int sampleCount, int channels);
    acre_result_t onEditPostProcessVoiceDataEvent(acre_id_t id, short* samples, int sampleCount, int channels, const unsigned int* channelSpeakerArray, unsigned int* channelFillMask);
    acre_result_t onEditMixedPlaybackVoiceDataEvent(short* samples, int sampleCount, int channels, const unsigned int speakerMask);

    acre_result_t onEditCapturedVoiceDataEvent(short* samples, int sampleCount, int channels);
    CSoundMixer * getSoundMixer() { return this->soundMixer; };
    DECLARE_MEMBER(BOOL, IsRunning);
    DECLARE_MEMBER(acre_curveModel_t, CurveModel);
    DECLARE_MEMBER(float, CurveScale);
    DECLARE_MEMBER(int, ChannelCount);
};

