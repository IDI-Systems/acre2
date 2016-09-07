#include "script_component.hpp"
NO_DEDICATED;
ADDON = false;

PREP(getVehicleAttenuateClass);
PREP(getVehicleOutsideAttenuate);
PREP(getVehicleCrewAttenuate);
PREP(getUnitAttenuate);
PREP(getVehicleUnitPosition);
PREP(getVehiclePositionClass);
PREP(isCrewIntercomAttenuate);
PREP(getVehicleAttenuation);

PREP(getPositionAttenuate);

GVAR(attenuationCache) = HASH_CREATE;

ADDON = true;
