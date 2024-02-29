#include "script_component.hpp"

ADDON = false;

PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;

if (hasInterface) then {
    GVAR(blackListAnims) = ["amovppnemstpsraswrfldnon", "aadjppnemstpsraswrfldleft", "aadjppnemstpsraswrfldright"];
    GVAR(binoClasses) = QUOTE(getNumber (_x >> 'type') == TYPE_BINOCULAR) configClasses (configFile >> "CfgWeapons") apply {configName _x};
    GVAR(disallowedViews) = ["GUNNER", "GROUP"];
};

#include "initSettings.inc.sqf"

ADDON = true;
