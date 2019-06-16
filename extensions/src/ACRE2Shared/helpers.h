#pragma once

#include "compat.h"

#include <cstdint>

// OS-specific API
bool getModuleVersion(int16_t *major, int16_t *minor, int16_t *patch);

// TeamSpeak
int32_t getTSAPIVersion();
