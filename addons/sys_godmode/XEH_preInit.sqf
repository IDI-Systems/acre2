#include "script_component.hpp"

ADDON = false;

PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;

#include "initSettings.sqf"

if (hasInterface) then {
    GVAR(targetUnits) = [];
    GVAR(groupPresets) = [[], [], []];
    GVAR(speakingGods) = [];
    GVAR(accessAllowed) = [false, false];
    GVAR(notificationLayer) = ""; // Name of the notification system layer where the current god mode is displayed
};

ADDON = true;
