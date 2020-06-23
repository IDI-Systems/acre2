#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Ask server to pause ACRE globally
 *
 * Arguments:
 * 0: Enable/Disable <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [true] call acre_sys_core_fnc_setPaused
 *
 * Public: No
 */


params ["_pause"];

TRACE_2("setPaused", ACRE_IS_PAUSED, _pause);
if !(ACRE_IS_PAUSED isEqualTo _pause) then {
	if (!_pause) then {
		systemChat "ACRE Enabled";
	} else {
		systemChat "ACRE Disabled";
	};

	[QEGVAR(sys_server,onSetPaused), [_pause]] call CALLSTACK(CBA_fnc_serverEvent);
};
