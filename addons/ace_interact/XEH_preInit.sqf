#include "script_component.hpp"

ADDON = false;

PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;

// Show/Hide connectors
GVAR(connectorsEnabled) = false;

ADDON = true;
