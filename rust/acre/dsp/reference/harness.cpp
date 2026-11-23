// Runs the original ACRE2Core effects on a fixed input and writes the results, so the Rust
// port (acre2_dsp) can be compared against them. Built by generate.sh; not part of any build.
//
// Noise is disabled: the original draws it from rand(), which can't be reproduced.

#include <cmath>
#include <cstdio>
#include <cstdint>
#include <vector>
#include <string>

#include "FilterRadio.h"
#include "BabbelEffect.h"

static const int RATE = 48000;
static const int BLOCK = 480;  // TeamSpeak callback size
static const int LEN = RATE / 2;

static void write(const std::string &path, const std::vector<short> &v) {
    FILE *f = fopen(path.c_str(), "wb");
    fwrite(v.data(), sizeof(short), v.size(), f);
    fclose(f);
}

// A voice-like input: harmonics of a gliding 120 Hz pitch shaped by three formants, with a
// syllable-rate envelope. Deterministic, so the Rust test reads it from input.i16.
static std::vector<short> make_input() {
    std::vector<short> out(LEN);
    double phase = 0.0;
    const double formants[3][2] = {{730, 90}, {1090, 110}, {2440, 170}};
    for (int i = 0; i < LEN; ++i) {
        double t = double(i) / RATE;
        double f0 = 120.0 + 15.0 * sin(2 * M_PI * 0.7 * t);
        phase = fmod(phase + f0 / RATE, 1.0);
        double v = 0.0;
        for (int k = 1; k <= 40 && f0 * k < RATE / 2; ++k) {
            double f = f0 * k, g = 0.05;
            for (auto &fm : formants) g += 1.0 / (1.0 + pow((f - fm[0]) / fm[1], 2));
            v += g / k * sin(2 * M_PI * phase * k);
        }
        double env = 0.8 + 0.2 * sin(2 * M_PI * 4.0 * t);
        out[i] = short(v * env * 0.18 * 32767.0);
    }
    return out;
}

static std::vector<short> radio(const std::vector<short> &in, float quality, bool loudspeaker) {
    CFilterRadio filter;
    std::vector<short> out(in);
    for (int i = 0; i < LEN; i += BLOCK)
        filter.process(out.data() + i, BLOCK, 1, quality, false, loudspeaker);
    return out;
}

static std::vector<short> babbel(const std::vector<short> &in) {
    CBabbelEffect effect;
    std::vector<short> out(in);
    for (int i = 0; i < LEN; i += BLOCK)
        effect.process(out.data() + i, BLOCK);
    return out;
}

int main(int argc, char **argv) {
    std::string dir = argc > 1 ? argv[1] : ".";
    auto input = make_input();
    write(dir + "/input.i16", input);
    write(dir + "/radio_q100.i16", radio(input, 1.0f, false));
    write(dir + "/radio_q050_loudspeaker.i16", radio(input, 0.5f, true));
    write(dir + "/radio_q015.i16", radio(input, 0.15f, false));
    write(dir + "/babbel.i16", babbel(input));
    return 0;
}
