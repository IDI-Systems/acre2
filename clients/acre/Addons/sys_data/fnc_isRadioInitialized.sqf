//fnc_isRadioInitialized.sqf
#include "script_component.hpp"

params ["_radioId"];

private _dataCheck = HASH_GET(GVAR(radioData),_radioId);
private _return = true;
if(isNil "_dataCheck") then {
	_return = false;
};
_return