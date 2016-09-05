//fnc_setState.sqf
#include "script_component.hpp"

params["_radioId", "_event", "_eventData", "_radioData"];

HASH_SET(_radioData, _eventData select 0, _eventData select 1);
// if(_radioId == acre_sys_radio_currentRadioDialog) then {
	// _display = uiNamespace getVariable QUOTE(GVAR(currentDisplay));
	// [_display] call FUNC(render);
// };