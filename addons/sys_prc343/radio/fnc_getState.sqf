/*
 * Author: ACRE2Team
 * Function to obtain the content of the radio data hash for the event data key
 *
 * Arguments:
 * 0: Radio ID <STRING> (Unused)
 * 1: Event: "getState" <STRING> (Unused)
 * 2: Event data <NUMBER>
 * 3: Radio data <HASH>
 * 4: Remote <BOOL> (Unused)
 *
 * Return Value:
 * Radio data content for the event data key <ARRAY>
 *
 * Example:
 * [ARGUMENTS] call acre_sys_prc343_fnc_getState
 *
 * Public: No
 */
#include "script_component.hpp"

params ["","", "_eventData", "_radioData", ""];

HASH_GET(_radioData, _eventData);
