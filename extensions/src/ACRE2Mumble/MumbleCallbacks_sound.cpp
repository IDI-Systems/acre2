#include "Engine.h"
#include "FilterPosition.h"
#include "FilterVolume.h"
#include "Log.h"
#include "MumbleClient.h"
#include "Wave.h"
#include "compat.h"

#include <map>
#define _USE_MATH_DEFINES

#include "AcreDsp.h"

#include <cmath>
#include <math.h>

using LIMITER = std::numeric_limits<int16_t>;

bool mumble_onAudioSourceFetched(float *outputPCM, uint32_t sampleCount, uint16_t channelCount, bool isSpeech, mumble_userid_t userID) {
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

    // if (mixdownSamples == NULL || sampleCount * channelCount > mixdownSampleLength) {
    const std::uint32_t mixdownSampleLength = sampleCount * channelCount;
    int16_t *mixdownSamples                 = new (nothrow) int16_t[mixdownSampleLength];
    if (mixdownSamples == nullptr) {
        return false;
    }
    //}

    for (std::uint32_t c = 0; c <= mixdownSampleLength - 1U; ++c) {
        float sample = outputPCM[c];
        if (sample > 1.0F) {
            sample = 1.0F;
        } else if (sample < -1.0F) {
            sample = -1.0F;
        }
        mixdownSamples[c] = static_cast<short>(sample * LIMITER::max());
    }

    CEngine::getInstance()->getSoundEngine()->onEditPlaybackVoiceDataEvent(
      static_cast<acre::id_t>(userID), mixdownSamples, sampleCount, channelCount);

    for (std::uint32_t c = 0; c <= mixdownSampleLength - 1; ++c) {
        float mixedSample = 0.0F;
        if (mixdownSamples[c] > 0) {
            mixedSample = static_cast<float>(mixdownSamples[c]) / LIMITER::max();
        } else {
            mixedSample = -static_cast<float>(mixdownSamples[c]) / LIMITER::min();
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

    uint32_t speakerMask = SPEAKER_STEREO;

    // Make this faster

    // if (mixdownSamples == NULL || sampleCount * channelCount > mixdownSampleLength) {
    const uint32_t mixdownSampleLength = sampleCount * channelCount;
    int16_t *mixdownSamples            = new (nothrow) int16_t[mixdownSampleLength];
    if (mixdownSamples == nullptr) {
        return false;
    }
    //}

    for (uint32_t c = 0; c <= mixdownSampleLength - 1U; ++c) {
        float sample = outputPCM[c];
        if (sample > 1.0F) {
            sample = 1.0F;
        } else if (sample < -1.0F) {
            sample = -1.0F;
        }
        mixdownSamples[c] = static_cast<int16_t>(sample * LIMITER::max());
    }

    CEngine::getInstance()->getSoundEngine()->onEditMixedPlaybackVoiceDataEvent(mixdownSamples, sampleCount, channelCount, speakerMask);

    for (uint32_t c = 0; c <= mixdownSampleLength - 1; ++c) {
        float mixedSample = 0.0F;
        if (mixdownSamples[c] > 0) {
            mixedSample = static_cast<float>(mixdownSamples[c]) / LIMITER::max();
        } else {
            mixedSample = -static_cast<float>(mixdownSamples[c]) / LIMITER::min();
        }
        outputPCM[c] = mixedSample;
    }
    delete[] mixdownSamples;
    return true;
}
