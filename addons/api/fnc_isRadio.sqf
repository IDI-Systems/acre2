#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Returns true or false whether the provided weapon is a ACRE radio or not.
 *
 * Arguments:
 * 0: Classname <STRING>
 *
 * Return Value:
 * Whether the provided object class name is a radio or not <BOOLEAN>
 *
 * Example:
 * _isRadio = ["NVGoggles"] call acre_api_fnc_isRadio;
 *
 * Public: Yes
 */

params [
    ["_radio", "", [""]]
];

private _config = configFile >> "CfgWeapons" >> _radio;

getNumber (_config >> "acre_isRadio") == 1
&& {getNumber (_config >> "scope") >= 1}
