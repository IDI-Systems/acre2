#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Returns true or false whether the provided classname is a ACRE radio or not.
 * This function returns false on Radio Base Classes.
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

getNumber (_config >> "acre_uniqueId") != 0
&& {getNumber (_config >> "scope") == 1}
