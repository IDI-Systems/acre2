#include "script_component.hpp"

ADDON = false;

PREP(monitorRadios);

PREP(setActiveRadio);

PREP(openRadio);
PREP(onDialogClose);

PREP(initDefaultRadio);
PREP(onReturnRadioId);

PREP(getRadioVolume);
PREP(setRadioVolume);


PREP(setRadioSpatial);
PREP(getRadioSpatial);

PREP(getRadioPos);
PREP(getRadioObject);
PREP(getRadioSubObject);
PREP(radioExists);
PREP(nearRadios);
PREP(playRadioSound);
PREP(handleRadioSpatialKeyPressed);

PREP(onPlayerKilled);



NO_DEDICATED;

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
// acre_player setVariable [QUOTE(GVAR(currentRadioList)), []];

if(isNil QUOTE(GVAR(defaultItemRadioType))) then {
    GVAR(defaultItemRadioType) = "ACRE_PRC343";
};

ADDON = true;
