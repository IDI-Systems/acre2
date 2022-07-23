#include "Engine.h"
#include "FilterPosition.h"
#include "FilterVolume.h"
#include "Log.h"
#include "MumbleClient.h"
#include "Wave.h"
#include "compat.h"

#include <Tracy.hpp>

#include <map>
#define _USE_MATH_DEFINES

#include "AcreDsp.h"

#include <cmath>
#include <math.h>

using LIMITER = std::numeric_limits<int16_t>;

bool mumble_onAudioSourceFetched(float *outputPCM, uint32_t sampleCount, uint16_t channelCount, uint32_t sampleRate, bool isSpeech, mumble_userid_t userID) {
    (void) sampleRate;

    if (CEngine::getInstance()->getSoundSystemOverride()) {
        return false;
    }

    if (!CEngine::getInstance()->getGameServer()) {
        return false;
    }

    if (!CEngine::getInstance()->getGameServer()->getConnected()) {
        return false;
    }

    ZoneScoped;

    // Make this faster
    const std::uint32_t mixdownSampleLength = sampleCount;
    int16_t *mixdownSamples                 = new (std::nothrow) int16_t[mixdownSampleLength];
    if (mixdownSamples == nullptr) {
        return false;
    }

    if (channelCount > 1) {
        std::uint32_t c = 0;
        for (std::uint32_t x = 0; x < sampleCount * channelCount; x += channelCount) {
            float sample = 0.0F;
            for (int i = 0; i < channelCount; i++) {
                sample += outputPCM[x + i];
            }
            sample = sample / static_cast<float>(channelCount);
            if (sample > 1.0F) {
                sample = 1.0F;
            } else if (sample < -1.0F) {
                sample = -1.0F;
            }
            mixdownSamples[c] = static_cast<short>(sample * LIMITER::max());
            c++; // lulz
        }
    } else {
        for (std::uint32_t c = 0; c < mixdownSampleLength; ++c) {
            float sample = outputPCM[c];
            if (sample > 1.0F) {
                sample = 1.0F;
            } else if (sample < -1.0F) {
                sample = -1.0F;
            }
            mixdownSamples[c] = static_cast<short>(sample * LIMITER::max());
        }
    }

    // should always be channel count of 1 since everything is mono and mumble is ... using stereo
    // dumb legacy crap.
    CEngine::getInstance()->getSoundEngine()->onEditPlaybackVoiceDataEvent(
      static_cast<acre::id_t>(userID), mixdownSamples, sampleCount, 1);


    if (channelCount > 1) {
        std::uint32_t c = 0;
        for (std::uint32_t x = 0; x < sampleCount * channelCount; x += channelCount) {
            float mixedSample = 0.0F;
            if (mixdownSamples[c] > 0) {
                mixedSample = static_cast<float>(mixdownSamples[c]) / LIMITER::max();
            } else {
                mixedSample = -static_cast<float>(mixdownSamples[c]) / LIMITER::min();
            }

            mixedSample = mixedSample / static_cast<float>(channelCount);
            for (int i = 0; i < channelCount; i++) {
                outputPCM[x + i] = mixedSample;
            }
            c++;
        }
    } else {
        for (std::uint32_t c = 0; c < mixdownSampleLength; ++c) {
            float mixedSample = 0.0F;
            if (mixdownSamples[c] > 0) {
                mixedSample = static_cast<float>(mixdownSamples[c]) / LIMITER::max();
            } else {
                mixedSample = -static_cast<float>(mixdownSamples[c]) / LIMITER::min();
            }
            outputPCM[c] = mixedSample;
        }
    }
    delete[] mixdownSamples;
    return true;
}

bool mumble_onAudioOutputAboutToPlay(float *outputPCM, uint32_t sampleCount, uint16_t channelCount, uint32_t sampleRate) {
    tracy::SetThreadName("Mumble audio output thread");

    (void) sampleRate;

    if (CEngine::getInstance()->getSoundSystemOverride()) {
        return false;
    }

    if (!CEngine::getInstance()->getGameServer()) {
        return false;
    }

    if (!CEngine::getInstance()->getGameServer()->getConnected()) {
        return false;
    }

    ZoneScoped;

    uint32_t speakerMask = SPEAKER_STEREO;

    // Make this faster
    const uint32_t mixdownSampleLength = sampleCount * channelCount;
    int16_t *mixdownSamples            = new (std::nothrow) int16_t[mixdownSampleLength];
    if (mixdownSamples == nullptr) {
        return false;
    }

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
