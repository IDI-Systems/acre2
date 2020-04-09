#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Sets the duplex of radio transmissions. If set to true, it means that you will receive transmissions even while talking and multiple people can speak at the same time.
 *
 * Arguments:
 * 0: Enable full duplex <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [true] call acre_sys_core_fnc_setFullDuplex
 *
 * Public: No
 */

if (!hasInterface) exitWith {false};

params ["_value"];

// Set
GVAR(fullDuplex) = _value;
