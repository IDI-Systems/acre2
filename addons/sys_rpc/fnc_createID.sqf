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

#define UPPER_ASCII    89
#define LOWER_ASCII    64

private _id = "";

for "_i" from 0 to 7 do {
    private _char = "a";
    if (random 1 > 0.25) then {
        _char = toString [(floor (random (UPPER_ASCII-LOWER_ASCII))) + LOWER_ASCII];
    } else {
        _char = str (floor (random 10));
    };
    _id = _id + _char;
};

if ((_id call FUNC(check)) > -1) then {
    _id = call FUNC(createID);
};

_id
