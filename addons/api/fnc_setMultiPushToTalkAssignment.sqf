#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Sets the assignment order for the Multi-Push-To-Talk keys, also known as Alternate Push-to-Talk keys. These assign the keys 1-3, in order, to the ID’s provided in the array. All radios must be valid assigned ACRE radio id’s and must be present on the local player.
 *
 * Arguments:
 * 0: Array of radio IDs <ARRAY>
 *
 * Return Value:
 * Successful <BOOLEAN>
 *
 * Example:
 * _personalRadio = [“ACRE_PRC343”] call acre_api_fnc_getRadioByType;
 * _handheldRadio = [“ACRE_PRC152”] call acre_api_fnc_getRadioByType;
 * _manpackRadio = [“ACRE_PRC117F”] call acre_api_fnc_getRadioByType;
 * _success = [ [ _personalRadio, _handheldRadio, _manpackRadio ] ] call acre_api_fnc_setMultiPushToTalkAssignment;
 *
 * Public: Yes
 */

params [
    ["_var", [], [[]]]
];
if !(_var isEqualType []) exitWith { false };

if (_var isEqualTo ACRE_ASSIGNED_PTT_RADIOS) exitWith {true};

private _currentRadioList = [] call FUNC(getCurrentRadioList);

private _index = _var findIf {
    !(_x isEqualType "")
    || {!([_x] call FUNC(isRadio))}
    || {!(_x in _currentRadioList)}
};

if (_index != -1) exitWith { false };

ACRE_ASSIGNED_PTT_RADIOS = _var;

true
