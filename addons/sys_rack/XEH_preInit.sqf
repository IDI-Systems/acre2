#include "script_component.hpp"

ADDON = false;

PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;

// Define caches to save repetitive config lookups.
GVAR(rackBaseClassCache) = HASH_CREATE;

if (hasInterface) then {
    GVAR(initializedVehicleClasses) = [];
    GVAR(rackPFH) = -1;
};

ADDON = true;
