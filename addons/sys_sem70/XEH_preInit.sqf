#include "script_component.hpp"

ADDON = false;

PREP_FOLDER(radio);
PREP_FOLDER(functions);

[] call FUNC(presetInformation);

if (hasInterface) then {
    GVAR(manualChannel) = 10;
    GVAR(currentRadioId) = -1;

    // UI Variables
    GVAR(backlightOn) = false;
    GVAR(displayButtonPressed) = false;
};

ADDON = true
