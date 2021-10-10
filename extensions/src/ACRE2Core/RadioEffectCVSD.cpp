#include "RadioEffectCVSD.h"

CRadioEffectCVSD::CVSDDecoder::CVSDDecoder() {
    lookback_register.reserve(lookback);
}

short CRadioEffectCVSD::CVSDDecoder::decode(bool sample) {
    // shift the new sample into the lookback shift register
    if (lookback_register.size() < lookback) {
        lookback_register.emplace_back();
    }
    std::copy(
        std::next(lookback_register.rbegin()),
        lookback_register.rend(),
        lookback_register.rbegin());
    if (!lookback_register.empty()) {
        lookback_register[0] = sample;
    }

    if (lookback_register.size() >= lookback) {
        // adjust delta
        bool positive_run = true;
        bool negative_run = true;
        for (bool val: lookback_register) {
            positive_run &= val;
            negative_run &= !val;
        }
        if (positive_run || negative_run) {
            delta = std::min(delta += delta_step, delta_max);
        } else {
            delta = std::max(delta *= delta_coef, delta_min);
        }
    }

    // adjust reference
    const short previous_reference = reference;
    if (sample) {
        reference += delta;
        if (reference < previous_reference) {
            reference = SHRT_MAX;
        }
    } else {
        reference -= delta;
        if (reference > previous_reference) {
            reference = SHRT_MIN;
        }
    }
    reference *= decay;

    return reference;
}

bool CRadioEffectCVSD::CVSDEncoder::encode(short sample) {
    const bool ret = sample > reference;
    reference = decoder.decode(ret);
    return ret;
}

CRadioEffectCVSD::CRadioEffectCVSD() {
    input_filter.setup(8, TS_SAMPLE_RATE, CVSD_RATE/2, 1);
    output_filter.setup(8, TS_SAMPLE_RATE, CVSD_RATE/4, 1);
}

// this is an arbitrary function derived empirically to match the intelligibility
// of the existing signalQuality metric at a variety of distances.
float CRadioEffectCVSD::quality_to_ber(float signalQuality) {
    return 0.05 * std::pow((signalQuality - 1), 2);
}

void CRadioEffectCVSD::process(short *samples, int sampleCount) {
    // anti-aliasing LPF prior to downsampling
    input_filter.process(sampleCount, &samples);

    for (std::size_t i = 0; i < sampleCount; i += TS_SAMPLE_RATE / CVSD_RATE) {
        bool coded = encoder.encode(samples[i]);

        // introduce bit errors
        const float bit_error_rate = quality_to_ber(getParam<float>("signalQuality"));
        if ((float) std::rand() / RAND_MAX < bit_error_rate) {
            coded ^= 1;
        }

        samples[i] = decoder.decode(coded);

        // boost the volume
        if (samples[i] < SHRT_MAX / VOL_BOOST) {
            samples[i] *= VOL_BOOST;
        } else {
            samples[i] = SHRT_MAX;
        }

        // upsample back to 48kHz
        for (std::size_t j = 1; j < TS_SAMPLE_RATE / CVSD_RATE; j++) {
            samples[i + j] = samples[i];
        }
    }

    output_filter.process(sampleCount, &samples);
}
