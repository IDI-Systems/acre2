#include "script_component.hpp"

ADDON = false;

PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;

if (hasInterface) then {
    // Initialise intercom variables
    GVAR(initializedIntercom) = [];
    GVAR(initializedInfantryPhone) = [];
    GVAR(intercomPFH) = -1;

    // Todo: Change to key down/up
    GVAR(broadcastKey) = false;
    GVAR(intercomPttKey) = false;
    GVAR(intercomUse) = [];

    GVAR(guiOpened) = false;
    GVAR(configChanged) = false;
    GVAR(activeIntercom) = -1;
};

ADDON = true;
