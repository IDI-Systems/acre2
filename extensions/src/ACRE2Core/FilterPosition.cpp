#include "FilterPosition.h"
#include "PositionalMixdownEffect.h"
#include "Engine.h"

#include "AcreSettings.h"
#include "AcreDsp.h"
#include "Log.h"

#include <cmath>
#pragma comment(lib, "x3daudio.lib")

#define MAX_FALLOFF_DISTANCE    75
#define MAX_FALLOFF_RANGE        150

static const X3DAUDIO_CONE Listener_DirectionalCone = { X3DAUDIO_PI*5.0f/6.0f, X3DAUDIO_PI*11.0f/6.0f, 1.0f, 0.75f, 0.0f, 0.25f, 0.708f, 1.0f };

static const X3DAUDIO_DISTANCE_CURVE_POINT distanceCurvePoints[151] = { 0.000000f, 1.000000f,1.000000f, 1.000000f,2.000000f, 1.000000f,3.000000f, 1.000000f,4.000000f, 1.000000f,5.000000f, 1.000000f,6.000000f, 1.000000f,7.000000f, 1.000000f,8.000000f, 1.000000f,9.000000f, 0.857339f,10.000000f, 0.694445f,11.000000f, 0.573921f,12.000000f, 0.482253f,13.000000f, 0.410914f,14.000000f, 0.354308f,15.000000f, 0.308642f,16.000000f, 0.271267f,17.000000f, 0.240292f,18.000000f, 0.214335f,19.000000f, 0.192367f,20.000000f, 0.173611f,21.000000f, 0.157470f,22.000000f, 0.143480f,23.000000f, 0.131275f,24.000000f, 0.120563f,25.000000f, 0.111111f,26.000000f, 0.102728f,27.000000f, 0.095260f,28.000000f, 0.088577f,29.000000f, 0.082574f,30.000000f, 0.077160f,31.000000f, 0.072263f,32.000000f, 0.067817f,33.000000f, 0.063769f,34.000000f, 0.060073f,35.000000f, 0.056689f,36.000000f, 0.053584f,37.000000f, 0.050726f,38.000000f, 0.048092f,39.000000f, 0.045657f,40.000000f, 0.043403f,41.000000f, 0.041311f,42.000000f, 0.039368f,43.000000f, 0.037558f,44.000000f, 0.035870f,45.000000f, 0.034294f,46.000000f, 0.032819f,47.000000f, 0.031437f,48.000000f, 0.030141f,49.000000f, 0.028923f,50.000000f, 0.027778f,51.000000f, 0.026699f,52.000000f, 0.025682f,53.000000f, 0.024722f,54.000000f, 0.023815f,55.000000f, 0.022957f,56.000000f, 0.022144f,57.000000f, 0.021374f,58.000000f, 0.020643f,59.000000f, 0.019950f,60.000000f, 0.019290f,61.000000f, 0.018663f,62.000000f, 0.018066f,63.000000f, 0.017497f,64.000000f, 0.016954f,65.000000f, 0.016437f,66.000000f, 0.015942f,67.000000f, 0.015470f,68.000000f, 0.015018f,69.000000f, 0.014586f,70.000000f, 0.014172f,71.000000f, 0.013776f,72.000000f, 0.013396f,73.000000f, 0.013031f,74.000000f, 0.012682f,75.000000f, 0.012346f,76.000000f, 0.012023f,77.000000f, 0.011713f,78.000000f, 0.011414f,79.000000f, 0.011127f,80.000000f, 0.010851f,81.000000f, 0.010584f,82.000000f, 0.010328f,83.000000f, 0.010080f,84.000000f, 0.009842f,85.000000f, 0.009612f,86.000000f, 0.009389f,87.000000f, 0.009175f,88.000000f, 0.008968f,89.000000f, 0.008767f,90.000000f, 0.008573f,91.000000f, 0.008386f,92.000000f, 0.008205f,93.000000f, 0.008029f,94.000000f, 0.007859f,95.000000f, 0.007695f,96.000000f, 0.007535f,97.000000f, 0.007381f,98.000000f, 0.007231f,99.000000f, 0.007085f,100.000000f, 0.006944f,101.000000f, 0.006808f,102.000000f, 0.006675f,103.000000f, 0.006546f,104.000000f, 0.006421f,105.000000f, 0.006299f,106.000000f, 0.006181f,107.000000f, 0.006066f,108.000000f, 0.005954f,109.000000f, 0.005845f,110.000000f, 0.005739f,111.000000f, 0.005636f,112.000000f, 0.005536f,113.000000f, 0.005439f,114.000000f, 0.005344f,115.000000f, 0.005251f,116.000000f, 0.005161f,117.000000f, 0.005073f,118.000000f, 0.004987f,119.000000f, 0.004904f,120.000000f, 0.004823f,121.000000f, 0.004743f,122.000000f, 0.004666f,123.000000f, 0.004590f,124.000000f, 0.004516f,125.000000f, 0.004444f,126.000000f, 0.004374f,127.000000f, 0.004306f,128.000000f, 0.004239f,129.000000f, 0.004173f,130.000000f, 0.004109f,131.000000f, 0.004047f,132.000000f, 0.003986f,133.000000f, 0.003926f,134.000000f, 0.003867f,135.000000f, 0.003810f,136.000000f, 0.003755f,137.000000f, 0.003700f,138.000000f, 0.003647f,139.000000f, 0.003594f,140.000000f, 0.003543f,141.000000f, 0.003493f,142.000000f, 0.003444f,143.000000f, 0.003396f,144.000000f, 0.003349f,145.000000f, 0.003303f,146.000000f, 0.003258f,147.000000f, 0.003214f,148.000000f, 0.003170f,149.000000f, 0.003128f, 150.0f, 0.0f };
static const X3DAUDIO_DISTANCE_CURVE       distanceCurve          = { (X3DAUDIO_DISTANCE_CURVE_POINT*)&distanceCurvePoints[0], 151 };

