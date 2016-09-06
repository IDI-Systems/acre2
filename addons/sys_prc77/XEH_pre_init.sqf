#include "script_component.hpp"

ADDON = false;

PREP_FOLDER(radio);

PREP(closeGui);
PREP(initializeRadio);
PREP(onBandSelectorKnobPress);
PREP(onFunctionKnobPress);
PREP(onkHzTuneKnobPress);
PREP(onMHzTuneKnobPress);
PREP(onPresetKnobPress);
PREP(onVolumeKnobPress);
PREP(openGui);
PREP(render);
PREP(snapbackFunctionKnob);

// PREP(setChannelData);
// PREP(getChannelData);
// PREP(getStates);


NO_DEDICATED;


ADDON = true;
