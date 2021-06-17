#include "script_component.hpp"
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
 * ["ACRE_BF888S_ID_1", "setOnOffState", 1, [], false] call acre_sys_BF888S_fnc_setOnOffState
 *
 * Public: No
 */

params ["", "", "_eventData", "_radioData", ""];

HASH_SET(_radioData,"radioOn",_eventData);
