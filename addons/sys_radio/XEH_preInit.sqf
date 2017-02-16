#include "script_component.hpp"

ADDON = false;

PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;

// Define caches to save repetitive config lookups.
GVAR(radioUniqueCache) = HASH_CREATE;
GVAR(radioBaseClassCache) = HASH_CREATE;
GVAR(radioIsBaseClassCache) = HASH_CREATE;

ADDON = true;

if (hasInterface) then {
    //DGVAR(workingRadioList) = [];
    DGVAR(currentRadioList) = [];

    // Addition for compat: Compat features / remote features can add a radio here.
    // TODO: not managed by monitorRadios yet
    DGVAR(auxRadioList) = [];
    DGVAR(pendingClaim) = 0;
    DGVAR(replacementRadioIdList) = [];

    // handler callbacks
    //DGVAR(radioListHandlers) = [];
    //DGVAR(lostRadioHandlers) = [];
    //DGVAR(gotRadioHandlers) = [];

    DGVAR(currentRadioDialog) = "";

    DVAR(ACRE_ACTIVE_RADIO) = "";
    DVAR(ACRE_SPECTATOR_RADIOS) = [];

    // this isn't used anymore i do not think?
    // acre_player setVariable [QGVAR(currentRadioList), []];

    if (isNil QGVAR(defaultItemRadioType)) then {
        GVAR(defaultItemRadioType) = "ACRE_PRC343";
    };
};

ADDON = true;
