#include "Player.h"
#include "Engine.h"

void CPlayer::init(ACRE_ID id) {
    this->setId(id);
    this->setInitType("");
    this->setAttenAverageSum(0);
    this->setAttenCount(1);
    this->setPreviousVolume(0);
    this->setSelectableCurveScale(1.0f);
    for (size_t i = 0; i < m_channels.size(); ++i) {
        this->m_channels[i] = NULL;
    }
}

CPlayer::CPlayer() {
    this->init(0);
}

CPlayer::CPlayer(const ACRE_ID id) {
    this->init(id);
}

void CPlayer::clearSoundChannels() {
    CEngine::getInstance()->lock();
    CEngine::getInstance()->getSoundEngine()->getSoundMixer()->lock();
    for (size_t i = 0; i < m_channels.size(); ++i) {
        if (m_channels[i]) {
            CEngine::getInstance()->getSoundEngine()->getSoundMixer()->releaseChannel(m_channels[i]);
        }
    }
    CEngine::getInstance()->getSoundEngine()->getSoundMixer()->unlock();
    CEngine::getInstance()->unlock();
};
