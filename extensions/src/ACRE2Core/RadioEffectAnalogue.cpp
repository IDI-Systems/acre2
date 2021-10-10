#include "RadioEffectAnalogue.h"


CRadioEffectAnalogue::CRadioEffectAnalogue() {
    radioFilter = new CFilterRadio();
    this->setParam("signalQuality", 0.0f);
};
CRadioEffectAnalogue::~CRadioEffectAnalogue() {
    delete radioFilter;
}
void CRadioEffectAnalogue::process(short *samples, int sampleCount) {
    bool noise = true;
    if (this->getParam<bool>("disableNoise")) {
        noise = false;
    }

    this->radioFilter->process(
        samples,
        sampleCount,
        1,
        this->getParam<acre::volume_t>("signalQuality"),
        noise);
};
