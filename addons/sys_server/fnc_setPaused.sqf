#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Globally pauses ACRE
 *
 * Arguments:
 * 0: Enable/Disable <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [true] call acre_sys_server_fnc_setPaused
 *
 * Public: No
 */


if (isServer) then {
	params ["_pause"];

	TRACE_2("onSetPaused", ACRE_IS_PAUSED, _pause);
	if !(ACRE_IS_PAUSED isEqualTo _pause) then {
		ACRE_IS_PAUSED = _pause;
		publicVariable "ACRE_IS_PAUSED";
	};
};