/*
 * Author: ACRE2Team
 * SHORT DESCRIPTION
 *
 * Arguments:
 * 0: Radio ID <STRING> (Unused)
 * 1: Event: "setState" <STRING> (Unused)
 * 2: Event data <NUMBER>
 * 3: Radio data <HASH>
 * 4: Remote <BOOL> (Unused)
 *
 * Return Value:
 * None
 *
 * Example:
 * [ARGUMENTS] call acre_sys_prc343_fnc_setState
 *
 * Public: No
 */
#include "script_component.hpp"

params ["", "", "_eventData", "_radioData", ""];

HASH_SET(_radioData, _eventData select 0, _eventData select 1);
