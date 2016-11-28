#include "script_component.hpp"

NO_DEDICATED;

ADDON = false;

PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;

#define TILE_SIZE 4000

with uiNamespace do {
    GVAR(completedAreas) = [];
    GVAR(currentArgs) = [];
    GVAR(rxAreas) = [];
    GVAR(areaProgress) = 0;
    GVAR(txPosition) = nil;
};

ADDON = true;
