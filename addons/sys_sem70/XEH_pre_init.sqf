#include "script_component.hpp"

ADDON = false;

PREP_FOLDER(radio);
PREP_FOLDER(functions);

[] call FUNC(presetInformation);

GVAR(channelMode) = "singleChannel";
GVAR(channelPower) = 400;
GVAR(channelCTCSS) = 0;
GVAR(channelModulation) = "FM";
GVAR(channelEncryption) = 0;
GVAR(channelSquelch) = 0;

NO_DEDICATED;

GVAR(currentRadioId) = -1;

// UI Variables
GVAR(backlightOn) = false;
GVAR(displayButtonPressed) = false;


ADDON = true;
