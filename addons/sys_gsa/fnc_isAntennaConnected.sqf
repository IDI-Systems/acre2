#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Checks if the ground spike antenna is connected to a radio.
 *
 * Arguments:
 * 0: Unit <OBJECT> (Unused)
 * 1: Ground spike antenna <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorObject] call acre_sys_gsa_fnc_isAntennaConnected
 *
 * Public: No
 */

params ["", "_gsa"];

_gsa getVariable [QGVAR(connectedRadio), ""] != ""
