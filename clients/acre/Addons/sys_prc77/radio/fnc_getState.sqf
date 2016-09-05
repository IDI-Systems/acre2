//fnc_getState.sqf
#include "script_component.hpp"

params ["_radioId", "_event", "_eventData", "_radioData"];

HASH_GET(_radioData, _eventData);
