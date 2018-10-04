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
params ["","_amount"];

if ((!alive player) || (time < 2)) exitWith {};

if (isNil QGVAR(VolumeControlDialog)) exitWith {};

if (isNull (GVAR(VolumeControlDialog) select 0)) exitWith {};

if (_amount > 0) then {
    GVAR(VolumeControl_Level) = (GVAR(VolumeControl_Level) + 1) min 2;
} else {
    GVAR(VolumeControl_Level) = (GVAR(VolumeControl_Level) - 1) max -2;
};

private _slider = (GVAR(VolumeControlDialog) select 0) displayCtrl 1900;
_slider sliderSetPosition GVAR(VolumeControl_Level);
call FUNC(setVolumeSliderColor);
