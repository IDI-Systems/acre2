#include "..\script_component.hpp"
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
 * [ARGUMENTS] call acre_sys_sem52sl_fnc_onAudioSocketPress
 *
 * Public: No
 */

params ["","_key"];

private _audioPath = GET_STATE("audioPath");

if (_audioPath == "HEADSET") then {
    [GVAR(currentRadioId), "setState", ["audioPath", "INTSPEAKER"]] call EFUNC(sys_data,dataEvent);
} else {
    [GVAR(currentRadioId), "setState", ["audioPath", "HEADSET"]] call EFUNC(sys_data,dataEvent);
};

[MAIN_DISPLAY] call FUNC(render);
