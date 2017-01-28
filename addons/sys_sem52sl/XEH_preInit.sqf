#include "script_component.hpp"

ADDON = false;

PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;

[] call FUNC(presetInformation);

GVAR(channelMode) = "singleChannel";
GVAR(channelPower) = 1000;
GVAR(channelCTCSS) = 0;
GVAR(channelModulation) = "FM";
GVAR(channelEncryption) = 0;
GVAR(channelSquelch) = 0;

if (!hasInterface) exitWith {
    ADDON = true;
};

GVAR(currentRadioId) = -1;

// UI Variables
GVAR(booting) = false;

ADDON = true;
