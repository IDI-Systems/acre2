#include "script_component.hpp"

PREP_MODULE(radio,initializeRadio);

PREP_MODULE(radio,setVolume);
PREP_MODULE(radio,getVolume);
PREP_MODULE(radio,getSpatial);
PREP_MODULE(radio,setSpatial);
PREP_MODULE(radio,setChannelData);
PREP_MODULE(radio,getChannelData);
PREP_MODULE(radio,getChannelDataInternal);
PREP_MODULE(radio,getCurrentChannelData);
PREP_MODULE(radio,getChannelDescription);
PREP_MODULE(radio,getCurrentChannel);
PREP_MODULE(radio,getCurrentChannelInternal);

PREP_MODULE(radio,setCurrentChannel);
PREP_MODULE(radio,getStates);
PREP_MODULE(radio,getState);
PREP_MODULE(radio,setState);
PREP_MODULE(radio,getOnOffState);
PREP_MODULE(radio,setOnOffState);
PREP_MODULE(radio,handleMultipleTransmissions);
PREP_MODULE(radio,handleBeginTransmission);
PREP_MODULE(radio,handleEndTransmission);
PREP_MODULE(radio,handleSignalData);
PREP_MODULE(radio,handlePTTDown);
PREP_MODULE(radio,handlePTTUp);
PREP_MODULE(radio,isExternalAudio);
PREP_MODULE(radio,getExternalAudioPosition);

PREP_MODULE(radio,closeGUI);
PREP_MODULE(radio,openGUI);
