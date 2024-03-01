#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Checks if the given unique radio ID exits.
 *
 * Arguments:
 * 0: Unique Radio ID <STRING>
 *
 * Return Value:
 * Radio exists? <BOOL>
 *
 * Example:
 * [ARGUMENTS] call acre_sys_radio_fnc_radioExists
 *
 * Public: No
 */

params ["_class"];

HASH_HASKEY(EGVAR(sys_server,objectIdRelationTable),_class)
