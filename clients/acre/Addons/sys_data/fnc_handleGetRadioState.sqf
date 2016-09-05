//fnc_handleGetRadioState.sqf
#include "script_component.hpp"

params["_radioId", "_event", "_eventData", "_radioData"];

private _radioState = HASH_GET(_radioData,"acre_radioState");
_radioState