#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Checks whether the provided unit is currently broadcasting on a radio.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 *
 * Return Value:
 * Broadcasting <BOOLEAN>
 *
 * Example:
 * _isBroadcasting = [player] call acre_api_fnc_isBroadcasting;
 *
 * Public: Yes
 */

params ["_unit"];

if (_unit in EGVAR(sys_core,keyedMicRadios)) exitWith {
    true
};
false
