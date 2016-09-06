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

if(isServer) then {
    if((_this select 1) == 1) then {
        if(!((_this select 0) in ACRE_SPECTATORS_LIST)) then {
            PUSH(ACRE_SPECTATORS_LIST, (_this select 0));
        };
    } else {
        ACRE_SPECTATORS_LIST = ACRE_SPECTATORS_LIST - [(_this select 0)];
    };
    publicVariable "ACRE_SPECTATORS_LIST";
};
