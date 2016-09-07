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

params["_eventName","_state"];

private _state = parseNumber _state;
//GVAR(keyboardEventsDown) = HASH_CREATE;
//GVAR(keyboardEventsUp) = HASH_CREATE;
if(_state == 1) then {
    if(HASH_HASKEY(GVAR(keyboardEventsDown), _eventName)) then {
        [] call HASH_GET(GVAR(keyboardEventsDown), _eventName);
    };
} else {
    if(HASH_HASKEY(GVAR(keyboardEventsUp), _eventName)) then {
        [] call HASH_GET(GVAR(keyboardEventsUp), _eventName);
    };
};
true
