#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Stops a unit speaking from a headless TS client
 *
 * Arguments:
 * 0: Unit <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [q2] call acre_sys_headless_fnc_stop
 *
 * Public: No
 */
if (!hasInterface) exitWith {};

params ["_unit"];
TRACE_1("stop"_unit);

if (isNil {_unit getVariable [QGVAR(keepRunning), nil]}) exitWith { ERROR_1("unit is not active",_this); };

// Won't have immediete effects, will shutdown at next PFEH interval
_unit setVariable [QGVAR(keepRunning), false];
