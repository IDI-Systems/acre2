#include "script_component.hpp"

NO_DEDICATED;
ADDON = false;
PREP(getSignal);
PREP(handleSignalReturn);

DGVAR(showSignalHint) = false;
DGVAR(terrainScaling) = 1;
DGVAR(omnidirectionalRadios) = 0;

FUNC(handleEndTransmission) = {
    _data = _this select 2;
    _transmitterClass = _data select 0;
    missionNamespace setVariable [_transmitterClass + "_running_count", 0];
    missionNamespace setVariable [_transmitterClass + "_best_signal", -992];
    missionNamespace setVariable [_transmitterClass + "_best_ant", ""];
    nil;
};

ADDON = true;
