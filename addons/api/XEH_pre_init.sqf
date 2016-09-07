#include "script_component.hpp"

ADDON = false;

DGVAR(selectableCurveScale) = 1.0;
DVAR(ACRE_IS_SPECTATOR) = false;

// Field name mapping for unifying radio field names
PREP(mapChannelFieldName);


// DEPRICATED /////
PREP(setDefaultChannels);    // DEPRICATING
PREP(getDefaultChannels);    // DEPRICATING

// module loading variables
GVAR(basicMissionSetup) = false;

ADDON = true;
