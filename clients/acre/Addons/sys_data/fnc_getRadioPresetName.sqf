//fnc_getRadioPresetName.sqf
#include "script_component.hpp"

params["_class"];

private _return = HASH_GET(GVAR(assignedRadioPresets),_class);
if(isNil "_return") then {
	_return = "default";
};
_return