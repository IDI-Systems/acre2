#include "SoundEngine.h"
#include "AcreSettings.h"
#include "Engine.h"

typedef std::numeric_limits<int16_t> LIMITER;

CSoundEngine::CSoundEngine( void ) {
    this->soundMixer = new CSoundMixer();
}

ACRE_RESULT CSoundEngine::onEditPlaybackVoiceDataEvent(const ACRE_ID ac_id, int16_t *const a_samples, const int32_t ac_sampleCount, const int32_t ac_channels) {
    if (CEngine::getInstance()->getSoundSystemOverride())
        return ACRE_OK;
    if (!CEngine::getInstance()->getGameServer())
        return ACRE_ERROR;
    if (!CEngine::getInstance()->getGameServer()->getConnected())
        return ACRE_ERROR;
    CPlayer *player;

    for (int32_t x = 0; x < ac_sampleCount * ac_channels; x += ac_channels) {
        for (int32_t i = 0; i < ac_channels; i++) {
            float32_t result = static_cast<float32_t>(a_samples[x + i]) * CAcreSettings::getInstance()->getPremixGlobalVolume();
            
            if (result > LIMITER::max()) result = LIMITER::max();
            else if (result < LIMITER::min()) result = LIMITER::min();
            
            a_samples[x + i] = static_cast<int16_t>(result);
        }
    }

    auto it = CEngine::getInstance()->speakingList.find(ac_id);
    CEngine::getInstance()->getSoundEngine()->getSoundMixer()->lock();
    if (it != CEngine::getInstance()->speakingList.end()) {
        player = (CPlayer *)it->second;
        LOCK(player);
        if (player->getSpeakingType() != ACRE_SPEAKING_UNKNOWN) {
            for (size_t i = 0; i < player->m_channels.size(); ++i) {
                if (player->m_channels[i]) {
                    player->m_channels[i]->lock();
                    player->m_channels[i]->In(a_samples, ac_sampleCount);
                    player->m_channels[i]->unlock();
                }
            }
        } else {
            memset(a_samples, 0x00, (ac_sampleCount*ac_channels)*sizeof(int16_t) );
        }

        UNLOCK(player);
    } else {
        memset(a_samples, 0x00, (ac_sampleCount*ac_channels)*sizeof(int16_t) );
    }
    CEngine::getInstance()->getSoundEngine()->getSoundMixer()->unlock();
    return ACRE_OK;
}

ACRE_RESULT CSoundEngine::onEditPostProcessVoiceDataEvent(const ACRE_ID ac_id, int16_t *const a_samples, const int32_t ac_sampleCount, const int32_t ac_channels, const uint32_t *const a_channelSpeakerArray, uint32_t *const a_channelFillMask) {
    
    if (CEngine::getInstance()->getSoundSystemOverride())
        return ACRE_OK;
    if (!CEngine::getInstance()->getGameServer())
        return ACRE_ERROR;
    if (!CEngine::getInstance()->getGameServer()->getConnected())
        return ACRE_ERROR;
    memset(a_samples, 0x00, (ac_sampleCount*ac_channels)*sizeof(int16_t) );
    *a_channelFillMask = (1 << ac_channels) - 1;
    return ACRE_OK;
}

ACRE_RESULT CSoundEngine::onEditMixedPlaybackVoiceDataEvent(int16_t *const a_samples, const int32_t ac_sampleCount, const int32_t ac_channels, const uint32_t ac_speakerMask) {
    if (CEngine::getInstance()->getSoundSystemOverride())
        return ACRE_OK;
    if (!CEngine::getInstance()->getGameServer())
        return ACRE_ERROR;
    if (!CEngine::getInstance()->getGameServer()->getConnected())
        return ACRE_ERROR;
    memset(a_samples, 0x00, (ac_sampleCount*ac_channels)*sizeof(int16_t) );
    this->getSoundMixer()->mixDown(a_samples, ac_sampleCount, ac_channels, ac_speakerMask);

    for (int32_t x = 0; x < ac_sampleCount * ac_channels; x += ac_channels) {
        for (int32_t i = 0; i < ac_channels; i++) {
            float32_t result = static_cast<float32_t>(a_samples[x + i]) * CAcreSettings::getInstance()->getGlobalVolume();

            if (result > LIMITER::max()) result = LIMITER::max();
            else if (result < LIMITER::min()) result = LIMITER::min();

            a_samples[x + i] = static_cast<int16_t>(result);
        }
    }

    return ACRE_OK;
}

ACRE_RESULT CSoundEngine::onEditCapturedVoiceDataEvent(int16_t *const a_samples, const int32_t ac_sampleCount, const int32_t ac_channels) {
    if (CEngine::getInstance()->getSoundSystemOverride())
        return ACRE_OK;
    if (!CEngine::getInstance()->getGameServer())
        return ACRE_ERROR;
    if (!CEngine::getInstance()->getGameServer()->getConnected())
        return ACRE_ERROR;
    /*
    if (CEngine::getInstance()->getSelf()) {
        if (CEngine::getInstance()->getSelf()->getSpeaking()) {
            CEngine::getInstance()->getSoundEngine()->getSoundMixer()->lock();
            CSelf *self = CEngine::getInstance()->getSelf();
            self->lock();
            for (int32_t i = 0; i < self->channels.size(); ++i) {
                if (self->channels[i]) {
                    self->channels[i]->lock();
                    self->channels[i]->In(samples, sampleCount);
                    self->channels[i]->unlock();
                }
            }
            self->unlock();
            CEngine::getInstance()->getSoundEngine()->getSoundMixer()->unlock();
        }
    }
    */
    return ACRE_OK;
}
