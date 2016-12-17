#include "script_component.hpp"

NO_DEDICATED;

ADDON = false;

PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;


GVAR(initializedVehicleClasses) = [];

// Show/Hide connectors
GVAR(connectorsEnabled) = false;

ADDON = true;
