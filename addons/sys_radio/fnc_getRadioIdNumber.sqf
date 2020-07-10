#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Returns the given radio ID's unique radio number.
 * -1 is returned if the radio ID does not belong to a unique radio.
 *
 * Arguments:
 * 0: Radio ID <STRING>
 *
 * Return Value:
 * Radio ID Number <NUMBER>
 *
 * Example:
 * [_radioId] call acre_sys_radio_fnc_getRadioIdNumber
 *
 * Public: No
 */

params ["_radioId"];

private _radioNumber = getNumber (configFile >> "CfgWeapons" >> _radioId >> "acre_uniqueId");

if (_radioNumber <= 0) then {
    _radioNumber = -1;
};

_radioNumber
