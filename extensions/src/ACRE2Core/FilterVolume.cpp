#include "compat.h"
#include "FilterVolume.h"

#include "AcreDsp.h"
#include "Log.h"

#include <cmath>
#include <math.h>

#define TS_SAMPLE_RATE_Hz 48000

ACRE_RESULT CFilterVolume::process(int16_t *const samples, const int32_t sampleCount, const int32_t channels, const ACRE_VOLUME volume, const ACRE_VOLUME previousVolume) {
    if (volume > 0.001f) {
        float32_t dif;
        float32_t v;
        if (volume > previousVolume) {
            dif = volume - previousVolume;
        } else {
            dif = -(previousVolume - volume);
        }

        int32_t tempVolume;
        for (int32_t i = 0; i < sampleCount; ++i) {
            v = (previousVolume + (dif*(((float)i/(float)sampleCount))));
            //LOG("vol: %f %f %f %d=%f", previousVolume, volume, dif, i, v);
            tempVolume = (int32_t) (samples[i] * v);
            if (tempVolume > SHRT_MAX) {
                tempVolume = SHRT_MAX;
            } else if (tempVolume < SHRT_MIN) {
                tempVolume = SHRT_MIN;
            }
            samples[i] = (int16_t) tempVolume;
        }
    } else {
        memset(samples, 0x00, (sampleCount*channels)*sizeof(int16_t) );
    }
    return ACRE_OK;
}

CFilterVolume::CFilterVolume(void) {
    this->setChannelCount(0);
}

CFilterVolume::~CFilterVolume(void) {

}
