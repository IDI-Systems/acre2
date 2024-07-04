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
 * [ARGUMENTS] call acre_sys_prc148_fnc_getCurrentChannelData
 *
 * Public: No
 */

params ["_radioId", "_event", "_eventData", "_radioData"];

private _channelNumber = HASH_GET(_radioData,"currentChannel");
if (isNil "_channelNumber") then {
    _channelNumber = 0;
};
private _cachedChannels = SCRATCH_GET_DEF(_radioId,"cachedFullChannels",[]);
private _return = nil;
if (_channelNumber < (count _cachedChannels)) then {
    _return = _cachedChannels select _channelNumber;
};
if (isNil "_return") then {
    // _istart = diag_tickTime;
    _return = [_channelNumber, _radioData] call FUNC(getChannelDataInternal);
    // _iend = diag_tickTime;
    // diag_log text format["i: %1", _iend-_istart];
    _cachedChannels set[_channelNumber, _return];
    SCRATCH_SET(_radioId,"cachedFullChannels",_cachedChannels);
};
_return;
