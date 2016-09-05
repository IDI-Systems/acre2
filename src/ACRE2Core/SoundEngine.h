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
	ACRE_RESULT onClientGameConnected( void ) { this->setIsRunning(true); return ACRE_OK; };
	ACRE_RESULT onClientGameDisconnected( void ) { this->setIsRunning(false); return ACRE_OK; };

	ACRE_RESULT onEditPlaybackVoiceDataEvent(ACRE_ID id, short* samples, int sampleCount, int channels);
	ACRE_RESULT onEditPostProcessVoiceDataEvent(ACRE_ID id, short* samples, int sampleCount, int channels, const unsigned int* channelSpeakerArray, unsigned int* channelFillMask);
	ACRE_RESULT onEditMixedPlaybackVoiceDataEvent(short* samples, int sampleCount, int channels, const unsigned int speakerMask);

	ACRE_RESULT onEditCapturedVoiceDataEvent(short* samples, int sampleCount, int channels);
	CSoundMixer * getSoundMixer() { return this->soundMixer; };
	DECLARE_MEMBER(BOOL, IsRunning);
	DECLARE_MEMBER(ACRE_CURVE_MODEL, CurveModel);
	DECLARE_MEMBER(float, CurveScale);
	DECLARE_MEMBER(int, ChannelCount);
};

