#include "compat.h"
#include "FilterVolume.h"

#include "AcreDsp.h"
#include "Log.h"

#include <cmath>
#include <math.h>

#define TS_SAMPLE_RATE_Hz 48000

ACRE_RESULT CFilterVolume::process(int16_t *const a_samples, const int32_t ac_sampleCount, const int32_t ac_channels, const ACRE_VOLUME ac_volume, const ACRE_VOLUME ac_previousVolume) {
    if (ac_volume > 0.001f) {
        float32_t dif;
        float32_t v;
        if (ac_volume > ac_previousVolume) {
            dif = ac_volume - ac_previousVolume;
        } else {
            dif = -(ac_previousVolume - ac_volume);
        }

        int32_t tempVolume;
        for (int32_t i = 0; i < ac_sampleCount; ++i) {
            v = (ac_previousVolume + (dif*(((float)i/(float)ac_sampleCount))));
            //LOG("vol: %f %f %f %d=%f", previousVolume, volume, dif, i, v);
            tempVolume = (int32_t) (a_samples[i] * v);
            if (tempVolume > SHRT_MAX) {
                tempVolume = SHRT_MAX;
            } else if (tempVolume < SHRT_MIN) {
                tempVolume = SHRT_MIN;
            }
            a_samples[i] = (int16_t) tempVolume;
        }
    } else {
        memset(a_samples, 0x00, (ac_sampleCount*ac_channels)*sizeof(int16_t) );
    }
    return ACRE_OK;
}

CFilterVolume::CFilterVolume(void) {
    this->setChannelCount(0);
}

CFilterVolume::~CFilterVolume(void) {

}
