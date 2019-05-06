#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Connects the ground spike antenna to a compatible radio.
 *
 * Arguments:
 * 0: Ground Spike Antenna <OBJECT>
 * 1: Unique Radio ID <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * [cursorTarget, "acre_prc152_id_1"] call acre_sys_gsa_fnc_connect
 *
 * Public: No
 */

params ["_gsa", "_radioId"];

// Fire the event
[QGVAR(connectGsa), [_gsa, _radioId, acre_player]] call CBA_fnc_serverEvent;
