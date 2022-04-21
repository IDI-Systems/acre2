#include "script_component.hpp"

ADDON = false;

PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;

if (hasInterface) then {
    GVAR(attenuationCache) = HASH_CREATE;
    GVAR(attenuationTurnedOutCache) = HASH_CREATE;
};

ADDON = true;
