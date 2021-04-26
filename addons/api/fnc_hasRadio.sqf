#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Checks whether the provided unit has an ACRE radio in their inventory.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 *
 * Return Value:
 * Whether the unit or player has a radio <BOOLEAN>
 *
 * Example:
 * _hasRadio = [player] call acre_api_fnc_hasRadio;
 *
 * Public: Yes
 */

params [
    ["_unit", objNull, [objNull]]
];

if (isNull _unit) exitWith {false};

private _index = ([_unit] call EFUNC(sys_core,getGear)) findIf {_x call FUNC(isRadio)};

_index != -1
