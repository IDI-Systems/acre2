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


typedef std::numeric_limits<short int> LIMITER;

//void ts3plugin_onEditPlaybackVoiceDataEvent(uint64 server, anyID id, short* samples, int sampleCount, int channels) {
bool mumble_onAudioSourceFetched(float* outputPCM, uint32_t sampleCount, uint16_t channelCount, bool isSpeech, mumble_userid_t userID) {
    if (CEngine::getInstance()->getSoundSystemOverride())
        return false;
    if (!CEngine::getInstance()->getGameServer())
        return false;
    if (!CEngine::getInstance()->getGameServer()->getConnected())
        return false;

    // Make this faster
    short* mixdownSamples;
    uint32_t mixdownSampleLength = 0;

    //if (mixdownSamples == NULL || sampleCount * channelCount > mixdownSampleLength) {
    mixdownSampleLength = sampleCount * channelCount;
    mixdownSamples = new short[mixdownSampleLength];
    //}

    for (int c = 0; c <= mixdownSampleLength - 1; ++c) {
        mixdownSamples[c] = static_cast<short>(outputPCM[c] / LIMITER::max());
    }

    CEngine::getInstance()->getSoundEngine()->onEditPlaybackVoiceDataEvent(static_cast<acre::id_t>(userID), mixdownSamples, sampleCount, channelCount);

    for (int c = 0; c <= mixdownSampleLength - 1; ++c) {
        float mixedSample;
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

    if (CEngine::getInstance()->getSoundSystemOverride())
        return false;
    if (!CEngine::getInstance()->getGameServer())
        return false;
    if (!CEngine::getInstance()->getGameServer()->getConnected())
        return false;
    UINT32 speakerMask = 0;
    speakerMask = SPEAKER_STEREO;

    // Make this faster
    short* mixdownSamples;
    uint32_t mixdownSampleLength = 0;

    //if (mixdownSamples == NULL || sampleCount * channelCount > mixdownSampleLength) {
        mixdownSampleLength = sampleCount * channelCount;
        mixdownSamples = new short[mixdownSampleLength];
    //}

    for (int c = 0; c <= mixdownSampleLength - 1; ++c) {
        mixdownSamples[c] = static_cast<short>(outputPCM[c] / LIMITER::max());
    }

    CEngine::getInstance()->getSoundEngine()->onEditMixedPlaybackVoiceDataEvent(mixdownSamples, sampleCount, channelCount, speakerMask);

    for (int c = 0; c <= mixdownSampleLength - 1; ++c) {
        float mixedSample;
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
