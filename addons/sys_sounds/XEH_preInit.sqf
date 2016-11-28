#include "script_component.hpp"

NO_DEDICATED;

ADDON = false;

DGVAR(loadedSounds) = [];
DGVAR(callBacks) = HASH_CREATE;
DGVAR(delayedSounds) = [];

PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;

ADDON = true;
