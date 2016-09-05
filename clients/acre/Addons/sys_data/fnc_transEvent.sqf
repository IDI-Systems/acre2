//fnc_transEvent.sqf
#include "script_component.hpp"
// _this = [radioId, eventType, data]
private _params = ["CfgAcreTransmissionInterface"];
/*_params set[1, _this select 0];
_params set[2, _this select 1];
if((count _this) == 3) then {
	_params set[3, _this select 2];
};*/
_params append _this;
_params call FUNC(acreEvent);