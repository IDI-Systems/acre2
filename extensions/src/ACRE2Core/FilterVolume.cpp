#include "compat.h"
#include "FilterVolume.h"

#include "AcreDsp.h"
#include "Log.h"

#include <cmath>
#include <math.h>

#define TS_SAMPLE_RATE 48000

acre_result_t CFilterVolume::process(short* samples, int sampleCount, int channels, acre_volume_t volume, acre_volume_t previousVolume) {
    if (volume > 0.001f) {
        float dif;
        float v;
        if (volume > previousVolume) {
            dif = volume - previousVolume;
        } else {
            dif = -(previousVolume - volume);
        }
        int tempVolume;
        for (int i = 0; i < sampleCount; ++i) {
            v = (previousVolume + (dif*(((float)i/(float)sampleCount))));
            //LOG("vol: %f %f %f %d=%f", previousVolume, volume, dif, i, v);
            tempVolume = (int)(samples[i] * v);
            if (tempVolume > SHRT_MAX) tempVolume = SHRT_MAX;
            if (tempVolume < SHRT_MIN) tempVolume = SHRT_MIN;
            samples[i] = (short)tempVolume;
        }
    } else {
        memset(samples, 0x00, (sampleCount*channels)*sizeof(short) );
    }
    return acre_result_ok;
}

CFilterVolume::CFilterVolume(void)
{
    this->setChannelCount(0);
}

CFilterVolume::~CFilterVolume(void)
{
}