//ACRE_RESULT CFilterPosition::process(short* samples, int sampleCount, int channels, CPlayer *player, const unsigned int* channelSpeakerArray, unsigned int *channelMask, ACRE_VOLUME volume) {
ACRE_RESULT CFilterPosition::process(short* samples, int sampleCount, int channels, const unsigned int speakerMask, CSoundMixdownEffect *params) {
    X3DAUDIO_LISTENER Listener = {};
    X3DAUDIO_EMITTER Emitter = {0};
    X3DAUDIO_DSP_SETTINGS DSPSettings = {0};
    X3DAUDIO_CONE emitterCone = {0};

    X3DAUDIO_VECTOR listener_position;
    X3DAUDIO_VECTOR speaker_position;
    X3DAUDIO_VECTOR vector_listenerDirection;
    X3DAUDIO_VECTOR vector_speakerDirection;
    
    //LOCK(player);
    //LOCK(CEngine::getInstance()->getSelf());
    float killCoef;
    float *Matrix = new float[1 * channels];

    //LOG("channels: %d", channels);
    if (!this->p_IsInitialized) {
        // we need to figure out what channel mask we want to use.
        /*
        unsigned int initSpeakers = channelSpeakerArray[0];
        LOG("Speaker 1: %d", channelSpeakerArray[0]);
        for (int i = 1; i < channels; i++) {
            LOG("Speaker %d: %d", i+1, channelSpeakerArray[i]);
            initSpeakers = initSpeakers | channelSpeakerArray[i];
        }
        */
        X3DAudioInitialize(speakerMask, X3DAUDIO_SPEED_OF_SOUND, this->p_X3DInstance);

        this->p_IsInitialized = true;
    }
    
    if (CAcreSettings::getInstance()->getDisablePosition())
        return ACRE_OK;

    DSPSettings.SrcChannelCount = 1;
    DSPSettings.DstChannelCount = channels;
    DSPSettings.pMatrixCoefficients = Matrix;

    speaker_position.x = params->getParam("speakerPosX");
    speaker_position.y = params->getParam("speakerPosY");
    speaker_position.z = params->getParam("speakerPosZ");

    Emitter.Position = speaker_position;

    vector_speakerDirection.x = params->getParam("headVectorX");
    vector_speakerDirection.y = params->getParam("headVectorY");
    vector_speakerDirection.z = params->getParam("headVectorZ");

    Emitter.OrientFront = vector_speakerDirection;
    Emitter.OrientTop = this->getUpVector(vector_speakerDirection);
    Emitter.Velocity = X3DAUDIO_VECTOR( 0, 0, 0 );
    Emitter.ChannelCount = 1;

    if (params->getParam("isWorld") == POSITIONAL_EFFECT_ISWORLD) {
        listener_position.x = CEngine::getInstance()->getSelf()->getWorldPosition().x;
        listener_position.y = CEngine::getInstance()->getSelf()->getWorldPosition().y;
        listener_position.z = CEngine::getInstance()->getSelf()->getWorldPosition().z;


        vector_listenerDirection.x = CEngine::getInstance()->getSelf()->getHeadVector().x;
        vector_listenerDirection.y = CEngine::getInstance()->getSelf()->getHeadVector().y;
        vector_listenerDirection.z = CEngine::getInstance()->getSelf()->getHeadVector().z;

        if (params->getParam("speakingType") == ACRE_SPEAKING_DIRECT) {
            /*if(CEngine::getInstance()->getSoundEngine()->getCurveModel() == ACRE_CURVE_MODEL_AMPLITUDE) {
                Emitter.CurveDistanceScaler = (player->getAmplitudeCoef())*(CEngine::getInstance()->getSoundEngine()->getCurveScale());
                Emitter.pVolumeCurve = NULL;
            } else */
            if (CEngine::getInstance()->getSoundEngine()->getCurveModel() == ACRE_CURVE_MODEL_SELECTABLE_A) {
                Emitter.CurveDistanceScaler = 1.0f*(params->getParam("curveScale"));
                Emitter.pVolumeCurve = NULL;
            } else if (CEngine::getInstance()->getSoundEngine()->getCurveModel() == ACRE_CURVE_MODEL_SELECTABLE_B) {
                Emitter.CurveDistanceScaler = 1.0f*(params->getParam("curveScale"));
                Emitter.pVolumeCurve = (X3DAUDIO_DISTANCE_CURVE *)&distanceCurve;
            } else {
                Emitter.CurveDistanceScaler = 1.0f;
                Emitter.pVolumeCurve = NULL;
                //Emitter.pVolumeCurve = (X3DAUDIO_DISTANCE_CURVE *)&distanceCurve;
            }
        } else {
            Emitter.CurveDistanceScaler = 1.0f;
            Emitter.pVolumeCurve = (X3DAUDIO_DISTANCE_CURVE *)&distanceCurve;
        }
    } else {
        listener_position.x = 0.0f;
        listener_position.y = 0.0f;
        listener_position.z = 0.0f;


        vector_listenerDirection.x = 0.0f;
        vector_listenerDirection.y = 1.0f;
        vector_listenerDirection.z = 0.0f;

        Emitter.CurveDistanceScaler = 1.0f;
        Emitter.pVolumeCurve = (X3DAUDIO_DISTANCE_CURVE *)&distanceCurve;
    }
    
    Emitter.DopplerScaler = 1.0f;
    Emitter.ChannelRadius = 1.0f;

    emitterCone.InnerAngle = X3DAUDIO_PI/4;
    emitterCone.OuterAngle = X3DAUDIO_PI/2;
    emitterCone.InnerVolume = 1.2f;
    emitterCone.OuterVolume = 1.0f;

    Emitter.pCone = &emitterCone;
    //Listener.pCone = &emitterCone;

    
    

    Emitter.InnerRadius = 2.0f;
    Emitter.InnerRadiusAngle = X3DAUDIO_PI/4.0f;

    X3DAUDIO_VECTOR listener_topVec = this->getUpVector(vector_listenerDirection);

    //float listenerDot = vector_listenerDirection.x*listener_topVec.x + vector_listenerDirection.y*listener_topVec.y + vector_listenerDirection.z*listener_topVec.z;
    //TRACE("Listener Dot Product: %f", listenerDot);
    Listener.OrientFront = vector_listenerDirection;
    Listener.OrientTop = listener_topVec;
    Listener.Position = listener_position;
    
    //UNLOCK(CEngine::getInstance()->getSelf());
    //UNLOCK(player);
    

    X3DAudioCalculate(this->p_X3DInstance, &Listener, &Emitter,
    X3DAUDIO_CALCULATE_MATRIX | X3DAUDIO_CALCULATE_EMITTER_ANGLE,
    &DSPSettings );

    /*
    std::string matrixVals = std::string("");
    for (int i = 0; i < channels; i++) {
        char *mAppend;
        sprintf(mAppend, "%f, ", Matrix[i]);
        matrixVals.append(std::string(mAppend));
    }
    
    TRACE("MATRIX: %s", matrixVals.c_str());
    */
    TRACE("matrix: c:[%d], %f, %f, %f", channels, Matrix[0], Matrix[1], (Matrix[0] + Matrix[1]));// +Matrix[2] + Matrix[3] + Matrix[4] + Matrix[5]));
    /*
    LOG("Positions: d:[%f], l:[%f,%f,%f] s:[%f,%f,%f]",
        DSPSettings.EmitterToListenerDistance,
        Listener.Position.x,
        Listener.Position.y,
        Listener.Position.z,
        Emitter.Position.x,
        Emitter.Position.y,
        Emitter.Position.z
        );
    */


    if (CEngine::getInstance()->getSoundEngine()->getCurveModel() == ACRE_CURVE_MODEL_AMPLITUDE || CEngine::getInstance()->getSoundEngine()->getCurveModel() == ACRE_CURVE_MODEL_SELECTABLE_A) {
        killCoef = std::max(0.0f,(1-((DSPSettings.EmitterToListenerDistance-(MAX_FALLOFF_DISTANCE))/MAX_FALLOFF_RANGE)));

        if (DSPSettings.EmitterToListenerDistance < (MAX_FALLOFF_DISTANCE)) {
            killCoef = 1;
        }
        killCoef = std::min(1.0f, killCoef);
    } else {
        killCoef = 1;
    };
    //LOG("dis: %f kc: %f ac: %f", DSPSettings.EmitterToListenerDistance, killCoef, this->getPlayer()->getAmplitudeCoef());
    for (int x = 0; x < sampleCount * channels; x+=channels) {
        for (int i = 0; i < channels; i++) {
            samples[x+i] = (short)(samples[x+i] * Matrix[i] * killCoef);
        }
    }

    if (Matrix)
        delete Matrix;

    return ACRE_OK;
}

