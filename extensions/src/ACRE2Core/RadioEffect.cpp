#include "RadioEffect.h"


CRadioEffect::CRadioEffect() {
    radioFilter = new CFilterRadio();
    this->setParam("signalQuality", 0.0f);
};
CRadioEffect::~CRadioEffect() {
    delete radioFilter;
}
void CRadioEffect::process(int16_t *const  samples, const int32_t sampleCount) {

    bool noise = true;
    if (this->getParam("disableNoise"))
        noise = false;

    this->radioFilter->process(samples, sampleCount, 1, (ACRE_VOLUME) this->getParam("signalQuality"), noise);
};
