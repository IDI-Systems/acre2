#include "script_component.hpp"

ADDON = false;

DGVAR(selectableCurveScale) = 1.0;
DVAR(ACRE_IS_SPECTATOR) = false;

// DEPRICATED /////
PREP(mapChannelFieldName); // DEPRICATING
PREP(setDefaultChannels);    // DEPRICATING
PREP(getDefaultChannels);    // DEPRICATING

// module loading variables
GVAR(basicMissionSetup) = false;

ADDON = true;
