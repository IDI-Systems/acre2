#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Gets the display name for a radio ID.
 *
 * Arguments:
 * 0: Radio ID <STRING>
 *
 * Return Value:
 * Radio display name <STRING>
 *
 * Example:
 * ["ACRE_PRC343_ID_1"] call acre_api_fnc_getDisplayName
 *
 * Public: Yes
 */

params [
    ["_radioId", "", [""]]
];

private _baseClass = BASE_CLASS_CONFIG(_radioId);
private _typeName = getText (configFile >> "CfgAcreComponents" >> _baseClass >> "name");

_typeName
