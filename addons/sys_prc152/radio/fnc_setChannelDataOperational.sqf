/*
 * Author: AUTHOR
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
#include "script_component.hpp"

private["_opt", "_optChannelId"];
params["_radioId", "channelId", "_key", "_value"];


_optChannelId = [GVAR(currentRadioId), "getState", "optChannelId"] call EFUNC(sys_data,dataEvent);
_opt = [GVAR(currentRadioId), "getState", "optChannelData"] call EFUNC(sys_data,dataEvent);

if(_optChannelId != _channelId) then {
    _opt = HASH_CREATE;
    [GVAR(currentRadioId), "setState", "optChannelId", _optChannelId] call EFUNC(sys_data,dataEvent);
    false
};

HASH_SET(_opt, _key, _value);

[GVAR(currentRadioId), "setState", "optChannelData", _opt] call EFUNC(sys_data,dataEvent);

true
