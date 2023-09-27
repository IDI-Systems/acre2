#include "..\script_component.hpp"

/*
 *  The PREP_MODULE macro is similar to the PREP macro
 *  with the only difference that it has the folder
 *  as an additional parameter
*/

PREP_MODULE(functions,presetInformation);
PREP_MODULE(functions,render);
PREP_MODULE(functions,renderRack);
PREP_MODULE(functions,renderDisplay);
PREP_MODULE(functions,clearDisplay);

PREP_MODULE(functions,onMainKnobTurn);
PREP_MODULE(functions,onChannelStepKnobTurn);
PREP_MODULE(functions,onMHzKnobTurn);
PREP_MODULE(functions,onkHzKnobTurn);
PREP_MODULE(functions,onFunctionKnobTurn);
PREP_MODULE(functions,onNetworkKnobTurn);
PREP_MODULE(functions,onMemorySlotKnobTurn);
PREP_MODULE(functions,onVolumeKnobTurn);
PREP_MODULE(functions,onDisplayButtonPress);

PREP_MODULE(functions,setNetworkID);
