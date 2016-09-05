//fnc_getCurrentChannelData.sqf
#include "script_component.hpp"

params["_radioId", "_event", "_eventData", "_radioData"];
private ["_channelNumber", "_return"];

_channelNumber = HASH_GET(_radioData,"currentChannel");
if(isNil "_channelNumber") then {
    _channelNumber = 0;
};
_cachedChannels = SCRATCH_GET_DEF(_radioId, "cachedFullChannels", []);
_return = nil;
if(_channelNumber < (count _cachedChannels)) then {
    _return = _cachedChannels select _channelNumber;
};
if(isNil "_return") then {
    // _istart = diag_tickTime;
    _return = [_channelNumber, _radioData] call FUNC(getChannelDataInternal);
    // _iend = diag_tickTime;
    // diag_log text format["i: %1", _iend-_istart];
    _cachedChannels set[_channelNumber, _return];
    SCRATCH_SET(_radioId, "cachedFullChannels", _cachedChannels);
};
_return;