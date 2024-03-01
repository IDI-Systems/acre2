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
 * [ARGUMENTS] call acre_sys_prc117f_fnc_setChannelDataOperational
 *
 * Public: No
 */

params ["", "_channelId", "_key", "_value"];

private _optChannelId = [GVAR(currentRadioId), "getState", "optChannelId"] call EFUNC(sys_data,dataEvent);
private _opt = [GVAR(currentRadioId), "getState", "optChannelData"] call EFUNC(sys_data,dataEvent);

if (_optChannelId != _channelId) then {
    _opt = HASH_CREATE;
    [GVAR(currentRadioId), "setState", "optChannelId", _optChannelId] call EFUNC(sys_data,dataEvent);
    false
};

HASH_SET(_opt,_key,_value);

[GVAR(currentRadioId), "setState", "optChannelData", _opt] call EFUNC(sys_data,dataEvent);

true
