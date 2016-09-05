//fnc_setOnOffState.sqf
#include "script_component.hpp"

params["_radioId", "_event", "_eventData", "_radioData"];

HASH_SET(_radioData, "radioOn", _eventData);