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
 * [ARGUMENTS] call acre_sys_prc148_fnc_setCurrentChannel
 *
 * Public: No
 */

params ["_radioId", "", "_eventData", "_radioData"];

TRACE_1("SETTING CURRENT CHANNEL",_this);
private _groups = HASH_GET(_radioData,"groups");

{
    _x params ["","_channelNums"];
    private _groupIndex = _forEachIndex;
    if (_eventData in _channelNums) exitWith {
        {
            if (_x == _eventData) then {
                HASH_SET(_radioData,"currentGroup",_groupIndex);
                HASH_SET(_radioData,"channelKnobPosition",_forEachIndex);
            };
        } forEach _channelNums;
    };
} forEach _groups;

private _channelsCount = count ([_radioId, "getState", "channels"] call EFUNC(sys_data,dataEvent)) - 1;
_eventData = (0 max _eventData) min _channelsCount;

HASH_SET(_radioData,"currentChannel",_eventData);
