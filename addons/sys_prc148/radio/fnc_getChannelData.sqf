//fnc_getChannelData.sqf
#include "script_component.hpp"

params["_radioId", "_event", "_eventData", "_radioData"];
private ["_cachedChannels", "_return"];

_cachedChannels = SCRATCH_GET_DEF(_radioId, "cachedFullChannels", []);
_return = nil;
if(_eventData < (count _cachedChannels)) then {
    _return = _cachedChannels select _eventData;
} else {
    _return = [_eventData, _radioData] call FUNC(getChannelDataInternal);
};
_return;