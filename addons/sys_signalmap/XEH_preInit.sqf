#include "script_component.hpp"

ADDON = false;

PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;

if (hasInterface) then {
    #define TILE_SIZE 4000

    with uiNamespace do {
        GVAR(completedAreas) = [];
        GVAR(currentArgs) = [];
        GVAR(rxAreas) = [];
        GVAR(areaProgress) = 0;
        GVAR(txPosition) = nil;
    };
};
ADDON = true;
