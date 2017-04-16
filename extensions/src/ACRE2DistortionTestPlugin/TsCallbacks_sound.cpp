#include "compat.h"

#include "public_errors.h"
#include "public_definitions.h"
#include "public_rare_definitions.h"
#include "ts3_functions.h"

#include "FilterRadio.h"
#include "FilterVolume.h"
#include "FilterPosition.h"

#include "Engine.h"

#include "Log.h"

#include "TsCallbacks.h"

#include "TS3Client.h"

#include "Wave.h"

#include <map>
#define _USE_MATH_DEFINES

#include <math.h>
#include <cmath>

#include "AcreDsp.h"


extern TS3Functions ts3Functions;

bool filterInit = false;

short maxSample = 0;
short maxSampleAft = 0;

CFilterRadio g_RadioFilter;

void ts3plugin_onEditPlaybackVoiceDataEvent(uint64 server, anyID id, short* samples, int sampleCount, int channels) {
    //CEngine::getInstance()->getSoundEngine()->onEditPlaybackVoiceDataEvent((ACRE_ID)id, samples, sampleCount, channels);
    //maxSample = std::max(maxSample, samples[0]);
    //LOG("MAX BEFORE: %d", maxSample);
    LOG("ENTER: ts3plugin_onEditPlaybackVoiceDataEvent: sampleCount=%d,channels=%d", sampleCount, channels);
    g_RadioFilter.process(samples, sampleCount, channels, 0.9, false);

}

void ts3plugin_onEditPostProcessVoiceDataEvent(uint64 server, anyID id, short* samples, int sampleCount, int channels, const unsigned int* channelSpeakerArray, unsigned int* channelFillMask) {
    //CEngine::getInstance()->getSoundEngine()->onEditPostProcessVoiceDataEvent((ACRE_ID)id, samples, sampleCount, channels, channelSpeakerArray, channelFillMask);
    //memset(samples, 0x00, (sampleCount*channels)*sizeof(short) );
    //*channelFillMask = (1<<channels)-1;
}

void ts3plugin_onEditMixedPlaybackVoiceDataEvent(uint64 serverConnectionHandlerID, short* samples, int sampleCount, int channels, const unsigned int* channelSpeakerArray, unsigned int* channelFillMask) {
    //LOG("ENTER: ts3plugin_onEditMixedPlaybackVoiceDataEvent: sampleCount=%d,channels=%d,channelFillMask=%08x", sampleCount, channels, *channelFillMask);
    /*maxSampleAft = std::max(maxSampleAft, (short)(samples[0] + samples[1]));
    
    
    //for (int x = 0; x < channels; x++) {
    //    LOG("\tchannelSpeakerArray[%d]=%08x", x, channelSpeakerArray[x]);
    //}

    //LOG("MAX AFTER: %d", maxSampleAft);
    if (CEngine::getInstance()->getSoundSystemOverride())
        return;
    if (!CEngine::getInstance()->getGameServer())
        return;
    if (!CEngine::getInstance()->getGameServer()->getConnected())
        return;
    UINT32 speakerMask = 0;
    if (!((CTS3Client *)(CEngine::getInstance()->getClient()))->getIsX3DInitialized())
    {
        
        if (channelSpeakerArray[0] >= 0x10000000) {
            for (int c = 0; c < channels; c++) {
                //LOG("c: %d i: %08x o: %08x", c, channelSpeakerArray[c], this->getChannelMask(channelSpeakerArray[c]));
                speakerMask |= channelSpeakerArray[c];
            }
            LOG("WARNING! WARNING! Teamspeak is possibly running in Windows Audio Session playback mode. This mode does not correctly determine surround sound channels!");
            LOG("WARNING! WARNING! ACRE IS NOW INITIALIZING POSITIONAL AUDIO IN STEREO MODE!");
            LOG("Speaker setup init: %08x [%dx%d] (2CH = %08x, 5.1CH = %08x/%08x, 7.1CH = %08x/%08x)", speakerMask, sampleCount, channels, SPEAKER_STEREO, SPEAKER_5POINT1, SPEAKER_5POINT1_SURROUND, SPEAKER_7POINT1, SPEAKER_7POINT1_SURROUND);
            speakerMask = SPEAKER_STEREO;
        }
        else {
            for (int c = 0; c < channels; c++) {
                //LOG("c: %d i: %08x o: %08x", c, channelSpeakerArray[c], this->getChannelMask(channelSpeakerArray[c]));
                speakerMask |= channelSpeakerArray[c];
            }
            LOG("Speaker setup init: %08x [%dx%d] (2CH = %08x, 5.1CH = %08x/%08x, 7.1CH = %08x/%08x)", speakerMask, sampleCount, channels, SPEAKER_STEREO, SPEAKER_5POINT1, SPEAKER_5POINT1_SURROUND, SPEAKER_7POINT1, SPEAKER_7POINT1_SURROUND);
        }
        ((CTS3Client *)(CEngine::getInstance()->getClient()))->setIsX3DInitialized(true);
        ((CTS3Client *)(CEngine::getInstance()->getClient()))->setSpeakerMask(speakerMask);
    }
    else
    {
        speakerMask = ((CTS3Client *)(CEngine::getInstance()->getClient()))->getSpeakerMask();
    }
    *channelFillMask = (1 << channels) - 1;

    //LOG("EXIT: ts3plugin_onEditMixedPlaybackVoiceDataEvent: sampleCount=%d,channels=%d,speakerMask=%08x,channelFillMask=%08x", sampleCount, channels, speakerMask, *channelFillMask);
    CEngine::getInstance()->getSoundEngine()->onEditMixedPlaybackVoiceDataEvent(samples, sampleCount, channels, speakerMask);
    */
}

void ts3plugin_onEditCapturedVoiceDataEvent(uint64 server, short* samples, int sampleCount, int channels, int* edited) {
    //CEngine::getInstance()->getSoundEngine()->onEditCapturedVoiceDataEvent(samples, sampleCount, channels);
}