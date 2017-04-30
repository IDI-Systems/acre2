#include "script_component.hpp"

ADDON = false;

PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;

// DATA PREPERATION
GVAR(Menus) = HASH_CREATE; // Base hash for menus
PREP_FOLDER(menus\types); // Directly calls after compilation
PREP_FOLDER(farris_menus); // Directly calls after compilation

[] call FUNC(preset_information);

GVAR(currentRadioId) = -1;

ADDON = true;
