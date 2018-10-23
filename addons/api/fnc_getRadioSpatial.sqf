#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Gets what spatialization zone the specified radio ID is currently in. “LEFT”, “RIGHT” or “CENTER”
 *
 * Arguments:
 * 0: Radio ID <STRING>
 *
 * Return Value:
 * "LEFT", "RIGHT" or "CENTER" <STRING>
 *
 * Example:
 * ["ACRE_PRC148_ID_1"] call acre_api_fnc_getRadioSpatial;
 *
 * Public: Yes
 */

params [
    ["_radioId", "", [""]]
];

[_radioId] call EFUNC(sys_radio,getRadioSpatial);
