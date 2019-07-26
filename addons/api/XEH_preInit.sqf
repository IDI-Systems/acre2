#include "script_component.hpp"

ADDON = false;

PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;

DVAR(ACRE_IS_SPECTATOR) = false;

// Generally ranges from 0.1 (whispering) to 1.3 (shouting)
GVAR(selectableCurveScale) = 0.7;

// Module loading variables
GVAR(basicMissionSetup) = false;

ADDON = true;
