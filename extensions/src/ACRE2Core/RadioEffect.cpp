#include "RadioEffect.h"


CRadioEffect::CRadioEffect() {
    radioFilter = new CFilterRadio();
    this->setParam("signalQuality", 0.0f);
    this->setParam("isLoudSpeaker", 0.0f);
};
CRadioEffect::~CRadioEffect() {
    delete radioFilter;
}
void CRadioEffect::process(short *samples, int sampleCount) {
    
    bool noise = true;
    if (this->getParam("disableNoise"))
        noise = false;
    const bool isLoudSpeaker = getParam("isLoudSpeaker") > 0.0f;

    this->radioFilter->process(samples, sampleCount, 1, static_cast<acre::volume_t>(this->getParam("signalQuality")), noise, isLoudSpeaker);
};
