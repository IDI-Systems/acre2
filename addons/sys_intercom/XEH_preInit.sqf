#include "script_component.hpp"

ADDON = false;

PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;

DGVAR(intercomConfigured) = false;

if (hasInterface) then {
    // Initialise intercom variables
    GVAR(initializedPassengerIntercom) = [];
    GVAR(initializedInfantryPhone) = [];
};

ADDON = true;
