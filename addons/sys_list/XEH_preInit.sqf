#include "script_component.hpp"

ADDON = false;

PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;

// CBA Settings
#include "initSettings.inc.sqf"

if (hasInterface) then {
    GVAR(hintBuffer) = [[], [], [], [], []];
    GVAR(hintDisplays) = [];
};

ADDON = true;
