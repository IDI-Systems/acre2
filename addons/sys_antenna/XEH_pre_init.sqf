#include "script_component.hpp"
NO_DEDICATED;
ADDON = false;

PREP(getAntennaInfo);
PREP(getGain);
PREP(interp);
PREP(getElevationXtoY);

GVAR(antennaCache) = HASH_CREATE;

ADDON = true;
