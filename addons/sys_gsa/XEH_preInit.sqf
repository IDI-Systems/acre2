#include "script_component.hpp"

ADDON = false;

PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;

if (hasInterface) then {
    GVAR(initializedAntennas) = [];
};

if (isServer) then {
    GVAR(gsaPFH) = [] call CBA_fnc_hashCreate;
};

ADDON = true;
