#include "script_component.hpp"
NO_DEDICATED;
ADDON = false;

PREP(actionSetMTT);
PREP(actionSetSpatialAudio);
PREP(generateConnectors);
PREP(generateConnectorActions);
PREP(generateConnectorList);
PREP(generateSpatialChildrenActions);
PREP(generateMountableRadioActions);
PREP(radioChildrenActions);
PREP(rackChildrenActions);
PREP(rackListChildrenActions);
PREP(radioListChildrenActions);
PREP(radioPTTChildrenActions);
PREP(initVehicle);

GVAR(initializedVehicleClasses) = [];

// Show/Hide connectors
GVAR(connectorsEnabled) = false;

ADDON = true;
