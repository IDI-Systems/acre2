#include "script_component.hpp"

ADDON = false;

PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;

// DATA PREPERATION
GVAR(Menus) = HASH_CREATE; // Must be created first
[] call FUNC(preset_information);

GVAR(currentRadioId) = -1;

ADDON = true;
