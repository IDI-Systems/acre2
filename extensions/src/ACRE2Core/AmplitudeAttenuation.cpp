#include "AmplitudeAttenuation.h"

#include "AcreDsp.h"

#include "Log.h"
#include "Player.h"

#include <cmath>

#define AVERAGE_RATE    20


ACRE_RESULT CAmplitudeAttenuation::processAmplitudes(void) {
    return ACRE_OK;
}

ACRE_RESULT CAmplitudeAttenuation::process(int16_t *const a_samples, const int32_t ac_sampleCount, const int32_t ac_channels, CPlayer *const a_player) {
    float32_t currentSample = 0.0f;
    float32_t averageSum = 0.0f;
    for (int32_t i = 0; i < ac_sampleCount*ac_channels && i < 4095; i++) {
        if (a_samples[i] > 0) {
            currentSample = 20.0f * log10f((float32_t) a_samples[i]);
            averageSum += currentSample;
        }
    }
    const float32_t averageAmplitude = averageSum/(ac_sampleCount*ac_channels);

    float32_t ampCoef = 0.001f*powf(averageAmplitude,2.0f) + 0.0155f*averageAmplitude - 0.0009f;
    //ampCoef = -7E-06f*pow(averageAmplitude,4) + 0.0008f*pow(averageAmplitude,3) - 0.0275f*pow(averageAmplitude,2) + 0.44f*averageAmplitude - 2.4821f;
    //ampCoef = 4E-08f*pow(averageAmplitude,5) - 6E-06f*pow(averageAmplitude,4) + 0.0004f*pow(averageAmplitude,3) - 0.0091f*pow(averageAmplitude,2) + 0.1279f*averageAmplitude - 0.7582f;
    //ampCoef = -3E-07f*pow(averageAmplitude,4) + 2E-05f*pow(averageAmplitude,3) + 0.0007f*pow(averageAmplitude,2) + 0.0138f*averageAmplitude + 0.0413f;

    ampCoef = std::max(0.0f, ampCoef);
    
    //LOG("ampCoef: %f %fdB", ampCoef, averageAmplitude);
    LOCK(a_player);
    if (a_player->getAttenCount() > AVERAGE_RATE) {
        a_player->setAttenCount(1);
        ampCoef = a_player->getAttenAverageSum()/AVERAGE_RATE;
        a_player->setAmplitudeCoef(ampCoef);
        a_player->setAttenAverageSum(averageAmplitude);
    } else {
        a_player->setAttenCount(a_player->getAttenCount() + 1);
        a_player->setAttenAverageSum(a_player->getAttenAverageSum() + ampCoef);
    }
    UNLOCK(a_player);
    //this->getPlayer()->setAmplitudeCoef(1);
    // process the new sample into the curves and globals
    //this->processAmplitudes();

    return ACRE_OK;
}

ACRE_RESULT CAmplitudeAttenuation::reset(void) {


    return ACRE_OK;
}

CAmplitudeAttenuation::CAmplitudeAttenuation(void) {
    
}


CAmplitudeAttenuation::~CAmplitudeAttenuation(void) {

}