X3DAUDIO_VECTOR CFilterPosition::getUpVector(X3DAUDIO_VECTOR inVector) {
    float elev = asin(inVector.y)+1.5707963268f;
    float dir = atan2(inVector.x, inVector.z);

    X3DAUDIO_VECTOR outVector;

    outVector.x = cos(elev)*sin(dir);
    outVector.y = sin(elev);
    outVector.z = cos(elev)*cos(dir);

    return outVector;
}

CFilterPosition::CFilterPosition(void)
{
    CoInitializeEx(NULL, NULL);
    this->p_IsInitialized = false;
}

CFilterPosition::~CFilterPosition(void) {
    CoUninitialize();
}

/*
#define TS_SPEAKER_FRONT_LEFT              0x1
#define TS_SPEAKER_FRONT_RIGHT             0x2
#define TS_SPEAKER_FRONT_CENTER            0x4
#define TS_SPEAKER_LOW_FREQUENCY           0x8
#define TS_SPEAKER_BACK_LEFT               0x10
#define TS_SPEAKER_BACK_RIGHT              0x20
#define TS_SPEAKER_FRONT_LEFT_OF_CENTER    0x40
#define TS_SPEAKER_FRONT_RIGHT_OF_CENTER   0x80
#define TS_SPEAKER_BACK_CENTER             0x100
#define TS_SPEAKER_SIDE_LEFT               0x200
#define TS_SPEAKER_SIDE_RIGHT              0x400
#define TS_SPEAKER_TOP_CENTER              0x800
#define TS_SPEAKER_TOP_FRONT_LEFT          0x1000
#define TS_SPEAKER_TOP_FRONT_CENTER        0x2000
#define TS_SPEAKER_TOP_FRONT_RIGHT         0x4000
#define TS_SPEAKER_TOP_BACK_LEFT           0x8000
#define TS_SPEAKER_TOP_BACK_CENTER         0x10000
#define TS_SPEAKER_TOP_BACK_RIGHT          0x20000
*/

