/*
 * Author: ACRE2Team
 * Checks if a radio is compatible with the ground spike antenna.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 * 1: Unique Radio ID <STRING>
 *
 * Return Value:
 * Compatible <BOOL>
 *
 * Example:
 * [cursorTarget, "acre_prc152_id_1"] call acre_sys_gsa_fnc_isRadioCompatible
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_gsa", "_radioId"];

private _isCompatible = true;

_isCompatible
