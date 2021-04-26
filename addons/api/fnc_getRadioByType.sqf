#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Returns the unique radio ID of the first radio the local player or unit possesses of a given type. This function does not compensate for units with multiple radios of the same type. There is no guarantee of which radio it will return.
 * In the case of a unit for the second parameter it will find the radio ID for that unit instead of the local player.
 *
 * Arguments:
 * 0: Radio type <STRING>
 * 1: Optional unit or List of String <ARRAY, OBJECT> (default: [])
 *
 * Return Value:
 * Radio ID <STRING>
 *
 * Example:
 * _radioId = ["ACRE_PRC152"] call acre_api_fnc_getRadioByType
 * _radioId = ["ACRE_PRC152", _unit] call acre_api_fnc_getRadioByType
 *
 * Public: Yes
 */

params [
    ["_radioType", "", [""]],
    ["_array", [], [[], objNull]]
];

if (_array isEqualType objNull) then {
    _array = _array call EFUNC(sys_core,getGear);
} else {
    if (_array isEqualTo []) then {
        _array = [] call FUNC(getCurrentRadioList);
    };
};

private _index = _array findIf {
    [_x, _radioType] call FUNC(isKindOf);
};
if (_index == -1) exitWith {nil};
_array select _index
