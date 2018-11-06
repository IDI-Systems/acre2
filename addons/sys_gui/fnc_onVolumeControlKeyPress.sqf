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

if (!alive acre_player || time < 1 || GVAR(keyBlock) || dialog || ACRE_IS_SPECTATOR) exitWith {
    if (!GVAR(keyBlock)) then {
        call FUNC(onVolumeControlKeyPressUp);
    };
    false
};

inGameUISetEventHandler ["PrevAction", "true"];
inGameUISetEventHandler ["NextAction", "true"];

GVAR(keyBlock) = true;
disableSerialization;

(QGVAR(VolumeControlDialog) call BIS_fnc_rscLayer) cutRsc [QGVAR(VolumeControlDialog), "PLAIN"];

private _slider = (GVAR(VolumeControlDialog) select 0) displayCtrl 1900;
_slider sliderSetRange [-2, 2];

_slider ctrlSetEventHandler ["SliderPosChanged", QUOTE(_this call FUNC(onVolumeControlSliderChanged))];
_slider sliderSetPosition GVAR(VolumeControl_Level);
call FUNC(setVolumeSliderColor);

false
