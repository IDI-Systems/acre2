//fnc_keyboardEvent.sqf
#include "script_component.hpp"

private ["_index"];

params["_eventName","_state"];
_state = parseNumber _state;
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
