#include "script_component.hpp"

ADDON = false;

PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;

// CBA Settings
#include "initSettings.sqf"

GVAR(hintTitle) = "";
GVAR(hintLine1) = "";
GVAR(hintLine2) = "";
GVAR(hintColor) = [];
GVAR(hintBuffer) = [0, 0, 0, 0, 0];

ADDON = true;
