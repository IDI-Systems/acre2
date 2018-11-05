#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Sets the spatial configuration of the radio. Possible values are -1 (left), 0 (center) and 1 (right).
 * Values are not checked in this function.
 *
 * Arguments:
 * 0: Radio ID <STRING>
 * 1: Event: "setSpatial" <STRING> (Unused)
 * 2: Event data <NUMBER>
 * 3: Radio data <HASH> (Unused)
 * 4: Remote <BOOL> (Unused)
 *
 * Return Value:
 * None
 *
 * Example:
 * ["ACRE_PRC77_ID_1", "setSpatial", -1, [], false] call acre_sys_prc77_fnc_setSpatial
 *
 * Public: No
 */

params ["_radioId", "", "_eventData", "", ""];

private _spatial = _eventData;

[_radioId, "setState", ["ACRE_INTERNAL_RADIOSPATIALIZATION", _spatial]] call EFUNC(sys_data,dataEvent);
