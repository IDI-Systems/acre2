#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Checks whether the given unit has a base radio.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 *
 * Return Value:
 * Has base radio <BOOLEAN>
 *
 * Example:
 * _result = [player] call acre_api_fnc_hasBaseRadio;
 *
 * Public: Yes
 */

params [
    ["_unit", objNull, [objNull]]
];

if (isNull _unit) exitWith {false};

private _ret = false;

{
    private _weapon = _x;
    _ret = [_weapon] call FUNC(isBaseRadio);
    if (_ret) exitWith { _ret };
} foreach ([_unit] call EFUNC(sys_core,getGear));

_ret
