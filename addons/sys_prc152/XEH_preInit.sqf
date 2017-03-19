#include "script_component.hpp"

ADDON = false;

PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;

// *******************************
// DATA PREPERATION
//
[] call FUNC(preset_information);

// Menu hash stuff
GVAR(Menus) = HASH_CREATE;

GVAR(currentRadioId) = -1;

DFUNC(onKnobMouseEnter) = {

};
DFUNC(onKnobMouseExit) = {

};

ADDON = true;
