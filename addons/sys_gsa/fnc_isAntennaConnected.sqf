/*
 * Author: ACRE2Team
 * Checks if the ground spike antenna is connected to a radio.
 *
 * Arguments:
 * 0: Ground Spike Antenna <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [cursorTarget] call acre_sys_gsa_fnc_isAntennaConnected
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_target", "_gsa"];

_gsa getVariable [QGVAR(connectedRadio), ""] != ""
