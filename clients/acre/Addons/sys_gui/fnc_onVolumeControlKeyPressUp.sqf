#include "script_component.hpp"

if (!(alive acre_player)) exitWith { false };
 
inGameUISetEventHandler ['PrevAction', 'false']; 
inGameUISetEventHandler ['NextAction', 'false'];

disableSerialization; 
GVAR(KeyBlock) = false; 
57701 cutRsc [QUOTE(GVAR(VolumeControlDialog_Close)), "PLAIN"];
call FUNC(closeVolumeControl);


false