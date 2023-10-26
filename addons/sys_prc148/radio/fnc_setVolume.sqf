#include "..\script_component.hpp"
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
 * [ARGUMENTS] call acre_sys_prc148_fnc_setVolume
 *
 * Public: No
 */

params ["", "", "_eventData", "_radioData"];

private _vol = _eventData;

if (_vol%0.20 != 0) then {
    _vol = _vol-(_vol%0.20);
};

HASH_SET(_radioData, "volume", _eventData);
