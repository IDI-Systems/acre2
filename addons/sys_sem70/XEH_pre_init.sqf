#include "script_component.hpp"

ADDON = false;

PREP_FOLDER(radio);
PREP_FOLDER(functions);

[] call FUNC(presetInformation);

NO_DEDICATED;

GVAR(currentRadioId) = -1;

// UI Variables
GVAR(backlightOn) = false;
GVAR(displayButtonPressed) = false;


ADDON = true;
