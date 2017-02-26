/*
 * Author: ACRE2Team
 * Returns the current radio volume.
 *
 * Arguments:
 * 0: Radio ID <STRING> (Unused)
 * 1: Event: "getVolume" <STRING> (Unused)
 * 2: Event data <NUMBER> (Unused)
 * 3: Radio data <HASH>
 *
 * Return Value:
 * Current radio volume to the power of 3 (for cubic function) <NUMBER>
 *
 * Example:
 * [ARGUMENTS] call acre_sys_prc343_fnc_getVolume
 *
 * Public: No
 */
#include "script_component.hpp"

params ["", "", "", "_radioData", ""];

private _volume = HASH_GET(_radioData,"volume");
if (isNil "_volume") then {
    _volume = 1;
};
_volume^3;
