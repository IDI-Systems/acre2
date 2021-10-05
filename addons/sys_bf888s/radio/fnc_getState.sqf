#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Function to obtain the content of the radio data hash for the event data key
 *
 * Arguments:
 * 0: Radio ID <STRING> (Unused)
 * 1: Event: "getState" <STRING> (Unused)
 * 2: Event data key <STRING>
 * 3: Radio data <HASH>
 * 4: Remote <BOOL> (Unused)
 *
 * Return Value:
 * Radio data content for the event data key <ARRAY>
 *
 * Example:
 * ["ACRE_BF888S_ID_1", "getState", "radioOn", _radioData, false] call acre_sys_BF888S_fnc_getState
 * ["ACRE_BF888S_ID_1", "getState", "currentChannel", _radioData, false] call acre_sys_BF888S_fnc_getState
 * ["ACRE_BF888S_ID_1", "getState", "volume", _radioData, false] call acre_sys_BF888S_fnc_getState
 * Public: No
 */

params ["", "", "_eventData", "_radioData", ""];

HASH_GET(_radioData, _eventData)
