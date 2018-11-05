#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * SHORT DESCRIPTION
 *
 * Arguments:
 * 0: ARGUMENT ONE <TYPE>
 * 1: ARGUMENT TWO <TYPE>
 *
 * Return Value:
 * RETURN VALUE <TYPE>
 *
 * Example:
 * [ARGUMENTS] call acre_COMPONENT_fnc_FUNCTIONNAME
 *
 * Public: No
 */

disableSerialization;
(QGVAR(VolumeControlDialog) call BIS_fnc_rscLayer) cutRsc [QGVAR(VolumeControlDialog), "PLAIN"];

private _slider = (GVAR(VolumeControlDialog) select 0) displayCtrl 1900;
_slider sliderSetRange [-2, 2];

_slider ctrlSetEventHandler ["SliderPosChanged", QUOTE(_this call FUNC(onVolumeControlSliderChanged))];

_slider sliderSetPosition GVAR(VolumeControl_Level);
call FUNC(setVolumeSliderColor);

_slider ctrlCommit 0;
//systemChat format["Initializing volume at %1 (should be 0) and %2 (should be .7)",GVAR(VolumeControl_Level),call acre_api_fnc_getSelectableVoiceCurve];
sleep .01; // acceptable?
(QGVAR(VolumeControlDialog) call BIS_fnc_rscLayer) cutText ["", "PLAIN"];
