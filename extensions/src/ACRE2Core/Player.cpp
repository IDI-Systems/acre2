#include "Player.h"
#include "Engine.h"

void CPlayer::init(ACRE_ID id) {
    this->setId(id);
    this->setInitType("");
    this->setAttenAverageSum(0);
    this->setAttenCount(1);
    this->setPreviousVolume(0);
    this->setSelectableCurveScale(1.0f);
    for(size_t i = 0; i < channels.size(); ++i) {
        this->channels[i] = NULL;
    }
}

CPlayer::CPlayer() {
    this->init(0);
}

CPlayer::CPlayer(ACRE_ID id) {
    this->init(id);
}

void CPlayer::clearSoundChannels() {
    CEngine::getInstance()->lock();
    CEngine::getInstance()->getSoundEngine()->getSoundMixer()->lock();
    for(size_t i = 0; i < channels.size(); ++i) {
        if(channels[i]) {
            CEngine::getInstance()->getSoundEngine()->getSoundMixer()->releaseChannel(channels[i]);
        }
    }
    CEngine::getInstance()->getSoundEngine()->getSoundMixer()->unlock();
    CEngine::getInstance()->unlock();
};