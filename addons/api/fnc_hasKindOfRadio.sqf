#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Checks whether the provided unit has a radio of the specified radio type in their inventory.
 *
 * Arguments:
 * 0: Unit or array of item classnames <OBJECT, ARRAY>
 * 1: Radio base type <STRING>
 *
 * Return Value:
 * Has kind of radio <BOOLEAN>
 *
 * Example:
 * _hasRadio = [player, "ACRE_PRC148"] call acre_api_fnc_hasKindOfRadio
 *
 * Public: Yes
 */

params [
    ["_array", objNull, [objNull, []]],
    ["_type", "", [""]]
];

if (_type isEqualTo "") exitWith {false};

_type = toLower _type;

if (IS_OBJECT(_array)) then {
    _array = [_array] call EFUNC(sys_core,getGear);
};

if (_type in _array) exitWith {true};

private _index = _array findIf {[_x, _type] call FUNC(isKindOf)};

_index != -1
