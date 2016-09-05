#include "script_component.hpp"

disableSerialization;
params["","_amount"];

if ((!alive player) || (time < 2)) exitWith {}; 

if (isNull (GVAR(VolumeControlDialog) select 0)) exitWith {};

if (_amount > 0) then {
	GVAR(VolumeControl_Level) = (GVAR(VolumeControl_Level) + 1) min 2; 
} else {
	GVAR(VolumeControl_Level) = (GVAR(VolumeControl_Level) - 1) max -2; 
};

private _slider = (GVAR(VolumeControlDialog) select 0) displayCtrl 1900;
_slider sliderSetPosition GVAR(VolumeControl_Level);
call FUNC(setVolumeSliderColor);