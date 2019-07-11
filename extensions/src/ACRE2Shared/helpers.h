#pragma once

#include "compat.h"

#include <cstdint>

// OS-specific API
bool getModuleVersion(int16_t *const major, int16_t *const minor, int16_t *const patch);

// TeamSpeak
int32_t getTSAPIVersion();
