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
 * [ARGUMENTS] call acre_sys_prc343_fnc_getChannelDescription;
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_radioId"];

_currentAbsChannel = [_radioId, "getCurrentChannel"] call EFUNC(sys_data,dataEvent);
_currentBlock = floor(_currentAbsChannel / 16);
_currentChannel = _currentAbsChannel - _currentBlock*16;

_description = format["Block %1 - Channel %2", _currentBlock +1, _currentChannel +1];

_description
