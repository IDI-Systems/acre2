/*
 * Author: ACRE2Team
 * Returns the spatial configuration of the radio.
 *
 * Arguments:
 * 0: Radio ID <STRING> (Unused)
 * 1: Event: "getSpatial" <STRING> (Unused)
 * 2: Event data <NUMBER> (Unused)
 * 3: Radio data <HASH> (Unused)
 * 4: Remote <BOOL> (Unused)
 *
 * Return Value:
 * Spatial setting: -1 (left) 0 (center) or 1 (right). Defaulting to 0.<NUMBER>
 *
 * Example:
 * ["ACRE_PRC343_ID_1"] call acre_sys_prc343_fnc_getSpatial
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_radioId", "", "", "", ""];

private _spatial = [_radioId, "getState", "ACRE_INTERNAL_RADIOSPATIALIZATION"] call EFUNC(sys_data,dataEvent);

if (!isNil "_spatial") exitWith { _spatial };
0
