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

    ACRE_RESULT onEditPlaybackVoiceDataEvent(const ACRE_ID id, int16_t *const samples, const int32_t sampleCount, const int32_t channels);
    ACRE_RESULT onEditPostProcessVoiceDataEvent(const ACRE_ID id, int16_t *const samples, const int32_t sampleCount, const int32_t channels, const uint32_t *const channelSpeakerArray, uint32_t *const channelFillMask);
    ACRE_RESULT onEditMixedPlaybackVoiceDataEvent(int16_t *const samples, const int32_t sampleCount, const int32_t channels, const uint32_t speakerMask);

    ACRE_RESULT onEditCapturedVoiceDataEvent(int16_t *const samples, const int32_t sampleCount, const int32_t channels);
    CSoundMixer* getSoundMixer() { return this->soundMixer; };

    virtual __inline void setIsRunning(const bool value) { this->m_isRunning = value; }
    virtual __inline bool getIsRunning() const { return this->m_isRunning; }

    virtual __inline void setCurveModel(const ACRE_CURVE_MODEL value) { this->m_curveModel = value; }
    virtual __inline ACRE_CURVE_MODEL getCurveModel() const { return this->m_curveModel; }

    virtual __inline void setCurveScale(const float32_t value) { this->m_curveScale = value; }
    virtual __inline float32_t getCurveScale() const { return this->m_curveScale; }

    virtual __inline void setChannelCount(const int32_t value) { this->m_channelCount = value; }
    virtual __inline int32_t getChannelCount() const { return this->m_channelCount; }

protected:
    bool m_isRunning;
    ACRE_CURVE_MODEL m_curveModel;
    float32_t m_curveScale;
    int32_t m_channelCount;
};

