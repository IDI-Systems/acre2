#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Returns all radios defined in CfgAcreRadios. Caches result for future calls.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * 0: Radio Class Names <ARRAY>
 * 1: Radio Display Names <ARRAY>
 *
 * Example:
 * [] call acre_sys_core_fnc_getAllRadios;
 *
 * Public: No
 */

// Return cached if already ran
if (!isNil QGVAR(allRadios)) exitWith {
    GVAR(allRadios)
};

// Compile and cache for later calls
private _classes = [];
private _names = [];
{
    private _isRadio = getNumber (_x >> "type") == ACRE_COMPONENT_RADIO;
    private _hasComponents = getArray (_x >> "defaultComponents") isNotEqualTo []; // Only non-base classes have that
    private _name = getText (_x >> "name");

    // Has name and isAcre, assume valid radio class
    if (_isRadio && {_hasComponents} && {_name != ""}) then {
        _classes pushBack (configName _x);
        _names pushBack _name;
    };
} forEach ("true" configClasses (configFile >> "CfgAcreComponents"));

GVAR(allRadios) = [_classes, _names];
GVAR(allRadios)
