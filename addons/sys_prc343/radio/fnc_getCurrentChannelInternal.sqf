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

params["_radioId"];

private _currentChannelId = [_radioId, "getState", "currentChannel"] call EFUNC(sys_data,dataEvent);
if(isNil "_currentChannelId") then {
    _currentChannelId = 0;
};

_currentChannelId
