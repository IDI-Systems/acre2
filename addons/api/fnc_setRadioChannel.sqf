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

params ["_radioId", "_channelNumber"];

if( !(_radioId isEqualType "")) exitWith { -1 };

if(_channelNumber isEqualType 0) then {
    _channelNumber = _channelNumber - 1;
    [_radioId, "setCurrentChannel", _channelNumber] call EFUNC(sys_data,dataEvent);
} else {
    // Should we handle a channel NAME and find it, and change it?!?

};

true
