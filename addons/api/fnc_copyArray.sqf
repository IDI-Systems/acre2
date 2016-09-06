/*
 * Author: AUTHOR
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
private["_copy"];

params["_array"];

/*_copy = [];
{
    if(typeName _x == "ARRAY") then {
        private["_innerArray"];
        _innerArray = [_x] call FUNC(copyArray);
        _copy pushBack _innerArray;
    } else {
        _copy pushBack _x;
    };
} foreach _array;*/
_copy = HASH_COPY(_array);

_copy;
