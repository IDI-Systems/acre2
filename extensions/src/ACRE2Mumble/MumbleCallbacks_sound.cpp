#include "compat.h"

#include "FilterVolume.h"
#include "FilterPosition.h"

#include "Engine.h"

#include "Log.h"

#include "MumbleClient.h"

#include "Wave.h"

#include <map>
#define _USE_MATH_DEFINES

#include <math.h>
#include <cmath>

#include "AcreDsp.h"


typedef std::numeric_limits<int16_t> LIMITER;

//void ts3plugin_onEditPlaybackVoiceDataEvent(uint64 server, anyID id, short* samples, int sampleCount, int channels) {
bool mumble_onAudioSourceFetched(float* outputPCM, uint32_t sampleCount, uint16_t channelCount, bool isSpeech, mumble_userid_t userID) {
    if (CEngine::getInstance()->getSoundSystemOverride()) {
        return false;
    }

    if (!CEngine::getInstance()->getGameServer()) {
        return false;
    }

    if (!CEngine::getInstance()->getGameServer()->getConnected()) {
        return false;
    }

    // Make this faster
    
    //if (mixdownSamples == NULL || sampleCount * channelCount > mixdownSampleLength) {
    const std::uint32_t mixdownSampleLength = sampleCount * channelCount;
    int16_t *mixdownSamples = new int16_t[mixdownSampleLength];
    //}

    for (std::int32_t c = 0; c <= mixdownSampleLength - 1; ++c) {
        mixdownSamples[c] = static_cast<int16_t>(outputPCM[c] / LIMITER::max());
    }

    CEngine::getInstance()->getSoundEngine()->onEditPlaybackVoiceDataEvent(static_cast<acre::id_t>(userID), mixdownSamples, sampleCount, channelCount);

    for (std::int32_t c = 0; c <= mixdownSampleLength - 1; ++c) {
        float mixedSample = 0.0F;
        if (mixdownSamples[c] > 0) {
            mixedSample = static_cast<float>(mixdownSamples[c] * LIMITER::max());
        }
        else {
            mixedSample = -static_cast<float>(mixdownSamples[c] * LIMITER::min());
        }
        outputPCM[c] = mixedSample;
    }
    delete[] mixdownSamples;
    return true;
}




bool mumble_onAudioOutputAboutToPlay(float *outputPCM, uint32_t sampleCount, uint16_t channelCount) {

    if (CEngine::getInstance()->getSoundSystemOverride()) {
        return false;
    }

    if (!CEngine::getInstance()->getGameServer()) {
        return false;
    }

    if (!CEngine::getInstance()->getGameServer()->getConnected()) {
        return false;
    }
        
    uint32_t speakerMask = 0U;
    speakerMask = SPEAKER_STEREO;

    // Make this faster

    //if (mixdownSamples == NULL || sampleCount * channelCount > mixdownSampleLength) {
    const uint32_t mixdownSampleLength = sampleCount * channelCount;
    int16_t  *mixdownSamples = new int16_t[mixdownSampleLength];
    //}

    for (int32_t c = 0; c <= mixdownSampleLength - 1; ++c) {
        mixdownSamples[c] = static_cast<short>(outputPCM[c] / LIMITER::max());
    }

    CEngine::getInstance()->getSoundEngine()->onEditMixedPlaybackVoiceDataEvent(mixdownSamples, sampleCount, channelCount, speakerMask);

    for (int32_t c = 0; c <= mixdownSampleLength - 1; ++c) {
        float mixedSample = 0.0F;
        if (mixdownSamples[c] > 0) {
            mixedSample = static_cast<float>(mixdownSamples[c] * LIMITER::max());
        }
        else {
            mixedSample = -static_cast<float>(mixdownSamples[c] * LIMITER::min());
        }
        outputPCM[c] = mixedSample;
    }
    delete[] mixdownSamples;
    return true;
}

void ts3plugin_onEditCapturedVoiceDataEvent(uint64_t server, short* samples, int sampleCount, int channels, int* edited) {
    CEngine::getInstance()->getSoundEngine()->onEditCapturedVoiceDataEvent(samples, sampleCount, channels);
}
