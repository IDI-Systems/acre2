#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Sets whether transmissions will interfere with each other. This, by default, causes signal loss when multiple people are transmitting on the same frequency.
 *
 * Arguments:
 * 0: Enable interference <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [true] call acre_sys_core_fnc_setInterference
 *
 * Public: No
 */

if (!hasInterface) exitWith {false};

params ["_value"];

// Set
GVAR(interference) = _value;
