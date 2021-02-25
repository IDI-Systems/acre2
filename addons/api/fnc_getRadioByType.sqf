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

private _ret = nil;

if (_array isEqualType objNull) then {
    _array = _array call EFUNC(sys_core,getGear);
} else {
    if (_array isEqualTo []) then {
        _array = [] call FUNC(getCurrentRadioList);
    };
};

{
    private _radioId = _x;
    if ([_radioId, _radioType] call FUNC(isKindOf)) exitWith {
        _ret = _radioId;
    };
} forEach _array;

// Prevent script errors in the scheduler when the unit does not have a radio and `_ret = nil`
if (isNil "_ret") exitWith { nil };

_ret
