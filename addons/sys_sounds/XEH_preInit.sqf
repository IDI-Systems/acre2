#include "script_component.hpp"

ADDON = false;

PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;

if (hasInterface) then {
    DGVAR(loadedSounds) = [];
    DGVAR(callBacks) = HASH_CREATE;
    DGVAR(delayedSounds) = [];
};

ADDON = true;
