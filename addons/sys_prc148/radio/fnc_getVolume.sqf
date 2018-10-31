#include "script_component.hpp"
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

params ["_radioId", "_event", "_eventData", "_radioData"];

private _volume = HASH_GET(_radioData, "volume");

if ((HASH_GET(_radioData, "audioPath") == "INTAUDIO")) then {
    _volume = _volume*0.75;
};

_volume^3;
