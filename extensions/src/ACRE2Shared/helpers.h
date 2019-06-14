#pragma once

#include "compat.h"

// OS-specific API
bool getModuleVersion(short &major, short &minor, short &patch);

// TeamSpeak
int getTSAPIVersion();
