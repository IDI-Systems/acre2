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
 * [ARGUMENTS] call acre_sys_prc148_fnc_getChannelData
 *
 * Public: No
 */

params ["_radioId", "", "_eventData", "_radioData"];

private _cachedChannels = SCRATCH_GET_DEF(_radioId, "cachedFullChannels", []);
private _return = nil;
if (_eventData < (count _cachedChannels)) then {
    _return = _cachedChannels select _eventData;
} else {
    _return = [_eventData, _radioData] call FUNC(getChannelDataInternal);
};
_return;
