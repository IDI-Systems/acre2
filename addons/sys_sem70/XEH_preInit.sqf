#include "script_component.hpp"

ADDON = false;

#include "XEH_PREP.hpp"

[] call FUNC(presetInformation);

GVAR(manualChannel) = 10;

if (hasInterface) then {
    GVAR(currentRadioId) = -1;

    // UI Variables
    GVAR(backlightOn) = false;
    GVAR(displayButtonPressed) = false;
};

ADDON = true
