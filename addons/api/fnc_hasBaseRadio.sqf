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


private _index = ([_unit] call EFUNC(sys_core,getGear)) findIf {_x call FUNC(isBaseRadio);};

_index != -1;
