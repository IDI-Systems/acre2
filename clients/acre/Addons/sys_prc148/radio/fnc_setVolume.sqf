//fnc_setVolume.sqf
#include "script_component.hpp"

private ["_vol"];
params["_radioId", "_event", "_eventData", "_radioData"];

_vol = _eventData;

if(_vol%0.20 != 0) then {
	_vol = _vol-(_vol%0.20);
};

HASH_SET(_radioData, "volume", _eventData);