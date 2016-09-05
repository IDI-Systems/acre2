#pragma once

#include "compat.h"

#include "SoundMonoEffect.h"
#include "FilterRadio.h"

#define _USE_MATH_DEFINES

#include <math.h>
#include <cmath>

#define VOLUME_MODIFIER 6.0f

class CBabbelEffect : public CSoundMonoEffect {
private:
	Dsp::SimpleFilter<Dsp::Butterworth::LowPass <4>, 1> lpFilter1;
	Dsp::SimpleFilter<Dsp::Butterworth::LowPass <4>, 1> lpFilter2;
	float offset;
	float sfreq;
	float mfreq;
public:
	CBabbelEffect() {
		offset = 128;
		sfreq = 48000;
		mfreq = 5200;
		lpFilter1.setup(4, sfreq, mfreq*0.3);
		lpFilter2.setup(4, sfreq, mfreq*0.5);
	};
	void process(short *samples, int sampleCount) {	
		float *floatPointer[1], *buffer;
		buffer = new float[sampleCount];
		floatPointer[0] = buffer;
		short *tempSamples = new short[sampleCount];
		memcpy(tempSamples, samples, sizeof(short)*sampleCount);
		short maxAmp = 1;
		for(int i = 0; i < sampleCount; ++i) {
			samples[i] = (short)(((float)tempSamples[i]*1.0f)*cos(((float)i/(sfreq/mfreq))*1.4*M_PI));
			//samples[i] += (short)(((float)tempSamples[i]*1.0f+offset)*cos(((float)i/(sfreq/500))*4*M_PI)+offset);
			if(abs(samples[i]) > maxAmp)
				maxAmp = samples[i];
			buffer[i] = (float)samples[i]/(float)SHRT_MAX;
			//samples[i] = samples[i-1] + (short)(alpha*(tempSamples[i] - samples[i-1]));
			//samples[i] = alpha * (samples[i-1] + tempSamples[i] - tempSamples[i-1]);
		}

		

		lpFilter1.process(sampleCount, floatPointer);
		//lpFilter2.process(sampleCount, floatPointer);
	
		for(int i = 0; i < sampleCount; ++i) {
			samples[i] = (short)((floatPointer[0][i]*SHRT_MAX)*1.0);
			//if(abs(samples[i]) < 200) {
			//	samples[i] = samples[i]*0.01;
			//}

			buffer[i] = (float)samples[i]/(float)SHRT_MAX;
		}
		lpFilter2.process(sampleCount, floatPointer);

		short maxAmpPost = 1;

		for(int i = 0; i < sampleCount; ++i) {
			if(((floatPointer[0][i]*SHRT_MAX)*VOLUME_MODIFIER) > SHRT_MAX) {
				samples[i] = SHRT_MAX;
			} else if(((floatPointer[0][i]*SHRT_MAX)*VOLUME_MODIFIER) < SHRT_MIN) {
				samples[i] = SHRT_MIN;
			} else {
				samples[i] = (short)((floatPointer[0][i]*SHRT_MAX)*VOLUME_MODIFIER);
				//if(abs(samples[i]) < 50) {
				//	samples[i] = samples[i]*0.01;
				//}
			};
			if(abs(samples[i]) > maxAmpPost)
				maxAmpPost = samples[i];
		}

		//float difference = (float)(maxAmp/maxAmpPost);


		//for(int i = 0; i < sampleCount; i = i + 1) {
		//	samples[i] = samples[i]*difference;
		//}

		delete tempSamples;
		delete buffer;
	};
};