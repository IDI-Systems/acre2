#include "BabelFilter.h"

#include "DspFilters/Dsp.h"

#include <vector>
#include "FFT.h"

#include "Log.h"

#define _USE_MATH_DEFINES

#include <math.h>

#define AVERAGE_RATE 45


#define TS_SAMPLE_RATE 48000

using namespace std;

CBabelFilter::CBabelFilter( void ) {

}

CBabelFilter::~CBabelFilter( void ) {

}


ACRE_RESULT CBabelFilter::process(short* samples, int sampleCount, int channels, ACRE_ID id) {
    /*
    BabelStruct *speaker = this->getSpeaker(id);
    
    float averageSum, currentSample, averageAmplitude;
    averageSum = 0;
    vector<FFT::Complex> buf_complex((sampleCount*channels)/2);
    for(int i = 0; i < sampleCount*channels && i < 4095; i++) {
        buf_complex[i >> 1] = samples[i >> 1];
        if(samples[i] > 0) {
            currentSample = 20.0f * log10((float)samples[i]);
            averageSum += currentSample;
        }
    }
    averageAmplitude = averageSum/(sampleCount*channels);

    if(speaker->attenCount > AVERAGE_RATE) {
        speaker->attenCount = 1;
        speaker->averageSum = (speaker->averageSum+averageAmplitude)/AVERAGE_RATE;
    } else {
        speaker->averageSum += averageAmplitude;
        speaker->attenCount += 1;
    }
    averageAmplitude = speaker->averageSum/speaker->attenCount;



    
    

    FFT dft(sampleCount*channels);
    vector<FFT::Complex> frequencies = dft.transform(buf_complex);
    
    


    short val;
    float multiplier = tan(averageAmplitude/100);
    for(int i = 0; i < sampleCount; i++){
        //val = sin((2*M_PI*440)/(TS_SAMPLE_RATE*speaker->period))*32768;
        val = 32760 * sin( (2.f*float(M_PI)*(440))/TS_SAMPLE_RATE * speaker->period );
        
        val = multiplier*val;
        val = val * dft.getIntensity(frequencies[i >> 1]);
        if (val < 32760 && val > -32760) {
            samples[i] = val;
        } else if (val > 32760) {
            LOG("CLIP!");
            samples[i] = 32760;
        } else if (val < -32760) {
            LOG("CLIP!");
            samples[i] = -32760;
        }


        //printf("%d(%d) = %d > %d\r\n", id, speaker->period, samples[i], val);
        
        speaker->period++;
    }
    */
    return ACRE_OK;
}

BabelStruct *CBabelFilter::getSpeaker(ACRE_ID id) {
    /*
    LOCK(this);
    BabelStruct *speaker;
    auto it = this->babelSpeakers.find(id);
    if(it == this->babelSpeakers.end()) {
        speaker = new BabelStruct();
        speaker->period = 0;
        speaker->attenCount = 0;
        this->babelSpeakers.insert(std::pair<ACRE_ID, BabelStruct *>(id, speaker));

    } else {
        speaker = it->second;
    }
    return speaker;
    UNLOCK(this);
    */
    return NULL;
}