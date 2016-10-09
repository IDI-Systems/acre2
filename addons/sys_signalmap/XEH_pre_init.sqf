#include "script_component.hpp"

NO_DEDICATED;
ADDON = false;

with uiNamespace do {
    GVAR(completedAreas) = [];
    GVAR(areaProgress) = 0;
    GVAR(currentArgs) = [];
    GVAR(rxAreas) = [];
    GVAR(txPosition) = nil;
};

PREP(onMapClick);
PREP(drawSignalMaps);
PREP(drawSignalSamples);
PREP(doProcess);
PREP(modify);
PREP(clear);
PREP(showOverlayMessage);
PREP(clearOverlayMessage);
PREP(onAreaLBChange);
PREP(addRxAreaStart);
PREP(setRxAreaBegin);
PREP(setRxAreaEnd);
PREP(setTxPositionStart);
PREP(setTxPositionEnd);
PREP(drawMenu);
PREP(deleteRxArea);
PREP(open);

ADDON = true;
