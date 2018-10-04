#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * SHORT DESCRIPTION
 *
 * Arguments:
 * 0: Radio ID <STRING> (Unused)
 * 1: Event: "getOnOffState" <STRING> (Unused)
 * 2: Event data <ARRAY> (Unused)
 * 3: Radio data <HASH>
 * 4: Remote <BOOL> (Unused)
 *
 * Return Value:
 * Returns 1 if the radio is on 0 otherwise <BOOL>
 *
 * Example:
 * ["ACRE_PRC77_ID_1", "getOnOffState", [], _radioData, false] call acre_sys_prc77_fnc_getOnOffState
 *
 * Public: No
 */

params ["", "", "", "_radioData", ""];

HASH_GET(_radioData, "radioOn");
