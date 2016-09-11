/*
 * Author: ACRE2Team
 * Returns all radios defined in CfgAcreRadios.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * 1: Radio Class Names <ARRAY>
 * 2: Radio Display Names <ARRAY>
 *
 * Example:
 * [] call acre_api_fnc_getAllRadios;
 *
 * Public: Yes
 */
#include "script_component.hpp"

// Return cached if already ran
if (!isNil QGVAR(allRadios)) exitWith {
    GVAR(allRadios)
};

// Compile and cache for later calls
private _classes = [];
private _names = [];
{
    private _isAcre = getNumber (_x >> "isAcre"); // All radio classes have that
    private _name = getText (_x >> "name"); // Only non-base classes have that

    // Has name and isAcre, assume valid radio class
    if (_isAcre == 1 && {_name != ""}) then {
        _classes pushBack (configName _x);
        _names pushBack _name;
    };
} forEach ("true" configClasses (configFile >> "CfgAcreComponents"));

GVAR(allRadios) = [_classes, _names];
GVAR(allRadios)
