#include "script_component.hpp"

NO_DEDICATED;

ADDON = false;

PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;

DGVAR(showSignalHint) = false;
DGVAR(terrainScaling) = 1;
DGVAR(omnidirectionalRadios) = 0;

ADDON = true;
