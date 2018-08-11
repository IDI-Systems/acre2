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

    ACRE_RESULT onEditPlaybackVoiceDataEvent(const ACRE_ID ac_id, int16_t *const a_samples, const int32_t ac_sampleCount, const int32_t ac_channels);
    ACRE_RESULT onEditPostProcessVoiceDataEvent(const ACRE_ID ac_id, int16_t *const a_samples, const int32_t ac_sampleCount, const int32_t ac_channels, const uint32_t *const a_channelSpeakerArray, uint32_t *const a_channelFillMask);
    ACRE_RESULT onEditMixedPlaybackVoiceDataEvent(int16_t *const a_samples, const int32_t ac_sampleCount, const int32_t ac_channels, const uint32_t ac_speakerMask);

    ACRE_RESULT onEditCapturedVoiceDataEvent(int16_t *const a_samples, const int32_t ac_sampleCount, const int32_t ac_channels);
    CSoundMixer* getSoundMixer() { return this->soundMixer; };

    virtual __inline void setIsRunning(const bool ac_value) { this->m_isRunning = ac_value; }
    virtual __inline bool getIsRunning() const { return this->m_isRunning; }

    virtual __inline void setCurveModel(const ACRE_CURVE_MODEL ac_value) { this->m_curveModel = ac_value; }
    virtual __inline ACRE_CURVE_MODEL getCurveModel() const { return this->m_curveModel; }

    virtual __inline void setCurveScale(const float32_t ac_value) { this->m_curveScale = ac_value; }
    virtual __inline float32_t getCurveScale() const { return this->m_curveScale; }

    virtual __inline void setChannelCount(const int32_t ac_value) { this->m_channelCount = ac_value; }
    virtual __inline int32_t getChannelCount() const { return this->m_channelCount; }

protected:
    bool m_isRunning;
    ACRE_CURVE_MODEL m_curveModel;
    float32_t m_curveScale;
    int32_t m_channelCount;
};

