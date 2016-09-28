#include "script_component.hpp"
NO_DEDICATED;
ADDON = false;

PREP(getUnitAttenuate);
PREP(isCrewIntercomAttenuate);
PREP(getVehicleAttenuation);

GVAR(attenuationCache) = HASH_CREATE;

ADDON = true;
