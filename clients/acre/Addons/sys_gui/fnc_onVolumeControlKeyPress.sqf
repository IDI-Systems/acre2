#include "script_component.hpp"

if (!(alive acre_player) || GVAR(keyBlock) || time < 1) exitWith { false };

inGameUISetEventHandler ['PrevAction', 'true']; 
inGameUISetEventHandler ['NextAction', 'true'];

GVAR(keyBlock) = true; 
disableSerialization; 

57701 cutRsc [QUOTE(GVAR(VolumeControlDialog)), "PLAIN"];

_slider = (GVAR(VolumeControlDialog) select 0) displayCtrl 1900;
_slider sliderSetRange [-2, 2];

_slider ctrlSetEventHandler ["SliderPosChanged","_this call FUNC(onVolumeControlSliderChanged)"];
_slider sliderSetPosition GVAR(VolumeControl_Level);
call FUNC(setVolumeSliderColor);

false