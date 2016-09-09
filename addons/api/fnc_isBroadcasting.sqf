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
#include "script_component.hpp"

params["_unit"];

if(_unit in acre_sys_core_keyedMicRadios) exitWith {
    true
};
false
