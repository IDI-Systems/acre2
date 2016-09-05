#include "script_component.hpp"

disableSerialization;
57701 cutRsc [QUOTE(GVAR(VolumeControlDialog)), "PLAIN"];

private _slider = (GVAR(VolumeControlDialog) select 0) displayCtrl 1900;
_slider sliderSetRange [-2, 2];

_slider ctrlSetEventHandler ["SliderPosChanged","_this call FUNC(onVolumeControlSliderChanged)"];

_slider sliderSetPosition GVAR(VolumeControl_Level);
call FUNC(setVolumeSliderColor);

_slider ctrlCommit 0;
//systemChat format["Initializing volume at %1 (should be 0) and %2 (should be .7)",GVAR(VolumeControl_Level),call acre_api_fnc_getSelectableVoiceCurve]; 
sleep .01; // acceptable?
57701 cutRsc [QUOTE(GVAR(VolumeControlDialog_Close)), "PLAIN"];
