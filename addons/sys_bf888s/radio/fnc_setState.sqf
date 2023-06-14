#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Sets the a key pair content into the radioData hash.
 *
 * Arguments:
 * 0: Radio ID <STRING> (Unused)
 * 1: Event: "setState" <STRING> (Unused)
 * 2: Event data key pair ["Key", value] <ARRAY>
 * 3: Radio data <HASH>
 * 4: Remote <BOOL> (Unused)
 *
 * Return Value:
 * None
 *
 * Example:
 * ["ACRE_BF888S_ID_1", "setState", ["volume", 0.8], _radioData, false] call acre_sys_BF888S_fnc_setState
 * ["ACRE_BF888S_ID_1", "setState", ["currentChannel", 1], _radioData, false] call acre_sys_BF888S_fnc_setState
 *
 * Public: No
 */

params ["", "", "_eventData", "_radioData", ""];

HASH_SET(_radioData, _eventData select 0, _eventData select 1);
