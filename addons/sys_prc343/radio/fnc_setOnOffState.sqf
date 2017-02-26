/*
 * Author: ACRE2Team
 * Sets the radio on (1) or off (0).
 *
 * Arguments:
 * 0: Radio ID <STRING> (Unused)
 * 1: Event: "setOnOffState" <STRING> (Unused)
 * 2: Event data <NUMBER>
 * 3: Radio data <HASH>
 * 4: Remote <BOOL> (Unused)
 *
 * Return Value:
 * None
 *
 * Example:
 * [ARGUMENTS] call acre_sys_prc343_fnc_setOnOffState
 *
 * Public: No
 */
#include "script_component.hpp"

params ["", "", "_eventData", "_radioData", ""];

HASH_SET(_radioData,"radioOn",_eventData);