#define TS_SPEAKER_FRONT_LEFT              0x1
#define TS_SPEAKER_FRONT_RIGHT             0x2
#define TS_SPEAKER_FRONT_CENTER            0x4
#define TS_SPEAKER_LOW_FREQUENCY           0x8
#define TS_SPEAKER_BACK_LEFT               0x10
#define TS_SPEAKER_BACK_RIGHT              0x20
#define TS_SPEAKER_FRONT_LEFT_OF_CENTER    0x40
#define TS_SPEAKER_FRONT_RIGHT_OF_CENTER   0x80
#define TS_SPEAKER_BACK_CENTER             0x100
#define TS_SPEAKER_SIDE_LEFT               0x200
#define TS_SPEAKER_SIDE_RIGHT              0x400
#define TS_SPEAKER_TOP_CENTER              0x800
#define TS_SPEAKER_TOP_FRONT_LEFT          0x1000
#define TS_SPEAKER_TOP_FRONT_CENTER        0x2000
#define TS_SPEAKER_TOP_FRONT_RIGHT         0x4000
#define TS_SPEAKER_TOP_BACK_LEFT           0x8000
#define TS_SPEAKER_TOP_BACK_CENTER         0x10000
#define TS_SPEAKER_TOP_BACK_RIGHT          0x20000

