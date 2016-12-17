/*
 * Author: ACRE2Team
 * SHORT DESCRIPTION
 *
 * Arguments:
 * 0: ARGUMENT ONE <TYPE>
 * 1: ARGUMENT TWO <TYPE>
 *
 * Return Value:
 * RETURN VALUE <TYPE>
 *
 * Example:
 * [ARGUMENTS] call acre_COMPONENT_fnc_FUNCTIONNAME
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_class"];

GVAR(radioIdMap) params ["_baseTypes","_radioIds"];

private _mapIndex = _baseTypes find _class;

if (_mapIndex == -1) then {
    _mapIndex = (count _baseTypes);
    _baseTypes pushBack _class;
    _radioIds set[_mapIndex, []];
};

private _takenIds = _radioIds select _mapIndex;

private _ret = -1;
for "_i" from 1 to 512 do {
    if (!(_i in _takenIds)) exitWith {
        _ret = _i;
        PUSH(_takenIds, _ret);
    };
};

_ret
