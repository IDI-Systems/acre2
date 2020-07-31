#include "script_component.hpp"

ADDON = false;

PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;

if (hasInterface) then {
    GVAR(targetUnits) = [];
    GVAR(groupPresets) = [[], [], []];
    GVAR(speakingGods) = [];
    GVAR(accessAllowed) = [false, false];
};

ADDON = true;
