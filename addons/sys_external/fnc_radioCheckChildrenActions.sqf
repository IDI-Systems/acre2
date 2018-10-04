#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Check if a given action is available for a specific radio external radio.
 *
 * Arguments:
 * 1: Unique radio ID <STRING>
 *
 * Return Value:
 * Action is available <BOOL>
 *
 * Example:
 * ["ACRE_PRC_343_ID_1"] call acre_sys_external_fnc_radioCheckChildrenActions
 *
 * Public: No
 */

params ["_radioId"];

if (_radioId in ACRE_ACTIVE_EXTERNAL_RADIOS) exitWith {false};

vehicle acre_player == acre_player