unsigned int CFilterPosition::getChannelMask(const unsigned int channelMask) {
    unsigned int returnValue = 0x0;
    LOG("Mask Get: %08x %u %08x %d %d", channelMask, channelMask, TS_SPEAKER_FRONT_LEFT, TS_SPEAKER_FRONT_LEFT, channelMask == TS_SPEAKER_FRONT_LEFT);
    switch(channelMask) {
        case TS_SPEAKER_FRONT_LEFT:
            LOG("Found: %08x", SPEAKER_FRONT_LEFT);
            returnValue = SPEAKER_FRONT_LEFT; 
            break;
        case TS_SPEAKER_FRONT_RIGHT:
            LOG("Found: %08x", SPEAKER_FRONT_RIGHT);
            returnValue = SPEAKER_FRONT_RIGHT; 
            break;
        case TS_SPEAKER_FRONT_CENTER: 
            LOG("Found: %08x", SPEAKER_FRONT_CENTER);
            returnValue = SPEAKER_FRONT_CENTER; 
            break;
        case TS_SPEAKER_LOW_FREQUENCY: 
            LOG("Found: %08x", SPEAKER_LOW_FREQUENCY);
            returnValue = SPEAKER_LOW_FREQUENCY; 
            break;
        case TS_SPEAKER_BACK_LEFT: 
            LOG("Found: %08x", SPEAKER_BACK_LEFT);
            returnValue = SPEAKER_BACK_LEFT; 
            break;
        case TS_SPEAKER_BACK_RIGHT: 
            LOG("Found: %08x", SPEAKER_BACK_RIGHT);
            returnValue = SPEAKER_BACK_RIGHT; 
            break;
        case TS_SPEAKER_FRONT_LEFT_OF_CENTER: 
            LOG("Found: %08x", SPEAKER_FRONT_LEFT_OF_CENTER);
            returnValue = SPEAKER_FRONT_LEFT_OF_CENTER; 
            break;
        case TS_SPEAKER_FRONT_RIGHT_OF_CENTER: 
            LOG("Found: %08x", SPEAKER_FRONT_RIGHT_OF_CENTER);
            returnValue = SPEAKER_FRONT_RIGHT_OF_CENTER; 
            break;
        case TS_SPEAKER_BACK_CENTER: 
            LOG("Found: %08x", SPEAKER_BACK_CENTER);
            returnValue = SPEAKER_BACK_CENTER; 
            break;
        case TS_SPEAKER_SIDE_LEFT: 
            LOG("Found: %08x", SPEAKER_SIDE_LEFT);
            returnValue = SPEAKER_SIDE_LEFT; 
            break;
        case TS_SPEAKER_SIDE_RIGHT: 
            LOG("Found: %08x", SPEAKER_SIDE_RIGHT);
            returnValue = SPEAKER_SIDE_RIGHT; 
            break;
        case TS_SPEAKER_TOP_CENTER: 
            LOG("Found: %08x", SPEAKER_TOP_CENTER);
            returnValue = SPEAKER_TOP_CENTER; 
            break;
        case TS_SPEAKER_TOP_FRONT_LEFT: 
            LOG("Found: %08x", SPEAKER_TOP_FRONT_LEFT);
            returnValue = SPEAKER_TOP_FRONT_LEFT; 
            break;
        case TS_SPEAKER_TOP_FRONT_CENTER: 
            LOG("Found: %08x", SPEAKER_TOP_FRONT_CENTER);
            returnValue = SPEAKER_TOP_FRONT_CENTER; 
            break;
        case TS_SPEAKER_TOP_FRONT_RIGHT: 
            LOG("Found: %08x", SPEAKER_TOP_FRONT_RIGHT);
            returnValue = SPEAKER_TOP_FRONT_RIGHT; 
            break;
        case TS_SPEAKER_TOP_BACK_LEFT: 
            LOG("Found: %08x", SPEAKER_TOP_BACK_LEFT);
            returnValue = SPEAKER_TOP_BACK_LEFT; 
            break;
        case TS_SPEAKER_TOP_BACK_CENTER: 
            LOG("Found: %08x", SPEAKER_TOP_BACK_CENTER);
            returnValue = SPEAKER_TOP_BACK_CENTER; 
            break;
        case TS_SPEAKER_TOP_BACK_RIGHT: 
            LOG("Found: %08x", SPEAKER_TOP_BACK_RIGHT);
            returnValue = SPEAKER_TOP_BACK_RIGHT; 
            break;
    }
    LOG("Mask Return: %08x", returnValue);
    return returnValue;
}