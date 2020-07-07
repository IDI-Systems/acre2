#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Returns a list of unique radio ID of local player or unit possesses of a given type.
 * In the case of a unit for the second parameter it will find the radio ID for that unit instead of the local player.
 *
 * Arguments:
 * 0: Radio type <STRING>
 * 1: Optional unit or List of String <ARRAY, OBJECT>(default: [])
 *
 * Return Value:
 * Radio ID <STRING>
 *
 * Example:
 * _radioIds = ["ACRE_PRC152"] call acre_api_fnc_getAllRadioByType;
 * _radioIds = ["ACRE_PRC152", _unit] call acre_api_fnc_getAllRadioByType;
 *
 * Public: Yes
 */

params [
    ["_radioType", "", [""]],
    ["_array", [], [[], objNull]]
];

private _ret = [];

if (_array isEqualType objNull) then {
    _array = _array call EFUNC(sys_core,getGear);
} else {
    if (_array isEqualTo []) then {
        _array = [] call FUNC(getCurrentRadioList);
    };
};

{
    private _radioId = _x;
    if (([_radioId, _radioType] call FUNC(isKindOf))) then {
        _ret pushBackUnique _radioId;
    };
} forEach _array;

_ret
