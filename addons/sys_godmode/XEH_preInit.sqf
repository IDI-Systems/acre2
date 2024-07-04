#include "script_component.hpp"

ADDON = false;

PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;

#include "initSettings.inc.sqf"

if (hasInterface) then {
    GVAR(speaking) = false;
    GVAR(targetUnits) = [];
    GVAR(groupPresets) = [[], [], []];
    GVAR(groupNames) = ["", "", ""];
    GVAR(speakingGods) = [];
    GVAR(accessAllowed) = [false, false];
};

ADDON = true;
