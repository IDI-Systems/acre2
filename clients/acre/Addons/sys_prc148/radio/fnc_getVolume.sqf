//fnc_getVolume.sqf
#include "script_component.hpp"

private["_volume"];
params["_radioId", "_event", "_eventData", "_radioData"];

_volume = HASH_GET(_radioData, "volume");

if((HASH_GET(_radioData, "audioPath") == "INTAUDIO")) then {
	_volume = _volume*0.75;
};

_volume^3;