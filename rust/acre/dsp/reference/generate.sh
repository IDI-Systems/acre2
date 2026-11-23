#!/usr/bin/env bash
# Regenerates ../tests/golden/*.i16 from the original C++ effects in extensions/src/ACRE2Core.
# Needs g++. Usage: ./generate.sh
set -euo pipefail
here="$(cd "$(dirname "$0")" && pwd)"
core="$here/../../../../extensions/src/ACRE2Core"
out="$here/../tests/golden"
build="$(mktemp -d)"
trap 'rm -rf "$build"' EXIT

cp "$core"/{FilterRadio.h,FilterRadio.cpp,AcreDsp.h,AcreDsp.cpp,PinkNoise.cpp,BabbelEffect.h} "$build/"
cp -r "$core/DspFilters" "$build/"
sed -i 's#DspFilters\\Dsp.h#DspFilters/Dsp.h#' "$build/AcreDsp.h"

# Stand-ins for the plugin's Windows/TeamSpeak headers.
cat > "$build/compat.h" <<'H'
#pragma once
#include <climits>
#include <cstring>
#include <cstdlib>
H
cat > "$build/Types.h" <<'H'
#pragma once
#include <cstdint>
namespace acre { using volume_t = float; enum class Result { ok, error }; }
H
: > "$build/Macros.h"
cat > "$build/Log.h" <<'H'
#pragma once
#define LOG(...)
#define TRACE(...)
H
cat > "$build/AcreSettings.h" <<'H'
#pragma once
class CAcreSettings {
public:
    static CAcreSettings *getInstance() { static CAcreSettings s; return &s; }
    int getDisableRadioNoise() { return 1; }
};
H
cat > "$build/SoundMonoEffect.h" <<'H'
#pragma once
#include <map>
#include <string>
class CSoundMonoEffect {
    std::map<std::string, float> params;
public:
    virtual ~CSoundMonoEffect() {}
    virtual void process(short *samples, int sampleCount) = 0;
    void setParam(std::string n, float v) { params[n] = v; }
    float getParam(std::string n) { return params.count(n) ? params[n] : 0.0f; }
};
H

g++ -O2 -std=c++17 -w -include cstdint -include cmath -I"$build" -o "$build/harness" \
    "$here/harness.cpp" "$build/FilterRadio.cpp" "$build/AcreDsp.cpp" "$build/PinkNoise.cpp" \
    "$build"/DspFilters/*.cpp
mkdir -p "$out"
"$build/harness" "$out"
ls -l "$out"
