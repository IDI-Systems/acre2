#include "script_component.hpp"

ADDON = false;

PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;

if (hasInterface) then {
    GVAR(blackListAnims) = ["amovppnemstpsraswrfldnon","aadjppnemstpsraswrfldleft","aadjppnemstpsraswrfldright"];
    GVAR(binoClasses) = "getText (_x >> 'simulation') == 'Binocular'" configClasses (configFile >> "CfgWeapons") apply {configName _x};
};

#include "initSettings.sqf"

ADDON = true;
