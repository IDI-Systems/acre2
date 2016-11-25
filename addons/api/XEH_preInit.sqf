#include "script_component.hpp"

ADDON = false;

PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;

DGVAR(selectableCurveScale) = 1.0;
DVAR(ACRE_IS_SPECTATOR) = false;

// module loading variables
GVAR(basicMissionSetup) = false;

ADDON = true;
