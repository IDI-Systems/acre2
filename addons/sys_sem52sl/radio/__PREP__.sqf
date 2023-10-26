#include "..\script_component.hpp"


/*
 *  The PREP_MODULE macro is similar to the PREP macro
 *  with the only difference that it has the folder
 *  as an additional parameter
*/

///////////////////////////////
// CfgAcreDataInterface
///////////////////////////////
PREP_MODULE(radio,initializeRadio);

PREP_MODULE(radio,getOnOffState);
PREP_MODULE(radio,setOnOffState);

PREP_MODULE(radio,getListInfo);

PREP_MODULE(radio,getVolume);
PREP_MODULE(radio,setVolume);

PREP_MODULE(radio,getSpatial);
PREP_MODULE(radio,setSpatial);
PREP_MODULE(radio,isExternalAudio);

PREP_MODULE(radio,getChannelData);
PREP_MODULE(radio,setChannelData);
PREP_MODULE(radio,getChannelDescription);

PREP_MODULE(radio,getCurrentChannelData);
PREP_MODULE(radio,getCurrentChannel);
PREP_MODULE(radio,setCurrentChannel);

PREP_MODULE(radio,getStates);
PREP_MODULE(radio,getState);
PREP_MODULE(radio,setState);

///////////////////////////////
//CfgAcrePhysicalInterface
///////////////////////////////
PREP_MODULE(radio,getExternalAudioPosition);

///////////////////////////////
//CfgAcreTransmissionInterface
///////////////////////////////
PREP_MODULE(radio,handleBeginTransmission);
PREP_MODULE(radio,handleEndTransmission);

PREP_MODULE(radio,handleSignalData);
PREP_MODULE(radio,handleMultipleTransmissions);

PREP_MODULE(radio,handlePTTDown);
PREP_MODULE(radio,handlePTTUp);

///////////////////////////////
//CfgAcreInteractInterface
///////////////////////////////
PREP_MODULE(radio,openGUI);
PREP_MODULE(radio,closeGUI);

///////////////////////////////
// Other Functions
///////////////////////////////
//PREP_MODULE(radio,getCurrentChannelInternal);
