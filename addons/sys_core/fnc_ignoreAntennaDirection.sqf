#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Use this to enable/disable the ignoring of antenna direction in the radio signal simulation.
 *
 * Arguments:
 * 0: Enable ignoring of antenna direction (omnidirectional radios) <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [true] call acre_sys_core_fnc_ignoreAntennaDirection
 *
 * Public: No
 */

if (!hasInterface) exitWith {false};

params ["_value"];

// Set
EGVAR(sys_signal,omnidirectionalRadios) = parseNumber _value;
