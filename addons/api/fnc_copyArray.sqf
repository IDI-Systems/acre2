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
 * Public: Yes
 */
#include "script_component.hpp"


params["_array"];

/*private _copy = [];
{
    if(typeName _x == "ARRAY") then {
        private _innerArray = [_x] call FUNC(copyArray);
        _copy pushBack _innerArray;
    } else {
        _copy pushBack _x;
    };
} foreach _array;*/
private _copy = HASH_COPY(_array);

_copy;
