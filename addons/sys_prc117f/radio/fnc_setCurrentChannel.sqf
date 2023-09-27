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
 * [ARGUMENTS] call acre_sys_prc117f_fnc_setCurrentChannel
 *
 * Public: No
 */

TRACE_1("", _this);

params ["_radioId", "", "_eventData", "_radioData"];

private _channelsCount = count ([_radioId, "getState", "channels"] call EFUNC(sys_data,dataEvent)) - 1;
_eventData = (0 max _eventData) min _channelsCount;

TRACE_1("SETTING CURRENT CHANNEL",_this);
HASH_SET(_radioData,"currentChannel",_eventData);
