#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Gets the channel data. It consists of mode, transmitting and receiving frequencies and power
 *
 * Arguments:
 * 0: Radio ID <STRING> (Unused)
 * 1: Event: "getCurrentChannelData" <STRING> (Unused)
 * 2: Event data <ARRAY> (Unused)
 * 3: Radio data <HASH>
 * 4: Remote <BOOL> (Unused)
 *
 * Return Value:
 * Hash with mode, transmitting and receiving frequencies and power <HASH>
 *
 * Example:
 * ["ACRE_BF888S_ID_1", "getCurrentChannelData", [], _radioData, false] call acre_sys_bf888s_fnc_getCurrentChannelData
 *
 * Public: No
 */

params ["_radioId", "_event", "_eventData", "_radioData"];

private _channelNumber = HASH_GET(_radioData,"currentChannel");
if (isNil "_channelNumber") then {
    _channelNumber = 0;
};
private _cachedChannels = SCRATCH_GET_DEF(_radioId, "cachedFullChannels", []);
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
    SCRATCH_SET(_radioId, "cachedFullChannels", _cachedChannels);
};
_return
