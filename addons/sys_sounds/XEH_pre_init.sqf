#include "script_component.hpp"

NO_DEDICATED;

ADDON = false;
DGVAR(loadedSounds) = [];
DGVAR(callBacks) = HASH_CREATE;
DGVAR(delayedSounds) = [];

PREP(loadSound);
PREP(playSound);
PREP(handleLoadedSound);

ADDON = true;
