#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Returns the spatial configuration of the radio.
 *
 * Arguments:
 * 0: Radio ID <STRING>
 * 1: Event: "getSpatial" <STRING> (Unused)
 * 2: Event data <ARRAY> (Unused)
 * 3: Radio data <HASH> (Unused)
 * 4: Remote <BOOL> (Unused)
 *
 * Return Value:
 * Spatial setting: -1 (left) 0 (center) or 1 (right). Defaulting to 0.<NUMBER>
 *
 * Example:
 * ["ACRE_BF888S_ID_1", "getSpatial", [], _radioData, false] call acre_sys_bf888s_fnc_getSpatial
 *
 * Public: No
 */

params ["_radioId", "", "", "", ""];

private _spatial = [_radioId, "getState", "ACRE_INTERNAL_RADIOSPATIALIZATION"] call EFUNC(sys_data,dataEvent);

if (!isNil "_spatial") exitWith { _spatial };
0
