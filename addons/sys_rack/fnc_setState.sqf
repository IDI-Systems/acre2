#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Update the different rack states.
 *
 * Arguments:
 * 0: Unique Radio ID <STRING>
 * 1: Event <STRING>
 * 2: Event Data <ARRAY>
 * 3: Radio Data <HASH>
 *
 * Return Value:
 * None
 *
 * Example:
 * [ARGUMENTS] call acre_sys_rack_fnc_setState
 *
 * Public: No
 */

params ["", "", "_eventData", "_radioData"];

HASH_SET(_radioData,_eventData select 0,_eventData select 1);
